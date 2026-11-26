local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

return function()
	return useSelector(function(p2): boolean
		return not Cryo.isEmpty(getDeepValue(p2, "ChatAppReducer.Conversations") or {})
	end)
end
