local enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/enumerate")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceFlags")
local fFlagAXCatalogM41Props = AvatarExperienceFlags.FFlagAXCatalogM41Props
local fFlagAXAddHDCatalogTab = AvatarExperienceFlags.FFlagAXAddHDCatalogTab
return enumerate("CatalogCategories", {
	Featured = "Featured",
	Recommended = "Recommended",
	Characters = "Characters",
	Avatars = "Avatars",
	Clothing = "Clothing",
	Accessories = "Accessories",
	Head = "Head",
	Body = "Body",
	Makeup = "Makeup",
	AllAnimations = "AllAnimations",
	Emotes = "Emotes",
	Backgrounds = AvatarExperienceFlags.FFlagAXCatalogBackgroundsSupport and "Backgrounds" or nil,
	Props = fFlagAXCatalogM41Props and "Props" or nil,
	HighDefinition = fFlagAXAddHDCatalogTab and "HighDefinition" or nil
})
