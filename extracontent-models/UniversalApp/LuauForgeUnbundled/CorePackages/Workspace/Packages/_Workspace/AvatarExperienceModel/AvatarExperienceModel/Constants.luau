require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/CommonTypes")
local InventoryOutfitType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/InventoryOutfitType")

local fFlagAXInventoryDurablesSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceFlags").FFlagAXInventoryDurablesSupport

local enumItems = Enum.BundleType:GetEnumItems()
local v5 = {}
local v6 = {}

for k, enumItem in enumItems do
	v5[enumItem.Name] = tostring(enumItem.Value)
	v6[tostring(enumItem.Value)] = enumItem.Name
end

if fFlagAXInventoryDurablesSupport then
	local v7 = tostring(#enumItems + 1)
	v5.Avatars = v7
	v6[v7] = "Avatars"
end

local v7 = {
	BodyCategories = { Heads = 8.5, Hair = 8.5, ClassicHeads = 6.5, ClassicFaces = 7 },
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
		Bodysuits = 12
	},
	Makeup = {
		Makeup = game:DefineFastInt("AXMakeupZoomRadius", 7),
		MakeupLooks = game:DefineFastInt("AXMakeupLooksZoomRadius", 7),
		Eyelashes = game:DefineFastInt("AXEyelashesZoomRadius", 7),
		Eyebrows = game:DefineFastInt("AXEyebrowsZoomRadius", 7),
		FaceMakeup = game:DefineFastInt("AXFaceMakeupZoomRadius", 7),
		LipMakeup = game:DefineFastInt("AXLipMakeupZoomRadius", 7),
		EyeMakeup = game:DefineFastInt("AXEyeMakeupZoomRadius", 7)
	},
	Special = {
		HeadRefinement = 7,
		PhotoboothMoments = game:DefineFastInt("AXPhotoboothMomentsZoomRadius", 17)
	}
}

local v8 = {
	["1"] = InventoryOutfitType.Body,
	["2"] = InventoryOutfitType.DynamicHead,
	["3"] = InventoryOutfitType.Avatar,
	["4"] = InventoryOutfitType.Shoes,
	["5"] = InventoryOutfitType.Animations,
	["6"] = InventoryOutfitType.PurchasedMakeup,
	["7"] = InventoryOutfitType.CreatedMakeup
}

local v9 = {}

for k, v10 in v8 do
	v9[v10] = tonumber(k)
end

return {
	AnimationCategoryCameraZoomRadius = 5,
	BundleTypeIdStrings = v5,
	BundleTypeIdStringToName = v6,
	CameraZoomRadius = v7,
	InventoryOutfitTypeToInventoryTypeId = v9,
	InventoryTypeIdToInventoryOutfitType = v8
}
