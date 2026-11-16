local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local RoactUtils = require(parent.RoactUtils)
local tutils = require(parent.tutils)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

require(ExpChat.installReducer.Messages)

return function()
	return (useSelector(function(p)
		return p.Messages
	end, tutils.shallowEqual))
end
