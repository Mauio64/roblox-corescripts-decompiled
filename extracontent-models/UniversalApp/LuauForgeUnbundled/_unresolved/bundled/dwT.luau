local gameSortGroups = require("@luauforge/bundled/dtp").GameSortGroups
local module = require("@luauforge/bundled/dtg")
local retrievalStatus = require("@luauforge/bundled/dus").Enum.RetrievalStatus
local appPage = require("@luauforge/bundled/dup").AppPage
local callOnce = require("@luauforge/bundled/dua").callOnce
local memStorageKeys = require("@luauforge/bundled/dup").MemStorageKeys
local fFlagUseSignalsForStartup = require("@luauforge/bundled/dtD").FFlagUseSignalsForStartup

local getStartupStore = if fFlagUseSignalsForStartup then require("@luauforge/bundled/dwS").GetStartupStore else nil

local v5 = if fFlagUseSignalsForStartup then require("@luauforge/bundled/dwU") else nil

local module2 = require("@luauforge/bundled/duq")
local module3 = require("@luauforge/bundled/dwE")
local module4 = require("@luauforge/bundled/dvE")
local module5 = require("@luauforge/bundled/dwx")
local module6 = require("@luauforge/bundled/dwt")

local module7 = require("@luauforge/bundled/dwV")
local module8 = require("@luauforge/bundled/dwX")
local module9 = require("@luauforge/bundled/dxW")
local module10 = require("@luauforge/bundled/dwi")

local fVariable = settings():GetFVariable("LuaAppsDiagPageLoadTimeHome")

local function fetchHomePageData(p2, p3, p4, p5, object, p6, object2, object3, p7, p8, p9)
	local v6 = if fFlagUseSignalsForStartup then getStartupStore(false) else nil
	local v7

	if fFlagUseSignalsForStartup then
		v7 = v6.getHomePageDataStatus(false)
	else
		v7 = object:getState().Startup.HomePageDataStatus
	end

	if v7 == retrievalStatus.Fetching then
		return module.resolve("home page data is already fetching")
	end

	if object2 then
		object2:logEvent("fetch_homepage_data_begin")
	end

	local lastTime = tick()

	if fFlagUseSignalsForStartup then
		v5.batch(function()
			v6.setHomePageDataStatus(retrievalStatus.Fetching)
			v6.setFetchHomePageDataStatusAll(retrievalStatus.Fetching)
		end)
	else
		object:dispatch(module5(retrievalStatus.Fetching))
		object:dispatch(module6(retrievalStatus.Fetching))
	end

	if module10() then
		object:dispatch(module7(p2))
	end

	local fn = p6 and function()
		local v8 = if object3 then object3:popPendingPrefetchGuid() else nil

		return object:dispatch(module2(p2, p3, appPage.Home, nil, v8, p7, object2, true))
	end or function()
		return object:dispatch(module4(p2, gameSortGroups.HomeGames, nil))
	end

	if not p9 then
		object:dispatch(module8(p2, p5))
	end

	if p6 then
		return fn():andThen(function(p10)
			local v8, v9 = module9()

			if v8 then
				callOnce(memStorageKeys.PerfRegressionTestTTI, function()
					if v9 ~= 0 then
						task.wait(v9)
					end
				end)
			end

			if fFlagUseSignalsForStartup then
				v5.batch(function()
					v6.setHomePageDataStatus(retrievalStatus.Done)
					v6.setFetchHomePageDataStatusAll(retrievalStatus.Done)
				end)
			else
				object:dispatch(module5(retrievalStatus.Done))
				object:dispatch(module6(retrievalStatus.Done))
			end

			local v10 = (tick() - lastTime) * 1000
			p4.Diag:reportStats(fVariable, v10)

			if object2 then
				object2:logEvent("fetch_homepage_data_end")
			end
		end, function(p10)
			if fFlagUseSignalsForStartup then
				v5.batch(function()
					v6.setHomePageDataStatus(retrievalStatus.Failed)
					v6.setFetchHomePageDataStatusAll(retrievalStatus.Failed)
				end)
			else
				object:dispatch(module5(retrievalStatus.Failed))
				object:dispatch(module6(retrievalStatus.Failed))
			end

			if object2 then
				object2:logEvent("fetch_homepage_data_error")
			end
		end)
	end

	return fn():andThen(function(p10)
		if fFlagUseSignalsForStartup then
			v6.setHomePageDataStatus(retrievalStatus.Done)
		else
			object:dispatch(module5(retrievalStatus.Done))
		end

		local v8 = { object:dispatch(module3(p2, gameSortGroups.HomeGames)) }

		return module.all(v8)
	end, function(p10)
		if fFlagUseSignalsForStartup then
			v6.setHomePageDataStatus(retrievalStatus.Failed)
		else
			object:dispatch(module5(retrievalStatus.Failed))
		end

		return module.reject(p10)
	end):andThen(function(p10)
		local v9 = (if fFlagUseSignalsForStartup then v6.getHomePageDataStatus(false) else object:getState().Startup.HomePageDataStatus) == retrievalStatus.Failed

		if fFlagUseSignalsForStartup then
			v6.setFetchHomePageDataStatusAll(v9 and retrievalStatus.Failed or retrievalStatus.Done)
		else
			object:dispatch(module6(v9 and retrievalStatus.Failed or retrievalStatus.Done))
		end

		local v10 = (tick() - lastTime) * 1000
		p4.Diag:reportStats(fVariable, v10)

		if object2 then
			object2:logEvent("fetch_homepage_data_end")
		end
	end, function(p10)
		if fFlagUseSignalsForStartup then
			v6.setFetchHomePageDataStatusAll(retrievalStatus.Failed)
		else
			object:dispatch(module6(retrievalStatus.Failed))
		end

		if object2 then
			object2:logEvent("fetch_homepage_data_error")
		end
	end)
end

return function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11)
	return function(p12)
		return fetchHomePageData(p2, p3, p4, p5, p12, p6, p7, p8, p9, p10, p11)
	end
end
