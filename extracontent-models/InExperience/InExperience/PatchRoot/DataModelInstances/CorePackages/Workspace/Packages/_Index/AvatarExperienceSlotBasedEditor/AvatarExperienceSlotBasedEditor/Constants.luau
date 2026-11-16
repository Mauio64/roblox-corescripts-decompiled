require(script.Parent.Types)
local InventoryFilters = require(script.Parent.Enums.InventoryFilters)
local SlotType = require(script.Parent.Enums.SlotType)
local Constants = {}
local Categories = require(script.Parent.Enums.Categories)

local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local AvatarEditorSubcategories = AvatarExperienceModel.Enums.AvatarEditorSubcategories
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagRemoveClassicHeadsAndFaces = AvatarExperienceFlags.FFlagRemoveClassicHeadsAndFaces
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagAXSlotsDesktopRedesign = AvatarExperienceFlags.FFlagAXSlotsDesktopRedesign
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local FFlagAXCustomizeBackgrounds = AvatarExperienceFlags.FFlagAXCustomizeBackgrounds
local FFlagAXDownrankMakeupCustomize = AvatarExperienceFlags.FFlagAXDownrankMakeupCustomize

local Foundation = require(parent.Foundation)
local IconName = Foundation.Enums.IconName
local Foundation2 = require(parent.Foundation)
local IconVariant = Foundation2.Enums.IconVariant

