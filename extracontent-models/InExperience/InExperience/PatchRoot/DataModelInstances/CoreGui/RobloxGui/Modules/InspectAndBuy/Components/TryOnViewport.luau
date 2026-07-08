local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Constants = require(ParentParent.Constants)
local AvatarViewport = require(ParentParent.Components.AvatarViewport)
local GetHumanoidDescriptionFromCostumeId = require(ParentParent.Thunks.GetHumanoidDescriptionFromCostumeId)
local GetFFlagDisplayCollectiblesIcon = require(ParentParent.Flags.GetFFlagDisplayCollectiblesIcon)
local v10 = Roact.PureComponent:extend("TryOnViewport")

local function isPartOfBundleAndOffsale(p1) -- line: 14
	return not not p1 and (p1.parentBundleId ~= nil and (not p1.isForSale or false))
end
local function createDefaultHumanoidDescriptionAccessoryInfo(p2, p3) -- line: 18
	-- upvalues: Constants (copy)
	return {
		AssetId = tonumber(p3),
		Order = Constants.LayeredClothingOrder[p2],
		AccessoryType = Constants.AssetTypeIdToAccessoryTypeEnum[p2],
		IsLayered = Constants.LayeredAssetTypes[p2] ~= nil
	}
end

function v10.init(p4) -- line: 27
	p4.model = p4.props.localPlayerModel
	p4.model.HumanoidRootPart.Anchored = true
	p4.humanoidDescriptions = {}
	p4.humanoidDescriptionForLocalPlayer = p4.model.Humanoid.HumanoidDescription
	p4.state = {
		obtainedHumanoidDescriptions = {}
	}
end
function v10.didMount(p5) -- line: 37
	p5.isMounted = true
end
function v10.didUpdate(p6, p7) -- line: 41
	-- upvalues: Cryo (copy)
	local assetInfo = p6.props.assetInfo
	local bundles = p6.props.bundles
	local tryingOnInfo = p6.props.tryingOnInfo

	if tryingOnInfo ~= p7.tryingOnInfo and (tryingOnInfo.tryingOn and (not not assetInfo and (assetInfo.parentBundleId ~= nil and (not assetInfo.isForSale or false)))) then
		local costumeId = bundles[assetInfo.parentBundleId].costumeId

		if costumeId then
			p6.props.getHumanoidDescriptionFromCostumeId(costumeId, function(p8) -- line: 53
				-- upvalues: p6 (copy), costumeId (copy), Cryo (copy)
				if p6 and p6.isMounted then
					p6.humanoidDescriptions[costumeId] = p8
					p6:setState({
						obtainedHumanoidDescriptions = Cryo.Dictionary.join(p6.state.obtainedHumanoidDescriptions, {
							[costumeId] = true
						})
					})
				end
			end)
		end
	end
end
function v10.tryOnBundleWithoutCostumeId(p9, p10, p11) -- line: 72
	-- upvalues: Constants (copy)
	local t1 = {}
	local t2 = {}
	local v29 = false

	for _, v in pairs(p9.props.bundles[p10].assetIds) do
		local v32 = p9.props.assets[v]
		local v33 = Constants.AssetTypeIdToAccessoryTypeEnum[v32.assetTypeId]

		if v33 then
			t1[v33] = true

			local v34 = Constants.AssetTypeToAssetCategory[v32.assetTypeId]

			if v34 then
				t2[v34] = true
			end

			v29 = true
		end
	end

	local Accessories = p11:GetAccessories(true)
	local t3 = {}

	if v29 then
		for _, v in pairs(Accessories) do
			local v39 = Constants.AccessoryTypeEnumToAssetTypeId[v.AccessoryType]
			local v40 = Constants.AssetTypeToAssetCategory[v39]
			local v41 = not v40 or not t2[v40]

			if not t1[v.AccessoryType] and v41 then
				table.insert(t3, v)
			end
		end
	end

	for _, v in pairs(p9.props.bundles[p10].assetIds) do
		local v44 = p9.props.assets[v]

		if Constants.AssetTypeIdToAccessoryTypeEnum[v44.assetTypeId] then
			local assetTypeId = v44.assetTypeId

			table.insert(t3, {
				AssetId = tonumber(v),
				Order = Constants.LayeredClothingOrder[assetTypeId],
				AccessoryType = Constants.AssetTypeIdToAccessoryTypeEnum[assetTypeId],
				IsLayered = Constants.LayeredAssetTypes[assetTypeId] ~= nil
			})
		else
			p11[Constants.AssetTypeIdStringToHumanoidDescriptionProp[v44.assetTypeId]] = v
		end
	end

	if v29 then
		p11:SetAccessories(t3, true)
	end

	return p11
