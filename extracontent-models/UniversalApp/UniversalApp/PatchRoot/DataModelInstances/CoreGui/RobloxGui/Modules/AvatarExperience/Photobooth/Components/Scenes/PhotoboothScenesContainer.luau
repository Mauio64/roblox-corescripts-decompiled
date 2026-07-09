local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local usePhotoboothScenesProps = require(Modules.AvatarExperience.Photobooth.Components.Scenes.usePhotoboothScenesProps)
local PhotoboothScenes = require(Modules.AvatarExperience.Photobooth.Components.Scenes.PhotoboothScenes)

local function PhotoboothScenesContainer(t1: {[any]: any}) -- line: 13
	-- upvalues: usePhotoboothScenesProps (copy), React (copy), PhotoboothScenes (copy)
	local v8 = usePhotoboothScenesProps(t1.Position, t1.onTileClicked)

	return React.createElement(PhotoboothScenes, v8)
end

return PhotoboothScenesContainer