local icons = {
	FullBody = FFlagAXMigrateBuilderIcons and {
		name = IconName.PersonStanding,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/body_on",
	ClassicHead = FFlagAXMigrateBuilderIcons and {
		name = IconName.HeadBlank,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/classicHead_on",
	Hair = FFlagAXMigrateBuilderIcons and {
		name = IconName.HeadFemale,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/hair_on",
	Faces = FFlagAXMigrateBuilderIcons and {
		name = IconName.FaceWinking,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/faces_on",
	Clothing = FFlagAXMigrateBuilderIcons and {
		name = IconName.ClothesHanger,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/clothing_on",
	Jackets = FFlagAXMigrateBuilderIcons and {
		name = IconName.Jacket,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/jackets_on",
	Shirts = FFlagAXMigrateBuilderIcons and { name = IconName.Shirt, variant = IconVariant.Filled } or "icons/menu/clothing/shirts_on",
	Pants = FFlagAXMigrateBuilderIcons and { name = IconName.Pants, variant = IconVariant.Filled } or "icons/menu/clothing/pants_on",
	Shoes = FFlagAXMigrateBuilderIcons and { name = IconName.Shoe, variant = IconVariant.Filled } or "icons/menu/clothing/shoes_on",
	ClassicTShirts = FFlagAXMigrateBuilderIcons and {
		name = IconName.Tshirt_2dText,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/classicTshirts_on",
	ClassicShirts = FFlagAXMigrateBuilderIcons and {
		name = IconName.Shirt_2dText,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/classicShirts_on",
	ClassicPants = FFlagAXMigrateBuilderIcons and {
		name = IconName.Pants_2dText,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/classicPants_on",
	Accessories = FFlagAXMigrateBuilderIcons and {
		name = IconName.BowTie,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/accessories_off",
	Head = FFlagAXMigrateBuilderIcons and {
		name = IconName.HatFedora,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/hats_on",
	Face = FFlagAXMigrateBuilderIcons and { name = IconName.Glasses, variant = IconVariant.Filled } or "icons/menu/clothing/eyes_on",
	Neck = FFlagAXMigrateBuilderIcons and { name = IconName.Necklace, variant = IconVariant.Filled } or "icons/menu/clothing/neck_off",
	Shoulder = FFlagAXMigrateBuilderIcons and {
		name = IconName.Parrot,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/shoulder_on",
	Front = FFlagAXMigrateBuilderIcons and { name = IconName.Purse, variant = IconVariant.Filled } or "icons/menu/clothing/front_on",
	Back = FFlagAXMigrateBuilderIcons and {
		name = IconName.ButterflyWings,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/back_on",
	Waist = FFlagAXMigrateBuilderIcons and { name = IconName.Belt, variant = IconVariant.Filled } or "icons/menu/clothing/waist_on",
	Gear = FFlagAXMigrateBuilderIcons and { name = IconName.Sword, variant = IconVariant.Filled } or "icons/menu/clothing/gear_on",
	Animation = FFlagAXMigrateBuilderIcons and {
		name = IconName.PersonTeleport,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/animation_off",
	Idle = FFlagAXMigrateBuilderIcons and {
		name = IconName.PersonStanding,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/idle_on",
	Walk = FFlagAXMigrateBuilderIcons and {
		name = IconName.PersonWalking,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/walk_off",
	Jump = FFlagAXMigrateBuilderIcons and {
		name = IconName.PersonJumping,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/jump_off",
	Fall = FFlagAXMigrateBuilderIcons and {
		name = IconName.PersonFalling,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/fall_off",
	Climb = FFlagAXMigrateBuilderIcons and {
		name = IconName.PersonClimbing,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/climb_off",
	Swim = FFlagAXMigrateBuilderIcons and {
		name = IconName.PersonSwimming,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/swim_off",
	Emote = FFlagAXMigrateBuilderIcons and {
		name = IconName.SquareFaceWavingHand,
		variant = IconVariant.Filled
	} or "icons/controls/emoteOn",
	Reset = FFlagAXMigrateBuilderIcons and {
		name = IconName.ArrowSpinClockwise,
		variant = IconVariant.Regular
	} or "icons/actions/reset",
	Undo = FFlagAXMigrateBuilderIcons and {
		name = IconName.ArrowCurlToLeft,
		variant = IconVariant.Regular
	} or "icons/actions/edit/undo",
	Redo = FFlagAXMigrateBuilderIcons and {
		name = IconName.ArrowCurlToRight,
		variant = IconVariant.Regular
	} or "icons/actions/edit/redo",
	Torso = FFlagAXMigrateBuilderIcons and { name = IconName.Torso, variant = IconVariant.Filled } or "icons/menu/clothing/torsos_on",
	Arm = FFlagAXMigrateBuilderIcons and { name = IconName.Arm, variant = IconVariant.Filled } or "icons/menu/clothing/arms_on",
	Leg = FFlagAXMigrateBuilderIcons and { name = IconName.Leg, variant = IconVariant.Filled } or "icons/menu/clothing/legs_on",
	Inventory = FFlagAXMigrateBuilderIcons and {
		name = IconName.Backpack,
		variant = IconVariant.Regular
	} or "icons/menu/inventoryOff",
	Adjust = FFlagAXMigrateBuilderIcons and {
		name = IconName.ThreeSlidersHorizontal,
		variant = IconVariant.Regular
	} or "icons/actions/adjust",
	Success = FFlagAXMigrateBuilderIcons and {
		name = IconName.CheckLarge,
		variant = IconVariant.Filled
	} or "icons/status/success_small",
	Add = FFlagAXMigrateBuilderIcons and {
		name = IconName.CirclePlus,
		variant = IconVariant.Regular
	} or "icons/actions/edit/add",
	Build = FFlagAXMigrateBuilderIcons and {
		name = IconName.PersonStandingDualArrowsVertical,
		variant = IconVariant.Filled
	} or "icons/menu/clothing/build_on"
}
local eyelashes

if FFlagAXMigrateBuilderIcons then
	eyelashes = { name = IconName.Eyelashes, variant = IconVariant.Regular }
else
	eyelashes = IconName.Eyelashes
end

icons.Eyelashes = eyelashes
local eyebrows

if FFlagAXMigrateBuilderIcons then
	eyebrows = { name = IconName.Eyebrows, variant = IconVariant.Regular }
else
	eyebrows = IconName.Eyebrows
end

icons.Eyebrows = eyebrows

icons.Backgrounds = { name = IconName.Image, variant = IconVariant.Filled }

local bodyAssetTypes = {
	Enum.AssetType.LeftLeg,
	Enum.AssetType.RightLeg,
	Enum.AssetType.LeftArm,
	Enum.AssetType.RightArm,
	Enum.AssetType.Torso,
	Enum.AssetType.Head,
	Enum.AssetType.DynamicHead
}

local v = { Categories.All, Categories.Avatars, Categories.Body }

if not FFlagAXDownrankMakeupCustomize then
	table.insert(v, Categories.Makeup)
end

table.insert(v, Categories.Clothing)
table.insert(v, Categories.Accessories)

if FFlagAXCustomizeBackgrounds then
	table.insert(v, Categories.Backgrounds)
end

table.insert(v, Categories.Animations)
table.insert(v, Categories.Emotes)

if FFlagAXDownrankMakeupCustomize then
	table.insert(v, Categories.Makeup)
end

local v2 = {}

for k, v3 in v do
	v2[v3] = k - 1
end

local slotEditorCategories = {
	[Categories.All] = {
		name = "All",
		nameTranslationKey = FFlagAXSlotsDesktopRedesign and "Feature.Avatar.Heading.All" or "Feature.Catalog.Label.Avatars",
		index = v2[Categories.All],
		slots = {},
		hide = true
	},
	[Categories.Avatars] = {
		name = "Avatars",
		nameTranslationKey = "Feature.Catalog.Label.Avatars",
		index = v2[Categories.Avatars],
		slots = {}
	}
}

local Body = Categories.Body
local v3 = {
	name = "Body",
	nameTranslationKey = "Feature.Catalog.Label.Body",
	index = v2[Categories.Body],
	slots = 0
}
local slots

if FFlagRemoveClassicHeadsAndFaces then
	slots = {
		{
			name = "Body",
			nameTranslationKey = "Feature.Catalog.Label.FullBody",
			editorSubcategory = AvatarEditorSubcategories.PurchasedCharacters,
			assetTypes = {}
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Hair",
			icon = icons.Hair,
			editorSubcategory = AvatarEditorSubcategories.Hair,
			assetTypes = { Enum.AvatarAssetType.HairAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Head",
			icon = icons.ClassicHead,
			editorSubcategory = AvatarEditorSubcategories.Heads,
			assetTypes = { Enum.AvatarAssetType.DynamicHead }
		},
		{
			name = "Build",
			nameTranslationKey = "Feature.Avatar.Label.Build",
			assetTypes = {},
			icon = icons.Build,
			editorSubcategory = AvatarEditorSubcategories.Build
		},
		{
			name = "Skin",
			nameTranslationKey = "Feature.Avatar.Label.Skin",
			editorSubcategory = AvatarEditorSubcategories.Skin,
			assetTypes = {}
		}
	}
else
	slots = {
		{
			name = "Body",
			nameTranslationKey = "Feature.Catalog.Label.FullBody",
			editorSubcategory = AvatarEditorSubcategories.PurchasedCharacters,
			assetTypes = {}
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Hair",
			icon = icons.Hair,
			editorSubcategory = AvatarEditorSubcategories.Hair,
			assetTypes = { Enum.AvatarAssetType.HairAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Head",
			icon = icons.ClassicHead,
			editorSubcategory = AvatarEditorSubcategories.Heads,
			assetTypes = { Enum.AvatarAssetType.DynamicHead, Enum.AvatarAssetType.Head }
		},
		{
			name = "Classic Face",
			nameTranslationKey = "Feature.Avatar.Label.Face",
			icon = icons.Faces,
			editorSubcategory = AvatarEditorSubcategories.ClassicFaces,
			assetTypes = { Enum.AvatarAssetType.Face }
		},
		{
			name = "Build",
			nameTranslationKey = "Feature.Avatar.Label.Build",
			assetTypes = {},
			icon = icons.Build,
			editorSubcategory = AvatarEditorSubcategories.Build
		},
		{
			name = "Skin",
			nameTranslationKey = "Feature.Avatar.Label.Skin",
			editorSubcategory = AvatarEditorSubcategories.Skin,
			assetTypes = {}
		}
	}
end

v3.slots = slots
slotEditorCategories[Body] = v3

slotEditorCategories[Categories.Makeup] = {
	name = "Makeup",
	nameTranslationKey = "Feature.Avatar.Label.Makeup",
	index = v2[Categories.Makeup],
	resetSlotOnClearAll = true,
	slots = {
		{
			nameTranslationKey = "Feature.Avatar.Label.Eyelashes",
			icon = icons.Eyelashes,
			editorSubcategory = AvatarEditorSubcategories.MakeupLooks,
			eligibleSubcategories = {
				AvatarEditorSubcategories.MakeupLooks,
				AvatarEditorSubcategories.EyeMakeup,
				AvatarEditorSubcategories.FaceMakeup,
				AvatarEditorSubcategories.LipMakeup
			},
			assetTypes = {},
			hide = true
		},
		{
			slotType = SlotType.LayeredSlot,
			layerLimit = 6,
			name = "Makeup",
			nameTranslationKey = "Feature.Avatar.Label.MakeupLayer",
			eligibleSubcategories = {
				AvatarEditorSubcategories.EyeMakeup,
				AvatarEditorSubcategories.FaceMakeup,
				AvatarEditorSubcategories.LipMakeup
			},
			editorSubcategory = AvatarEditorSubcategories.EyeMakeup,
			assetTypes = {
				Enum.AvatarAssetType.EyeMakeup,
				Enum.AvatarAssetType.FaceMakeup,
				Enum.AvatarAssetType.LipMakeup
			},
			deselectable = true
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Eyelashes",
			icon = icons.Eyelashes,
			editorSubcategory = AvatarEditorSubcategories.Eyelashes,
			assetTypes = { Enum.AvatarAssetType.EyelashAccessory },
			deselectable = true
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Eyebrows",
			icon = icons.Eyebrows,
			editorSubcategory = AvatarEditorSubcategories.Eyebrows,
			assetTypes = { Enum.AvatarAssetType.EyebrowAccessory },
			deselectable = true
		}
	}
}

slotEditorCategories[Categories.Clothing] = {
	name = "Clothing",
	nameTranslationKey = "Feature.Catalog.Label.Clothing",
	index = v2[Categories.Clothing],
	slots = {
		{
			nameTranslationKey = "Feature.Avatar.Label.Top",
			icon = icons.Shirts,
			editorSubcategory = AvatarEditorSubcategories.Tops,
			assetTypes = {
				Enum.AvatarAssetType.ShirtAccessory,
				Enum.AvatarAssetType.TShirtAccessory,
				Enum.AvatarAssetType.SweaterAccessory
			}
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Outerwear",
			icon = icons.Jackets,
			editorSubcategory = AvatarEditorSubcategories.Outerwear,
			assetTypes = { Enum.AvatarAssetType.JacketAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Bottom",
			icon = icons.Pants,
			editorSubcategory = AvatarEditorSubcategories.Bottoms,
			assetTypes = {
				Enum.AvatarAssetType.PantsAccessory,
				Enum.AvatarAssetType.ShortsAccessory,
				Enum.AvatarAssetType.DressSkirtAccessory
			}
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Shoes",
			icon = icons.Shoes,
			editorSubcategory = AvatarEditorSubcategories.Shoes,
			assetTypes = { Enum.AvatarAssetType.RightShoeAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.ShirtClassic",
			icon = icons.ClassicShirts,
			editorSubcategory = AvatarEditorSubcategories.ClassicShirts,
			assetTypes = { Enum.AvatarAssetType.Shirt }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.PantsClassic",
			icon = icons.ClassicPants,
			editorSubcategory = AvatarEditorSubcategories.ClassicPants,
			assetTypes = { Enum.AvatarAssetType.Pants }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.TShirtClassic",
			icon = icons.ClassicTShirts,
			editorSubcategory = AvatarEditorSubcategories.ClassicTShirts,
			assetTypes = { Enum.AvatarAssetType.TShirt }
		}
	}
}

slotEditorCategories[Categories.Accessories] = {
	name = "Accessories",
	nameTranslationKey = "Feature.Catalog.LabelAccessories",
	index = v2[Categories.Accessories],
	slots = {
		{
			name = "Head",
			nameTranslationKey = "Feature.Avatar.Label.Head",
			icon = icons.Head,
			editorSubcategory = AvatarEditorSubcategories.Hats,
			assetTypes = { Enum.AvatarAssetType.Hat }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Face",
			icon = icons.Face,
			editorSubcategory = AvatarEditorSubcategories.Face,
			assetTypes = { Enum.AvatarAssetType.FaceAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Neck",
			icon = icons.Neck,
			editorSubcategory = AvatarEditorSubcategories.Neck,
			assetTypes = { Enum.AvatarAssetType.NeckAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Back",
			icon = icons.Back,
			editorSubcategory = AvatarEditorSubcategories.Back,
			assetTypes = { Enum.AvatarAssetType.BackAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Waist",
			icon = icons.Waist,
			editorSubcategory = AvatarEditorSubcategories.Waist,
			assetTypes = { Enum.AvatarAssetType.WaistAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Shoulder",
			icon = icons.Shoulder,
			editorSubcategory = AvatarEditorSubcategories.Shoulder,
			assetTypes = { Enum.AvatarAssetType.ShoulderAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Front",
			icon = icons.Front,
			editorSubcategory = AvatarEditorSubcategories.Front,
			assetTypes = { Enum.AvatarAssetType.FrontAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Gear",
			icon = icons.Gear,
			editorSubcategory = AvatarEditorSubcategories.Gear,
			assetTypes = { Enum.AvatarAssetType.Gear }
		}
	}
}

slotEditorCategories[Categories.Backgrounds] = FFlagAXCustomizeBackgrounds
	and {
		name = "Backgrounds",
		nameTranslationKey = "Feature.Catalog.Label.Backgrounds",
		index = v2[Categories.Backgrounds],
		slots = {}
	}
	or nil

slotEditorCategories[Categories.Animations] = {
	name = "Animations",
	nameTranslationKey = "Feature.Avatar.Heading.Animations",
	index = v2[Categories.Animations],
	slots = {
		{
			nameTranslationKey = "Feature.Avatar.Label.AnimationFullSet",
			icon = icons.Animation,
			editorSubcategory = AvatarEditorSubcategories.AnimationFullSets,
			assetTypes = { Enum.AvatarAssetType.IdleAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Idle",
			icon = icons.Idle,
			editorSubcategory = AvatarEditorSubcategories.IdleAnimations,
			assetTypes = { Enum.AvatarAssetType.IdleAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Walk",
			icon = icons.Walk,
			editorSubcategory = AvatarEditorSubcategories.WalkAnimations,
			assetTypes = { Enum.AvatarAssetType.WalkAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Run",
			icon = icons.Animation,
			editorSubcategory = AvatarEditorSubcategories.RunAnimations,
			assetTypes = { Enum.AvatarAssetType.RunAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Jump",
			icon = icons.Jump,
			editorSubcategory = AvatarEditorSubcategories.JumpAnimations,
			assetTypes = { Enum.AvatarAssetType.JumpAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Fall",
			icon = icons.Fall,
			editorSubcategory = AvatarEditorSubcategories.FallAnimations,
			assetTypes = { Enum.AvatarAssetType.FallAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Climb",
			icon = icons.Climb,
			editorSubcategory = AvatarEditorSubcategories.ClimbAnimations,
			assetTypes = { Enum.AvatarAssetType.ClimbAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Swim",
			icon = icons.Swim,
			editorSubcategory = AvatarEditorSubcategories.SwimAnimations,
			assetTypes = { Enum.AvatarAssetType.SwimAnimation }
		}
	}
}

slotEditorCategories[Categories.Emotes] = {
	name = "Emotes",
	nameTranslationKey = "Feature.Catalog.Label.Emotes",
	index = v2[Categories.Emotes],
	slots = {}
}
local inventoryFilterToAvailabilityStatus

if FFlagAXInventoryDurablesExpiredFilter then
	inventoryFilterToAvailabilityStatus = {}
	inventoryFilterToAvailabilityStatus[InventoryFilters.Expired] = 2
end

Constants.Categories = Categories
Constants.SlotEditorCategories = slotEditorCategories
Constants.Icons = icons
Constants.BodyAssetTypes = bodyAssetTypes
Constants.InventoryFilterToAvailabilityStatus = inventoryFilterToAvailabilityStatus
Constants.ActionBarHeight = 64

return Constants
