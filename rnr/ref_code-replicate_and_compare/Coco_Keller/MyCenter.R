## written by Florian Jaeger, and taken from his blog

myCenter <- function(x) {
	if (is.numeric(x)) { return(x - mean(x, na.rm = T)) }
	if (is.factor(x)) {
		x <- as.numeric(x)
		return(x - mean(x, na.rm = T))
	}
	if (is.data.frame(x) || is.matrix(x)) {
		m <- matrix(nrow=nrow(x), ncol=ncol(x))
		colnames(m) <- paste("c", colnames(x), sep="")
		for (i in 1:ncol(x)) {
			if (is.factor(x[,i])) {
				y <- as.numeric(x[,i])
				m[,i] <- y - mean(y, na.rm=T)
                        }
			if (is.numeric(x[,i])) {
				m[,i] <- x[,i] - mean(x[,i], na.rm=T)
                        }
 		}
                return(as.data.frame(m))

        }
}
