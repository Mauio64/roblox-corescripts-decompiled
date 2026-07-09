local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local RoactUtils = require(ExpChatParent.RoactUtils)
local tutils = require(ExpChatParent.tutils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

require(ExpChat.installReducer.Messages)

return function() -- line: 14
	-- upvalues: useSelector (copy), tutils (copy)
	return (useSelector(function(p1) -- line: 15
		return p1.Messages
	end, tutils.shallowEqual))
end
