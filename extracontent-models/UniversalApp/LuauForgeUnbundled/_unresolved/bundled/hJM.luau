local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local modules = require("@luauforge/bundled/dpZ").Modules
local homePageDataStatus = modules.LuaApp.Reducers.HomePageDataStatus
local fetchHomePageDataStatusAll = modules.LuaApp.Reducers.FetchHomePageDataStatusAll
local gamesPageDataStatus = modules.LuaApp.Reducers.GamesPageDataStatus

local module = require("@luauforge/bundled/hJN")
local module2 = require("@luauforge/bundled/dxy")

local function isRetrievalStatus(p2): boolean
	return p2 == module2.NotStarted or p2 == module2.Fetching or p2 == module2.Failed or p2 == module2.Done
end

local function joinRetrievalStatus(p2, p3)
	if
		p2 ~= module2.NotStarted
		and p2 ~= module2.Fetching
		and p2 ~= module2.Failed
		and p2 ~= module2.Done
	then
		p2 = nil
	end

	if
		p3 ~= module2.NotStarted
		and p3 ~= module2.Fetching
		and p3 ~= module2.Failed
		and p3 ~= module2.Done
	then
		p3 = nil
	end

	if p2 == nil then
		return p3
	end

	if p3 == nil then
		return p2
	end

	if p2 == module2.Failed or p3 == module2.Failed then
		return module2.Failed
	end

	if p2 == module2.NotStarted and p3 == module2.NotStarted then
		return module2.NotStarted
	end

	if p2 == module2.Done and p3 == module2.Done then
		return module2.Done
	end

	return module2.Fetching
end

return function(options, p2)
	local v5 = options or {}

	local v6 = gamesPageDataStatus(v5.GamesPageDataStatus, p2)
	local v7 = homePageDataStatus(v5.HomePageDataStatus, p2)
	local v8 = fetchHomePageDataStatusAll(v5.FetchHomePageDataStatusAll, p2)

	local v9 = v5.Preloading == nil or v5.Preloading

	if p2.type == module.name then
		v9 = p2.isPreloading
	end

	return {
		GamesPageDataStatus = v6,
		HomePageDataStatus = v7,
		FetchHomePageDataStatusAll = v8,
		Preloading = v9,
		AppDataStatus = Cryo.List.foldLeft({ v6.status, v7, v8 }, joinRetrievalStatus)
	}
end
