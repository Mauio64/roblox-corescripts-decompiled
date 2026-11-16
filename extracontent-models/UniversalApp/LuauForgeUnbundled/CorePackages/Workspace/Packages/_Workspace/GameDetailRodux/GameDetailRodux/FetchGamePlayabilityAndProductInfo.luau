local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Promise")
local playabilityStatusEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/DiscoveryTypes").PlayabilityStatusEnum
local apiFetchPlayabilityStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/PlayabilityRodux").PlayabilityStatus.ApiFetchPlayabilityStatus
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Http").PerformFetch
local fetchGamesProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameProductInfoRodux").FetchGamesProductInfo

local function keyMapper(p2)
	return "luaapp.playability-and-productinfo." .. p2
end

return {
	["KeyMapper"] = keyMapper,
	Fetch = function(p2, value)
		assert(
			type(value) == "string",
			"FetchPlayabilityAndProductInfo thunk expects universeId to be a string"
		)
		return performFetch.Single("luaapp.playability-and-productinfo." .. value, function(object)
			return object:dispatch(apiFetchPlayabilityStatus.Fetch(p2, { value })):andThen(function(p3)
				local unwrapped, v5 = p3[apiFetchPlayabilityStatus.KeyMapper(value)]:unwrap()

				if not unwrapped then
					return Promise.reject()
				end

				local v6 = object:getState().PlayabilityStatus[value]

				if
					v6.isPlayable == false
					and (v6.playabilityStatus == playabilityStatusEnum.PurchaseRequired or v6.playabilityStatus == playabilityStatusEnum.FiatPurchaseRequired)
				then
					return object:dispatch(fetchGamesProductInfo.Fetch(p2, { value })):andThen(function(p4)
						local unwrapped2, v7 = p4[fetchGamesProductInfo.KeyMapper(value)]:unwrap()

						if unwrapped2 then
							return Promise.resolve(v6.playabilityStatus)
						end

						return Promise.reject()
					end)
				end

				return Promise.resolve(v6.playabilityStatus)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.playability-and-productinfo." .. p3)
	end
}
