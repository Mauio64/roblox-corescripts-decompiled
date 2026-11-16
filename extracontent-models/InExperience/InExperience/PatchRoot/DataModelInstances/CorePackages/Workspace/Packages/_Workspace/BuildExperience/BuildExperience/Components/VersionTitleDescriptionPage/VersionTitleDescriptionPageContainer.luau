local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local VersionTitleDescriptionPageView = require(script.Parent.VersionTitleDescriptionPageView)
local useVersionTitleDescriptionPageViewModel = require(script.Parent.useVersionTitleDescriptionPageViewModel)

local function VersionTitleDescriptionPageContainer(p)
	local v = useVersionTitleDescriptionPageViewModel(p)
	return React.createElement(VersionTitleDescriptionPageView, v)
end

return VersionTitleDescriptionPageContainer
