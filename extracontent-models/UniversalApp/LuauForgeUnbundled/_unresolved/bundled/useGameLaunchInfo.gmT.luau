local module = require("@luauforge/bundled/gmo")
local module2 = require("@luauforge/bundled/gmU")
local module3 = require("@luauforge/bundled/gmV")
local module4 = require("@luauforge/bundled/gmW")
local pioneerInfo = require("@luauforge/bundled/gmX").PioneerInfo

local module5 = require("@luauforge/bundled/gmY")
require("@luauforge/bundled/gmu")

local computed = module2.createComputed(function(): nil
	return nil
end)

local function useGameLaunchInfo()
	local state, setState = module.useState(0)
	local pioneerRootPlaceId = pioneerInfo.getPioneerRootPlaceId()

	local v5 = module.useMemo(function()
		if pioneerRootPlaceId then
			return module4(false).getMarketplaceAssetInfo((tostring(pioneerRootPlaceId))).data
		end

		return computed
	end, { pioneerRootPlaceId })
	local v6 = module3.useSignalState(v5)

	module.useEffect(function()
		if not pioneerRootPlaceId then
			return
		end

		local v7 = false
		task.spawn(function()
			local success, result = pcall(module5.fetchProductInfo, pioneerRootPlaceId)

			if v7 or not success then
				return
			end

			local creator = result.Creator
			local updateMarketplaceAssetInfo = module4(false).updateMarketplaceAssetInfo
			local v8 = tostring(pioneerRootPlaceId)
			local v9 = {
				name = result.Name,
				creatorName = 0,
				creatorHasVerifiedBadge = 0
			}
			local v10 = if creator then creator.Name else nil
			v9.creatorName = v10
			local v11 = if creator then creator.HasVerifiedBadge == true else false
			v9.creatorHasVerifiedBadge = v11
			updateMarketplaceAssetInfo(v8, v9)
		end)
		task.spawn(function()
			local success, result = pcall(module5.fetchUniverseId, pioneerRootPlaceId)

			if v7 or not (success and result) then
				return
			end

			setState(result)
		end)

		return function()
			v7 = true
		end
	end, { pioneerRootPlaceId })

	local v8 = if v6 then v6.name else nil
	local v9 = if v6 then v6.creatorName else nil
	local v10 = if v6 then v6.creatorHasVerifiedBadge == true else false
	return {
		gameName = v8,
		creatorName = v9,
		isCreatorVerified = v10,
		thumbnailUrl = not (state > 0) and "" or string.format(
			"rbxthumb://type=GameIcon&id=%d&w=256&h=256",
			state
		)
	}
end

return useGameLaunchInfo
