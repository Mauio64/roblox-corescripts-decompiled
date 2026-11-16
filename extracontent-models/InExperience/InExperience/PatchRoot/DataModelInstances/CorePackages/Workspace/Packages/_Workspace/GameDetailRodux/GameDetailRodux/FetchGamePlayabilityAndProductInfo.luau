local parent = script:FindFirstAncestor("GameDetailRodux").Parent
local Promise = require(parent.Promise)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum
local PlayabilityRodux = require(parent.PlayabilityRodux)
local ApiFetchPlayabilityStatus = PlayabilityRodux.PlayabilityStatus.ApiFetchPlayabilityStatus
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local GameProductInfoRodux = require(parent.GameProductInfoRodux)
local FetchGamesProductInfo = GameProductInfoRodux.FetchGamesProductInfo

local function keyMapper(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.playability-and-productinfo." .. p
end

local FetchGamePlayabilityAndProductInfo = {}
FetchGamePlayabilityAndProductInfo.KeyMapper = keyMapper

function FetchGamePlayabilityAndProductInfo.Fetch(p, value)
	assert(type(value) == "string", "FetchPlayabilityAndProductInfo thunk expects universeId to be a string")

	return PerformFetch.Single(keyMapper(value), function(object) -- inferred equivalent call
		return object:dispatch(ApiFetchPlayabilityStatus.Fetch(p, { value })):andThen(function(p2)
			local unwrapped, _ = p2[ApiFetchPlayabilityStatus.KeyMapper(value)]:unwrap()

			if not unwrapped then
				return Promise.reject()
			end

			local v = object:getState().PlayabilityStatus[value]

			if
				v.isPlayable ~= false
				or v.playabilityStatus ~= PlayabilityStatusEnum.PurchaseRequired
				and v.playabilityStatus ~= PlayabilityStatusEnum.FiatPurchaseRequired
			then
				return Promise.resolve(v.playabilityStatus)
			end

			return object:dispatch(FetchGamesProductInfo.Fetch(p, { value })):andThen(function(p3)
				local unwrapped2, _ = p3[FetchGamesProductInfo.KeyMapper(value)]:unwrap()

				if unwrapped2 then
					return Promise.resolve(v.playabilityStatus)
				end

				return Promise.reject()
			end)
		end)
	end)
end

function FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, keyMapper(p2)) -- inferred equivalent call
end

return FetchGamePlayabilityAndProductInfo
