# merges multiple results files and updates anonymized worker ID 
# Usage: merge_results.R file1 file2 file3 ...
args = commandArgs(trailingOnly=TRUE)

n_args = length(args)

if (n_args > 0) {
  
  d = read.csv(args[1])
  
  n_files = n_args
  if (n_files > 1) {
    for (i in 2:n_files) {
      max_workerid = max(d$workerid)
      d2 = read.csv(args[i])
      d2$workerid = d2$workerid + max(d$workerid) + 1
      d = rbind(d, d2)
    }
  }
  
  write.csv(d, file="", row.names = FALSE)
  
  
} else {
  print("Not enough arguments supplied!")
}