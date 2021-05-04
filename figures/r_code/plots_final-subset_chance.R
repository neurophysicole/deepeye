# Figure -- Subsets v. Chance

# this is mixed with the image and timeline data so need to go through and run line-by-line

# packages
library('ggplot2')
library('ggpubr')
library('jtools')

# --------
# IMG!
# img data
m.data    <- c(.436, .449, .449, .430, .413, .400, .439, .466, .414, .392, .412, .422, .333, .340) #means
m.data_str<- c(".436", ".449", ".449", ".430", ".413", ".400", ".439", ".466", ".414", ".392", ".412", ".422", ".333", ".340") #made it into a string so the figure will show it how I want
sd.data   <- c(.020, .012, .014, .044, .014, .026, .014, .012, .017, .030, .016, .024, 5.925e-4, .012) #sd's
se.data   <- c(.006, .004, .004, .014, .004, .008, .005, .004, .005, .009, .005, .008, 1.874e-4, .004) #se's
se_max    <- m.data + se.data #calc y-max
se_min    <- m.data - se.data #calc y-min

paramval  <- c('', '', 'a', '', '', 'a', '', '', 'a', '', '', '', 'a', 'a')

# -------------
# TIMELINE
# timeline data
m.data    <- c(.526, .537, .466, .488, .509, .507, .536, .555, .484, .486, .460, .484, .427, .431) #means
m.data_str<- c(".526", ".537", ".466", ".488", ".509", ".507", ".536", ".555", ".484", ".486", ".460", ".484", ".427", ".431") #made it into a string so the figure will show it how I want
sd.data   <- c(.018, .036, .008, .010, .011, .013, .018, .016, .010, .015, .010, .009, .011, .011) #sd's
se.data   <- c(.006, .011, .002, .003, .003, .004, .006, .005, .003, .005, .003, .003, .003, .004) #se's
se_max    <- m.data + se.data #calc y-max
se_min    <- m.data - se.data #calc y-min

paramval  <- c('', '', '', '', '', '', 'a', '', '', '', '', '', '', '')


# ---------------
# GENERIC TO BOTH
# ---------------


parcels   <- c('XYP', 'XYP', 'øYP', 'øYP', 'XøP', 'XøP', 'XYø', 'XYø', 'øYø', 'øYø', 'Xøø', 'Xøø', 'øøP', 'øøP')
xdataset  <- c('Exploratory', 'Confirmatory', 'Exploratory', 'Confirmatory','Exploratory', 'Confirmatory','Exploratory', 'Confirmatory','Exploratory', 'Confirmatory','Exploratory', 'Confirmatory','Exploratory', 'Confirmatory')

parcels   <- factor(parcels, unique(parcels)) #order of bars is order encountered in dataset
xdataset  <- factor(xdataset, unique(xdataset)) #order of bars is order encountered in dataset

plot_data <- data.frame(m.data, sd.data, se.data, se_max, se_min, paramval, parcels, xdataset)
chance    <- 1/3 #chance level

plot        <- ggplot(data = plot_data, mapping = aes(x = parcels, y = m.data, fill = xdataset)) #setup plot
lims        <- coord_cartesian(ylim = c(.25, .6)) #setting y-axis limit
plot_labs   <- labs(x = 'Data Subsets', y = 'Mean Accuracy') #customize axis and legend labels
bars        <- geom_col(data = plot_data, group = xdataset, position = 'dodge') #group bars
error_bars  <- geom_errorbar(aes(ymin = se_min, ymax = se_max), width = 0.1, position = position_dodge(width = 0.9)) #add error bars
# colors      <- scale_fill_brewer(palette = 'Set1') #set the color scheme
colors      <- scale_fill_manual(values = c("lawngreen", "dodgerblue3")) # list of colors --> https://www.nceas.ucsb.edu/sites/default/files/2020-04/colorPaletteCheatsheet.pdf
placement   <- scale_y_continuous(expand = c(0,0), breaks = seq(.25, .55, .05), labels = numform::ff_num(digits = 2, zero = 0)) #put bars on x-, breaks sets the tick marks, numform gets rid of the leading zero on the y-axis
hz_line     <- geom_hline(yintercept = (chance), linetype = 'dashed') #horizontal line indicating chance performance
hz_line_lab <- geom_text(aes(0, chance, label = ' Chance', hjust = 'left', vjust = -1, fontface = 'plain', family = 'Helvetica')) #Chance line label
bar_labs    <- geom_text(aes(label = m.data_str, vjust = 4, fontface = 'plain', family = 'Helvetica'), position = position_dodge(width = 0.9), size = 2.5) #add means to the figure
theme       <- theme_apa(legend.pos = 'top', legend.font.size = '12')

zplot      <- plot + lims + plot_labs + bars + error_bars + colors + placement + hz_line + hz_line_lab + bar_labs + theme
zplot
