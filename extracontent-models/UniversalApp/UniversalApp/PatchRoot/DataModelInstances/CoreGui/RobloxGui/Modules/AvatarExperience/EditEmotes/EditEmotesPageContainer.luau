local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useEditEmotesPageProps = require(Modules.AvatarExperience.EditEmotes.useEditEmotesPageProps)
local EditEmotesPage = require(Modules.AvatarExperience.EditEmotes.EditEmotesPage)

local function EditEmotesPageContainer() -- line: 14
	-- upvalues: useEditEmotesPageProps (copy), React (copy), EditEmotesPage (copy)
	local v7 = useEditEmotesPageProps()

	return React.createElement(EditEmotesPage, v7)
end

return (require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)(EditEmotesPageContainer))