end
function v10.render(p12) -- line: 126
	-- upvalues: Constants (copy), Roact (copy), GetFFlagDisplayCollectiblesIcon (copy), AvatarViewport (copy)
	local assetInfo = p12.props.assetInfo
	local bundles = p12.props.bundles
	local tryingOnInfo = p12.props.tryingOnInfo
	local clone = p12.humanoidDescriptionForLocalPlayer:Clone()
	local tryingOn = tryingOnInfo.tryingOn
	local setScrollingEnabled = p12.props.setScrollingEnabled

	if tryingOnInfo and tryingOnInfo.tryingOn then
		if not not assetInfo and (assetInfo.parentBundleId ~= nil and (not assetInfo.isForSale or false)) then
			local parentBundleId = assetInfo.parentBundleId
			local costumeId = bundles[parentBundleId].costumeId

			if costumeId then
				local v55 = p12.humanoidDescriptions[costumeId]

				tryingOn = p12.state.obtainedHumanoidDescriptions[costumeId] == true

				if v55 then
					for k, v in pairs(Constants.AssetTypeIdStringToHumanoidDescriptionProp) do
						if Constants.AssetTypeIdToAccessoryTypeEnum[k] == nil and tonumber(v55[v]) and tostring(v55[v]) ~= "0" then
							clone[v] = v55[v]
						end
					end

					clone:SetAccessories(v55:GetAccessories(true), true)
				end
			else
				clone = p12:tryOnBundleWithoutCostumeId(parentBundleId, clone)
			end
		elseif Constants.AssetTypeIdToAccessoryTypeEnum[tryingOnInfo.assetTypeId] then
			local v58 = Constants.AssetTypeIdToAccessoryTypeEnum[tryingOnInfo.assetTypeId]
			local Accessories = clone:GetAccessories(true)
			local t4 = {}

			for _, v in pairs(Accessories) do
				local v63 = Constants.AccessoryTypeEnumToAssetTypeId[v.AccessoryType]
				local v64 = Constants.AssetTypeToAssetCategory[tryingOnInfo.assetTypeId]
				local v65 = Constants.AssetTypeToAssetCategory[v63]
				local v66 = not v64 or v65 ~= v64

				if v58 ~= v.AccessoryType and v66 then
					table.insert(t4, v)
				end
			end

			local assetTypeId = tryingOnInfo.assetTypeId

			table.insert(t4, {
				AssetId = tonumber(tryingOnInfo.assetId),
				Order = Constants.LayeredClothingOrder[assetTypeId],
				AccessoryType = Constants.AssetTypeIdToAccessoryTypeEnum[assetTypeId],
				IsLayered = Constants.LayeredAssetTypes[assetTypeId] ~= nil
			})
			clone:SetAccessories(t4, true)
		else
			clone[Constants.AssetTypeIdStringToHumanoidDescriptionProp[tryingOnInfo.assetTypeId]] = tryingOnInfo.assetId
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, GetFFlagDisplayCollectiblesIcon() and Constants.DetailsThumbnailFrameHeight or 300),
		Visible = tryingOn
	}, {
		AvatarViewport = Roact.createElement(AvatarViewport, {
			visible = true,
			backgroundTransparency = 1,
			size = UDim2.new(0.75, 0, 1, 0),
			position = UDim2.new(0.5, 0, 0.5, 0),
			humanoidDescription = clone,
			model = p12.model,
			setScrollingEnabled = setScrollingEnabled
		})
	})
end
function v10.willUnmount(p13) -- line: 214
	p13.isMounted = false
end

return RoactRodux.UNSTABLE_connect2(function(p14, _) -- line: 218
	local assetId = p14.detailsInformation.assetId

	return {
		assets = p14.assets,
		assetInfo = p14.assets[assetId],
		bundles = p14.bundles,
		tryingOnInfo = p14.tryingOnInfo
	}
end, function(p16) -- line: 227
	-- upvalues: GetHumanoidDescriptionFromCostumeId (copy)
	return {
		getHumanoidDescriptionFromCostumeId = function(p17, p18) -- line: 229
			-- upvalues: p16 (copy), GetHumanoidDescriptionFromCostumeId (copy)
			return p16(GetHumanoidDescriptionFromCostumeId(p17, p18))
		end
	}
end)(v10)
