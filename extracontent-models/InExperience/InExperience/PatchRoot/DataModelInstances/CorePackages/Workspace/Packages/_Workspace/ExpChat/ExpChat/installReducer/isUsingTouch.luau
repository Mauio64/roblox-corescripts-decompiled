local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local ClientAppLoaded = require(ExpChatParent.ExpChatShared).Actions.ClientAppLoaded
local LastInputTypeChanged = require(ExpChat.Actions.LastInputTypeChanged)

return Rodux.createReducer(false, {
	[ClientAppLoaded.name] = function(_: boolean, p1) -- line: 10
		return p1.isTouchEnabled
	end,
	[LastInputTypeChanged.name] = function(b2: boolean, p2) -- line: 13
		if p2.lastInputTypeUsed == Enum.UserInputType.Touch then
			return true
		end

		if p2.lastInputTypeUsed == Enum.UserInputType.Keyboard then
			return false
		end

		return b2
	end
})
