local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getDeepValue = require(AppChat.Utils.getDeepValue)
local Cryo = require(parent.Cryo)

return function()
	return useSelector(function(p): boolean
		return not Cryo.isEmpty(getDeepValue(p, "ChatAppReducer.Conversations") or {})
	end)
end
