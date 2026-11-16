local IXPService = game:GetService("IXPService")

local parent = script.Parent.Parent

local ArgCheck = require(parent.ArgCheck)
local AppCommonLib = require(parent.AppCommonLib)
local Symbol = AppCommonLib.Symbol
local Dash = require(parent.Dash)
local React = require(parent.React)
local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager
local SharedFlags = require(parent.SharedFlags)
local FFlagAXLegacyIXPExposureLogging = SharedFlags.FFlagAXLegacyIXPExposureLogging

local AppDebug = require(parent.AppDebug)
local logger = AppDebug.LogTree.logger("ax.ixp")

local named = Symbol.named("NO_VALUE")

local v = IXPService
local v2 = RoactAppExperiment.connectUserLayer
local v3 = experimentCacheManager.default

local IXPUtils = {}

function IXPUtils.defineIXPTest(data)
	local result = {
		name = data.name,
		layer = data.layer,
		recordExposure = 0,
		logExposureEnabled = 0,
		getIsUserInExperiment = 0,
		isEnabled = 0,
		isEnabledForAll = 0
	}
	local recordExposure

	if data.recordExposure then
		recordExposure = data.recordExposure
	else
		recordExposure = false
	end

	result.recordExposure = recordExposure
	local logExposureEnabled

	if FFlagAXLegacyIXPExposureLogging then
		logExposureEnabled = data.logExposureEnabled
	end

	result.logExposureEnabled = logExposureEnabled

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
		result[k] = { name = k, ixpTest = result, mapLayerToValue = variable, lastValue = named }
	end

	return result
end

local function readLayerVariablesForTest(state)
	state.usedExperimentCacheManager = state.usedExperimentCacheManager
		or v:GetUserStatusForLayer(state.layer) ~= Enum.IXPLoadingStatus.Initialized
	local v4

	if state.usedExperimentCacheManager then
		v4 = v3:getLayerVariables(state.layer)
	else
		v4 = v:GetUserLayerVariables(state.layer)
	end

	return v4 or {}
end

local function mapTestVariable(state, p) -- 1 equivalent call inferred from this helper
	local ixpTest = state.ixpTest

	local v4 = p or readLayerVariablesForTest(ixpTest)

	local mapLayerToValue = state.mapLayerToValue(v4, ixpTest.isEnabledForAll())

	if mapLayerToValue ~= state.lastValue then
		logger:info("[Read IXP Variable] {} {} = {}", ixpTest.name, state.name, mapLayerToValue)
		state.lastValue = mapLayerToValue
	end

	return mapLayerToValue
end

local function accessLayer(ixpTest, p) -- 2 equivalent calls inferred from this helper
	if ixpTest.usedExperimentCacheManager then
		return nil
	end

	return p[ixpTest.layer]
end

local function doConnectTestVariables(items, keys, flag: boolean)
	return v2(keys, function(p)
		local result = {}

		for k, item in items do
			local ixpTest = item.ixpTest

			if ixpTest.isEnabled() then
				result[k] = mapTestVariable(item, accessLayer(ixpTest, p)) -- inferred equivalent call
			end
		end

		return result
	end, flag)
end

function IXPUtils.connectTestVariables(items)
	local layerSet = {}

	local v4 = {}
	local layerSet2 = {}

	local v5 = {}

	for k, item in items do
		local ixpTest = item.ixpTest

		if ixpTest.recordExposure then
			layerSet[ixpTest.layer] = true
			v4[k] = item
		else
			layerSet2[ixpTest.layer] = true
			v5[k] = item
		end
	end

	local v6 = {}

	local keys = Dash.keys(layerSet2)

	if #keys > 0 then
		table.sort(keys)
		table.insert(v6, doConnectTestVariables(v5, keys, false))
	end

	local keys2 = Dash.keys(layerSet)

	if #keys2 > 0 then
		table.sort(keys2)
		table.insert(v6, doConnectTestVariables(v4, keys2, true))
	end

	return Dash.pipe(table.unpack(v6))
end

function IXPUtils.useTestVariables(...)
	local v4 = { ... }
	local ixpTest = nil

	for _, v5 in v4 do
		if ixpTest then
			ArgCheck.assert(
				v5.ixpTest == ixpTest,
				"All test variables passed to IXPUtils.useTestVariables must belong to same IXP test."
			)
		else
			ixpTest = v5.ixpTest
		end
	end

	return useUserExperiment({ ixpTest.layer }, function(p)
		local v5 = accessLayer(ixpTest, p) -- inferred equivalent call
		local v6 = {}

		for k, v7 in v4 do
			if ixpTest.isEnabled() then
				v6[k] = mapTestVariable(v7, v5)
			end
		end

		return table.unpack(v6)
	end, ixpTest.recordExposure)
end

local function readTestVariableImpl(callback, p) -- 1 equivalent call inferred from this helper
	local ixpTest = callback.ixpTest

	if not ixpTest.isEnabled() then
		return nil
	end

	local v4

	if p then
		v4 = p[ixpTest.layer]
	end

	return mapTestVariable(callback, v4)
end

function IXPUtils.readTestVariable(state)
	if not state.ixpTest.isEnabled() then
		return nil
	end

	return mapTestVariable(state) -- inferred equivalent call
end

function IXPUtils.getFromLayers(p, callback)
	return readTestVariableImpl(callback, p) -- inferred equivalent call
end

function IXPUtils.logExposure(p)
	logger:debug("LogUserLayerExposure: {}", p.layer)
	v:LogUserLayerExposure(p.layer)
end

function IXPUtils.logLayerExposure(p: string)
	logger:debug("LogLayerExposure: {}", p)
	v:LogUserLayerExposure(p)
end

function IXPUtils.logExperimentExposure(data): boolean
	logger:debug("LogExperimentExposure: {}", data.layer)

	if
		data.isEnabled()
		and data.getIsUserInExperiment
		and data.getIsUserInExperiment(readLayerVariablesForTest(data))
	then
		v:LogUserLayerExposure(data.layer)
		return true
	end

	return false
end

function IXPUtils.useLogExposureOnce(p)
	local ref = React.useRef(false)

	return React.useCallback(function()
		if not ref.current then
			IXPUtils.logExposure(p)
			ref.current = true
		end
	end, { p.layer })
end

function IXPUtils.setMocksForTesting(p, p2, p3)
	v = p or v
	v2 = p2 or v2
	v3 = p3 or v3
end

function IXPUtils.restoreDefaultsAfterTesting()
	v = IXPService
	v2 = RoactAppExperiment.connectUserLayer
	v3 = experimentCacheManager.default
end

return IXPUtils
