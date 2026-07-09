local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local FFlagAXSimplifyOutfitEquipCheck = require(Modules.AvatarExperience.Flags.FFlagAXSimplifyOutfitEquipCheck)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local LAYERED_MAKEUP_ORDER = AvatarExperienceCommon.Constants.LAYERED_MAKEUP_ORDER
local t1 = {
	mock = function() -- line: 32
		return {
			version = "1",
			order = 1,
			type = Enum.AccessoryType.Hat,
			isLayered = true,
			position = Vector3.new(),
			rotation = Vector3.new(),
			scale = Vector3.new(1, 1, 1)
		}
	end,
	getDefaultLayeredClothingMetadata = function(p1) -- line: 50
		-- upvalues: Constants (copy)
		if Constants.AssetTypeIdToAccessoryTypeEnum[p1] == nil then
			return {
				version = "1"
			}
		end

		return {
			version = "1",
			order = Constants.LayeredClothingOrder[p1],
			type = Constants.AssetTypeIdToAccessoryTypeEnum[p1],
			isLayered = Constants.LayeredAssetTypes[p1] ~= nil
		}
	end
}

if FFlagAXCustomizeMakeupSupport then
	function t1.getDefaultLayeredMakeupMetadata(p2) -- line: 70
		-- upvalues: ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), LAYERED_MAKEUP_ORDER (copy)
		if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2] == nil then
			return {
				version = "1"
			}
		end

		return {
			version = "1",
			isLayered = true,
			order = LAYERED_MAKEUP_ORDER[p2],
			type = ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2]
		}
	end
end

if FFlagAXCustomizeMakeupSupport then
	function t1.getDefaultMetadata(p3) -- line: 94
		-- upvalues: ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), t1 (copy)
		if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p3] then
			return (t1.getDefaultLayeredMakeupMetadata(p3))
		end

		return (t1.getDefaultLayeredClothingMetadata(p3))
	end
else
	function t1.getDefaultMetadata(p4) -- line: 106
		-- upvalues: t1 (copy)
		return (t1.getDefaultLayeredClothingMetadata(p4))
	end
end

local function fromWebAPIVector3(t2: {[any]: any}?) -- line: 113
	if t2 then
		return (Vector3.new(t2.x, t2.y, t2.z))
	end

	return nil
end

if FFlagAXCustomizeMakeupSupport then
	function t1.fromMetadata(p5, p6) -- line: 124
		-- upvalues: ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), LAYERED_MAKEUP_ORDER (copy), FFlagAXSimplifyOutfitEquipCheck (copy), Constants (copy), FFlagParseHeadShapeFromAPIResponse (copy), FFlagHeadRefinementFacialAnimationToggle (copy)
		local v22 = p5 or {}

		if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p6] then
			local v23 = LAYERED_MAKEUP_ORDER[p6]

			return {
				isLayered = true,
				version = FFlagAXSimplifyOutfitEquipCheck() ~= false and not v22.version and "1" or tostring(v22.version),
				order = v22.order or v23,
				type = v22.type
			}
		end

		local v24 = Constants.LayeredClothingOrder[p6]
		local t3 = {
			version = FFlagAXSimplifyOutfitEquipCheck() ~= false and not v22.version and "1" or tostring(v22.version),
			order = v22.order or v24,
			type = v22.type,
			isLayered = Constants.LayeredAssetTypes[p6] ~= nil
		}

		if FFlagParseHeadShapeFromAPIResponse then
			t3.headShape = v22.headShape
		end

		if FFlagHeadRefinementFacialAnimationToggle then
			t3.staticFacialAnimation = v22.staticFacialAnimation
		end

		local position = v22.position

		t3.position = if not position then nil else Vector3.new(position.x, position.y, position.z)

		local rotation = v22.rotation

		t3.rotation = if not rotation then nil else Vector3.new(rotation.x, rotation.y, rotation.z)

		local scale = v22.scale

		t3.scale = if not scale then nil else Vector3.new(scale.x, scale.y, scale.z)

		return t3
	end

	return t1
end

function t1.fromMetadata(p7, p8) -- line: 179
	-- upvalues: Constants (copy), FFlagAXSimplifyOutfitEquipCheck (copy), FFlagParseHeadShapeFromAPIResponse (copy), FFlagHeadRefinementFacialAnimationToggle (copy)
	local v31 = p7 or {}
	local v32 = Constants.LayeredClothingOrder[p8]
	local t4 = {
		version = FFlagAXSimplifyOutfitEquipCheck() ~= false and not v31.version and "1" or tostring(v31.version),
		order = v31.order or v32,
		type = v31.type,
		isLayered = Constants.LayeredAssetTypes[p8] ~= nil
	}

	if FFlagParseHeadShapeFromAPIResponse then
		t4.headShape = v31.headShape
	end

	if FFlagHeadRefinementFacialAnimationToggle then
		t4.staticFacialAnimation = v31.staticFacialAnimation
	end

	local position = v31.position

	t4.position = if not position then nil else Vector3.new(position.x, position.y, position.z)

	local rotation = v31.rotation

	t4.rotation = if not rotation then nil else Vector3.new(rotation.x, rotation.y, rotation.z)

	local scale = v31.scale

	t4.scale = if not scale then nil else Vector3.new(scale.x, scale.y, scale.z)

	return t4
end

return t1
