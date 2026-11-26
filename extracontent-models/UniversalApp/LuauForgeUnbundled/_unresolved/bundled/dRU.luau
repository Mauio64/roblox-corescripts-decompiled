local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dRV")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dKU")

local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local LAYERED_MAKEUP_ORDER = AvatarExperienceCommon.Constants.LAYERED_MAKEUP_ORDER

local v5 = {}

function v5.mock()
	return {
		version = "1",
		order = 1,
		["type"] = Enum.AccessoryType.Hat,
		isLayered = true,
		position = Vector3.new(),
		rotation = Vector3.new(),
		scale = Vector3.new(1, 1, 1)
	}
end

function v5.getDefaultLayeredClothingMetadata(p2)
	if module.AssetTypeIdToAccessoryTypeEnum[p2] == nil then
		return { version = "1" }
	end

	return {
		version = "1",
		order = module.LayeredClothingOrder[p2],
		type = module.AssetTypeIdToAccessoryTypeEnum[p2],
		isLayered = module.LayeredAssetTypes[p2] ~= nil
	}
end

function v5.getDefaultLayeredMakeupMetadata(p2)
	if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2] == nil then
		return { version = "1" }
	end

	return {
		version = "1",
		order = LAYERED_MAKEUP_ORDER[p2],
		type = ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2],
		isLayered = true
	}
end

function v5.getDefaultMetadata(p2)
	if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2] then
		return (v5.getDefaultLayeredMakeupMetadata(p2))
	end

	return (v5.getDefaultLayeredClothingMetadata(p2))
end

local function fromWebAPIVector3(data)
	if data then
		return (Vector3.new(data.x, data.y, data.z))
	end

	return nil
end

function v5.fromMetadata(options, p2)
	local v6 = options or {}

	if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2] then
		local v7 = LAYERED_MAKEUP_ORDER[p2]

		return {
			version = module2() ~= false and not v6.version and "1" or tostring(v6.version),
			order = v6.order or v7,
			type = v6.type,
			isLayered = true
		}
	end

	local v7 = module.LayeredClothingOrder[p2]

	local v8 = {
		version = module2() ~= false and not v6.version and "1" or tostring(v6.version),
		order = v6.order or v7,
		type = v6.type,
		isLayered = module.LayeredAssetTypes[p2] ~= nil
	}

	if fFlagParseHeadShapeFromAPIResponse then
		v8.headShape = v6.headShape
	end

	if fFlagHeadRefinementFacialAnimationToggle then
		v8.staticFacialAnimation = v6.staticFacialAnimation
	end

	local position = v6.position
	local v9 = if position then Vector3.new(position.x, position.y, position.z) else nil

	v8.position = v9
	local rotation = v6.rotation
	local v10 = if rotation then Vector3.new(rotation.x, rotation.y, rotation.z) else nil

	v8.rotation = v10
	local scale = v6.scale
	local v11 = if scale then Vector3.new(scale.x, scale.y, scale.z) else nil

	v8.scale = v11

	return v8
end

return v5
