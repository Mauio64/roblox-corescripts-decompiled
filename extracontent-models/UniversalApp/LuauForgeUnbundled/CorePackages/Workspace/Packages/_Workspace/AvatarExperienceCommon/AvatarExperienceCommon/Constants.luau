local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/LabelAbuseTypeMapping")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/CategoryTypes")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel")
local OutfitTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/OutfitTypes")
local inventoryOutfitType = AvatarExperienceModel.Enums.InventoryOutfitType
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport

local frozen = table.freeze({
	height = 1,
	width = 1,
	depth = 1,
	head = 1,
	bodyType = 0,
	proportion = 0
})

local enumItems = Enum.AvatarAssetType:GetEnumItems()
local v5 = {}
local names = {}

for k, enumItem in enumItems do
	v5[enumItem.Name] = tostring(enumItem.Value)
	names[tostring(enumItem.Value)] = enumItem.Name
end

local v7 = {
	[tostring(Enum.AssetType.Hat.Value)] = Enum.AccessoryType.Hat,
	[tostring(Enum.AssetType.HairAccessory.Value)] = Enum.AccessoryType.Hair,
	[tostring(Enum.AssetType.FaceAccessory.Value)] = Enum.AccessoryType.Face,
	[tostring(Enum.AssetType.NeckAccessory.Value)] = Enum.AccessoryType.Neck,
	[tostring(Enum.AssetType.ShoulderAccessory.Value)] = Enum.AccessoryType.Shoulder,
	[tostring(Enum.AssetType.FrontAccessory.Value)] = Enum.AccessoryType.Front,
	[tostring(Enum.AssetType.BackAccessory.Value)] = Enum.AccessoryType.Back,
	[tostring(Enum.AssetType.WaistAccessory.Value)] = Enum.AccessoryType.Waist,
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = Enum.AccessoryType.TShirt,
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = Enum.AccessoryType.Shirt,
	[tostring(Enum.AssetType.PantsAccessory.Value)] = Enum.AccessoryType.Pants,
	[tostring(Enum.AssetType.JacketAccessory.Value)] = Enum.AccessoryType.Jacket,
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = Enum.AccessoryType.Sweater,
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = Enum.AccessoryType.Shorts,
	[tostring(Enum.AssetType.LeftShoeAccessory.Value)] = Enum.AccessoryType.LeftShoe,
	[tostring(Enum.AssetType.RightShoeAccessory.Value)] = Enum.AccessoryType.RightShoe,
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = Enum.AccessoryType.DressSkirt,
	[tostring(Enum.AssetType.EyebrowAccessory.Value)] = Enum.AccessoryType.Eyebrow,
	[tostring(Enum.AssetType.EyelashAccessory.Value)] = Enum.AccessoryType.Eyelash
}

local v8 = {}

for k, v9 in v7 do
	v8[v9] = k
end

local v9 = {
	[tostring(Enum.AssetType.TShirt.Value)] = "GraphicTShirt",
	[tostring(Enum.AssetType.Hat.Value)] = "HatAccessory",
	[tostring(Enum.AssetType.Shirt.Value)] = "Shirt",
	[tostring(Enum.AssetType.Pants.Value)] = "Pants",
	[tostring(Enum.AssetType.Head.Value)] = "Head",
	[tostring(Enum.AssetType.Face.Value)] = "Face",
	[tostring(Enum.AssetType.Torso.Value)] = "Torso",
	[tostring(Enum.AssetType.RightArm.Value)] = "RightArm",
	[tostring(Enum.AssetType.LeftArm.Value)] = "LeftArm",
	[tostring(Enum.AssetType.LeftLeg.Value)] = "LeftLeg",
	[tostring(Enum.AssetType.RightLeg.Value)] = "RightLeg",
	[tostring(Enum.AssetType.HairAccessory.Value)] = "HairAccessory",
	[tostring(Enum.AssetType.FaceAccessory.Value)] = "FaceAccessory",
	[tostring(Enum.AssetType.NeckAccessory.Value)] = "NeckAccessory",
	[tostring(Enum.AssetType.ShoulderAccessory.Value)] = "ShouldersAccessory",
	[tostring(Enum.AssetType.FrontAccessory.Value)] = "FrontAccessory",
	[tostring(Enum.AssetType.BackAccessory.Value)] = "BackAccessory",
	[tostring(Enum.AssetType.WaistAccessory.Value)] = "WaistAccessory",
	[tostring(Enum.AssetType.ClimbAnimation.Value)] = "ClimbAnimation",
	[tostring(Enum.AssetType.FallAnimation.Value)] = "FallAnimation",
	[tostring(Enum.AssetType.IdleAnimation.Value)] = "IdleAnimation",
	[tostring(Enum.AssetType.JumpAnimation.Value)] = "JumpAnimation",
	[tostring(Enum.AssetType.RunAnimation.Value)] = "RunAnimation",
	[tostring(Enum.AssetType.SwimAnimation.Value)] = "SwimAnimation",
	[tostring(Enum.AssetType.WalkAnimation.Value)] = "WalkAnimation",
	[tostring(Enum.AssetType.MoodAnimation.Value)] = "MoodAnimation",
	[tostring(Enum.AssetType.DynamicHead.Value)] = "Head"
}

