local parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(parent.React)

local ChatCaptureGalleryView = require(script.Parent.ChatCaptureGalleryView)
local useChatCaptureGalleryViewModel = require(script.Parent.useChatCaptureGalleryViewModel)

local function ChatCaptureGalleryContainer(p)
	local v = useChatCaptureGalleryViewModel(p)
	return React.createElement(ChatCaptureGalleryView, v)
end

return ChatCaptureGalleryContainer
