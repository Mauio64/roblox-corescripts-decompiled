local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local GetProductInfo = require(ParentParent.Thunks.GetProductInfo)
local GetVersionInfo = require(ParentParent.Thunks.GetVersionInfo)
local AssetInfo = require(ParentParent.Models.AssetInfo)
local SetAssets = require(ParentParent.Actions.SetAssets)
local SetEquippedAssets = require(ParentParent.Actions.SetEquippedAssets)
local Constants = require(ParentParent.Constants)
local GetAssetBundles = require(ParentParent.Thunks.GetAssetBundles)
local BatchGetAssets = require(ParentParent.Thunks.BatchGetAssets)
local FFlagAXEnableRegionalFilteringofAssets = require(ParentParent.Flags.FFlagAXEnableRegionalFilteringofAssets)
local t1 = {}

local function getAssetIds(p1) -- line: 18
	-- upvalues: Constants (copy), AssetInfo (copy)
	local t2 = {}

	for k, v in pairs(Constants.AssetTypeIdStringToHumanoidDescriptionProp) do
		if Constants.AssetTypeIdToAccessoryTypeEnum[k] == nil then
			local v19 = p1[v] or ""

			for _, v2 in pairs(string.split(v19)) do
				if tonumber(v2) and v2 ~= "0" then
					table.insert(t2, AssetInfo.fromHumanoidDescription(v2))
				end
			end
		end
	end

	local Accessories = p1:GetAccessories(true)

	for _, v in pairs(Accessories) do
		t2[#t2 + 1] = AssetInfo.fromHumanoidDescription(v.AssetId)
	end

	local Emotes = p1:GetEmotes()

	for _, v in pairs(Emotes) do
		for _, v3 in pairs(v) do
			t2[#t2 + 1] = AssetInfo.fromHumanoidDescription(v3)
		end
	end

	return t2
end
local function GetAssetsFromHumanoidDescription(p2, p3) -- line: 52
	-- upvalues: Thunk (copy), t1 (copy), getAssetIds (copy), FFlagAXEnableRegionalFilteringofAssets (copy), BatchGetAssets (copy), GetProductInfo (copy), GetAssetBundles (copy), GetVersionInfo (copy), SetAssets (copy), SetEquippedAssets (copy)
	return Thunk.new(script.Name, t1, function(p4, _) -- line: 53
		-- upvalues: getAssetIds (copy), p2 (copy), p3 (copy), FFlagAXEnableRegionalFilteringofAssets (copy), BatchGetAssets (copy), GetProductInfo (copy), GetAssetBundles (copy), GetVersionInfo (copy), SetAssets (copy), SetEquippedAssets (copy)
		local v34 = getAssetIds(p2)

		if not p3 then
			if FFlagAXEnableRegionalFilteringofAssets then
				p4:dispatch(BatchGetAssets(v34))

				return
			end

			for _, v in ipairs(v34) do
				coroutine.wrap(function() -- line: 61
					-- upvalues: p4 (copy), GetProductInfo (copy), v (copy), GetAssetBundles (copy), GetVersionInfo (copy)
					p4:dispatch(GetProductInfo(v.assetId))

					if v.parentBundleId == nil then
						p4:dispatch(GetAssetBundles(v.assetId))
					end

					p4:dispatch(GetVersionInfo(v.assetId))
				end)()
			end

			p4:dispatch(SetAssets(v34))

			return
		end

		p4:dispatch(SetEquippedAssets(v34))
	end)
end

return GetAssetsFromHumanoidDescription
