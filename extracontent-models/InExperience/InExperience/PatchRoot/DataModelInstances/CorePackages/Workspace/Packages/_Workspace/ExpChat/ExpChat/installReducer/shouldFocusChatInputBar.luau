local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local ExpChatShared = require(parent.ExpChatShared)

local v = ExpChatShared.Logger:new("ExpChat/Reducers/" .. script.Name)

local Actions = ExpChat.Actions
local AvatarContextMenuWhisperSelected = require(Actions.AvatarContextMenuWhisperSelected)
local PresetTrayKeyboardSelected = require(Actions.PresetTrayKeyboardSelected)

return Rodux.createReducer(1, {
	[AvatarContextMenuWhisperSelected.name] = function(p: number, _)
		v:trace("AvatarContextMenuWhisperSelected dispatched")
		return p * -1
	end,
	[PresetTrayKeyboardSelected.name] = function(p: number, _)
		v:trace("PresetTrayKeyboardSelected dispatched")
		return p * -1
	end
})
