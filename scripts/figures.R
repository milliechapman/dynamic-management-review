###########################################################################################
# Generate figures for comparison of marine and terrestrial dynamic management case studies.
# Loads in .csv of case studies, creates and saves 3 figures for comparison 
# 
# William Oestreich
# Hopkins Marine Station of Stanford University
# Last updated: Oct 16, 2019
###########################################################################################

# Load necessary packages
library(tidyverse)
library(plyr)
library(reshape2)
library(gridExtra)
rm(list = ls())

# Read in "cases" CSV file
data<- read_csv("../") %>% 
  select(Domain, `Temporal scale (days)`, `Number of species`, `Spatial scale (km)`, Implementation, Year)

# Data cleaning for subsequent analysis
data$`Spatial scale (km)`[data$`Spatial scale (km)`=="Not explicitly defined"] <- NA
data$`Number of species`[data$`Number of species`=="Not explicitly defined"] <- NA
data$`Spatial scale (km)` <- as.numeric(data$`Spatial scale (km)`)

###########################################################################################
# Plots
###########################################################################################

###########################################################################################
# Figure 3 - timeline of case studies

yearly_counts <- data.frame(Year = 1985:2019, Marine = numeric(35), Terrestrial = numeric(35))
for (i in 1985:2019) {
  yearly_counts$Marine[i-1984] <- sum(data$Year == i & data$Domain == "Marine")
  yearly_counts$Terrestrial[i-1984] <- sum(data$Year == i & data$Domain == "Terrestrial") 
}

Year = c((1985:2019),(1985:2019))
Count = c(yearly_counts$Marine,yearly_counts$Terrestrial)
Domain = c(rep("Marine",35),rep("Terrestrial",35))
df = data.frame(Year,Count,Domain)

tiff("../figures/Fig3.tiff", units="in", width=4, height=1.6, res=400)
ggplot(data = df, aes(x = Year, y = Count, fill = Domain)) + 
  geom_bar(stat = "identity", width = .8, position = "dodge") +
  scale_x_continuous(breaks = seq(1985, 2015, by = 5)) +
  scale_colour_manual(values = c("deepskyblue2", "Chartreuse4")) +
  scale_fill_manual(values = c("deepskyblue2", "Chartreuse4")) +
  ylab("DM case studies") +
  ylim(0,8) +
  theme(panel.background = element_rect(fill = "white", colour = "white") ,panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) + 
  theme(legend.position = c(0.15, 0.7))
dev.off() 

########################################################################################### 
# Figure 4 - spatial vs. temporal scale

rm(Count, Domain, i, Year)

data<- data %>%
  select(Domain, `Temporal scale (days)`, `Spatial scale (km)`, Implementation, `Number of species`) %>%
  na.omit() 

data$`Temporal scale (days)` <- log10(data$`Temporal scale (days)`)
data$`Spatial scale (km)` <- log10(data$`Spatial scale (km)`)
data$`Number of species`[data$`Number of species` == 'Habitat'] <- '100'
data$`Number of species`[data$`Number of species` == '>100'] <- '100'
data$`Number of species` <- as.integer(data$`Number of species`)
data$`Number of species` <- log10(data$`Number of species`)

hull <- data %>%
  group_by(Domain) %>% 
  slice(chull(`Temporal scale (days)`, `Spatial scale (km)`))

tiff("../figures/Fig4.tiff", units="in", width=4, height=3.5, res=400)
data %>%
  ggplot(aes(`Temporal scale (days)`, `Spatial scale (km)`, colour = Domain, fill = Domain, shape = Domain)) +
  scale_colour_manual(values = c("deepskyblue2", "Chartreuse4")) +
  scale_fill_manual(values = c("deepskyblue2", "Chartreuse4")) +
  scale_shape_manual(values=c(19, 17)) +
  geom_point(size = 4, alpha = 0.8, position = position_jitter(w = 0.01, h = 0)) +
  geom_polygon(data = hull, alpha=.5) +
  scale_x_continuous(breaks=c(0,1,2,3,4),
                     labels=c("1","10","100","1000","10,000")) +
  scale_y_continuous(breaks=c(-2,-1,0,1,2,3),
                     labels=c("0.01","0.1","1","10","100","1000")) +  
  xlab(expression("Temporal scale (days)")) + 
  ylab(expression("Spatial scale (km)")) +
  theme(panel.background = element_rect(fill = "white", colour = "white"), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) + 
  theme(legend.position = c(0.85, 0.9))
dev.off()

###########################################################################################
# Figure 5 - Number of species vs. spatial scale, temporal scale

# get_legend function from the following forum: 
# http://www.sthda.com/english/wiki/wiki.php?id_contents=7930
get_legend<-function(myggplot){
  tmp <- ggplot_gtable(ggplot_build(myggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

clabs <- c("1","10","Habitat-scale")
tiff("../figures/Fig5.tiff", units="in", width=14, height=5, res=400)
p1 <- data %>%
  ggplot(aes(`Temporal scale (days)`, `Number of species`, colour = Domain, fill = Domain, shape = Domain)) +
  scale_colour_manual(values = c("deepskyblue2", "Chartreuse4")) +
  scale_shape_manual(values=c(19, 17)) +
  geom_point(size = 4, alpha = 0.8, position = position_jitter(w = 0.08, h = 0)) +
  xlab(expression("Temporal scale (days)")) + 
  ylab(expression("Number of species included")) +
  scale_x_continuous(breaks=c(0,1,2,3,4),
                     labels=c("1","10","100","1000","10,000")) +
  scale_y_continuous(breaks = c(0,1,2),
                     labels = clabs) + 
  annotate("text", label = "(a)", x = 4.3, y = 2, size = 8, colour = "black") +
  theme(panel.background = element_rect(fill = "white", colour = "white"), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), text = element_text(size=20))

p2 <- data %>%
  select(Domain, `Spatial scale (km)`, `Number of species`, Implementation) %>%
  na.omit() %>%
  ggplot(aes(`Spatial scale (km)`, `Number of species`, colour = Domain, fill = Domain, shape = Domain)) +
  scale_colour_manual(values = c("deepskyblue2", "Chartreuse4")) +
  scale_shape_manual(values=c(19, 17)) +
  geom_point(size = 4, alpha = 0.8, position = position_jitter(w = 0.08, h = 0)) +
  xlab(expression("Spatial scale (km)")) + 
  ylab("") +
  theme(legend.position = "none") +
  scale_x_continuous(breaks=c(-2,-1,0,1,2,3),
                     labels=c("0.01","0.1","1","10","100","1000")) +
  scale_y_continuous(breaks = c(0,1,2),
                     labels = clabs) + 
  annotate("text", label = "(b)", x = 3.3, y = 2, size = 8, colour = "black") +
  theme(panel.background = element_rect(fill = "white", colour = "white"), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), text = element_text(size=20))

legend <- get_legend(p1)

p1 <- p1 + theme(legend.position = "none")

grid.arrange(p1, p2, legend, ncol=3, widths=c(7, 7, 2))
dev.off()