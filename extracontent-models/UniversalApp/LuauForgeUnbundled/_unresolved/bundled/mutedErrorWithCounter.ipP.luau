local module = require("@luauforge/bundled/dFs")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local module2 = require("@luauforge/bundled/dPN")

local function mutedErrorWithCounter(p2, p3)
	module(`[AXNilGuard] {p2}{p3 == nil and "" or " :: " .. p3}`)
	local v5 = module2.Counter.NilGuard[p2]

	if v5 ~= nil then
		sendAXCounterV2(v5)
	end
end

return mutedErrorWithCounter
