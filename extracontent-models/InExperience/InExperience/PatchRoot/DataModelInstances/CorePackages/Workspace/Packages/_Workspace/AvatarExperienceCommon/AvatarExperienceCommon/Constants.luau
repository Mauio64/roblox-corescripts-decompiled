local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local LabelAbuseTypeMapping = require(script.Parent.LabelAbuseTypeMapping)
require(script.Parent.Types.CategoryTypes.CategoryTypes)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local OutfitTypes = require(script.Parent.Enums.OutfitTypes)
local InventoryOutfitType = AvatarExperienceModel.Enums.InventoryOutfitType
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport

local frozen = table.freeze({
	height = 1,
	width = 1,
	depth = 1,
	head = 1,
	bodyType = 0,
	proportion = 0
})

local enumItems = Enum.AvatarAssetType:GetEnumItems()
local v = {}
local names = {}

for _, enumItem in enumItems do
	v[enumItem.Name] = tostring(enumItem.Value)
	names[tostring(enumItem.Value)] = enumItem.Name
end

local v2 = {
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

local v3 = {}

for k, v4 in v2 do
	v3[v4] = k
end

local v4 = {
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

local v5 = {
	[v.EyebrowAccessory] = 0,
	[v.EyelashAccessory] = 1,
	[v.Pants] = 2,
	[v.Shirt] = 3,
	[v.TShirt] = 4,
	[v.LeftShoeAccessory] = 5,
	[v.RightShoeAccessory] = 5,
	[v.PantsAccessory] = 6,
	[v.ShortsAccessory] = 7,
	[v.DressSkirtAccessory] = 8,
	[v.TShirtAccessory] = 9,
	[v.ShirtAccessory] = 10,
	[v.SweaterAccessory] = 11,
	[v.JacketAccessory] = 12,
	[v.HairAccessory] = 13
}

local v6 = {
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
	[v.EyeMakeup] = true,
	[v.FaceMakeup] = true,
	[v.LipMakeup] = true,
	[v.EyebrowAccessory] = true,
	[v.EyelashAccessory] = true
}
return {
	BODY_BUNDLE_TYPE_ID = "1",
	SPAWN_EFFECT_ASSET_TYPE_ID_STRING = "97",
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
	ASSET_TYPE_TO_ACCESSORY_TYPE = v2,
	ACCESSORY_TYPE_TO_ASSET_TYPE = v3,
	ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = v4,
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
	ASSET_TYPE_NAME_TO_ID_STRING = v,
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
		CreateMakeupLookKey = FFlagAXCatalogMakeupSupport and "avatar.createMakeupLook" or nil
	},
	LAYERED_CLOTHING_ORDER = v5,
	LAYERED_ASSET_TYPES = v6,
	ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = {
		[v.EyeMakeup] = Enum.MakeupType.Eye,
		[v.FaceMakeup] = Enum.MakeupType.Face,
		[v.LipMakeup] = Enum.MakeupType.Lip
	},
	MAKEUP_TYPE_TO_ASSET_TYPE_ID = {
		[Enum.MakeupType.Eye] = v.EyeMakeup,
		[Enum.MakeupType.Face] = v.FaceMakeup,
		[Enum.MakeupType.Lip] = v.LipMakeup
	},
	LAYERED_MAKEUP_ORDER = { [v.FaceMakeup] = 0, [v.LipMakeup] = 1, [v.EyeMakeup] = 2 },
	MAKEUP_LOOK_ASSET_TYPES = set,
	MAX_MAKEUP_LAYERS = 6,
	LOOK_TYPE = {
		Avatar = "Avatar",
		Makeup = "Makeup",
		Outfit = "Outfit",
		AvatarMoment = "AvatarMoment"
	},
	MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON = 2,
	LabelAbuseTypeMapping = LabelAbuseTypeMapping,
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
		[InventoryOutfitType.Body] = OutfitTypes.Avatar,
		[InventoryOutfitType.Avatar] = OutfitTypes.Avatar,
		[InventoryOutfitType.DynamicHead] = OutfitTypes.DynamicHead,
		[InventoryOutfitType.Shoes] = OutfitTypes.Shoes,
		[InventoryOutfitType.Animations] = OutfitTypes.Animations,
		[InventoryOutfitType.PurchasedMakeup] = OutfitTypes.Makeup,
		[InventoryOutfitType.CreatedMakeup] = OutfitTypes.Makeup
	},
	INVENTORY_TYPE_ID_TO_INVENTORY_OUTFIT_TYPE = AvatarExperienceModel.Constants.InventoryTypeIdToInventoryOutfitType,
	INVENTORY_OUTFIT_TYPE_TO_INVENTORY_TYPE_ID = AvatarExperienceModel.Constants.InventoryOutfitTypeToInventoryTypeId,
	IXP_WIDGET_LAYER_EXPOSURE = { AttributeKey = "IXP_LAYER", TagName = "WIDGET" }
}
