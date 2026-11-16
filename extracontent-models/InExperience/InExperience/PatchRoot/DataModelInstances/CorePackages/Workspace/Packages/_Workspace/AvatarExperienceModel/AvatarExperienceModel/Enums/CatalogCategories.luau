local parent = script:FindFirstAncestor("AvatarExperienceModel").Parent

local enumerate = require(parent.enumerate)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogM41Props = AvatarExperienceFlags.FFlagAXCatalogM41Props
local FFlagAXAddHDCatalogTab = AvatarExperienceFlags.FFlagAXAddHDCatalogTab
local FFlagAXCatalogBackgroundsSupport = AvatarExperienceFlags.FFlagAXCatalogBackgroundsSupport

return enumerate(script.Name, {
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
	Backgrounds = FFlagAXCatalogBackgroundsSupport and "Backgrounds" or nil,
	Props = FFlagAXCatalogM41Props and "Props" or nil,
	HighDefinition = FFlagAXAddHDCatalogTab and "HighDefinition" or nil
})
