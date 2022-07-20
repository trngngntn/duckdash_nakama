local nk = require('nakama')
local stats = require('data.modules.math.stats')
nk.logger_info("Hello World!")

for i = 1 , 1000, 1 
do
    nk.logger_info(i + " " + stats.pChisq(i, 2))
end