local Charts = script:FindFirstAncestor("Charts")
local parent = Charts.Parent

local Promise = require(parent.Promise)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope

local ChartsSortDetailScopeFields = require(Charts.ChartsSortDetailPage.ChartsSortDetailScopeFields)

local function canStartGenreRefresh(p: string): boolean
	return not getSduiApiStore().isInFlight(p)
end

local function finishRefresh(p: string, flag: boolean) -- 2 equivalent calls inferred from this helper
	local sduiClientPageScope = getSduiClientPageScope(p)

	if flag then
		local v = sduiClientPageScope.get(ChartsSortDetailScopeFields.DesiredGenre)
		sduiClientPageScope.set(ChartsSortDetailScopeFields.SafeGenre, v)
	else
		local v = sduiClientPageScope.get(ChartsSortDetailScopeFields.SafeGenre)
		sduiClientPageScope.set(ChartsSortDetailScopeFields.DesiredGenre, v)
	end
end

local function settleGenreRefresh(configKey: string, p)
	if typeof(p) ~= "table" then
		return Promise.reject("ChartsSortDetail genre refresh non-table result")
	end

	finishRefresh(configKey, true) -- inferred equivalent call
	return Promise.resolve(p)
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

	return getSduiApiStore().refreshFromApi({ configKey = configKey, loadTimer = data.loadTimer }):andThen(function(p)
		return settleGenreRefresh(configKey, p)
	end):catch(function(p)
		finishRefresh(configKey, false) -- inferred equivalent call
		return Promise.reject(p)
	end)
end

return refreshChartsSortDetailGenre