local v10 = {
	[v5.EyebrowAccessory] = 0,
	[v5.EyelashAccessory] = 1,
	[v5.Pants] = 2,
	[v5.Shirt] = 3,
	[v5.TShirt] = 4,
	[v5.LeftShoeAccessory] = 5,
	[v5.RightShoeAccessory] = 5,
	[v5.PantsAccessory] = 6,
	[v5.ShortsAccessory] = 7,
	[v5.DressSkirtAccessory] = 8,
	[v5.TShirtAccessory] = 9,
	[v5.ShirtAccessory] = 10,
	[v5.SweaterAccessory] = 11,
	[v5.JacketAccessory] = 12,
	[v5.HairAccessory] = 13
}

local v11 = {
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = Enum.AccessoryType.TShirt,
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = Enum.AccessoryType.Shirt,
	[tostring(Enum.AssetType.PantsAccessory.Value)] = Enum.AccessoryType.Pants,
	[tostring(Enum.AssetType.JacketAccessory.Value)] = Enum.AccessoryType.Jacket,
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = Enum.AccessoryType.Sweater,
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = Enum.AccessoryType.Shorts,
	[tostring(Enum.AssetType.LeftShoeAccessory.Value)] = Enum.AccessoryType.LeftShoe,
	[tostring(Enum.AssetType.RightShoeAccessory.Value)] = Enum.AccessoryType.RightShoe,
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = Enum.AccessoryType.DressSkirt,
	[tostring(Enum.AssetType.HairAccessory.Value)] = Enum.AccessoryType.Hair,
	[tostring(Enum.AssetType.EyebrowAccessory.Value)] = Enum.AccessoryType.Eyebrow,
	[tostring(Enum.AssetType.EyelashAccessory.Value)] = Enum.AccessoryType.Eyelash
}

