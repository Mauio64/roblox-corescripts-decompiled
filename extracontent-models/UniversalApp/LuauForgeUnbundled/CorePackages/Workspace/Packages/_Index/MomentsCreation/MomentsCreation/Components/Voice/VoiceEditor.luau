local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local VoiceEditorView = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/VoiceEditorView")
local useVoiceEditorViewModel = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/useVoiceEditorViewModel")

local function VoiceEditor(p2)
	local v5 = useVoiceEditorViewModel(p2)
	return React.createElement(VoiceEditorView, v5)
end

return VoiceEditor
