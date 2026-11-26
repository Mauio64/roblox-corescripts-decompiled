local module = require("@luauforge/deferred/gTU")
local module2 = require("@luauforge/deferred/gTV")
local module3 = require("@luauforge/deferred/gUj")

local fFlagAXPhotoboothMomentsLookAccessoryAdjustments = module2.FFlagAXPhotoboothMomentsLookAccessoryAdjustments

local function toAxisTable(data)
	if typeof(data) == "Vector3" then
		return { x = data.X, y = data.Y, z = data.Z }
	end

	return nil
end

local DEFAULT_AVATAR_SCALES = module.Constants.DEFAULT_AVATAR_SCALES

local function getAllowedWornAssetTypeIds()
	local v5 = {
		Enum.AssetType.TShirt,
		Enum.AssetType.Shirt,
		Enum.AssetType.Pants,
		Enum.AssetType.Head,
		Enum.AssetType.Face,
		Enum.AssetType.Torso,
		Enum.AssetType.RightArm,
		Enum.AssetType.LeftArm,
		Enum.AssetType.LeftLeg,
		Enum.AssetType.RightLeg,
		Enum.AssetType.DynamicHead,
		Enum.AssetType.FaceMakeup,
		Enum.AssetType.LipMakeup,
		Enum.AssetType.EyeMakeup
	}

	local allowedWornAssetTypeIds = {}

	for k in module.Constants.ASSET_TYPE_TO_ACCESSORY_TYPE do
		allowedWornAssetTypeIds[tostring(k)] = true
	end

	for k, v6 in v5 do
		allowedWornAssetTypeIds[tostring(v6.Value)] = true
	end

	return allowedWornAssetTypeIds
end

local allowedWornAssetTypeIds = getAllowedWornAssetTypeIds()

local v5 = {
	"headColor3",
	"torsoColor3",
	"leftArmColor3",
	"rightArmColor3",
	"leftLegColor3",
	"rightLegColor3"
}

local function toHex(value)
	if typeof(value) == "Color3" then
		return value:ToHex()
	end

	if type(value) == "string" and value ~= "" then
		return string.upper((string.gsub(value, "#", "")))
	end

	return "A3A2A5"
end

local function buildAvatarMomentLookRequest(data)
	local v6 = {}

	for k, v7 in data.assets or {} do
		if not allowedWornAssetTypeIds[tostring(k)] then
			continue
		end

		for k2, v9 in v7 do
			local v10 = tonumber(k2)

			if v10 == nil and type(v9) == "table" then
				v10 = tonumber(v9.id or v9.assetId)
			end

			if not (v10 ~= nil and v10 > 0) then
				continue
			end

			local v11 = { id = v10 }

			if type(v9) == "table" then
				local order = tonumber(v9.order)
				local version = tonumber(v9.version)

				if fFlagAXPhotoboothMomentsLookAccessoryAdjustments then
					local position = v9.position
					local v12 = typeof(position) == "Vector3"
						and { x = position.X, y = position.Y, z = position.Z }
						or nil

					local rotation = v9.rotation
					local v13 = typeof(rotation) == "Vector3"
						and { x = rotation.X, y = rotation.Y, z = rotation.Z }
						or nil

					local scale = v9.scale
					local v14 = typeof(scale) == "Vector3" and {
							x = scale.X,
							y = scale.Y,
							z = scale.Z
						}
						or nil

					if order ~= nil and version ~= nil or v12 ~= nil or v13 ~= nil or v14 ~= nil then
						v11.meta = {
							order = order,
							version = version == nil and 1 or version,
							position = v12,
							rotation = v13,
							scale = v14
						}
					end
				elseif order ~= nil and version ~= nil then
					v11.meta = { order = order, version = version }
				end
			end

			if v6[v10] == nil or v11.meta ~= nil then
				v6[v10] = v11
			end
		end
	end

	local v8 = (if data.emoteAssetId == module3.R6WaveEmoteId then tonumber(module3.R15WaveEmoteId) else tonumber(data.emoteAssetId))
		or tonumber(module3.R15WaveEmoteId)
	local backgroundAssetId = tonumber(data.backgroundAssetId) or tonumber(module3.DefaultBackgroundAssetId)

	if v8 ~= nil and v8 > 0 then
		v6[v8] = v6[v8] or { id = v8 }
	end

	if backgroundAssetId ~= nil and backgroundAssetId > 0 then
		v6[backgroundAssetId] = v6[backgroundAssetId] or { id = backgroundAssetId }
	end

	local v9 = {}

	for k, v10 in v6 do
		table.insert(v9, v10)
	end

	table.sort(v9, function(a, b): boolean
		return a.id < b.id
	end)

	local bodyColor3s = data.bodyColor3s or {}
	local v10 = {}

	for k, v11 in v5 do
		local bodyColor3 = bodyColor3s[v11]
		local v12 = if typeof(bodyColor3) == "Color3" then bodyColor3:ToHex() else (type(bodyColor3) ~= "string" or bodyColor3 == "") and "A3A2A5" or string.upper((string.gsub(bodyColor3, "#", "")))

		v10[v11] = v12
	end

	return {
		assets = v9,
		avatarProperties = {
			playerAvatarType = data.avatarType or "R15",
			bodyColor3s = v10,
			scale = table.clone(data.scales or DEFAULT_AVATAR_SCALES)
		},
		thumbnailDisplayProperties = { backgroundType = "None", emoteAssetId = v8 }
	}
end

return buildAvatarMomentLookRequest
