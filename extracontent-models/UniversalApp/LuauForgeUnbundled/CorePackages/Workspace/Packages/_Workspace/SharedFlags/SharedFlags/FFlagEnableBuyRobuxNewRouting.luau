local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagBuyRobuxLatencyIxpEnabled")

local defineFastFlag = game:DefineFastFlag("EnableBuyRobuxNewRouting2", false)
local defineFastFlag2 = game:DefineFastFlag("EnableBuyRobuxNewRouting3", false)

if not (defineFastFlag or defineFastFlag2) then
	v5 = defineFastFlag2
end

return v5
