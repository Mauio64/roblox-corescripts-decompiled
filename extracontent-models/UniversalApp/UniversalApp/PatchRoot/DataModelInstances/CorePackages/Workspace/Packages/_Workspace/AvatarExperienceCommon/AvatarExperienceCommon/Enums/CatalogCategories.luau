local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local enumerate = require(Parent.enumerate)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
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
	AllAnimations = "AllAnimations",
	Emotes = "Emotes",
	Makeup = if not FFlagAXCustomizeMakeupSupport and not FFlagAXCatalogMakeupSupport then nil else "Makeup",
	Backgrounds = if not FFlagAXCatalogBackgroundsSupport then nil else "Backgrounds",
	Props = if not FFlagAXCatalogM41Props then nil else "Props",
	HighDefinition = if not FFlagAXAddHDCatalogTab then nil else "HighDefinition"
})
