require(script.Parent.Types)

local AvatarEditorSubcategories = require(script.Parent.Enums.AvatarEditorSubcategories)
local InventoryFilters = require(script.Parent.Enums.InventoryFilters)
local SlotType = require(script.Parent.Enums.SlotType)
local t1 = {}
local Categories = require(script.Parent.Enums.Categories)
local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagRemoveClassicHeadsAndFaces = AvatarExperienceFlags.FFlagRemoveClassicHeadsAndFaces
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagAXSlotsDesktopRedesign = AvatarExperienceFlags.FFlagAXSlotsDesktopRedesign
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local FFlagAXCustomizeBackgrounds = AvatarExperienceFlags.FFlagAXCustomizeBackgrounds
local FFlagAXDownrankMakeupCustomize = AvatarExperienceFlags.FFlagAXDownrankMakeupCustomize
local IconName = require(Parent.Foundation).Enums.IconName
local IconVariant = require(Parent.Foundation).Enums.IconVariant
local t2 = {
	FullBody = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/body_on" or {
		name = IconName.PersonStanding,
		variant = IconVariant.Filled
	},
	ClassicHead = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_on" or {
		name = IconName.HeadBlank,
		variant = IconVariant.Filled
	},
	Hair = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hair_on" or {
		name = IconName.HeadFemale,
		variant = IconVariant.Filled
	},
	Faces = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/faces_on" or {
		name = IconName.FaceWinking,
		variant = IconVariant.Filled
	},
	Clothing = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_on" or {
		name = IconName.ClothesHanger,
		variant = IconVariant.Filled
	},
	Jackets = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/jackets_on" or {
		name = IconName.Jacket,
		variant = IconVariant.Filled
	},
	Shirts = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/shirts_on" or {
		name = IconName.Shirt,
		variant = IconVariant.Filled
	},
	Pants = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/pants_on" or {
		name = IconName.Pants,
		variant = IconVariant.Filled
	},
	Shoes = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/shoes_on" or {
		name = IconName.Shoe,
		variant = IconVariant.Filled
	},
	ClassicTShirts = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicTshirts_on" or {
		name = IconName.Tshirt_2dText,
		variant = IconVariant.Filled
	},
	ClassicShirts = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicShirts_on" or {
		name = IconName.Shirt_2dText,
		variant = IconVariant.Filled
	},
	ClassicPants = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicPants_on" or {
		name = IconName.Pants_2dText,
		variant = IconVariant.Filled
	},
	Accessories = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/accessories_off" or {
		name = IconName.BowTie,
		variant = IconVariant.Filled
	},
	Head = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_on" or {
		name = IconName.HatFedora,
		variant = IconVariant.Filled
	},
	Face = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyes_on" or {
		name = IconName.Glasses,
		variant = IconVariant.Filled
	},
	Neck = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/neck_off" or {
		name = IconName.Necklace,
		variant = IconVariant.Filled
	},
	Shoulder = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/shoulder_on" or {
		name = IconName.Parrot,
		variant = IconVariant.Filled
	},
	Front = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/front_on" or {
		name = IconName.Purse,
		variant = IconVariant.Filled
	},
	Back = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/back_on" or {
		name = IconName.ButterflyWings,
		variant = IconVariant.Filled
	},
	Waist = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/waist_on" or {
		name = IconName.Belt,
		variant = IconVariant.Filled
	},
	Gear = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/gear_on" or {
		name = IconName.Sword,
		variant = IconVariant.Filled
	},
	Animation = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/animation_off" or {
		name = IconName.PersonTeleport,
		variant = IconVariant.Filled
	},
	Idle = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/idle_on" or {
		name = IconName.PersonStanding,
		variant = IconVariant.Filled
	},
	Walk = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/walk_off" or {
		name = IconName.PersonWalking,
		variant = IconVariant.Filled
	},
	Jump = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/jump_off" or {
		name = IconName.PersonJumping,
		variant = IconVariant.Filled
	},
	Fall = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/fall_off" or {
		name = IconName.PersonFalling,
		variant = IconVariant.Filled
	},
	Climb = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/climb_off" or {
		name = IconName.PersonClimbing,
		variant = IconVariant.Filled
	},
	Swim = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/swim_off" or {
		name = IconName.PersonSwimming,
		variant = IconVariant.Filled
	},
	Emote = not FFlagAXMigrateBuilderIcons and "icons/controls/emoteOn" or {
		name = IconName.SquareFaceWavingHand,
		variant = IconVariant.Filled
	},
	Reset = not FFlagAXMigrateBuilderIcons and "icons/actions/reset" or {
		name = IconName.ArrowSpinClockwise,
		variant = IconVariant.Regular
	},
	Undo = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/undo" or {
		name = IconName.ArrowCurlToLeft,
		variant = IconVariant.Regular
	},
	Redo = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/redo" or {
		name = IconName.ArrowCurlToRight,
		variant = IconVariant.Regular
	},
	Torso = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/torsos_on" or {
		name = IconName.Torso,
		variant = IconVariant.Filled
	},
	Arm = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/arms_on" or {
		name = IconName.Arm,
		variant = IconVariant.Filled
	},
	Leg = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/legs_on" or {
		name = IconName.Leg,
		variant = IconVariant.Filled
	},
	Inventory = not FFlagAXMigrateBuilderIcons and "icons/menu/inventoryOff" or {
		name = IconName.Backpack,
		variant = IconVariant.Regular
	},
	Adjust = not FFlagAXMigrateBuilderIcons and "icons/actions/adjust" or {
		name = IconName.ThreeSlidersHorizontal,
		variant = IconVariant.Regular
	},
	Success = not FFlagAXMigrateBuilderIcons and "icons/status/success_small" or {
		name = IconName.CheckLarge,
		variant = IconVariant.Filled
	},
	Add = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/add" or {
		name = IconName.CirclePlus,
		variant = IconVariant.Regular
	},
	Build = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_on" or {
		name = IconName.PersonStandingDualArrowsVertical,
		variant = IconVariant.Filled
	},
	Eyelashes = if not FFlagAXMigrateBuilderIcons then IconName.Eyelashes else {
		name = IconName.Eyelashes,
		variant = IconVariant.Regular
	},
	Eyebrows = if not FFlagAXMigrateBuilderIcons then IconName.Eyebrows else {
		name = IconName.Eyebrows,
		variant = IconVariant.Regular
	},
	Backgrounds = {
		name = IconName.Image,
		variant = IconVariant.Filled
	}
}
local t3 = {
	Enum.AssetType.LeftLeg,
	Enum.AssetType.RightLeg,
	Enum.AssetType.LeftArm,
	Enum.AssetType.RightArm,
	Enum.AssetType.Torso,
	Enum.AssetType.Head,
	Enum.AssetType.DynamicHead
}
local t4 = {
	Categories.All,
	Categories.Avatars,
	Categories.Body
}

