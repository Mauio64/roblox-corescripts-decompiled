local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")

return function(p2)
	return useSelector(function(p3)
		return getDeepValue(p3, `ChatAppReducer.Conversations.{p2}`)
	end)
end
