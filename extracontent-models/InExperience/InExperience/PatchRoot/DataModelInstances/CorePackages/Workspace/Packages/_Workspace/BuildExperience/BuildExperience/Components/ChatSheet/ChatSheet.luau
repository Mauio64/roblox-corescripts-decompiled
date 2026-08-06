local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)

require(BuildExperience.Chat.chatTypes)

local ChatSheetView = require(script.Parent.ChatSheetView)
local useChatSheetViewModel = require(script.Parent.useChatSheetViewModel)

local function ChatSheet(p1) -- line: 14
	-- upvalues: useChatSheetViewModel (copy), React (copy), ChatSheetView (copy)
	local v8 = useChatSheetViewModel(p1)

	return React.createElement(ChatSheetView, v8)
end

return ChatSheet
