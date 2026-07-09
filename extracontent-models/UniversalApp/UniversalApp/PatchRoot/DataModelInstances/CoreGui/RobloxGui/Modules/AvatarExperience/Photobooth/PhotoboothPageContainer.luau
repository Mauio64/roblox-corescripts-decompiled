local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local PhotoboothPage = require(Modules.AvatarExperience.Photobooth.PhotoboothPage)
local usePhotoboothPageProps = require(Modules.AvatarExperience.Photobooth.usePhotoboothPageProps)

local function PhotoboothPageContainer() -- line: 11
	-- upvalues: usePhotoboothPageProps (copy), React (copy), PhotoboothPage (copy)
	local v7 = usePhotoboothPageProps()

	return React.createElement(PhotoboothPage, v7)
end

return (require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)(PhotoboothPageContainer))
