local module = require("@luauforge/bundled/dXA")
local fFlagUseSignalsRoduxStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsRoduxStore

local SetScreenSize = require("@game/CoreGui/RobloxGui/Modules/PlayerList/Actions/SetScreenSize")

local defineFastFlag = game:DefineFastFlag("DebugScreenSizeUseDisplayStore", false)

return function(p2, p3, p4)
	if fFlagUseSignalsRoduxStore and defineFastFlag then
		return module.GetDisplayStore(false).getViewportSize(p4)
	end

	local v5 = p2 or Vector2.new(0, 0)
	assert(v5, "")

	if p3.type == SetScreenSize.name then
		return p3.screenSize
	end

	return v5
end
