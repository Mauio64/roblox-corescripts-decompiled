local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/Promise")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SduiSharedUtilities")
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope

local ChartsSortDetailScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/ChartsSortDetailScopeFields")

local function canStartGenreRefresh(p2): boolean
	return not getSduiApiStore().isInFlight(p2)
end

local function finishRefresh(p2, p3)
	local sduiClientPageScope = getSduiClientPageScope(p2)

	if p3 then
		local v5 = sduiClientPageScope.get(ChartsSortDetailScopeFields.DesiredGenre)
		sduiClientPageScope.set(ChartsSortDetailScopeFields.SafeGenre, v5)
	else
		local v5 = sduiClientPageScope.get(ChartsSortDetailScopeFields.SafeGenre)
		sduiClientPageScope.set(ChartsSortDetailScopeFields.DesiredGenre, v5)
	end
end

local function settleGenreRefresh(configKey, p2)
	if typeof(p2) ~= "table" then
		return Promise.reject("ChartsSortDetail genre refresh non-table result")
	end

	local sduiClientPageScope = getSduiClientPageScope(configKey)

	local v5 = sduiClientPageScope.get(ChartsSortDetailScopeFields.DesiredGenre)
	sduiClientPageScope.set(ChartsSortDetailScopeFields.SafeGenre, v5)

	return Promise.resolve(p2)
end

local function refreshChartsSortDetailGenre(data)
	local configKey = data.configKey
	local selectedGenre = data.selectedGenre

	if
		typeof(configKey) ~= "string"
		or configKey == ""
		or (typeof(selectedGenre) ~= "string" or selectedGenre == "")
	then
		return nil
	end

	if getSduiApiStore().isInFlight(configKey) then
		return nil
	end

	getSduiClientPageScope(configKey).set(ChartsSortDetailScopeFields.DesiredGenre, selectedGenre)

	return getSduiApiStore().refreshFromApi({
		configKey = configKey,
		loadTimer = data.loadTimer
	}):andThen(function(p2)
		return settleGenreRefresh(configKey, p2)
	end):catch(function(p2)
		local sduiClientPageScope = getSduiClientPageScope(configKey)

		local v5 = sduiClientPageScope.get(ChartsSortDetailScopeFields.SafeGenre)
		sduiClientPageScope.set(ChartsSortDetailScopeFields.DesiredGenre, v5)

		return Promise.reject(p2)
	end)
end

return refreshChartsSortDetailGenre
