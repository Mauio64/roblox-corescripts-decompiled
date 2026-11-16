local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Constants = require(parent.Constants)
local AvatarViewport = require(parent.Components.AvatarViewport)
local GetHumanoidDescriptionFromCostumeId = require(parent.Thunks.GetHumanoidDescriptionFromCostumeId)

local GetFFlagDisplayCollectiblesIcon = require(parent.Flags.GetFFlagDisplayCollectiblesIcon)

local extended = Roact.PureComponent:extend("TryOnViewport")

local function isPartOfBundleAndOffsale(p): boolean
	if p then
		return p.parentBundleId ~= nil and not p.isForSale or false
	end

	return false
end

local function createDefaultHumanoidDescriptionAccessoryInfo(assetTypeId, assetId) -- 2 equivalent calls inferred from this helper
	return {
		AssetId = tonumber(assetId),
		Order = Constants.LayeredClothingOrder[assetTypeId],
		AccessoryType = Constants.AssetTypeIdToAccessoryTypeEnum[assetTypeId],
		IsLayered = Constants.LayeredAssetTypes[assetTypeId] ~= nil
	}
end

function extended:init()
	self.model = self.props.localPlayerModel
	self.model.HumanoidRootPart.Anchored = true
	self.humanoidDescriptions = {}
	self.humanoidDescriptionForLocalPlayer = self.model.Humanoid.HumanoidDescription
	self.state = { obtainedHumanoidDescriptions = {} }
end

function extended:didMount()
	self.isMounted = true
end

function extended.didUpdate(object, p)
	local assetInfo = object.props.assetInfo
	local bundles = object.props.bundles
	local tryingOnInfo = object.props.tryingOnInfo

	if tryingOnInfo ~= p.tryingOnInfo and tryingOnInfo.tryingOn then
		local v

		if assetInfo and assetInfo.parentBundleId ~= nil then
			v = not assetInfo.isForSale or false
		else
			v = false
		end

		local costumeId = v and bundles[assetInfo.parentBundleId].costumeId

		if costumeId then
			object.props.getHumanoidDescriptionFromCostumeId(costumeId, function(p2)
				if object and object.isMounted then
					object.humanoidDescriptions[costumeId] = p2
					object:setState({
						obtainedHumanoidDescriptions = Cryo.Dictionary.join(object.state.obtainedHumanoidDescriptions, {
							[costumeId] = true
						})
					})
				end
			end)
		end
	end
end

function extended:tryOnBundleWithoutCostumeId(p, assetIds)
	local accessoryTypeEnumSet = {}
	local set = {}
	local flag = false

	for _, assetId in pairs(self.props.bundles[p].assetIds) do
		local asset = self.props.assets[assetId]
		local accessoryTypeEnum = Constants.AssetTypeIdToAccessoryTypeEnum[asset.assetTypeId]

		if not accessoryTypeEnum then
			continue
		end

		accessoryTypeEnumSet[accessoryTypeEnum] = true
		local v = Constants.AssetTypeToAssetCategory[asset.assetTypeId]

		if v then
			set[v] = true
		end

		flag = true
	end

	local accessories = assetIds:GetAccessories(true)
	local v = {}

	if flag then
		for _, accessory in pairs(accessories) do
			local v2 = Constants.AccessoryTypeEnumToAssetTypeId[accessory.AccessoryType]
			local v3 = Constants.AssetTypeToAssetCategory[v2]
			local v4 = not (v3 and set[v3])

			if accessoryTypeEnumSet[accessory.AccessoryType] or not v4 then
				continue
			end

			table.insert(v, accessory)
		end
	end

	for _, assetId in pairs(self.props.bundles[p].assetIds) do
		local asset = self.props.assets[assetId]

		if Constants.AssetTypeIdToAccessoryTypeEnum[asset.assetTypeId] then
			table.insert(v, createDefaultHumanoidDescriptionAccessoryInfo(asset.assetTypeId, assetId)) -- inferred equivalent call
		else
			assetIds[Constants.AssetTypeIdStringToHumanoidDescriptionProp[asset.assetTypeId]] = assetId
		end
	end

	if flag then
		assetIds:SetAccessories(v, true)
	end

	return assetIds