local set = {
	[v5.EyeMakeup] = true,
	[v5.FaceMakeup] = true,
	[v5.LipMakeup] = true,
	[v5.EyebrowAccessory] = true,
	[v5.EyelashAccessory] = true
}
return {
	BODY_BUNDLE_TYPE_ID = "1",
	AVATAR_ANIMATIONS_BUNDLE_TYPE_ID = "2",
	SHOES_BUNDLE_TYPE_ID = "3",
	DYNAMIC_HEAD_BUNDLE_TYPE_ID = "4",
	DEFAULT_AVATAR_SCALES = frozen,
	BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND = {
		["1"] = "Body",
		["2"] = "AvatarAnimations",
		["3"] = "Shoes",
		["4"] = "DynamicHead"
	},
	ASSET_TYPE_TO_ACCESSORY_TYPE = v7,
	ACCESSORY_TYPE_TO_ASSET_TYPE = v8,
	ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = v9,
	HUMANOID_DESCRIPTION_SCALE_TO_NAME = {
		bodyType = "BodyTypeScale",
		head = "HeadScale",
		height = "HeightScale",
		proportion = "ProportionScale",
		depth = "DepthScale",
		width = "WidthScale"
	},
	BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION = {
		headColor3 = "HeadColor",
		leftArmColor3 = "LeftArmColor",
		leftLegColor3 = "LeftLegColor",
		rightArmColor3 = "RightArmColor",
		rightLegColor3 = "RightLegColor",
		torsoColor3 = "TorsoColor"
	},
	ASSET_TYPE_NAME_TO_ID_STRING = v5,
	ASSET_TYPE_ID_STRING_TO_NAME = names,
	NAVIGATION_DIRECTION = { IS_LEFT = "IS_LEFT", IS_RIGHT = "IS_RIGHT" },
	LANDSCAPE_UI_WIDTH_PERCENTAGE = 0.6,
	LANDSCAPE_SCENE_WIDTH_PERCENTAGE = 0.4,
	AVATAR_BLOCKY_DEFAULT_BUNDLE_ID = "356",
	AX_TOOLTIP_STORAGE_KEY = "AXTooltipStorageKey",
	AX_TOOLTIP_COUNTERS = {
		Seen = "AXTooltipSeen",
		TimeDismiss = "AXTooltipTimeDismiss",
		ClickDismiss = "AXTooltipClickDismiss",
		CallbackDismiss = "AXTooltipCallbackDismiss"
	},
	AVATAR_EDITOR_CONSTANTS = {
		CreateOutfitKey = "avatar.createOutfit",
		CreateMakeupLookKey = fFlagAXCatalogMakeupSupport and "avatar.createMakeupLook" or nil
	},
	LAYERED_CLOTHING_ORDER = v10,
	LAYERED_ASSET_TYPES = v11,
	ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = {
		[v5.EyeMakeup] = Enum.MakeupType.Eye,
		[v5.FaceMakeup] = Enum.MakeupType.Face,
		[v5.LipMakeup] = Enum.MakeupType.Lip
	},
	MAKEUP_TYPE_TO_ASSET_TYPE_ID = {
		[Enum.MakeupType.Eye] = v5.EyeMakeup,
		[Enum.MakeupType.Face] = v5.FaceMakeup,
		[Enum.MakeupType.Lip] = v5.LipMakeup
	},
	LAYERED_MAKEUP_ORDER = {
		[v5.FaceMakeup] = 0,
		[v5.LipMakeup] = 1,
		[v5.EyeMakeup] = 2
	},
	MAKEUP_LOOK_ASSET_TYPES = set,
	MAX_MAKEUP_LAYERS = 6,
	LOOK_TYPE = {
		Avatar = "Avatar",
		Makeup = "Makeup",
		Outfit = "Outfit",
		AvatarMoment = "AvatarMoment"
	},
	MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON = 2,
	LabelAbuseTypeMapping = module,
	BODY_PART_NAME_TO_ENUM = {
		Head = Enum.BodyPart.Head,
		LeftArm = Enum.BodyPart.LeftArm,
		LeftLeg = Enum.BodyPart.LeftLeg,
		RightArm = Enum.BodyPart.RightArm,
		RightLeg = Enum.BodyPart.RightLeg,
		Torso = Enum.BodyPart.Torso
	},
	STATIC_FACIAL_ANIMATION = "StaticFacialAnimation",
	NON_EDITABLE_MAKEUP_GRANT_KEY = "NonEditableMakeup",
	INVENTORY_OUTFIT_TYPE_TO_OUTFIT_TYPE = {
		[inventoryOutfitType.Body] = OutfitTypes.Avatar,
		[inventoryOutfitType.Avatar] = OutfitTypes.Avatar,
		[inventoryOutfitType.DynamicHead] = OutfitTypes.DynamicHead,
		[inventoryOutfitType.Shoes] = OutfitTypes.Shoes,
		[inventoryOutfitType.Animations] = OutfitTypes.Animations,
		[inventoryOutfitType.PurchasedMakeup] = OutfitTypes.Makeup,
		[inventoryOutfitType.CreatedMakeup] = OutfitTypes.Makeup
	},
	INVENTORY_TYPE_ID_TO_INVENTORY_OUTFIT_TYPE = AvatarExperienceModel.Constants.InventoryTypeIdToInventoryOutfitType,
	INVENTORY_OUTFIT_TYPE_TO_INVENTORY_TYPE_ID = AvatarExperienceModel.Constants.InventoryOutfitTypeToInventoryTypeId,
	IXP_WIDGET_LAYER_EXPOSURE = { AttributeKey = "IXP_LAYER", TagName = "WIDGET" }
}