if FFlagAXCustomizeMakeupSupport and not FFlagAXDownrankMakeupCustomize then
	table.insert(t4, Categories.Makeup)
end

table.insert(t4, Categories.Clothing)
table.insert(t4, Categories.Accessories)

if FFlagAXCustomizeBackgrounds then
	table.insert(t4, Categories.Backgrounds)
end

table.insert(t4, Categories.Animations)
table.insert(t4, Categories.Emotes)

if FFlagAXDownrankMakeupCustomize then
	table.insert(t4, Categories.Makeup)
end

local t5 = {}

for v21, v22 in t4 do
	t5[v22] = v21 - 1
end

local t6 = {
	[Categories.All] = {
		name = "All",
		hide = true,
		nameTranslationKey = not FFlagAXSlotsDesktopRedesign and "Feature.Catalog.Label.Avatars" or "Feature.Avatar.Heading.All",
		index = t5[Categories.All],
		slots = {}
	},
	[Categories.Avatars] = {
		name = "Avatars",
		nameTranslationKey = "Feature.Catalog.Label.Avatars",
		index = t5[Categories.Avatars],
		slots = {}
	},
	[Categories.Body] = {
		name = "Body",
		nameTranslationKey = "Feature.Catalog.Label.Body",
		index = t5[Categories.Body],
		slots = if FFlagRemoveClassicHeadsAndFaces then {
			{
				name = "Body",
				nameTranslationKey = "Feature.Catalog.Label.FullBody",
				editorSubcategory = AvatarEditorSubcategories.PurchasedCharacters,
				assetTypes = {}
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Hair",
				icon = t2.Hair,
				editorSubcategory = AvatarEditorSubcategories.Hair,
				assetTypes = { Enum.AvatarAssetType.HairAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Head",
				icon = t2.ClassicHead,
				editorSubcategory = AvatarEditorSubcategories.Heads,
				assetTypes = { Enum.AvatarAssetType.DynamicHead }
			},
			{
				name = "Build",
				nameTranslationKey = "Feature.Avatar.Label.Build",
				assetTypes = {},
				icon = t2.Build,
				editorSubcategory = AvatarEditorSubcategories.Build
			},
			{
				name = "Skin",
				nameTranslationKey = "Feature.Avatar.Label.Skin",
				editorSubcategory = AvatarEditorSubcategories.Skin,
				assetTypes = {}
			}
		} else {
			{
				name = "Body",
				nameTranslationKey = "Feature.Catalog.Label.FullBody",
				editorSubcategory = AvatarEditorSubcategories.PurchasedCharacters,
				assetTypes = {}
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Hair",
				icon = t2.Hair,
				editorSubcategory = AvatarEditorSubcategories.Hair,
				assetTypes = { Enum.AvatarAssetType.HairAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Head",
				icon = t2.ClassicHead,
				editorSubcategory = AvatarEditorSubcategories.Heads,
				assetTypes = {
					Enum.AvatarAssetType.DynamicHead,
					Enum.AvatarAssetType.Head
				}
			},
			{
				name = "Classic Face",
				nameTranslationKey = "Feature.Avatar.Label.Face",
				icon = t2.Faces,
				editorSubcategory = AvatarEditorSubcategories.ClassicFaces,
				assetTypes = { Enum.AvatarAssetType.Face }
			},
			{
				name = "Build",
				nameTranslationKey = "Feature.Avatar.Label.Build",
				assetTypes = {},
				icon = t2.Build,
				editorSubcategory = AvatarEditorSubcategories.Build
			},
			{
				name = "Skin",
				nameTranslationKey = "Feature.Avatar.Label.Skin",
				editorSubcategory = AvatarEditorSubcategories.Skin,
				assetTypes = {}
			}
		}
	},
	[Categories.Makeup] = if FFlagAXCustomizeMakeupSupport then {
		name = "Makeup",
		nameTranslationKey = "Feature.Avatar.Label.Makeup",
		resetSlotOnClearAll = true,
		index = t5[Categories.Makeup],
		slots = {
			{
				nameTranslationKey = "Feature.Avatar.Label.Eyelashes",
				hide = true,
				icon = t2.Eyelashes,
				editorSubcategory = AvatarEditorSubcategories.MakeupLooks,
				eligibleSubcategories = {
					AvatarEditorSubcategories.MakeupLooks,
					AvatarEditorSubcategories.EyeMakeup,
					AvatarEditorSubcategories.FaceMakeup,
					AvatarEditorSubcategories.LipMakeup
				},
				assetTypes = {}
			},
			{
				layerLimit = 6,
				name = "Makeup",
				nameTranslationKey = "Feature.Avatar.Label.MakeupLayer",
				deselectable = true,
				slotType = SlotType.LayeredSlot,
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
				}
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Eyelashes",
				deselectable = true,
				icon = t2.Eyelashes,
				editorSubcategory = AvatarEditorSubcategories.Eyelashes,
				assetTypes = { Enum.AvatarAssetType.EyelashAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Eyebrows",
				deselectable = true,
				icon = t2.Eyebrows,
				editorSubcategory = AvatarEditorSubcategories.Eyebrows,
				assetTypes = { Enum.AvatarAssetType.EyebrowAccessory }
			}
		}
	} else nil,
	[Categories.Clothing] = {
		name = "Clothing",
		nameTranslationKey = "Feature.Catalog.Label.Clothing",
		index = t5[Categories.Clothing],
		slots = {
			{
				nameTranslationKey = "Feature.Avatar.Label.Top",
				icon = t2.Shirts,
				editorSubcategory = AvatarEditorSubcategories.Tops,
				assetTypes = {
					Enum.AvatarAssetType.ShirtAccessory,
					Enum.AvatarAssetType.TShirtAccessory,
					Enum.AvatarAssetType.SweaterAccessory
				}
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Outerwear",
				icon = t2.Jackets,
				editorSubcategory = AvatarEditorSubcategories.Outerwear,
				assetTypes = { Enum.AvatarAssetType.JacketAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Bottom",
				icon = t2.Pants,
				editorSubcategory = AvatarEditorSubcategories.Bottoms,
				assetTypes = {
					Enum.AvatarAssetType.PantsAccessory,
					Enum.AvatarAssetType.ShortsAccessory,
					Enum.AvatarAssetType.DressSkirtAccessory
				}
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Shoes",
				icon = t2.Shoes,
				editorSubcategory = AvatarEditorSubcategories.Shoes,
				assetTypes = { Enum.AvatarAssetType.RightShoeAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.ShirtClassic",
				icon = t2.ClassicShirts,
				editorSubcategory = AvatarEditorSubcategories.ClassicShirts,
				assetTypes = { Enum.AvatarAssetType.Shirt }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.PantsClassic",
				icon = t2.ClassicPants,
				editorSubcategory = AvatarEditorSubcategories.ClassicPants,
				assetTypes = { Enum.AvatarAssetType.Pants }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.TShirtClassic",
				icon = t2.ClassicTShirts,
				editorSubcategory = AvatarEditorSubcategories.ClassicTShirts,
				assetTypes = { Enum.AvatarAssetType.TShirt }
			}
		}
	},
	[Categories.Accessories] = {
		name = "Accessories",
		nameTranslationKey = "Feature.Catalog.LabelAccessories",
		index = t5[Categories.Accessories],
		slots = {
			{
				name = "Head",
				nameTranslationKey = "Feature.Avatar.Label.Head",
				icon = t2.Head,
				editorSubcategory = AvatarEditorSubcategories.Hats,
				assetTypes = { Enum.AvatarAssetType.Hat }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Face",
				icon = t2.Face,
				editorSubcategory = AvatarEditorSubcategories.Face,
				assetTypes = { Enum.AvatarAssetType.FaceAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Neck",
				icon = t2.Neck,
				editorSubcategory = AvatarEditorSubcategories.Neck,
				assetTypes = { Enum.AvatarAssetType.NeckAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Back",
				icon = t2.Back,
				editorSubcategory = AvatarEditorSubcategories.Back,
				assetTypes = { Enum.AvatarAssetType.BackAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Waist",
				icon = t2.Waist,
				editorSubcategory = AvatarEditorSubcategories.Waist,
				assetTypes = { Enum.AvatarAssetType.WaistAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Shoulder",
				icon = t2.Shoulder,
				editorSubcategory = AvatarEditorSubcategories.Shoulder,
				assetTypes = { Enum.AvatarAssetType.ShoulderAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Front",
				icon = t2.Front,
				editorSubcategory = AvatarEditorSubcategories.Front,
				assetTypes = { Enum.AvatarAssetType.FrontAccessory }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Gear",
				icon = t2.Gear,
				editorSubcategory = AvatarEditorSubcategories.Gear,
				assetTypes = { Enum.AvatarAssetType.Gear }
			}
		}
	},
	[Categories.Backgrounds] = if FFlagAXCustomizeBackgrounds then {
		name = "Backgrounds",
		nameTranslationKey = "Feature.Catalog.Label.Backgrounds",
		index = t5[Categories.Backgrounds],
		slots = {}
	} else nil,
	[Categories.Animations] = {
		name = "Animations",
		nameTranslationKey = "Feature.Avatar.Heading.Animations",
		index = t5[Categories.Animations],
		slots = {
			{
				nameTranslationKey = "Feature.Avatar.Label.AnimationFullSet",
				icon = t2.Animation,
				editorSubcategory = AvatarEditorSubcategories.AnimationFullSets,
				assetTypes = { Enum.AvatarAssetType.IdleAnimation }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Idle",
				icon = t2.Idle,
				editorSubcategory = AvatarEditorSubcategories.IdleAnimations,
				assetTypes = { Enum.AvatarAssetType.IdleAnimation }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Walk",
				icon = t2.Walk,
				editorSubcategory = AvatarEditorSubcategories.WalkAnimations,
				assetTypes = { Enum.AvatarAssetType.WalkAnimation }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Run",
				icon = t2.Animation,
				editorSubcategory = AvatarEditorSubcategories.RunAnimations,
				assetTypes = { Enum.AvatarAssetType.RunAnimation }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Jump",
				icon = t2.Jump,
				editorSubcategory = AvatarEditorSubcategories.JumpAnimations,
				assetTypes = { Enum.AvatarAssetType.JumpAnimation }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Fall",
				icon = t2.Fall,
				editorSubcategory = AvatarEditorSubcategories.FallAnimations,
				assetTypes = { Enum.AvatarAssetType.FallAnimation }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Climb",
				icon = t2.Climb,
				editorSubcategory = AvatarEditorSubcategories.ClimbAnimations,
				assetTypes = { Enum.AvatarAssetType.ClimbAnimation }
			},
			{
				nameTranslationKey = "Feature.Avatar.Label.Swim",
				icon = t2.Swim,
				editorSubcategory = AvatarEditorSubcategories.SwimAnimations,
				assetTypes = { Enum.AvatarAssetType.SwimAnimation }
			}
		}
	},
	[Categories.Emotes] = {
		name = "Emotes",
		nameTranslationKey = "Feature.Catalog.Label.Emotes",
		index = t5[Categories.Emotes],
		slots = {}
	}
}
local v24 = if not FFlagAXInventoryDurablesExpiredFilter then nil else {
	[InventoryFilters.Expired] = 2
}

t1.Categories = Categories
t1.SlotEditorCategories = t6
t1.Icons = t2
t1.BodyAssetTypes = t3
t1.InventoryFilterToAvailabilityStatus = v24

return t1
