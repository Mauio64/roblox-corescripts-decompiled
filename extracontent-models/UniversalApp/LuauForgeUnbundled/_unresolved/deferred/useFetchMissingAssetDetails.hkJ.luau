local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local itemTypeEnum = require("@luauforge/bundled/dPt").Enums.ItemTypeEnum
local updateFetchingStatus = require("@game/CorePackages/Workspace/Packages/Http").Actions.UpdateFetchingStatus
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking

local module3 = require("@luauforge/deferred/gTo")
require("@luauforge/bundled/dKT")

local v5 = math.max(
	1,
	require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FIntAXPhotoboothMomentsMissingDetailsBatchSize
)

local function useFetchMissingAssetDetails(callback)
	local v6 = useDispatch()
	local v7 = useNetworking()

	local v9 = useSelector(React.useCallback(function(p2)
		local v9 = callback(p2)

		if not v9 then
			return {}
		end

		local assetInfos = p2.AvatarExperience.Common.AssetInfos
		local result = {}

		for k, v10 in v9 do
			local assetInfo = assetInfos[v10]

			if not (assetInfo and assetInfo.name) then
				table.insert(result, v10)
			end
		end

		return result
	end, { callback }), getUseSelectorDeepEquals())

	local ref = React.useRef({})
	React.useEffect(function()
		local set = {}

		for k, v10 in v9 do
			set[v10] = true
		end

		for k in ref.current do
			if not set[k] then
				ref.current[k] = nil
			end
		end

		local v10 = {}

		for k, v11 in v9 do
			if ref.current[v11] then
				continue
			end

			ref.current[v11] = true
			table.insert(v10, v11)
		end

		for i = 1, #v10, v5 do
			local v11 = table.move(v10, i, math.min(i + v5 - 1, #v10), 1, {})
			local v12 = {}

			for k, v13 in v11 do
				table.insert(v12, {
					id = v13,
					itemType = itemTypeEnum.Asset,
					quantityOwned = 1
				})
			end

			local v13 = "PhotoboothMomentsMissingDetails:" .. table.concat(v11, ",")
			v6(module3(v7, nil, v12, true, v13)):catch(function(p2)
				for k, v14 in v11 do
					ref.current[v14] = nil
				end

				mutedError(`useFetchMissingAssetDetails: details request failed: {tostring(p2)}`)
			end):finally(function()
				v6(updateFetchingStatus(v13, nil))
			end)
		end
	end, { v9, v6, v7 })
end

return useFetchMissingAssetDetails
