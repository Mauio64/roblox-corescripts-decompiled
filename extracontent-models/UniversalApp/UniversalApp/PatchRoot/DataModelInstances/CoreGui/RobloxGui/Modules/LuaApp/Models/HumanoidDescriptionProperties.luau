local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local t = require(CorePackages.Packages.t)
local tutils = require(CorePackages.Packages.tutils)
local mutedError = require(Modules.LuaApp.mutedError)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AssetTypeIdStringToHumanoidDescriptionProp = Constants.AssetTypeIdStringToHumanoidDescriptionProp
local HumanoidDescriptionScaleToName = Constants.HumanoidDescriptionScaleToName
local BodyPartForSkinColoringIdToHumanoidDescription = Constants.BodyPartForSkinColoringIdToHumanoidDescription
local t1 = {}
local v11 = t.interface({
	id = t.number,
	assets = t.table,
	bodyColor3s = t.table,
	scale = t.table
})

function t1.new() -- line: 29
	return {}
end
function t1.fromOutfitDetailsWebApi(p1) -- line: 36
	-- upvalues: t1 (copy), v11 (copy), mutedError (copy), tutils (copy), AssetTypeIdStringToHumanoidDescriptionProp (copy), t (copy), BodyPartForSkinColoringIdToHumanoidDescription (copy), HumanoidDescriptionScaleToName (copy)
	local v13 = t1.new()

	if not v11(p1) then
		mutedError(string.format("the responseBody of Avatar endpoint, /v3/outfits/{outfitId}/details, did not have expected sets of data: %s", tutils.toString(p1)))
	end

	local id = p1.id
	local v15 = p1.assets or {}
	local v16 = p1.scale or {}

	for _, v in pairs(v15) do
		local v19 = v.assetType and v.assetType.id
		local str = tostring(v.id)
		local v21 = AssetTypeIdStringToHumanoidDescriptionProp[tostring(v19)]

		if t.string(v21) then
			v13[v21] = str
		else
			mutedError(string.format("Avatar's /%s/outfits/%s/details returned an assetTypeId that was not recognized: %s", "v3", id, tutils.toString(v)))
		end
	end

	local v22 = p1.bodyColor3s or {}

	for k, v in pairs(v22) do
		local v25 = BodyPartForSkinColoringIdToHumanoidDescription[tostring(k)]

		if t.string(v25) then
			local ok, result = pcall(function() -- line: 76
				-- upvalues: v (copy)
				return Color3.fromHex(v)
			end)

			if ok then
				v13[v25] = result
			else
				mutedError(string.format("Avatar's /v3/outfits/%s/details returned a bodyColor3 with bad hash value: bodyPartForSkinColoringId = %s, bodyColor3AsHex = %s", id, k, v))
			end
		else
			mutedError(string.format("Avatar's /v3/outfits/%s/details returned a BodyPartForSkinColoringId that was not recognized: bodyPartForSkinColoringId = %s, bodyColor3AsHex = %s", id, k, v))
		end
	end

	for k, v in pairs(v16) do
		local v30 = HumanoidDescriptionScaleToName[tostring(k)]

		if t.string(v30) then
			v13[v30] = v
		else
			mutedError(string.format("Avatar's /%s/outfits/%s/details returned a scaleType that was not recognized: scaleType: %s, scale: %s", "v3", id, k, v))
		end
	end

	return v13
end
function t1.createHumanoidDescription(p2) -- line: 125
	local HumanoidDescription = Instance.new("HumanoidDescription")

	for k, v in pairs(p2) do
		HumanoidDescription[k] = v
	end

	return HumanoidDescription
end

return t1
