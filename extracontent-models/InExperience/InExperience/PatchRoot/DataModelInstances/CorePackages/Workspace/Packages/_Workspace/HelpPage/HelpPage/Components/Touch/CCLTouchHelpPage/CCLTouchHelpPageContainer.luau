local parent = script:FindFirstAncestor("HelpPage").Parent
local React = require(parent.React)

local CCLTouchHelpPageView = require(script.Parent.CCLTouchHelpPageView)
local useCCLTouchHelpPageViewModel = require(script.Parent.useCCLTouchHelpPageViewModel)

local function CCLTouchHelpPageContainer()
	local v = useCCLTouchHelpPageViewModel()
	return React.createElement(CCLTouchHelpPageView, v)
end

return CCLTouchHelpPageContainer
