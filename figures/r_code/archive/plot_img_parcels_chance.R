# Figure -- Parcellations v. Chance -- Image Data

# Z DRAFT2 -- NOTE: Went through and edited. Left original lines in comments.

# packages
library('ggplot2')
library('ggpubr')
library('jtools')

# data
m.data    <- c(.449, .430, .413, .400, .439, .466, .414, .392, .412, .422, .333, .340) #means
sd.data   <- c(.014, .044, .014, .026, .014, .012, .017, .030, .016, .024, 5.925e-4, .012) #sd's
se.data   <- c(.004, .014, .004, .008, .005, .004, .005, .009, .005, .008, 1.874e-4, .004) #se's
se_max    <- m.data + se.data #calc y-max
se_min    <- m.data - se.data #calc y-min

# labels
# p_values  <- c('***', '***', '***', '**', '***', '***', '***', '***', '***', '***', '', '*')
paramval  <- c('a', '', '', 'a', '', '', 'a', '', '', '', 'a', 'a')
# parcels   <- c('No X', 'No X', 'No Y', 'No Y', 'No Pupil Size', 'No Pupil Size', 'Only Y', 'Only Y', 'Only X', 'Only X', 'Only Pupil Size', 'Only Pupil Size')
parcels   <- c('øYP', 'øYP', 'XøP', 'XøP', 'XYø', 'XYø', 'øYø', 'øYø', 'Xøø', 'Xøø', 'øøP', 'øøP')
xdataset  <- c('Exploratory', 'Confirmatory','Exploratory', 'Confirmatory','Exploratory', 'Confirmatory','Exploratory', 'Confirmatory','Exploratory', 'Confirmatory','Exploratory', 'Confirmatory')

parcels   <- factor(parcels, unique(parcels)) #order of bars is order encountered in dataset
xdataset  <- factor(xdataset, unique(xdataset)) #order of bars is order encountered in dataset

# make the data frame
# plot_data <- data.frame(m.data, sd.data, se.data, se_max, se_min, p_values, paramval, parcels, xdataset)
plot_data <- data.frame(m.data, sd.data, se.data, se_max, se_min, paramval, parcels, xdataset)
chance    <- 1/3 #chance level

# plot sections
plot        <- ggplot(data = plot_data, mapping = aes(x = parcels, y = m.data, fill = xdataset)) #setup plot
# lims        <- coord_cartesian(ylim = c(0, .65)) #setting y-axis limit
lims        <- coord_cartesian(ylim = c(0, .6)) #setting y-axis limit
plot_labs   <- labs(x = 'Dataset Parcellations', y = 'Mean Accuracy') #customize axis and legend labels
bars        <- geom_col(data = plot_data, group = xdataset, position = 'dodge') #group bars
error_bars  <- geom_errorbar(aes(ymin = se_min, ymax = se_max), width = 0.1, position = position_dodge(width = 0.9)) #add error bars
colors      <- scale_fill_brewer(palette = 'Set1') #set the color scheme
placement   <- scale_y_continuous(expand = c(0,0)) #put bars on x-axis
# sig_labs    <- geom_text(data = plot_data, aes(label = p_values), position = position_dodge(width = 0.9), vjust = -3) #p-value labels (e.g., ***)
hz_line     <- geom_hline(yintercept = (chance), linetype = 'dashed') #horizontal line indicating chance performance
hz_line_lab <- geom_text(aes(0, chance, label = ' Chance', hjust = 'left', vjust = -1, fontface = 'plain', family = 'Helvetica')) #Chance line label
# theme       <- theme_pubr(legend.pos = 'top', legend.font.size = '12')
theme       <- theme_apa(legend.pos = 'top', legend.font.size = '12')


# plot it!
# plot + lims + plot_labs + bars + error_bars + colors + placement + sig_labs + hz_line + hz_line_lab + theme
plot + lims + plot_labs + bars + error_bars + colors + placement + hz_line + hz_line_lab + theme

