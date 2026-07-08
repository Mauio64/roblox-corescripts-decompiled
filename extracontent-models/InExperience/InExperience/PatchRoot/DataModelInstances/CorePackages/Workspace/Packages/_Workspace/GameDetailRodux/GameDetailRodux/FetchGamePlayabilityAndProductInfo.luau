local Parent = script:FindFirstAncestor("GameDetailRodux").Parent
local Promise = require(Parent.Promise)
local PlayabilityStatusEnum = require(Parent.DiscoveryTypes).PlayabilityStatusEnum
local ApiFetchPlayabilityStatus = require(Parent.PlayabilityRodux).PlayabilityStatus.ApiFetchPlayabilityStatus
local PerformFetch = require(Parent.Http).PerformFetch
local FetchGamesProductInfo = require(Parent.GameProductInfoRodux).FetchGamesProductInfo

local function keyMapper(p1) -- line: 9
	return "luaapp.playability-and-productinfo." .. p1
end

return {
	KeyMapper = keyMapper,
	Fetch = function(p2, p3) -- line: 17
		-- upvalues: PerformFetch (copy), ApiFetchPlayabilityStatus (copy), PlayabilityStatusEnum (copy), FetchGamesProductInfo (copy), Promise (copy)
		assert(type(p3) == "string", "FetchPlayabilityAndProductInfo thunk expects universeId to be a string")

		return PerformFetch.Single("luaapp.playability-and-productinfo." .. p3, function(p4) -- line: 20
			-- upvalues: ApiFetchPlayabilityStatus (copy), p2 (copy), p3 (copy), PlayabilityStatusEnum (copy), FetchGamesProductInfo (copy), Promise (copy)
			return p4:dispatch(ApiFetchPlayabilityStatus.Fetch(p2, { p3 })):andThen(function(p5) -- line: 23
				-- upvalues: ApiFetchPlayabilityStatus (copy), p3 (copy), p4 (copy), PlayabilityStatusEnum (copy), FetchGamesProductInfo (copy), p2 (copy), Promise (copy)
				local v15, _ = p5[ApiFetchPlayabilityStatus.KeyMapper(p3)]:unwrap()

				if v15 then
					local v17 = p4:getState().PlayabilityStatus[p3]

					if v17.isPlayable == false and (v17.playabilityStatus == PlayabilityStatusEnum.PurchaseRequired or v17.playabilityStatus == PlayabilityStatusEnum.FiatPurchaseRequired) then
						return p4:dispatch(FetchGamesProductInfo.Fetch(p2, { p3 })):andThen(function(p6) -- line: 39
							-- upvalues: FetchGamesProductInfo (copy), p3 (copy), Promise (copy), v17 (copy)
							local v19, _ = p6[FetchGamesProductInfo.KeyMapper(p3)]:unwrap()

							if v19 then
								return Promise.resolve(v17.playabilityStatus)
							end

							return Promise.reject()
						end)
					end

					return Promise.resolve(v17.playabilityStatus)
				end

				return Promise.reject()
			end)
		end)
	end,
	GetFetchingStatus = function(p7, p8) -- line: 59
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p7, "luaapp.playability-and-productinfo." .. p8)
	end
}
