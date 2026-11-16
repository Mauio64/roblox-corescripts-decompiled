local v = require(script.Parent.FFlagBuyRobuxLatencyIxpEnabled)

local defineFastFlag = game:DefineFastFlag("EnableBuyRobuxNewRouting2", false)
local defineFastFlag2 = game:DefineFastFlag("EnableBuyRobuxNewRouting3", false)

if not (defineFastFlag or defineFastFlag2) then
	return defineFastFlag2
end

return v
