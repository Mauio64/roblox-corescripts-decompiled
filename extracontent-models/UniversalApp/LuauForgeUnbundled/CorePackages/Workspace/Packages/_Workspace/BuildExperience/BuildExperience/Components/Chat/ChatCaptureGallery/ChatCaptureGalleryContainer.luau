local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local ChatCaptureGalleryView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureGalleryView")
local useChatCaptureGalleryViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/useChatCaptureGalleryViewModel")

local function ChatCaptureGalleryContainer(p2)
	local v5 = useChatCaptureGalleryViewModel(p2)
	return React.createElement(ChatCaptureGalleryView, v5)
end

return ChatCaptureGalleryContainer
