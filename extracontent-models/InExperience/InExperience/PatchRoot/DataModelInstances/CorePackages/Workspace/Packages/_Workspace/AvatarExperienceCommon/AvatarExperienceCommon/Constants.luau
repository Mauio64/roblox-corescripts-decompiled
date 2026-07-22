local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local LabelAbuseTypeMapping = require(script.Parent.LabelAbuseTypeMapping)

require(script.Parent.Types.CategoryTypes.CategoryTypes)

local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagAXCatalogBodySuits = AvatarExperienceFlags.FFlagAXCatalogBodySuits
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local t1 = {}
local t2 = {}
local EnumItems = Enum.BundleType:GetEnumItems()

for _, v11 in EnumItems do
	t1[v11.Name] = tostring(v11.Value)
	t2[tostring(v11.Value)] = v11.Name
end

if FFlagAXInventoryDurablesSupport then
	local str = tostring(#EnumItems + 1)

	t1.Avatars = str
	t2[str] = "Avatars"
end

local t3 = {
	["1"] = "Body",
	["2"] = "AvatarAnimations",
	["3"] = "Shoes",
	["4"] = "DynamicHead"
}
local t4 = {}
local t5 = {}

for _, v17 in (Enum.AvatarAssetType:GetEnumItems()) do
	t4[v17.Name] = tostring(v17.Value)
	t5[tostring(v17.Value)] = v17.Name
end

local t6 = {
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
local t7 = {}

for v20, v21 in t6 do
	t7[v21] = v20
end

local t8 = {
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
local t9 = {
	bodyType = "BodyTypeScale",
	head = "HeadScale",
	height = "HeightScale",
	proportion = "ProportionScale",
	depth = "DepthScale",
	width = "WidthScale"
}
local t10 = {
	headColor3 = "HeadColor",
	leftArmColor3 = "LeftArmColor",
	leftLegColor3 = "LeftLegColor",
	rightArmColor3 = "RightArmColor",
	rightLegColor3 = "RightLegColor",
	torsoColor3 = "TorsoColor"
}
local t11 = {
	IS_LEFT = "IS_LEFT",
	IS_RIGHT = "IS_RIGHT"
}
local v26 = game:DefineFastInt("AXMakeupZoomRadius", 7)
local v27 = game:DefineFastInt("AXMakeupLooksZoomRadius", 7)
local v28 = game:DefineFastInt("AXEyelashesZoomRadius", 7)
local v29 = game:DefineFastInt("AXEyebrowsZoomRadius", 7)
local v30 = game:DefineFastInt("AXFaceMakeupZoomRadius", 7)
local v31 = game:DefineFastInt("AXLipMakeupZoomRadius", 7)
local v32 = game:DefineFastInt("AXEyeMakeupZoomRadius", 7)
local t12 = {
	BodyCategories = {
		Heads = 8.5,
		Hair = 8.5,
		ClassicHeads = 6.5,
		ClassicFaces = 7
	},
	DynamicBodyCategories = {
		Style = 6.5,
		Hair = 8.5,
		ClassicHeads = 6.5,
		ClassicFaces = 7,
		Torsos = 9,
		Arms = 13,
		Legs = 13.5
	},
	CatalogAccessories = {
		Hats = 11,
		Face = 4.5,
		Neck = 9,
		Shoulder = 11,
		Front = 9.5,
		Back = 21,
		Waist = 17
	},
	AvatarEditorAccessories = {
		Hats = 11,
		Face = 7,
		Neck = 9,
		Shoulder = 11,
		Front = 9.5,
		Back = 21,
		Waist = 17
	},
	AccessoryAdjustment = {
		Hat = 11,
		Face = 7,
		Neck = 9,
		Shoulder = 11,
		Front = 21,
		Back = 21,
		Waist = 17
	},
	Clothing = {
		Shirts = 12,
		TShirts = 12,
		Sweaters = 12,
		Jackets = 12,
		Pants = 12,
		Shorts = 12,
		Shoes = 12,
		ClassicShirts = 12,
		ClassicTShirts = 12,
		ClassicPants = 12,
		Tops = 12,
		Outerwear = 12,
		Bottoms = 12,
		Bodysuits = if not FFlagAXCatalogBodySuits then nil else 12
	},
	Makeup = {
		Makeup = v26,
		MakeupLooks = v27,
		Eyelashes = v28,
		Eyebrows = v29,
		FaceMakeup = v30,
		LipMakeup = v31,
		EyeMakeup = v32
	},
	Special = {
		HeadRefinement = 7
	}
}
local t13 = {
	Seen = "AXTooltipSeen",
	TimeDismiss = "AXTooltipTimeDismiss",
	ClickDismiss = "AXTooltipClickDismiss",
	CallbackDismiss = "AXTooltipCallbackDismiss"
}
local t14 = {
	CreateOutfitKey = "avatar.createOutfit",
	CreateMakeupLookKey = if not FFlagAXCatalogMakeupSupport then nil else "avatar.createMakeupLook"
}
local t15 = {
	[t4.EyebrowAccessory] = 0,
	[t4.EyelashAccessory] = 1,
	[t4.Pants] = 2,
	[t4.Shirt] = 3,
	[t4.TShirt] = 4,
	[t4.LeftShoeAccessory] = 5,
	[t4.RightShoeAccessory] = 5,
	[t4.PantsAccessory] = 6,
	[t4.ShortsAccessory] = 7,
	[t4.DressSkirtAccessory] = 8,
	[t4.TShirtAccessory] = 9,
	[t4.ShirtAccessory] = 10,
	[t4.SweaterAccessory] = 11,
	[t4.JacketAccessory] = 12,
	[t4.HairAccessory] = 13
}
local t16 = {
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
local t17 = {
	[t4.EyeMakeup] = true,
	[t4.FaceMakeup] = true,
	[t4.LipMakeup] = true,
	[t4.EyebrowAccessory] = true,
	[t4.EyelashAccessory] = true
}
local t18 = {
	Avatar = "Avatar",
	Makeup = "Makeup",
	Outfit = "Outfit"
}
local t19 = {
	[t4.EyeMakeup] = Enum.MakeupType.Eye,
	[t4.FaceMakeup] = Enum.MakeupType.Face,
	[t4.LipMakeup] = Enum.MakeupType.Lip
}
local t20 = {
	[Enum.MakeupType.Eye] = t4.EyeMakeup,
	[Enum.MakeupType.Face] = t4.FaceMakeup,
	[Enum.MakeupType.Lip] = t4.LipMakeup
}
local t21 = {
	[t4.FaceMakeup] = 0,
	[t4.LipMakeup] = 1,
	[t4.EyeMakeup] = 2
}
local t22 = {
	AttributeKey = "IXP_LAYER",
	TagName = "WIDGET"
}

return {
	BODY_BUNDLE_TYPE_ID = "1",
	AVATAR_ANIMATIONS_BUNDLE_TYPE_ID = "2",
	SHOES_BUNDLE_TYPE_ID = "3",
	DYNAMIC_HEAD_BUNDLE_TYPE_ID = "4",
	BUNDLE_TYPE_ID_STRINGS = t1,
	BUNDLE_TYPE_ID_STRING_TO_NAME = t2,
	BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND = t3,
	ASSET_TYPE_TO_ACCESSORY_TYPE = t6,
	ACCESSORY_TYPE_TO_ASSET_TYPE = t7,
	ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP = t8,
	HUMANOID_DESCRIPTION_SCALE_TO_NAME = t9,
	BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION = t10,
	ASSET_TYPE_NAME_TO_ID_STRING = t4,
	ASSET_TYPE_ID_STRING_TO_NAME = t5,
	NAVIGATION_DIRECTION = t11,
	LANDSCAPE_UI_WIDTH_PERCENTAGE = 0.6,
	LANDSCAPE_SCENE_WIDTH_PERCENTAGE = 0.4,
	CAMERA_ZOOM_RADIUS = t12,
	AVATAR_BLOCKY_DEFAULT_BUNDLE_ID = "356",
	AX_TOOLTIP_STORAGE_KEY = "AXTooltipStorageKey",
	AX_TOOLTIP_COUNTERS = t13,
	AVATAR_EDITOR_CONSTANTS = t14,
	LAYERED_CLOTHING_ORDER = t15,
	LAYERED_ASSET_TYPES = t16,
	ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = t19,
	MAKEUP_TYPE_TO_ASSET_TYPE_ID = t20,
	LAYERED_MAKEUP_ORDER = t21,
	MAKEUP_LOOK_ASSET_TYPES = t17,
	MAX_MAKEUP_LAYERS = 6,
	LOOK_TYPE = t18,
	MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON = 2,
	LabelAbuseTypeMapping = LabelAbuseTypeMapping,
	IXP_WIDGET_LAYER_EXPOSURE = t22
}
