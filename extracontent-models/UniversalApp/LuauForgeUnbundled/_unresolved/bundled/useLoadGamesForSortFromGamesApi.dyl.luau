local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dva")
local module2 = require("@luauforge/bundled/dtF")
local retrievalStatus = require("@luauforge/bundled/dus").Enum.RetrievalStatus
local useRoactService = require("@luauforge/bundled/dvr").useRoactService
local roactNetworking = require("@luauforge/bundled/dum").RoactNetworking
local useDispatch = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useDispatch
local useSelector = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useSelector
local topicInfosReducer = require("@luauforge/bundled/dtt").TopicInfosReducer
local gameSortGroups = require("@luauforge/bundled/dtp").GameSortGroups
local module3 = require("@luauforge/bundled/duu")
local fetchStatusReducer = module3.FetchStatusReducer
local fetchStatusNamespace = module3.FetchStatusNamespace
local setFetchStatus = module3.SetFetchStatus
local module4 = require("@luauforge/bundled/dvD")
local setNextDataExpirationTime = module4.SetNextDataExpirationTime
local expirationTimeNamespace = module4.ExpirationTimeNamespace

local module5 = require("@luauforge/bundled/dwF")

local function useLoadGamesForSortFromGamesApi(p2)
	local state, setState = module.useState(0)
	local v5 = useRoactService(roactNetworking)
	local v6 = useDispatch()
	local v7 = useSelector(function(p3)
		local v8 = p3.Personalization[topicInfosReducer.key][p2]

		if v8 and v8:isOmni() then
			v8 = nil
		end

		return {
			gamesApiGameSort = v8,
			gameSortFetchingStatus = p3.Personalization[fetchStatusReducer.key][fetchStatusNamespace.GameSorts][p2] or retrievalStatus.NotStarted
		}
	end, module2.shallowEqual)

	local gamesApiGameSort = v7.gamesApiGameSort
	local gameSortFetchingStatus = v7.gameSortFetchingStatus

	return (module.useCallback(function()
		if gamesApiGameSort == nil or gameSortFetchingStatus ~= retrievalStatus.NotStarted then
			return
		end

		assert(gamesApiGameSort, "gamesApiGameSort can never be nil")
		v6(module5(v5, gamesApiGameSort, false, nil)):catch(function(p3)
			if state > 2 then
				return
			end

			if p3 and p3.Body then
				local success, result = pcall(function()
					return HttpService:JSONDecode(p3.Body)
				end)

				if success and result and result.errors then
					for i, err in ipairs(result.errors) do
						if not (err.code == 400 and err.field == "sortToken") then
							continue
						end

						v6(setFetchStatus(
							fetchStatusNamespace.GameSorts,
							gamesApiGameSort.name,
							retrievalStatus.NotStarted
						))

						v6(setNextDataExpirationTime(
							gameSortGroups.Games,
							0,
							expirationTimeNamespace.GameSortGroup
						))

						setState(state + 1)
					end
				end
			end
		end)
	end, { gamesApiGameSort, gameSortFetchingStatus, state, v5, v6 }))
end

return useLoadGamesForSortFromGamesApi
