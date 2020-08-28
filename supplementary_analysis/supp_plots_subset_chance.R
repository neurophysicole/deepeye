# Figure -- Subsets v. Chance

# this is mixed with the re-calculated and supplementary data so need to go through and run line-by-line

# packages
library('ggplot2')
library('ggpubr')
library('jtools')

# its all timeline data


# --------
# re-calc
name = 'Primary Analysis Re-Calculated'
m.data    <- c(.689, .666, .725, .755, .652, .673) #re-calc means
m.data_str<- c(".689", ".666", ".725", ".755", ".652", ".673") #re-calc means - string version to make them show up how I want them to..
sd.data   <- c(.034, .076, .011, .045, .018, .041) #re-calc sd's
se.data   <- c(.024, .053, .008, .032, .013, .029) #re-calc se's

se_max    <- m.data + se.data #calc y-max
se_min    <- m.data - se.data #calc y-min

# -------------
# supplementary
name = 'Supplementary Analysis'
m.data    <- c(.692, .687, .712, .720, .675, .656) #supplementary means
m.data_str<- c(".692", ".687", ".712", ".720", ".675", ".656") #supplementary means - string version to make them show up how I want them to..
sd.data   <- c(.007, .011, .015, .011, .016, .038) #supplementary sd's
se.data   <- c(.002, .003, .005, .004, .005, .012) #supplementary se's

se_max    <- m.data + se.data #calc y-max
se_min    <- m.data - se.data #calc y-min

# ---------------
# GENERIC TO BOTH
# ---------------

parcels   <- c('øMR', 'øMR', 'SøR', 'SøR', 'SMø', 'SMø')
xdataset  <- c('Exploratory', 'Confirmatory', 'Exploratory', 'Confirmatory', 'Exploratory', 'Confirmatory')

parcels   <- factor(parcels, unique(parcels)) #order of bars is order encountered in dataset
xdataset  <- factor(xdataset, unique(xdataset)) #order of bars is order encountered in dataset

plot_data <- data.frame(m.data, sd.data, se.data, se_max, se_min, parcels, xdataset)
chance    <- .5 #chance level

plot        <- ggplot(data = plot_data, mapping = aes(x = parcels, y = m.data, fill = xdataset)) #setup plot
lims        <- coord_cartesian(ylim = c(0.25, .8)) #setting y-axis limit
plot_labs   <- labs(x = name, y = 'Mean Accuracy') #customize axis and legend labels
bars        <- geom_col(data = plot_data, group = xdataset, position = 'dodge') #group bars
error_bars  <- geom_errorbar(aes(ymin = se_min, ymax = se_max), width = 0.1, position = position_dodge(width = 0.9)) #add error bars
colors      <- scale_fill_manual(values = c("lawngreen", "dodgerblue3")) # list of colors --> https://www.nceas.ucsb.edu/sites/default/files/2020-04/colorPaletteCheatsheet.pdf
placement   <- scale_y_continuous(expand = c(0,0), breaks = seq(.25, .75, .05), labels = numform::ff_num(digits = 2, zero = 0)) #put bars on x-, breaks sets the tick marks, numform gets rid of the leading zero on the y-axis
hz_line     <- geom_hline(yintercept = (chance), linetype = 'dashed') #horizontal line indicating chance performance
hz_line_lab <- geom_text(aes(0, chance, label = ' Chance', hjust = 'left', vjust = -.5, fontface = 'plain', family = 'Helvetica')) #Chance line label
bar_labs    <- geom_text(aes(label = m.data_str, vjust = 6, fontface = 'plain', family = 'Helvetica'), position = position_dodge(width = 0.9), size = 4) #add means to the figure
themez     <- theme_apa(legend.pos = 'right', legend.font.size = '12') # move legend to top for third version to crop for the legend

zplot       <- plot + lims + plot_labs + bars + error_bars + colors + placement + hz_line + hz_line_lab + bar_labs + themez# + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) #no y ticks for the right side of the graph (although now that I am just cropping them, I don't think it really matters...)
zplot

