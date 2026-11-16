local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local AssetInfo = require(parent.Models.AssetInfo)
local SetEquippedAssets = require(parent.Actions.SetEquippedAssets)
local Constants = require(parent.Constants)
local GetAvatarPreview = require(parent.Thunks.GetAvatarPreview)
local SendCounter = require(parent.Thunks.SendCounter)

local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarBackground = require(CorePackages.Workspace.Packages.DataHydration.AvatarBackground)
local FFlagAXInspectAndBuyMakeupSupport = AvatarExperienceFlags.FFlagAXInspectAndBuyMakeupSupport
local FFlagAXInspectAndBuyAvatarBackground = AvatarExperienceFlags.FFlagAXInspectAndBuyAvatarBackground

local v = {}

local function getAssetIds(instance)
	local v2 = false
	local assetIds = {}

	for k, v3 in Constants.AssetTypeIdStringToHumanoidDescriptionProp do
		if Constants.AssetTypeIdToAccessoryTypeEnum[k] ~= nil then
			continue
		end

		local v4 = instance[v3] or ""

		local v5 = k == tostring(Enum.AssetType.Head.Value) or k == tostring(Enum.AssetType.DynamicHead.Value)

		if v2 and v5 then
			continue
		end

		v2 = v5 and true or v2

		for _, v6 in string.split(v4) do
			if tonumber(v6) and v6 ~= "0" then
				table.insert(assetIds, AssetInfo.fromHumanoidDescription(v6))
			end
		end
	end

	local accessories = instance:GetAccessories(true)

	for _, accessory in accessories do
		assetIds[#assetIds + 1] = AssetInfo.fromHumanoidDescriptionAccessory(accessory)
	end

	local emotes = instance:GetEmotes()

	for _, emote in emotes do
		for _, v3 in emote do
			assetIds[#assetIds + 1] = AssetInfo.fromHumanoidDescription(v3)
		end
	end

	if FFlagAXInspectAndBuyMakeupSupport then
		for _, makeupDescription in instance:GetChildren() do
			if makeupDescription:IsA("MakeupDescription") and makeupDescription.AssetId > 0 then
				assetIds[#assetIds + 1] = AssetInfo.fromHumanoidDescription(makeupDescription.AssetId)
			end
		end
	end

	return assetIds
end

local function withEquippedBackground(object, p, playerId)
	if playerId == nil or playerId == "" then
		return Promise.resolve(p)
	end

	return AvatarBackground.getAvatarBackgroundStore(false).awaitAvatarBackground(playerId):andThen(function(p2)
		if not p2.assetId then
			return p
		end

		local clone = table.clone(p)
		table.insert(clone, AssetInfo.fromHumanoidDescription(p2.assetId))
		return clone
	end):catch(function()
		object:dispatch(SendCounter(Constants.Counters.GetAvatarBackground .. Constants.CounterSuffix.RequestFailed))
		return p
	end)
end

local function dispatchPreviewWithEquippedBackground(object, assetIds, callback) -- 1 equivalent call inferred from this helper
	withEquippedBackground(object, assetIds, object:getState().playerId):andThen(function(p)
		if callback and not callback() then
			return
		end

		object:dispatch(GetAvatarPreview(p))
	end)
end

local function GetAssetsFromHumanoidDescriptionV2(p, p2, callback)
	return Thunk.new(script.Name, v, function(object, _)
		local assetIds = getAssetIds(p)

		if p2 then
			object:dispatch(SetEquippedAssets(assetIds))

			return
		end

		if not FFlagAXInspectAndBuyAvatarBackground then
			object:dispatch(GetAvatarPreview(assetIds))
			return
		end

		dispatchPreviewWithEquippedBackground(object, assetIds, callback) -- inferred equivalent call
	end)
end

return GetAssetsFromHumanoidDescriptionV2
