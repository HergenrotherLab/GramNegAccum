## Load libraries
library(ggplot2)
library(reshape2)

time <- seq(0,1998)*2

makePlotRep <- function(d, fn="out.png", rep = "A"){
  str <- paste("Distance primary amine to residue (Rep. ", rep, ")", sep="")
  print(str)
  print(fn)
  png(filename = fn,
      width=6, height=6,
      units = "in",
      res=600)
  x <- ggplot(d, aes(x = time, y = value, color = variable)) +
    geom_point(size = 0.2) +
    scale_color_brewer(palette = "Set1") +
    theme_linedraw(base_size = 16) + theme(legend.position = "bottom") +
    guides(color = guide_legend(override.aes = list(size=4))) +
    labs(title = str,
         x = "Time (ps)",
         y = "Distance (angstoms)",
         color = "Residue: ")
  print(x)
  dev.off()
}

makePlotRes <- function(data, filename, res)
{
  str <- paste("Distance primary amine to", res)
  png(filename = filename,
      width=6, height=6,
      units = "in",
      res = 600)
  x <- ggplot(data, aes(x = time, y = value, color = variable)) +
    geom_point(size = 0.2) +
    scale_color_brewer(palette = "Set1") +
    theme_linedraw(base_size = 16) + theme(legend.position = "bottom") +
    guides(color = guide_legend(override.aes = list(size=4))) +
    labs(title = str,
         x = "Time (ps)",
         y = "Distance (angstoms)",
         color = "Replicate: ")
  print(x)
  dev.off()
}

# Asp113
Asp113 <- data.frame(a = read.delim("Asp113_a_r.dat", sep=" ")[,2])
#Asp113$b <- read.delim("Asp113_b_r.dat", sep=" ")[,2]
Asp113$c <- read.delim("Asp113_c_r.dat", sep=" ")[,2]
Asp113$d <- read.delim("Asp113_d_r.dat", sep=" ")[,2]
Asp113$e <- read.delim("Asp113_e_r.dat", sep=" ")[,2]
Asp113$f <- read.delim("Asp113_orig_r.dat", sep=" ")[,2]
Asp113.melt <- melt(cbind(time, Asp113), id="time")

# Asp121
Asp121 <- data.frame(a = read.delim("Asp121_a_r.dat", sep=" ")[,2])
#Asp121$b <- read.delim("Asp121_b_r.dat", sep=" ")[,2]
Asp121$c <- read.delim("Asp121_c_r.dat", sep=" ")[,2]
Asp121$d <- read.delim("Asp121_d_r.dat", sep=" ")[,2]
Asp121$e <- read.delim("Asp121_e_r.dat", sep=" ")[,2]
Asp121$f <- read.delim("Asp121_orig_r.dat", sep=" ")[,2]
Asp121.melt <- melt(cbind(time, Asp121), id="time")

# Glu117
Glu117 <- data.frame(a = read.delim("Glu117_a_r.dat", sep=" ")[,2])
#Glu117$b <- read.delim("Glu117_b_r.dat", sep=" ")[,2]
Glu117$c <- read.delim("Glu117_c_r.dat", sep=" ")[,2]
Glu117$d <- read.delim("Glu117_d_r.dat", sep=" ")[,2]
Glu117$e <- read.delim("Glu117_e_r.dat", sep=" ")[,2]
Glu117$f <- read.delim("Glu117_orig_r.dat", sep=" ")[,2]
Glu117.melt <- melt(cbind(time, Glu117), id="time")

# Combine data
dist.a <- data.frame(Asp113 = Asp113$a, Asp121 = Asp121$a, Glu117 = Glu117$a)
dist.a.melt <- melt(cbind(time, dist.a), id="time")
dist.c <- data.frame(Asp113 = Asp113$c, Asp121 = Asp121$c, Glu117 = Glu117$c)
dist.c.melt <- melt(cbind(time, dist.c), id="time")
dist.d <- data.frame(Asp113 = Asp113$d, Asp121 = Asp121$d, Glu117 = Glu117$d)
dist.d.melt <- melt(cbind(time, dist.d), id="time")
dist.e <- data.frame(Asp113 = Asp113$e, Asp121 = Asp121$e, Glu117 = Glu117$e)
dist.e.melt <- melt(cbind(time, dist.e), id="time")
dist.f <- data.frame(Asp113 = Asp113$f, Asp121 = Asp121$f, Glu117 = Glu117$f)
dist.f.melt <- melt(cbind(time, dist.f), id="time")

### Plot based on residue
makePlotRes(Asp113.melt, "figs/r_asp113.png", "Asp113")
makePlotRes(Asp121.melt, "figs/r_asp121.png", "Asp121")
makePlotRes(Glu117.melt, "figs/r_glu117.png", "Glu117")

### Plot based on replicate
makePlotRep(dist.a.melt, "figs/r_a.png", "A")
makePlotRep(dist.c.melt, "figs/r_c.png", "C")
makePlotRep(dist.d.melt, "figs/r_d.png", "D")
makePlotRep(dist.e.melt, "figs/r_e.png", "E")
makePlotRep(dist.f.melt, "figs/r_f.png", "F")
