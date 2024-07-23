sbatch -w g4-simple-dy-cr1-1 --wrap "hostname" --job-name g4-simple
sbatch -w g4-open-dy-cr1-1 --wrap "hostname" --partition g4-open --job-name g4-open
sbatch -w g4-targeted-dy-cr1-1 --wrap "hostname" --partition g4-targeted --job-name g4-targeted

sbatch -w g6-simple-dy-cr1-1 --wrap "hostname" --partition g6-simple --job-name g6-simple
sbatch -w g6-open-dy-cr1-1 --wrap "hostname" --partition g6-open --job-name g6-open
sbatch -w g6-targeted-dy-cr1-1 --wrap "hostname" --partition g6-targeted --job-name g6-targeted