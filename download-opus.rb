require 'json'

$source = "en"
$target = "th"
$prefix = "corpus"
corpora = JSON.parse(`curl 'http://opus.nlpl.eu/opusapi/?source=#{$source}&target=#{$target}'`)["corpora"]
moses_names = corpora.select {|c| c["preprocessing"] == "moses"}
                     .select {|c| c["latest"]}
                     .map {|c| c["corpus"]}
xml_names = corpora.select {|c| c["preprocessing"] == "xml"}
                   .select {|c| c["latest"]}
                   .select {|c| c["source"] == $source}
                   .select {|c| c["target"] == $target}
                   .map {|c| c["corpus"]}
names = moses_names & xml_names

def download_corpus(c)
  filename = c["url"].split(/\//)[-1]
  dir = File.join($prefix, c["corpus"], "latest", c["preprocessing"])
  `mkdir -p #{dir}`
  file_path = File.join(dir, filename)
  `curl #{c["url"]} -o #{file_path}`
end

corpora.select {|c| c["preprocessing"] == "moses"}
       .select {|c| c["latest"]}
       .each {|c| download_corpus(c)}

corpora.select {|c| c["preprocessing"] == "xml"}
       .select {|c| c["latest"]}
       .each {|c| download_corpus(c)}
