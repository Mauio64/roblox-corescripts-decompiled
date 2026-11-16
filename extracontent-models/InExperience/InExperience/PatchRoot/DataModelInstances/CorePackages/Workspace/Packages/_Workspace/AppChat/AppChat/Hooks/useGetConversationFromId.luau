local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getDeepValue = require(AppChat.Utils.getDeepValue)

return function(p: string?)
	return useSelector(function(p2)
		return getDeepValue(p2, `ChatAppReducer.Conversations.{p}`)
	end)
end
