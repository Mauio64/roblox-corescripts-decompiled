local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")

local AssetPickerCarousel = require(script.AssetPickerCarousel)
local AssetPickerGrid = require(script.AssetPickerGrid)
require(script.AssetPickerTile)
require(AvatarExperienceProfilePictureEditor.Utils.getAssetPickerStatus)

return { AssetPickerCarousel = AssetPickerCarousel, AssetPickerGrid = AssetPickerGrid }
