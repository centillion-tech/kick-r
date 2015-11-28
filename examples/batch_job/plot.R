data <- read.csv('plot_tfidf.csv', header=T, sep=",")
pdf("plot_result.pdf")
plot(data)
dev.off()
