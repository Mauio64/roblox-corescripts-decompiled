local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local BuildChatPageView = require(script.Parent.BuildChatPageView)
local useBuildChatPageViewModel = require(script.Parent.useBuildChatPageViewModel)

local function BuildChatPage(p1) -- line: 11
	-- upvalues: useBuildChatPageViewModel (copy), React (copy), BuildChatPageView (copy)
	local v7 = useBuildChatPageViewModel(p1)

	return React.createElement(BuildChatPageView, v7)
end

return BuildChatPage
