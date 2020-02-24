(require '[clojure.tools.cli :refer [parse-opts]]
         '[clojure.string :as string])

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



(let [{:keys [exit-message convert-info]} (validate-args *command-line-args*)]
  (cond
    exit-message (do (println exit-message)
                     (System/exit 1))
    :else "OK"))


