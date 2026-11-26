require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")
local InventoryFilters = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventoryFilters")
local SlotType = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/SlotType")
local v5 = {}
local Categories = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/Categories")

local avatarEditorSubcategories = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceModel").Enums.AvatarEditorSubcategories
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags")
local fFlagRemoveClassicHeadsAndFaces = AvatarExperienceFlags.FFlagRemoveClassicHeadsAndFaces
local fFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local fFlagAXSlotsDesktopRedesign = AvatarExperienceFlags.FFlagAXSlotsDesktopRedesign
local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local fFlagAXCustomizeBackgrounds = AvatarExperienceFlags.FFlagAXCustomizeBackgrounds
local fFlagAXDownrankMakeupCustomize = AvatarExperienceFlags.FFlagAXDownrankMakeupCustomize
local fFlagAXSpawnEffects = AvatarExperienceFlags.FFlagAXSpawnEffects

local iconName = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Foundation").Enums.IconName
local iconVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Foundation").Enums.IconVariant

local v6 = {
	FullBody = fFlagAXMigrateBuilderIcons and {
		name = iconName.PersonStanding,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/body_on",
	ClassicHead = fFlagAXMigrateBuilderIcons and {
		name = iconName.HeadBlank,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/classicHead_on",
	Hair = fFlagAXMigrateBuilderIcons and {
		name = iconName.HeadFemale,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/hair_on",
	Faces = fFlagAXMigrateBuilderIcons and {
		name = iconName.FaceWinking,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/faces_on",
	Clothing = fFlagAXMigrateBuilderIcons and {
		name = iconName.ClothesHanger,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/clothing_on",
	Jackets = fFlagAXMigrateBuilderIcons and {
		name = iconName.Jacket,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/jackets_on",
	Shirts = fFlagAXMigrateBuilderIcons and {
		name = iconName.Shirt,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/shirts_on",
	Pants = fFlagAXMigrateBuilderIcons and {
		name = iconName.Pants,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/pants_on",
	Shoes = fFlagAXMigrateBuilderIcons and {
		name = iconName.Shoe,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/shoes_on",
	ClassicTShirts = fFlagAXMigrateBuilderIcons and {
		name = iconName.Tshirt_2dText,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/classicTshirts_on",
	ClassicShirts = fFlagAXMigrateBuilderIcons and {
		name = iconName.Shirt_2dText,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/classicShirts_on",
	ClassicPants = fFlagAXMigrateBuilderIcons and {
		name = iconName.Pants_2dText,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/classicPants_on",
	Accessories = fFlagAXMigrateBuilderIcons and {
		name = iconName.BowTie,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/accessories_off",
	Head = fFlagAXMigrateBuilderIcons and {
		name = iconName.HatFedora,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/hats_on",
	Face = fFlagAXMigrateBuilderIcons and {
		name = iconName.Glasses,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/eyes_on",
	Neck = fFlagAXMigrateBuilderIcons and {
		name = iconName.Necklace,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/neck_off",
	Shoulder = fFlagAXMigrateBuilderIcons and {
		name = iconName.Parrot,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/shoulder_on",
	Front = fFlagAXMigrateBuilderIcons and {
		name = iconName.Purse,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/front_on",
	Back = fFlagAXMigrateBuilderIcons and {
		name = iconName.ButterflyWings,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/back_on",
	Waist = fFlagAXMigrateBuilderIcons and {
		name = iconName.Belt,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/waist_on",
	Gear = fFlagAXMigrateBuilderIcons and {
		name = iconName.Sword,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/gear_on",
	Animation = fFlagAXMigrateBuilderIcons and {
		name = iconName.PersonTeleport,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/animation_off",
	Idle = fFlagAXMigrateBuilderIcons and {
		name = iconName.PersonStanding,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/idle_on",
	Walk = fFlagAXMigrateBuilderIcons and {
		name = iconName.PersonWalking,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/walk_off",
	Jump = fFlagAXMigrateBuilderIcons and {
		name = iconName.PersonJumping,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/jump_off",
	Fall = fFlagAXMigrateBuilderIcons and {
		name = iconName.PersonFalling,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/fall_off",
	Climb = fFlagAXMigrateBuilderIcons and {
		name = iconName.PersonClimbing,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/climb_off",
	Swim = fFlagAXMigrateBuilderIcons and {
		name = iconName.PersonSwimming,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/swim_off",
	Emote = fFlagAXMigrateBuilderIcons and {
		name = iconName.SquareFaceWavingHand,
		variant = iconVariant.Filled
	} or "icons/controls/emoteOn",
	Reset = fFlagAXMigrateBuilderIcons and {
		name = iconName.ArrowSpinClockwise,
		variant = iconVariant.Regular
	} or "icons/actions/reset",
	Undo = fFlagAXMigrateBuilderIcons and {
		name = iconName.ArrowCurlToLeft,
		variant = iconVariant.Regular
	} or "icons/actions/edit/undo",
	Redo = fFlagAXMigrateBuilderIcons and {
		name = iconName.ArrowCurlToRight,
		variant = iconVariant.Regular
	} or "icons/actions/edit/redo",
	Torso = fFlagAXMigrateBuilderIcons and {
		name = iconName.Torso,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/torsos_on",
	Arm = fFlagAXMigrateBuilderIcons and {
		name = iconName.Arm,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/arms_on",
	Leg = fFlagAXMigrateBuilderIcons and {
		name = iconName.Leg,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/legs_on",
	Inventory = fFlagAXMigrateBuilderIcons and {
		name = iconName.Backpack,
		variant = iconVariant.Regular
	} or "icons/menu/inventoryOff",
	Adjust = fFlagAXMigrateBuilderIcons and {
		name = iconName.ThreeSlidersHorizontal,
		variant = iconVariant.Regular
	} or "icons/actions/adjust",
	Success = fFlagAXMigrateBuilderIcons and {
		name = iconName.CheckLarge,
		variant = iconVariant.Filled
	} or "icons/status/success_small",
	Add = fFlagAXMigrateBuilderIcons and {
		name = iconName.CirclePlus,
		variant = iconVariant.Regular
	} or "icons/actions/edit/add",
	Build = fFlagAXMigrateBuilderIcons and {
		name = iconName.PersonStandingDualArrowsVertical,
		variant = iconVariant.Filled
	} or "icons/menu/clothing/build_on"
}

local v7 = if fFlagAXMigrateBuilderIcons then {
	name = iconName.Eyelashes,
	variant = iconVariant.Regular
} else iconName.Eyelashes
v6.Eyelashes = v7

local v8 = if fFlagAXMigrateBuilderIcons then {
	name = iconName.Eyebrows,
	variant = iconVariant.Regular
} else iconName.Eyebrows
v6.Eyebrows = v8

v6.Backgrounds = { name = iconName.Image, variant = iconVariant.Filled }
v6.SpawnEffects = { name = iconName.CursorStars, variant = iconVariant.Filled }

local v9 = {
	Enum.AssetType.LeftLeg,
	Enum.AssetType.RightLeg,
	Enum.AssetType.LeftArm,
	Enum.AssetType.RightArm,
	Enum.AssetType.Torso,
	Enum.AssetType.Head,
	Enum.AssetType.DynamicHead
}

local v10 = { Categories.All, Categories.Avatars, Categories.Body }

if not fFlagAXDownrankMakeupCustomize then
	table.insert(v10, Categories.Makeup)
end

table.insert(v10, Categories.Clothing)
table.insert(v10, Categories.Accessories)

if fFlagAXCustomizeBackgrounds then
	table.insert(v10, Categories.Backgrounds)
end

table.insert(v10, Categories.Animations)
table.insert(v10, Categories.Emotes)

if fFlagAXDownrankMakeupCustomize then
	table.insert(v10, Categories.Makeup)
end

local v11 = {}

for k, v12 in v10 do
	v11[v12] = k - 1
end

local v12 = {
	[Categories.All] = {
		name = "All",
		nameTranslationKey = fFlagAXSlotsDesktopRedesign and "Feature.Avatar.Heading.All" or "Feature.Catalog.Label.Avatars",
		index = v11[Categories.All],
		slots = {},
		hide = true
	},
	[Categories.Avatars] = {
		name = "Avatars",
		nameTranslationKey = "Feature.Catalog.Label.Avatars",
		index = v11[Categories.Avatars],
		slots = {}
	}
}

local body = Categories.Body
local v13 = {
	name = "Body",
	nameTranslationKey = "Feature.Catalog.Label.Body",
	index = v11[Categories.Body],
	slots = 0
}
local v14

if fFlagRemoveClassicHeadsAndFaces then
	v14 = {
		{
			name = "Body",
			nameTranslationKey = "Feature.Catalog.Label.FullBody",
			editorSubcategory = avatarEditorSubcategories.PurchasedCharacters,
			assetTypes = {}
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Hair",
			icon = v6.Hair,
			editorSubcategory = avatarEditorSubcategories.Hair,
			assetTypes = { Enum.AvatarAssetType.HairAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Head",
			icon = v6.ClassicHead,
			editorSubcategory = avatarEditorSubcategories.Heads,
			assetTypes = { Enum.AvatarAssetType.DynamicHead }
		},
		{
			name = "Build",
			nameTranslationKey = "Feature.Avatar.Label.Build",
			assetTypes = {},
			icon = v6.Build,
			editorSubcategory = avatarEditorSubcategories.Build
		},
		{
			name = "Skin",
			nameTranslationKey = "Feature.Avatar.Label.Skin",
			editorSubcategory = avatarEditorSubcategories.Skin,
			assetTypes = {}
		}
	}
else
	v14 = {
		{
			name = "Body",
			nameTranslationKey = "Feature.Catalog.Label.FullBody",
			editorSubcategory = avatarEditorSubcategories.PurchasedCharacters,
			assetTypes = {}
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Hair",
			icon = v6.Hair,
			editorSubcategory = avatarEditorSubcategories.Hair,
			assetTypes = { Enum.AvatarAssetType.HairAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Head",
			icon = v6.ClassicHead,
			editorSubcategory = avatarEditorSubcategories.Heads,
			assetTypes = { Enum.AvatarAssetType.DynamicHead, Enum.AvatarAssetType.Head }
		},
		{
			name = "Classic Face",
			nameTranslationKey = "Feature.Avatar.Label.Face",
			icon = v6.Faces,
			editorSubcategory = avatarEditorSubcategories.ClassicFaces,
			assetTypes = { Enum.AvatarAssetType.Face }
		},
		{
			name = "Build",
			nameTranslationKey = "Feature.Avatar.Label.Build",
			assetTypes = {},
			icon = v6.Build,
			editorSubcategory = avatarEditorSubcategories.Build
		},
		{
			name = "Skin",
			nameTranslationKey = "Feature.Avatar.Label.Skin",
			editorSubcategory = avatarEditorSubcategories.Skin,
			assetTypes = {}
		}
	}
end

v13.slots = v14
v12[body] = v13

v12[Categories.Makeup] = {
	name = "Makeup",
	nameTranslationKey = "Feature.Avatar.Label.Makeup",
	index = v11[Categories.Makeup],
	resetSlotOnClearAll = true,
	slots = {
		{
			nameTranslationKey = "Feature.Avatar.Label.Eyelashes",
			icon = v6.Eyelashes,
			editorSubcategory = avatarEditorSubcategories.MakeupLooks,
			eligibleSubcategories = {
				avatarEditorSubcategories.MakeupLooks,
				avatarEditorSubcategories.EyeMakeup,
				avatarEditorSubcategories.FaceMakeup,
				avatarEditorSubcategories.LipMakeup
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
				avatarEditorSubcategories.EyeMakeup,
				avatarEditorSubcategories.FaceMakeup,
				avatarEditorSubcategories.LipMakeup
			},
			editorSubcategory = avatarEditorSubcategories.EyeMakeup,
			assetTypes = {
				Enum.AvatarAssetType.EyeMakeup,
				Enum.AvatarAssetType.FaceMakeup,
				Enum.AvatarAssetType.LipMakeup
			},
			deselectable = true
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Eyelashes",
			icon = v6.Eyelashes,
			editorSubcategory = avatarEditorSubcategories.Eyelashes,
			assetTypes = { Enum.AvatarAssetType.EyelashAccessory },
			deselectable = true
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Eyebrows",
			icon = v6.Eyebrows,
			editorSubcategory = avatarEditorSubcategories.Eyebrows,
			assetTypes = { Enum.AvatarAssetType.EyebrowAccessory },
			deselectable = true
		}
	}
}

v12[Categories.Clothing] = {
	name = "Clothing",
	nameTranslationKey = "Feature.Catalog.Label.Clothing",
	index = v11[Categories.Clothing],
	slots = {
		{
			nameTranslationKey = "Feature.Avatar.Label.Top",
			icon = v6.Shirts,
			editorSubcategory = avatarEditorSubcategories.Tops,
			assetTypes = {
				Enum.AvatarAssetType.ShirtAccessory,
				Enum.AvatarAssetType.TShirtAccessory,
				Enum.AvatarAssetType.SweaterAccessory
			}
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Outerwear",
			icon = v6.Jackets,
			editorSubcategory = avatarEditorSubcategories.Outerwear,
			assetTypes = { Enum.AvatarAssetType.JacketAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Bottom",
			icon = v6.Pants,
			editorSubcategory = avatarEditorSubcategories.Bottoms,
			assetTypes = {
				Enum.AvatarAssetType.PantsAccessory,
				Enum.AvatarAssetType.ShortsAccessory,
				Enum.AvatarAssetType.DressSkirtAccessory
			}
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Shoes",
			icon = v6.Shoes,
			editorSubcategory = avatarEditorSubcategories.Shoes,
			assetTypes = { Enum.AvatarAssetType.RightShoeAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.ShirtClassic",
			icon = v6.ClassicShirts,
			editorSubcategory = avatarEditorSubcategories.ClassicShirts,
			assetTypes = { Enum.AvatarAssetType.Shirt }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.PantsClassic",
			icon = v6.ClassicPants,
			editorSubcategory = avatarEditorSubcategories.ClassicPants,
			assetTypes = { Enum.AvatarAssetType.Pants }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.TShirtClassic",
			icon = v6.ClassicTShirts,
			editorSubcategory = avatarEditorSubcategories.ClassicTShirts,
			assetTypes = { Enum.AvatarAssetType.TShirt }
		}
	}
}

v12[Categories.Accessories] = {
	name = "Accessories",
	nameTranslationKey = "Feature.Catalog.LabelAccessories",
	index = v11[Categories.Accessories],
	slots = {
		{
			name = "Head",
			nameTranslationKey = "Feature.Avatar.Label.Head",
			icon = v6.Head,
			editorSubcategory = avatarEditorSubcategories.Hats,
			assetTypes = { Enum.AvatarAssetType.Hat }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Face",
			icon = v6.Face,
			editorSubcategory = avatarEditorSubcategories.Face,
			assetTypes = { Enum.AvatarAssetType.FaceAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Neck",
			icon = v6.Neck,
			editorSubcategory = avatarEditorSubcategories.Neck,
			assetTypes = { Enum.AvatarAssetType.NeckAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Back",
			icon = v6.Back,
			editorSubcategory = avatarEditorSubcategories.Back,
			assetTypes = { Enum.AvatarAssetType.BackAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Waist",
			icon = v6.Waist,
			editorSubcategory = avatarEditorSubcategories.Waist,
			assetTypes = { Enum.AvatarAssetType.WaistAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Shoulder",
			icon = v6.Shoulder,
			editorSubcategory = avatarEditorSubcategories.Shoulder,
			assetTypes = { Enum.AvatarAssetType.ShoulderAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Front",
			icon = v6.Front,
			editorSubcategory = avatarEditorSubcategories.Front,
			assetTypes = { Enum.AvatarAssetType.FrontAccessory }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Gear",
			icon = v6.Gear,
			editorSubcategory = avatarEditorSubcategories.Gear,
			assetTypes = { Enum.AvatarAssetType.Gear }
		}
	}
}

v12[Categories.Backgrounds] = fFlagAXCustomizeBackgrounds
	and {
		name = "Backgrounds",
		nameTranslationKey = "Feature.Catalog.Label.Backgrounds",
		index = v11[Categories.Backgrounds],
		slots = {}
	}
	or nil

v12[Categories.Animations] = {
	name = "Animations",
	nameTranslationKey = "Feature.Avatar.Heading.Animations",
	index = v11[Categories.Animations],
	slots = {
		{
			nameTranslationKey = "Feature.Avatar.Label.AnimationFullSet",
			icon = v6.Animation,
			editorSubcategory = avatarEditorSubcategories.AnimationFullSets,
			assetTypes = { Enum.AvatarAssetType.IdleAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Idle",
			icon = v6.Idle,
			editorSubcategory = avatarEditorSubcategories.IdleAnimations,
			assetTypes = { Enum.AvatarAssetType.IdleAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Walk",
			icon = v6.Walk,
			editorSubcategory = avatarEditorSubcategories.WalkAnimations,
			assetTypes = { Enum.AvatarAssetType.WalkAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Run",
			icon = v6.Animation,
			editorSubcategory = avatarEditorSubcategories.RunAnimations,
			assetTypes = { Enum.AvatarAssetType.RunAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Jump",
			icon = v6.Jump,
			editorSubcategory = avatarEditorSubcategories.JumpAnimations,
			assetTypes = { Enum.AvatarAssetType.JumpAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Fall",
			icon = v6.Fall,
			editorSubcategory = avatarEditorSubcategories.FallAnimations,
			assetTypes = { Enum.AvatarAssetType.FallAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Climb",
			icon = v6.Climb,
			editorSubcategory = avatarEditorSubcategories.ClimbAnimations,
			assetTypes = { Enum.AvatarAssetType.ClimbAnimation }
		},
		{
			nameTranslationKey = "Feature.Avatar.Label.Swim",
			icon = v6.Swim,
			editorSubcategory = avatarEditorSubcategories.SwimAnimations,
			assetTypes = { Enum.AvatarAssetType.SwimAnimation }
		}
	}
}

v12[Categories.Emotes] = {
	name = "Emotes",
	nameTranslationKey = "Feature.Catalog.Label.Emotes",
	index = v11[Categories.Emotes],
	slots = {}
}

if fFlagAXSpawnEffects then
	table.insert(v12[Categories.Animations].slots, 1, {
		nameTranslationKey = "Feature.Avatar.Label.Spawn",
		icon = v6.SpawnEffects,
		editorSubcategory = avatarEditorSubcategories.SpawnEffects,
		assetTypes = { Enum.AvatarAssetType:FromValue(97) }
	})
end

local v15

if fFlagAXInventoryDurablesExpiredFilter then
	v15 = {}
	v15[InventoryFilters.Expired] = 2
end

v5.Categories = Categories
v5.SlotEditorCategories = v12
v5.Icons = v6
v5.BodyAssetTypes = v9
v5.InventoryFilterToAvailabilityStatus = v15
v5.ActionBarHeight = 64

return v5
