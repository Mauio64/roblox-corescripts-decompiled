local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local tutils = require(CorePackages.Packages.tutils)
local module = require("@luauforge/bundled/dFs")

local module2 = require("@luauforge/bundled/dPN")

local assetTypeIdStringToHumanoidDescriptionProp = module2.AssetTypeIdStringToHumanoidDescriptionProp
local humanoidDescriptionScaleToName = module2.HumanoidDescriptionScaleToName
local bodyPartForSkinColoringIdToHumanoidDescription = module2.BodyPartForSkinColoringIdToHumanoidDescription

local v5 = {}

local interface = t.interface({
	id = t.number,
	assets = t.table,
	bodyColor3s = t.table,
	scale = t.table
})

function v5.new()
	return {}
end

function v5.fromOutfitDetailsWebApi(data)
	local result = v5.new()

	if not interface(data) then
		module(string.format(
			"the responseBody of Avatar endpoint, /v3/outfits/{outfitId}/details, did not have expected sets of data: %s",
			tutils.toString(data)
		))
	end

	local id = data.id
	local assets = data.assets or {}
	local scale = data.scale or {}

	for k, asset in pairs(assets) do
		local id2 = asset.assetType and asset.assetType.id
		local id3 = tostring(asset.id)
		local v6 = assetTypeIdStringToHumanoidDescriptionProp[tostring(id2)]

		if t.string(v6) then
			result[v6] = id3
		else
			module(string.format(
				"Avatar's /%s/outfits/%s/details returned an assetTypeId that was not recognized: %s",
				"v3",
				id,
				tutils.toString(asset)
			))
		end
	end

	local bodyColor3s = data.bodyColor3s or {}

	for k, bodyColor3 in pairs(bodyColor3s) do
		local humanoidDescription = bodyPartForSkinColoringIdToHumanoidDescription[tostring(k)]

		if t.string(humanoidDescription) then
			local success, result2 = pcall(function()
				return Color3.fromHex(bodyColor3)
			end)

			if success then
				result[humanoidDescription] = result2
			else
				module(string.format(
					"Avatar's /v3/outfits/%s/details returned a bodyColor3 with bad hash value: bodyPartForSkinColoringId = %s, bodyColor3AsHex = %s",
					id,
					k,
					bodyColor3
				))
			end
		else
			module(string.format(
				"Avatar's /v3/outfits/%s/details returned a BodyPartForSkinColoringId that was not recognized: bodyPartForSkinColoringId = %s, bodyColor3AsHex = %s",
				id,
				k,
				bodyColor3
			))
		end
	end

	for k, v6 in pairs(scale) do
		local v7 = humanoidDescriptionScaleToName[tostring(k)]

		if t.string(v7) then
			result[v7] = v6
		else
			module(string.format(
				"Avatar's /%s/outfits/%s/details returned a scaleType that was not recognized: scaleType: %s, scale: %s",
				"v3",
				id,
				k,
				v6
			))
		end
	end

	return result
end

function v5.createHumanoidDescription(items)
	local humanoidDescription = Instance.new("HumanoidDescription")

	for k, item in pairs(items) do
		humanoidDescription[k] = item
	end

	return humanoidDescription
end

return v5