end

function extended:render()
	local assetInfo = self.props.assetInfo
	local bundles = self.props.bundles
	local tryingOnInfo = self.props.tryingOnInfo
	local clone = self.humanoidDescriptionForLocalPlayer:Clone()
	local visible = tryingOnInfo.tryingOn
	local setScrollingEnabled = self.props.setScrollingEnabled

	if tryingOnInfo and tryingOnInfo.tryingOn then
		local v

		if assetInfo and assetInfo.parentBundleId ~= nil then
			v = not assetInfo.isForSale or false
		else
			v = false
		end

		if v then
			local parentBundleId = assetInfo.parentBundleId
			local costumeId = bundles[parentBundleId].costumeId

			if costumeId then
				local humanoidDescription = self.humanoidDescriptions[costumeId]
				visible = self.state.obtainedHumanoidDescriptions[costumeId] == true

				if humanoidDescription then
					for k, v2 in pairs(Constants.AssetTypeIdStringToHumanoidDescriptionProp) do
						if not (Constants.AssetTypeIdToAccessoryTypeEnum[k] == nil and tonumber(humanoidDescription[v2]) and tostring(humanoidDescription[v2]) ~= "0") then
							continue
						end

						clone[v2] = humanoidDescription[v2]
					end

					clone:SetAccessories(humanoidDescription:GetAccessories(true), true)
				end
			else
				clone = self:tryOnBundleWithoutCostumeId(parentBundleId, clone)
			end
		elseif Constants.AssetTypeIdToAccessoryTypeEnum[tryingOnInfo.assetTypeId] then
			local accessoryTypeEnum = Constants.AssetTypeIdToAccessoryTypeEnum[tryingOnInfo.assetTypeId]
			local accessories = clone:GetAccessories(true)
			local v2 = {}

			for _, accessory in pairs(accessories) do
				local v3 = Constants.AccessoryTypeEnumToAssetTypeId[accessory.AccessoryType]
				local v4 = Constants.AssetTypeToAssetCategory[tryingOnInfo.assetTypeId]
				local v5 = Constants.AssetTypeToAssetCategory[v3]
				local v6 = not v4 or v5 ~= v4

				if accessory.AccessoryType ~= accessoryTypeEnum and v6 then
					table.insert(v2, accessory)
				end
			end

			table.insert(
				v2,
				createDefaultHumanoidDescriptionAccessoryInfo(tryingOnInfo.assetTypeId, tryingOnInfo.assetId) -- inferred equivalent call
			)
			clone:SetAccessories(v2, true)
		else
			clone[Constants.AssetTypeIdStringToHumanoidDescriptionProp[tryingOnInfo.assetTypeId]] = tryingOnInfo.assetId
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, GetFFlagDisplayCollectiblesIcon() and Constants.DetailsThumbnailFrameHeight or 300),
		LayoutOrder = 2,
		Visible = visible
	}, {
		AvatarViewport = Roact.createElement(AvatarViewport, {
			size = UDim2.new(0.75, 0, 1, 0),
			position = UDim2.new(0.5, 0, 0.5, 0),
			humanoidDescription = clone,
			model = self.model,
			visible = true,
			backgroundTransparency = 1,
			setScrollingEnabled = setScrollingEnabled
		})
	})
end

function extended:willUnmount()
	self.isMounted = false
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local assetId = data.detailsInformation.assetId

	return {
		assets = data.assets,
		assetInfo = data.assets[assetId],
		bundles = data.bundles,
		tryingOnInfo = data.tryingOnInfo
	}
end, function(callback)
	return {
		getHumanoidDescriptionFromCostumeId = function(p, p2)
			return callback(GetHumanoidDescriptionFromCostumeId(p, p2))
		end
	}
end)(extended)
