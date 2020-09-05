# confusion matrices equivalency math for DeepEye supplementary analysis

# -------------------------------
# original scores (timeline data)
# exploratory
e_s = [ .527, .266, .207 ] #search row
e_m = [ .273, .484, .243 ] #memorize row
e_r = [ .207, .227, .567 ] #rate row
# confirmatory
c_s = [ .553, .235, .212 ] #search row
c_m = [ .253, .457, .290 ] #memorize row
c_r = [ .163, .235, .602 ] #rate row

# -----------
# do the math
# exploratory -- for confusion matrices
e_sr_s_hit  = e_s[0] / ( e_s[0] + e_s[2] ) #search in search/rate - hits
e_sr_s_miss = e_s[2] / ( e_s[0] + e_s[2] ) #search in search/rate - misses
e_sr_r_hit  = e_r[2] / ( e_r[0] + e_r[2] ) #rate in search/rate - hits
e_sr_r_miss = e_r[0] / ( e_r[0] + e_r[2] ) #rate in search/rate - misses
e_sm_s_hit  = e_s[0] / ( e_s[0] + e_s[1] ) #search in search/memorize - hits
e_sm_s_miss = e_s[1] / ( e_s[0] + e_s[1] ) #search in search/memorize - misses
e_sm_m_hit  = e_m[1] / ( e_m[0] + e_m[1] ) #memorize in search/memorize - hits
e_sm_m_miss = e_m[0] / ( e_m[0] + e_m[1] ) #memorize in search/memorize - misses
e_mr_m_hit  = e_m[1] / ( e_m[1] + e_m[2] ) #memorize in memorize/rate - hits
e_mr_m_miss = e_m[2] / ( e_m[1] + e_m[2] ) #memorize in memorize/rate - misses
e_mr_r_hit  = e_r[2] / ( e_r[1] + e_r[2] ) #rate in memorize/rate - hits
e_mr_r_miss = e_r[1] / ( e_r[1] + e_r[2] ) #rate in memorize/rate - misses
# totals -- for graph
e_sr = ( e_sr_s_hit + e_sr_r_hit ) / 2
e_sm = ( e_sm_s_hit + e_sm_m_hit ) / 2
e_mr = ( e_mr_m_hit + e_mr_r_hit ) / 2

#! note: below was copied from above, so if mistakes in one are likely present in the other

# confirmatory -- for confusion matrices
c_sr_s_hit  = c_s[0] / ( c_s[0] + c_s[2] ) #search in search/rate - hits
c_sr_s_miss = c_s[2] / ( c_s[0] + c_s[2] ) #search in search/rate - misses
c_sr_r_hit  = c_r[2] / ( c_r[0] + c_r[2] ) #rate in search/rate - hits
c_sr_r_miss = c_r[0] / ( c_r[0] + c_r[2] ) #rate in search/rate - misses
c_sm_s_hit  = c_s[0] / ( c_s[0] + c_s[1] ) #search in search/memorize - hits
c_sm_s_miss = c_s[1] / ( c_s[0] + c_s[1] ) #search in search/memorize - misses
c_sm_m_hit  = c_m[1] / ( c_m[0] + c_m[1] ) #memorize in search/memorize - hits
c_sm_m_miss = c_m[0] / ( c_m[0] + c_m[1] ) #memorize in search/memorize - misses
c_mr_m_hit  = c_m[1] / ( c_m[1] + c_m[2] ) #memorize in memorize/rate - hits
c_mr_m_miss = c_m[2] / ( c_m[1] + c_m[2] ) #memorize in memorize/rate - misses
c_mr_r_hit  = c_r[2] / ( c_r[1] + c_r[2] ) #rate in memorize/rate - hits
c_mr_r_miss = c_r[1] / ( c_r[1] + c_r[2] ) #rate in memorize/rate - misses
# totals -- for graph
c_sr = ( c_sr_s_hit + c_sr_r_hit ) / 2
c_sm = ( c_sm_s_hit + c_sm_m_hit ) / 2
c_mr = ( c_mr_m_hit + c_mr_r_hit ) / 2

# print it out
print('\n\n-----\nEXPLORATORY')
print('search - rate: %f' %e_sr)
print('search - memorize: %f' %e_sm)
print('memorize - rate: %f' %e_mr)

print('\n\n-----\nCONFIRMATORY')
print('search - rate: %f' %c_sr)
print('search - memorize: %f' %c_sm)
print('memorize - rate: %f' %c_mr)