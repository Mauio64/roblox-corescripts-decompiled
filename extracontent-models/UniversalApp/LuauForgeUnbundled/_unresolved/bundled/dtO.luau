local gameSortGroups = require("@luauforge/bundled/dqn").GameSortGroups
local module = require("@luauforge/bundled/dqe")
local retrievalStatus = require("@luauforge/bundled/drq").Enum.RetrievalStatus

local module2 = require("@luauforge/bundled/dsC")
local module3 = require("@luauforge/bundled/dtt")

local fFlagUseSignalsForStartup = require("@luauforge/bundled/dqB").FFlagUseSignalsForStartup

local getStartupStore = if fFlagUseSignalsForStartup then require("@luauforge/bundled/dtP").GetStartupStore else nil

local fVariable = settings():GetFVariable("LuaAppsDiagPageLoadTimeGames")

return function(p2, p3, p4, p5, p6)
	return function(object)
		local v5

		if fFlagUseSignalsForStartup then
			v5 = getStartupStore(false).getGamesPageDataStatus(false)
		else
			v5 = object:getState().Startup.GamesPageDataStatus
		end

		if v5.status == retrievalStatus.Fetching then
			return module.resolve("games page data is already fetching")
		end

		local lastTime = tick()

		if fFlagUseSignalsForStartup then
			getStartupStore(false).setGamesPageDataStatus(retrievalStatus.Fetching, p6)
		else
			object:dispatch(module3(retrievalStatus.Fetching, p6))
		end

		return object:dispatch(module2(p2, gameSortGroups.Games, p4, p5)):andThen(function()
			if fFlagUseSignalsForStartup then
				getStartupStore(false).setGamesPageDataStatus(retrievalStatus.Done, p6)
			else
				object:dispatch(module3(retrievalStatus.Done, p6))
			end

			if not p4 or p4 == "" then
				local v6 = (tick() - lastTime) * 1000

				p3.Diag:reportStats(fVariable, v6)
			end

			return module.resolve()
		end, function(p7)
			if fFlagUseSignalsForStartup then
				getStartupStore(false).setGamesPageDataStatus(retrievalStatus.Failed, p6)
			else
				object:dispatch(module3(retrievalStatus.Failed, p6))
			end

			return module.reject(p7)
		end)
	end
end
