# Figure -- Subsets v. Chance

# this is mixed with the image and timeline data so need to go through and run line-by-line

# packages
library('ggplot2')
library('ggpubr')
library('jtools')

# its all timeline data

# --------
# timeline data
m.data    <- c(.692, .687, .712, .72, .675, .656) #means
sd.data   <- c(.007, .011, .015, .011, .016, .038) #sd's
se.data   <- c(.002, .003, .005, .004, .005, .012) #se's
se_max    <- m.data + se.data #calc y-max
se_min    <- m.data - se.data #calc y-min

# ---------------
# GENERIC TO BOTH
# ---------------

parcels   <- c('øMR', 'øMR', 'SøR', 'SøR', 'SMø', 'SMø')
xdataset  <- c('Exploratory', 'Confirmatory', 'Exploratory', 'Confirmatory','Exploratory', 'Confirmatory')

parcels   <- factor(parcels, unique(parcels)) #order of bars is order encountered in dataset
xdataset  <- factor(xdataset, unique(xdataset)) #order of bars is order encountered in dataset

plot_data <- data.frame(m.data, sd.data, se.data, se_max, se_min, parcels, xdataset)
chance    <- .5 #chance level

plot        <- ggplot(data = plot_data, mapping = aes(x = parcels, y = m.data, fill = xdataset)) #setup plot
lims        <- coord_cartesian(ylim = c(0, .8)) #setting y-axis limit
plot_labs   <- labs(x = 'Data Subsets', y = 'Mean Accuracy') #customize axis and legend labels
bars        <- geom_col(data = plot_data, group = xdataset, position = 'dodge') #group bars
error_bars  <- geom_errorbar(aes(ymin = se_min, ymax = se_max), width = 0.1, position = position_dodge(width = 0.9)) #add error bars
colors      <- scale_fill_brewer(palette = 'Set1') #set the color scheme
placement   <- scale_y_continuous(expand = c(0,0)) #put bars on x-axis
hz_line     <- geom_hline(yintercept = (chance), linetype = 'dashed') #horizontal line indicating chance performance
hz_line_lab <- geom_text(aes(0, chance, label = ' Chance', hjust = 'left', vjust = -1, fontface = 'plain', family = 'Helvetica')) #Chance line label
bar_labs    <- geom_text(aes(label = m.data, vjust = 4, fontface = 'plain', family = 'Helvetica'), position = position_dodge(width = 0.9), size = 2.5) #add means to the figure
theme       <- theme_apa(legend.pos = 'top', legend.font.size = '12')

zplot       <- plot + lims + plot_labs + bars + error_bars + colors + placement + hz_line + hz_line_lab + bar_labs + theme
zplot
