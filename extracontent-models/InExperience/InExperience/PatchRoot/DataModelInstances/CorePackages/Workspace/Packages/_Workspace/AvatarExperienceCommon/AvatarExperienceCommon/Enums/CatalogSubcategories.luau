local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local enumerate = require(parent.enumerate)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogM41Props = AvatarExperienceFlags.FFlagAXCatalogM41Props
local FFlagAXCatalogM41FullMasks = AvatarExperienceFlags.FFlagAXCatalogM41FullMasks
local FFlagAXCatalogM41HandAndArm = AvatarExperienceFlags.FFlagAXCatalogM41HandAndArm
local FFlagAXFixHandAndArmWidgetApiContext = AvatarExperienceFlags.FFlagAXFixHandAndArmWidgetApiContext

return enumerate(script.Name, {
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
	FullMasks = FFlagAXCatalogM41FullMasks and "Full Masks" or nil,
	Neck = "Neck",
	Shoulder = "Shoulder",
	HandAndArm = FFlagAXCatalogM41HandAndArm and (FFlagAXFixHandAndArmWidgetApiContext and "Hand And Arm" or "Hand & Arm") or nil,
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
	Props = FFlagAXCatalogM41Props and "Props" or nil
})
