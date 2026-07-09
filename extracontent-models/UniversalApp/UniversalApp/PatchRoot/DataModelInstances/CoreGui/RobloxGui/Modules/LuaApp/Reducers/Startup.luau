local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules2 = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local HomePageDataStatus = Modules2.LuaApp.Reducers.HomePageDataStatus
local FetchHomePageDataStatusAll = Modules2.LuaApp.Reducers.FetchHomePageDataStatusAll
local GamesPageDataStatus = Modules2.LuaApp.Reducers.GamesPageDataStatus
local SetPreloading = require(Modules.LuaApp.Actions.SetPreloading)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local FFlagLuaAppChartsResetFetchingStatusOnFilterChange = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppChartsResetFetchingStatusOnFilterChange

local function isRetrievalStatus(p1) -- line: 17
	-- upvalues: RetrievalStatus (copy)
	return p1 == RetrievalStatus.NotStarted or (p1 == RetrievalStatus.Fetching or (p1 == RetrievalStatus.Failed or p1 == RetrievalStatus.Done))
end
local function joinRetrievalStatus(p2, p3) -- line: 24
	-- upvalues: RetrievalStatus (copy)
	if p2 ~= RetrievalStatus.NotStarted and (p2 ~= RetrievalStatus.Fetching and (p2 ~= RetrievalStatus.Failed and p2 ~= RetrievalStatus.Done)) then
		p2 = nil
	end

	if p3 ~= RetrievalStatus.NotStarted and (p3 ~= RetrievalStatus.Fetching and (p3 ~= RetrievalStatus.Failed and p3 ~= RetrievalStatus.Done)) then
		p3 = nil
	end

	if p2 == nil then
		return p3
	end

	if p3 == nil then
		return p2
	end

	if p2 == RetrievalStatus.Failed or p3 == RetrievalStatus.Failed then
		return RetrievalStatus.Failed
	end

	if p2 == RetrievalStatus.NotStarted and p3 == RetrievalStatus.NotStarted then
		return RetrievalStatus.NotStarted
	end

	if p2 == RetrievalStatus.Done and p3 == RetrievalStatus.Done then
		return RetrievalStatus.Done
	end

	return RetrievalStatus.Fetching
end

return function(p4, p5) -- line: 49
	-- upvalues: GamesPageDataStatus (copy), HomePageDataStatus (copy), FetchHomePageDataStatusAll (copy), SetPreloading (copy), Cryo (copy), FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), joinRetrievalStatus (copy)
	local v18 = p4 or {}
	local v19 = GamesPageDataStatus(v18.GamesPageDataStatus, p5)
	local v20 = HomePageDataStatus(v18.HomePageDataStatus, p5)
	local v21 = FetchHomePageDataStatusAll(v18.FetchHomePageDataStatusAll, p5)
	local v22 = v18.Preloading == nil or v18.Preloading

	if p5.type == SetPreloading.name then
		v22 = p5.isPreloading
	end

	local v23 = Cryo.List.foldLeft({
		if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then v19 else v19.status,
		v20,
		v21
	}, joinRetrievalStatus)

	return {
		GamesPageDataStatus = v19,
		HomePageDataStatus = v20,
		FetchHomePageDataStatusAll = v21,
		Preloading = v22,
		AppDataStatus = v23
	}
end
