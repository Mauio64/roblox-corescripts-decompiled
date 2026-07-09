local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local usePhotoboothAnimationsProps = require(Modules.AvatarExperience.Photobooth.Components.Animations.usePhotoboothAnimationsProps)
local PhotoboothAnimations = require(Modules.AvatarExperience.Photobooth.Components.Animations.PhotoboothAnimations)

local function PhotoboothAnimationsContainer(t1: {[any]: any}) -- line: 21
	-- upvalues: usePhotoboothAnimationsProps (copy), React (copy), PhotoboothAnimations (copy)
	local v8 = usePhotoboothAnimationsProps(t1.Position, t1.onTileClicked)

	return React.createElement(PhotoboothAnimations, v8)
end

return PhotoboothAnimationsContainer
