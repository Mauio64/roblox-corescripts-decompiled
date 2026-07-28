local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local VersionTitleDescriptionPageView = require(script.Parent.VersionTitleDescriptionPageView)
local useVersionTitleDescriptionPageViewModel = require(script.Parent.useVersionTitleDescriptionPageViewModel)

local function VersionTitleDescriptionPageContainer(p1) -- line: 11
	-- upvalues: useVersionTitleDescriptionPageViewModel (copy), React (copy), VersionTitleDescriptionPageView (copy)
	local v7 = useVersionTitleDescriptionPageViewModel(p1)

	return React.createElement(VersionTitleDescriptionPageView, v7)
end

return VersionTitleDescriptionPageContainer
