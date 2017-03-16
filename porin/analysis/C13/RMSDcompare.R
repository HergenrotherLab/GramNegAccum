## Load libraries
library(ggplot2)
library(reshape2)

## Input data
# 4ns simulations contain 1999 frames, 2 ps per frame
time <- seq(0,1998)*2
# Arg42
Arg42 <- data.frame(a = read.delim("Arg42_a_rmsd.dat", sep=" ")[,2])
Arg42$b <- read.delim("Arg42_b_rmsd.dat", sep=" ")[,2]
Arg42$c <- read.delim("Arg42_c_rmsd.dat", sep=" ")[,2]
Arg42$d <- read.delim("Arg42_d_rmsd.dat", sep=" ")[,2]
Arg42$e <- read.delim("Arg42_orig_rmsd.dat", sep=" ")[,2]
Arg42.melt <- melt(cbind(time,Arg42), id="time")

# Arg82
Arg82 <- data.frame(a = read.delim("Arg82_a_rmsd.dat", sep=" ")[,2])
Arg82$b <- read.delim("Arg82_b_rmsd.dat", sep=" ")[,2]
Arg82$c <- read.delim("Arg82_c_rmsd.dat", sep=" ")[,2]
Arg82$d <- read.delim("Arg82_d_rmsd.dat", sep=" ")[,2]
Arg82$e <- read.delim("Arg82_orig_rmsd.dat", sep=" ")[,2]
Arg82.melt <- melt(cbind(time, Arg82), id="time")

# Arg132
Arg132 <- data.frame(a = read.delim("Arg132_a_rmsd.dat", sep=" ")[,2])
Arg132$b <- read.delim("Arg132_b_rmsd.dat", sep=" ")[,2]
Arg132$c <- read.delim("Arg132_c_rmsd.dat", sep=" ")[,2]
Arg132$d <- read.delim("Arg132_d_rmsd.dat", sep=" ")[,2]
Arg132$e <- read.delim("Arg132_orig_rmsd.dat", sep=" ")[,2]
Arg132.melt <- melt(cbind(time, Arg132), id="time")

# Asp113
Asp113 <- data.frame(a = read.delim("Asp113_a_rmsd.dat", sep=" ")[,2])
Asp113$b <- read.delim("Asp113_b_rmsd.dat", sep=" ")[,2]
Asp113$c <- read.delim("Asp113_c_rmsd.dat", sep=" ")[,2]
Asp113$d <- read.delim("Asp113_d_rmsd.dat", sep=" ")[,2]
Asp113$e <- read.delim("Asp113_orig_rmsd.dat", sep=" ")[,2]
Asp113.melt <- melt(cbind(time, Asp113), id="time")

# Asp121
Asp121 <- data.frame(a = read.delim("Asp121_a_rmsd.dat", sep=" ")[,2])
Asp121$b <- read.delim("Asp121_b_rmsd.dat", sep=" ")[,2]
Asp121$c <- read.delim("Asp121_c_rmsd.dat", sep=" ")[,2]
Asp121$d <- read.delim("Asp121_d_rmsd.dat", sep=" ")[,2]
Asp121$e <- read.delim("Asp121_orig_rmsd.dat", sep=" ")[,2]
Asp121.melt <- melt(cbind(time, Asp121), id="time")

# Glu117
Glu117 <- data.frame(a = read.delim("Glu117_a_rmsd.dat", sep=" ")[,2])
Glu117$b <- read.delim("Glu117_b_rmsd.dat", sep=" ")[,2]
Glu117$c <- read.delim("Glu117_c_rmsd.dat", sep=" ")[,2]
Glu117$d <- read.delim("Glu117_d_rmsd.dat", sep=" ")[,2]
Glu117$e <- read.delim("Glu117_orig_rmsd.dat", sep=" ")[,2]
Glu117.melt <- melt(cbind(time, Glu117), id="time")

makeRMSDplot <- function (data, file.name, title)
{
  png(filename = file.name,
      width=6, height=6,
      units = "in",
      res = 600)
  x <- ggplot(data, aes(x = time, y = value, color = variable)) +
    geom_point(size = 0.2) + geom_smooth() +
    scale_color_brewer(palette = "Set1") +
    theme_linedraw(base_size = 16) + theme(legend.position = "bottom") +
    ylim(0,12) +
    labs(title = title,
         x = "Time (ps)",
         y = "RMSD (angstoms)",
         color = "Replicate: ")
  print(x)
  dev.off()
}

### Plotting
## Overlay
# Arg42
makeRMSDplot(data = Arg42.melt, file.name = "figs/rmsd_arg42.png",
             title = "Displacement of Arg42 during SMD")

# Arg82
makeRMSDplot(data = Arg82.melt, file.name = "figs/rmsd_arg82.png",
             title = "Displacement of Arg82 during SMD")

# Arg132
makeRMSDplot(data = Arg132.melt, file.name = "figs/rmsd_arg132.png",
             title = "Displacement of Arg132 during SMD")

# Asp121
makeRMSDplot(data = Asp121.melt, file.name = "figs/rmsd_asp121.png",
             title = "Displacement of Asp121 during SMD")

# Asp113
makeRMSDplot(data = Asp113.melt, file.name = "figs/rmsd_asp113.png",
             title = "Displacement of Asp113 during SMD")

# Glu117
makeRMSDplot(data = Glu117.melt, file.name = "figs/rmsd_glu117.png",
             title = "Displacement of Glu117 during SMD")
