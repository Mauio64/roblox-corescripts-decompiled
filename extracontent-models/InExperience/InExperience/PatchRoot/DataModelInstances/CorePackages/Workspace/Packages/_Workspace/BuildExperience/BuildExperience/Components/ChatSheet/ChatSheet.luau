local BuildExperience = script:FindFirstAncestor("BuildExperience")

local parent = BuildExperience.Parent

local React = require(parent.React)

require(BuildExperience.Chat.chatTypes)
local ChatSheetView = require(script.Parent.ChatSheetView)
local useChatSheetViewModel = require(script.Parent.useChatSheetViewModel)

local function ChatSheet(p)
	local v = useChatSheetViewModel(p)
	return React.createElement(ChatSheetView, v)
end

return ChatSheet
