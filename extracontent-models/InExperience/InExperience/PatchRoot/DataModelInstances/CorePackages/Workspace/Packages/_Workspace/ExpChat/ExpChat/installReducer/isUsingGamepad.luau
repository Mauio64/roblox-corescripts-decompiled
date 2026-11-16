local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local ExpChatShared = require(parent.ExpChatShared)

local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local LastInputTypeChanged = require(ExpChat.Actions.LastInputTypeChanged)

return Rodux.createReducer(false, {
	[ClientAppLoaded.name] = function(_: boolean, p)
		return p.isGamepadEnabled
	end,
	[LastInputTypeChanged.name] = function(flag: boolean, p)
		if p.lastInputTypeUsed == Enum.UserInputType.Gamepad1 then
			return true
		end

		return p.lastInputTypeUsed ~= Enum.UserInputType.Keyboard and flag
	end
})
