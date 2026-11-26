local enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/enumerate")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXCatalogM41Props = AvatarExperienceFlags.FFlagAXCatalogM41Props
local fFlagAXCatalogM41FullMasks = AvatarExperienceFlags.FFlagAXCatalogM41FullMasks
local fFlagAXCatalogM41HandAndArm = AvatarExperienceFlags.FFlagAXCatalogM41HandAndArm
local fFlagAXFixHandAndArmWidgetApiContext = AvatarExperienceFlags.FFlagAXFixHandAndArmWidgetApiContext

return enumerate("CatalogSubcategories", {
	Featured = "Featured",
	Limited = "Limited",
	Community = "Community",
	Premium = "Premium",
	Shirts = "Shirts",
	TShirts = "TShirts",
	Sweaters = "Sweaters",
	Jackets = "Jackets",
	Pants = "Pants",
	DressesAndSkirts = "DressSkirt",
	Shorts = "Shorts",
	Shoes = "Shoes",
	ClassicShirts = "Classic Shirts",
	ClassicTShirts = "Classic T-Shirts",
	ClassicPants = "Classic Pants",
	Bodysuits = "Bodysuits",
	Hats = "Hats",
	Face = "Face",
	FullMasks = fFlagAXCatalogM41FullMasks and "Full Masks" or nil,
	Neck = "Neck",
	Shoulder = "Shoulder",
	HandAndArm = fFlagAXCatalogM41HandAndArm and (fFlagAXFixHandAndArmWidgetApiContext and "Hand And Arm" or "Hand & Arm") or nil,
	Front = "Front",
	Back = "Back",
	Waist = "Waist",
	Gear = "Gear",
	FullBodies = "Full Bodies",
	Heads = "Heads",
	Hair = "Hair",
	MakeupLooks = "Makeup Looks",
	EyeMakeup = "Eye Makeup",
	FaceMakeup = "Face Makeup",
	LipMakeup = "Lip Makeup",
	Eyelashes = "Eyelashes",
	Eyebrows = "Eyebrows",
	AnimationBundles = "AnimationBundles",
	Emotes = "Emotes",
	Props = fFlagAXCatalogM41Props and "Props" or nil
})
