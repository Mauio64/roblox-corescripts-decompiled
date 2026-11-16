local module = require("@luauforge/bundled/drY")
local retrievalStatus = require("@luauforge/bundled/drq").Enum.RetrievalStatus
local useRoactService = require("@luauforge/bundled/dsp").useRoactService
local roactNetworking = require("@luauforge/bundled/drk").RoactNetworking
local appLogging = require("@luauforge/bundled/drk").AppLogging
local useDispatch = require("@luauforge/bundled/dsv").Hooks.RoactRodux.useDispatch
local module2 = require("@luauforge/bundled/dqn")
local DEFAULT_GAME_FETCH_COUNT = module2.Constants.DEFAULT_GAME_FETCH_COUNT
local reportWarning = require("@luauforge/bundled/dqo").Points.reportWarning

local module3 = require("@luauforge/bundled/dtM")
local module4 = require("@luauforge/bundled/dtD")

local module5 = require("@luauforge/bundled/dtG")

local fFlagLuaAppLogOmniRecommendationsMetadata = require("@luauforge/bundled/dqB").FFlagLuaAppLogOmniRecommendationsMetadata

local function useLoadMoreGames(data, object, p2, p3, p4)
	local v5 = if data then data.hasMoreRows or false else false
	local v6 = p2 == retrievalStatus.Fetching
	local v7 = v5 and not v6
	local v8 = useRoactService(roactNetworking)
	local v9 = useRoactService(appLogging)

	local v10 = useDispatch()

	return (module.useCallback(function()
		if not v7 or (data == nil or object == nil) then
			return
		end

		if object:isOmni() then
			return v10(module3(module5(
				v8,
				p3,
				p4,
				DEFAULT_GAME_FETCH_COUNT,
				v9,
				fFlagLuaAppLogOmniRecommendationsMetadata and "useLoadMoreGames" or nil
			)))
		end

		if object.dataSource == module2.DataSourceType.ExploreApi then
			return v10(module3(module4(v8, object, true, {
				startRows = data.rowsRequested,
				maxRows = DEFAULT_GAME_FETCH_COUNT,
				exclusiveStartId = data.nextPageExclusiveStartId,
				pageToken = data.nextPageToken
			})))
		end

		reportWarning(
			v9,
			"DataFetch",
			`Tried to fetch more games for unsupported API. sort: {object.name}, API: {object.dataSource}`
		)
	end, { v7, v8, v10, p3, object, data, p4, v9 }))
end

return useLoadMoreGames
