local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local AvatarContextMenuWhisperSelected = require(actions.AvatarContextMenuWhisperSelected)

return event(AvatarContextMenuWhisperSelected)
