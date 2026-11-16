local parent = script:FindFirstAncestor("MomentsCreation").Parent

local React = require(parent.React)

local VoiceEditorView = require(script.Parent.VoiceEditorView)
local useVoiceEditorViewModel = require(script.Parent.useVoiceEditorViewModel)

local function VoiceEditor(p)
	local v = useVoiceEditorViewModel(p)
	return React.createElement(VoiceEditorView, v)
end

return VoiceEditor
