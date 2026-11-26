local IXPService = game:GetService("IXPService")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/IxpUtils/ArgCheck")
local symbol = require("@game/CorePackages/Workspace/Packages/_Workspace/IxpUtils/AppCommonLib").Symbol
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/IxpUtils/Dash")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IxpUtils/React")
local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/IxpUtils/RoactAppExperiment")
local useUserExperiment = RoactAppExperiment.useUserExperiment
local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/IxpUtils/ExperimentCacheManager").ExperimentCacheManager
local fFlagAXLegacyIXPExposureLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/IxpUtils/SharedFlags").FFlagAXLegacyIXPExposureLogging

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/IxpUtils/AppDebug").LogTree.logger("ax.ixp")

local named = symbol.named("NO_VALUE")

local v5 = IXPService
local v6 = RoactAppExperiment.connectUserLayer
local v7 = experimentCacheManager.default

local v8 = {}

function v8.defineIXPTest(data)
	local result = {
		name = data.name,
		layer = data.layer,
		recordExposure = 0,
		logExposureEnabled = 0,
		getIsUserInExperiment = 0,
		isEnabled = 0,
		isEnabledForAll = 0
	}

	local v9 = if data.recordExposure then data.recordExposure else false
	result.recordExposure = v9

	local v10 = if fFlagAXLegacyIXPExposureLogging then data.logExposureEnabled else nil
	result.logExposureEnabled = v10

	result.getIsUserInExperiment = data.getIsUserInExperiment

	function result.isEnabled()
		return data.getDependentFlagsEnabled() and (data.getEnabledFlag() or data.getEnabledForAllFlag())
	end

	function result.isEnabledForAll()
		return data.getDependentFlagsEnabled() and data.getEnabledForAllFlag()
	end

	logger:info(
		"[Define IXP Test] {}, layer: {}, isEnabled: {}, isEnabledForAll: {}",
		result.name,
		result.layer,
		result.isEnabled(),
		result.isEnabledForAll()
	)

	for k, variable in data.variables do
		result[k] = {
			name = k,
			ixpTest = result,
			mapLayerToValue = variable,
			lastValue = named
		}
	end

	return result
end

local function readLayerVariablesForTest(state)
	state.usedExperimentCacheManager = state.usedExperimentCacheManager
		or v5:GetUserStatusForLayer(state.layer) ~= Enum.IXPLoadingStatus.Initialized

	return (if state.usedExperimentCacheManager then v7:getLayerVariables(state.layer) else v5:GetUserLayerVariables(state.layer))
		or {}
end

local function mapTestVariable(state, p2)
	local ixpTest = state.ixpTest

	local v9 = p2 or readLayerVariablesForTest(ixpTest)

	local mapLayerToValue = state.mapLayerToValue(v9, ixpTest.isEnabledForAll())

	if mapLayerToValue ~= state.lastValue then
		logger:info("[Read IXP Variable] {} {} = {}", ixpTest.name, state.name, mapLayerToValue)
		state.lastValue = mapLayerToValue
	end

	return mapLayerToValue
end

local function accessLayer(p2, p3)
	if p2.usedExperimentCacheManager then
		return nil
	end

	return p3[p2.layer]
end

local function doConnectTestVariables(items, keys, p2)
	return v6(keys, function(p3)
		local result = {}

		for k, item in items do
			local ixpTest = item.ixpTest

			if not ixpTest.isEnabled() then
				continue
			end

			local v9 = if not ixpTest.usedExperimentCacheManager then p3[ixpTest.layer] else nil

			result[k] = mapTestVariable(item, v9)
		end

		return result
	end, p2)
end

function v8.connectTestVariables(items)
	local layerSet = {}

	local v9 = {}
	local layerSet2 = {}

	local v10 = {}

	for k, item in items do
		local ixpTest = item.ixpTest

		if ixpTest.recordExposure then
			layerSet[ixpTest.layer] = true
			v9[k] = item
		else
			layerSet2[ixpTest.layer] = true
			v10[k] = item
		end
	end

	local v11 = {}

	local keys = Dash.keys(layerSet2)

	if #keys > 0 then
		table.sort(keys)
		table.insert(v11, doConnectTestVariables(v10, keys, false))
	end

	local keys2 = Dash.keys(layerSet)

	if #keys2 > 0 then
		table.sort(keys2)
		table.insert(v11, doConnectTestVariables(v9, keys2, true))
	end

	return Dash.pipe(table.unpack(v11))
end

function v8.useTestVariables(...)
	local v9 = { ... }
	local ixpTest = nil

	for k, v10 in v9 do
		if ixpTest then
			ArgCheck.assert(
				v10.ixpTest == ixpTest,
				"All test variables passed to IXPUtils.useTestVariables must belong to same IXP test."
			)
		else
			ixpTest = v10.ixpTest
		end
	end

	return useUserExperiment({ ixpTest.layer }, function(p2)
		local v10 = ixpTest
		local v11 = if not v10.usedExperimentCacheManager then p2[v10.layer] else nil

		local v12 = {}

		for k, v13 in v9 do
			if ixpTest.isEnabled() then
				v12[k] = mapTestVariable(v13, v11)
			end
		end

		return table.unpack(v12)
	end, ixpTest.recordExposure)
end

local function readTestVariableImpl(p2, p3)
	local ixpTest = p2.ixpTest

	if not ixpTest.isEnabled() then
		return nil
	end

	local v9 = if p3 then p3[ixpTest.layer] else nil
	return mapTestVariable(p2, v9)
end

function v8:readTestVariable()
	if not self.ixpTest.isEnabled() then
		return nil
	end

	local ixpTest = self.ixpTest

	local v9 = nil or readLayerVariablesForTest(ixpTest)

	local mapLayerToValue = self.mapLayerToValue(v9, ixpTest.isEnabledForAll())

	if mapLayerToValue ~= self.lastValue then
		logger:info("[Read IXP Variable] {} {} = {}", ixpTest.name, self.name, mapLayerToValue)
		self.lastValue = mapLayerToValue
	end

	return mapLayerToValue
end

function v8.getFromLayers(p2, p3)
	local ixpTest = p3.ixpTest

	if not ixpTest.isEnabled() then
		return nil
	end

	local v9 = if p2 then p2[ixpTest.layer] else nil
	return mapTestVariable(p3, v9)
end

function v8.logExposure(p2)
	logger:debug("LogUserLayerExposure: {}", p2.layer)
	v5:LogUserLayerExposure(p2.layer)
end

function v8.logLayerExposure(p2)
	logger:debug("LogLayerExposure: {}", p2)
	v5:LogUserLayerExposure(p2)
end

function v8.logExperimentExposure(data): boolean
	logger:debug("LogExperimentExposure: {}", data.layer)

	if
		data.isEnabled()
		and data.getIsUserInExperiment
		and data.getIsUserInExperiment(readLayerVariablesForTest(data))
	then
		v5:LogUserLayerExposure(data.layer)
		return true
	end

	return false
end

function v8.useLogExposureOnce(p2)
	local ref = React.useRef(false)

	return React.useCallback(function()
		if not ref.current then
			v8.logExposure(p2)
			ref.current = true
		end
	end, { p2.layer })
end

function v8.setMocksForTesting(p2, p3, p4)
	v5 = p2 or v5
	v6 = p3 or v6
	v7 = p4 or v7
end

function v8.restoreDefaultsAfterTesting()
	v5 = IXPService
	v6 = RoactAppExperiment.connectUserLayer
	v7 = experimentCacheManager.default
end

return v8
