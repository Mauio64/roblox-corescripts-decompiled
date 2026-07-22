local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local enumerate = require(Parent.enumerate)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
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
	Backgrounds = if not FFlagAXCatalogBackgroundsSupport then nil else "Backgrounds",
	Props = if not FFlagAXCatalogM41Props then nil else "Props",
	HighDefinition = if not FFlagAXAddHDCatalogTab then nil else "HighDefinition"
})
