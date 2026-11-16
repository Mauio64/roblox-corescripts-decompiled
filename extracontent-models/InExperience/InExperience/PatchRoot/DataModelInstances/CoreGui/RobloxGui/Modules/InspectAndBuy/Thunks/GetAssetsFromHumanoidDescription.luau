local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local GetProductInfo = require(parent.Thunks.GetProductInfo)
local GetVersionInfo = require(parent.Thunks.GetVersionInfo)
local AssetInfo = require(parent.Models.AssetInfo)
local SetAssets = require(parent.Actions.SetAssets)
local SetEquippedAssets = require(parent.Actions.SetEquippedAssets)
local Constants = require(parent.Constants)
local GetAssetBundles = require(parent.Thunks.GetAssetBundles)
local BatchGetAssets = require(parent.Thunks.BatchGetAssets)

local FFlagAXEnableRegionalFilteringofAssets = require(parent.Flags.FFlagAXEnableRegionalFilteringofAssets)

local v = {}

local function getAssetIds(object)
	local assetIds = {}

	for k, v2 in pairs(Constants.AssetTypeIdStringToHumanoidDescriptionProp) do
		if Constants.AssetTypeIdToAccessoryTypeEnum[k] ~= nil then
			continue
		end

		local v3 = object[v2] or ""

		for _, v4 in pairs(string.split(v3)) do
			if tonumber(v4) and v4 ~= "0" then
				table.insert(assetIds, AssetInfo.fromHumanoidDescription(v4))
			end
		end
	end

	local accessories = object:GetAccessories(true)

	for _, accessory in pairs(accessories) do
		assetIds[#assetIds + 1] = AssetInfo.fromHumanoidDescription(accessory.AssetId)
	end

	local emotes = object:GetEmotes()

	for _, emote in pairs(emotes) do
		for _, v2 in pairs(emote) do
			assetIds[#assetIds + 1] = AssetInfo.fromHumanoidDescription(v2)
		end
	end

	return assetIds
end

local function GetAssetsFromHumanoidDescription(p, p2)
	return Thunk.new(script.Name, v, function(object, _)
		local assetIds = getAssetIds(p)

		if p2 then
			object:dispatch(SetEquippedAssets(assetIds))

			return
		end

		if FFlagAXEnableRegionalFilteringofAssets then
			object:dispatch(BatchGetAssets(assetIds))
			return
		end

		for _, assetId in ipairs(assetIds) do
			coroutine.wrap(function()
				object:dispatch(GetProductInfo(assetId.assetId))

				if assetId.parentBundleId == nil then
					object:dispatch(GetAssetBundles(assetId.assetId))
				end

				object:dispatch(GetVersionInfo(assetId.assetId))
			end)()
		end

		object:dispatch(SetAssets(assetIds))
	end)
end

return GetAssetsFromHumanoidDescription
