# merges multiple results files and updates anonymized worker ID and sets  condition to condition
# Usage: merge_results.R file1 speaker_cond1 file2 speaker_cond2 ...

args = commandArgs(trailingOnly=TRUE)

n_args = length(args)

if (n_args > 1 || n_args %% 2 != 0) {
  
  d = read.csv(args[1])
  d$condition = args[2]
  
  n_files = n_args/2
  if (n_files > 1) {
    for (i in 2:n_files) {
      max_workerid = max(d$workerid)
      d2 = read.csv(args[i*2 - 1])
      d2$condition = args[i*2]
      d2$workerid = d2$workerid + max(d$workerid) + 1
      d = rbind(d, d2)
    }
  }
  
  write.csv(d, file="", row.names = FALSE)
  
  
} else {
  print("Not enough arguments supplied!")
}