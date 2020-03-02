(require '[clojure.tools.cli :refer [parse-opts]]
         '[clojure.string :as string]
         '[clojure.java.io :as io]
         '[clojure.data.xml :as xml])

(def cli-options
  [["-d" "--output-dir" "Output path to folder" :default "."]])

(defn usage
  [summary]
  (->> ["Usage: clojure [option] tmx_to_moses.clj <tmx file>"
        summary]        
       (string/join \newline)))

(defn validate-args [args]
  (let [{:keys [arguments summary options]} (parse-opts args cli-options)]
    (cond (not= (count arguments) 1)
          {:exit-message (usage summary)}
          :else
          {:convert-info (merge options
                                {:tmx-file-path (first arguments)})})))

(defn ext-seg [seg]
  (->> seg
       :content))

(defn ext-tuv [tuv]
  (let [lang (->> tuv
                  :attrs
                  :xml/lang
                  )
        seg-coll (->> tuv
                      :content
                      (filter #(= (:tag %) :seg)))
        value (mapcat ext-seg seg-coll)]
    {:lang lang :value value}))

(defn ext-tu
  [tu]
  (let [tuv-coll (->> tu
                      :content
                      (filter #(= (:tag %) :tuv)))]
    (map ext-tuv tuv-coll)))

(defn extract [r]
  (let [root (xml/parse r)]
    (->> root
         :content
         second
         :content        
         (filter #(= (:tag %) :tu))
         (map ext-tu))))

(defn valid-tu? [tu]
  (and (= (count (map :lang tu))
          2)
       (every? #(> (->> %
                        :value
                        string/join
                        string/trim
                        count)
                   0)
               tu)))

(defn remove-newlines [s]
  (string/replace s #"[\n\r]" "  "))

(defn join-segs [segs]
  (string/join "\n" segs))

(defn print-tuv
  [lang-files tuv]
  (let [lang (:lang tuv)
        f (lang-files lang)
        val (->> tuv
                 :value
                 join-segs
                 remove-newlines)]
    (.write f val)
    (.write f "\n")))

(defn print-tu
  [lang-files tu]
  (map #(print-tuv lang-files %) tu))

(defn create-print-output
  [lang-files]
  (fn [acc tu]
    (cond
      (> (count acc) 3) (reduced acc)
      :else (print-tu lang-files tu))))

(defn simplified-lang [lang]
  (string/replace lang #"-.+" ""))

(defn tmx->moses
  [{:keys [output-dir tmx-file-path]}]
  (with-open [r0 (io/reader tmx-file-path)
              r  (io/reader tmx-file-path)]
    (let [tu (-> r0 extract first)
          langs (map :lang tu)
          add-prefix #(str output-dir java.io.File/separator %)
          lang-files (reduce (fn [files lang]
                          (assoc files
                                 lang
                                 (->> lang
                                      simplified-lang
                                      add-prefix
                                      io/writer)))
                        {}
                        langs)]
      (reduce (create-print-output lang-files)
              '()
              (->> r
                   extract                 
                   (filter valid-tu?)))
      (reduce #(.close %2) nil (vals lang-files)))))

(comment
  (tmx->moses {:tmx-file-path "corpus/moz/latest/mozilla_en-US_th_bca3a7cdc6ed6c88a21bb8e18c22eb6c_normal.tmx"
               :output-dir "."}))

(let [{:keys [exit-message convert-info]} (validate-args *command-line-args*)]
   (cond
     exit-message (do (println exit-message)
                      (System/exit 1))
     :else (tmx->moses convert-info)))
