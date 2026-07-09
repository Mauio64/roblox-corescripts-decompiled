local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local v4 = require(ExpChatParent.ExpChatShared).Logger:new("ExpChat/Reducers/" .. script.Name)
local Actions = ExpChat.Actions
local AvatarContextMenuWhisperSelected = require(Actions.AvatarContextMenuWhisperSelected)
local PresetTrayKeyboardSelected = require(Actions.PresetTrayKeyboardSelected)

return Rodux.createReducer(1, {
	[AvatarContextMenuWhisperSelected.name] = function(n1: number, _) -- line: 15
		-- upvalues: v4 (copy)
		v4:trace("AvatarContextMenuWhisperSelected dispatched")

		return n1 * -1
	end,
	[PresetTrayKeyboardSelected.name] = function(n2: number, _) -- line: 20
		-- upvalues: v4 (copy)
		v4:trace("PresetTrayKeyboardSelected dispatched")

		return n2 * -1
	end
})
