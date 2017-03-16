library(ggplot2)

force.a <- read.delim("a.FvP.dat", sep=" ")
time.a <- read.delim("a.TvP.dat", sep=" ")
colnames(force.a) <- c("z", "Force")
colnames(time.a) <- c("Time", "z")

force.c <- read.delim("c.FvP.dat", sep=" ")
time.c <- read.delim("c.TvP.dat", sep=" ")
colnames(force.c) <- c("z", "Force")
colnames(time.c) <- c("Time", "z")

force.d <- read.delim("d.FvP.dat", sep=" ")
time.d <- read.delim("d.TvP.dat", sep=" ")
colnames(force.d) <- c("z", "Force")
colnames(time.d) <- c("Time", "z")

force.e <- read.delim("e.FvP.dat", sep=" ")
time.e <- read.delim("e.TvP.dat", sep=" ")
colnames(force.e) <- c("z", "Force")
colnames(time.e) <- c("Time", "z")

force.f <- read.delim("f.FvP.dat", sep=" ")
time.f <- read.delim("f.TvP.dat", sep=" ")
colnames(force.f) <- c("z", "Force")
colnames(time.f) <- c("Time", "z")

makeForcePlot <- function (data, file.name, title)
{
  png(filename = file.name,
      width = 6, height = 6,
      units = "in",
      res = 600)
  x <- ggplot(data, aes(x = z, y = Force)) +
    geom_point(size = 0.2, col = "#999999") + geom_smooth(col = "#e41a1c") +
    scale_color_brewer(palette = "Set1") +
    theme_linedraw(base_size = 16) +
    labs(title = title,
         x = "z (angstroms)",
         y = "Force (pN)")
  print(x)
  dev.off()
}

reps <- list(force.a, force.c, force.d, force.e, force.f)
repnames <- c("A", "C", "D", "E", "F")

for (i in 1:length(reps))
{
  file.name <- paste("figs/", repnames[i],"_force.png",sep="")
  title <- paste("Replicate",repnames[i])
  makeForcePlot(reps[[i]], file.name, title)
}
