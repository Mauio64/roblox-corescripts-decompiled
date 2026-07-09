local IXPService = game:GetService("IXPService")
local ParentParent = script.Parent.Parent
local ArgCheck = require(ParentParent.ArgCheck)
local Symbol = require(ParentParent.AppCommonLib).Symbol
local Dash = require(ParentParent.Dash)
local React = require(ParentParent.React)
local RoactAppExperiment = require(ParentParent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local ExperimentCacheManager = require(ParentParent.ExperimentCacheManager).ExperimentCacheManager
local FFlagAXLegacyIXPExposureLogging = require(ParentParent.SharedFlags).FFlagAXLegacyIXPExposureLogging
local v11 = require(ParentParent.AppDebug).LogTree.logger("ax.ixp")
local v12 = Symbol.named("NO_VALUE")
local u13 = IXPService
local connectUserLayer = RoactAppExperiment.connectUserLayer
local default = ExperimentCacheManager.default
local t3 = {
	defineIXPTest = function(t1: {[any]: any}) -- line: 210
		-- upvalues: FFlagAXLegacyIXPExposureLogging (copy), v11 (copy), v12 (copy)
		local t2 = {
			name = t1.name,
			layer = t1.layer,
			recordExposure = not not t1.recordExposure and t1.recordExposure,
			logExposureEnabled = if not FFlagAXLegacyIXPExposureLogging then nil else t1.logExposureEnabled,
			getIsUserInExperiment = t1.getIsUserInExperiment,
			isEnabled = function() -- line: 222
				-- upvalues: t1 (copy)
				return t1.getDependentFlagsEnabled() and (t1.getEnabledFlag() or t1.getEnabledForAllFlag())
			end,
			isEnabledForAll = function() -- line: 227
				-- upvalues: t1 (copy)
				return t1.getDependentFlagsEnabled() and t1.getEnabledForAllFlag()
			end
		}

		v11:info("[Define IXP Test] {}, layer: {}, isEnabled: {}, isEnabledForAll: {}", t2.name, t2.layer, t2.isEnabled(), t2.isEnabledForAll())

		for v24, v25 in t1.variables do
			t2[v24] = {
				name = v24,
				ixpTest = t2,
				mapLayerToValue = v25,
				lastValue = v12
			}
		end

		return t2
	end
}

local function readLayerVariablesForTest(p1) -- line: 254
	-- upvalues: u13 (ref), default (ref)
	p1.usedExperimentCacheManager = p1.usedExperimentCacheManager or u13:GetUserStatusForLayer(p1.layer) ~= Enum.IXPLoadingStatus.Initialized

	return ((if not p1.usedExperimentCacheManager then u13:GetUserLayerVariables(p1.layer) else default:getLayerVariables(p1.layer))) or {}
end
local function mapTestVariable(t4: {[any]: any}, p2) -- line: 265
	-- upvalues: readLayerVariablesForTest (copy), v11 (copy)
	local ixpTest = t4.ixpTest

	if not p2 then
		p2 = readLayerVariablesForTest(ixpTest)
	end

	local v30 = t4.mapLayerToValue(p2, ixpTest.isEnabledForAll())

	if v30 ~= t4.lastValue then
		v11:info("[Read IXP Variable] {} {} = {}", ixpTest.name, t4.name, v30)
		t4.lastValue = v30
	end

	return v30
end
local function accessLayer(p3, p4) -- line: 278
	if p3.usedExperimentCacheManager then
		return nil
	end

	return p4[p3.layer]
end
local function doConnectTestVariables(t5: {[any]: any}, t6: {[any]: any}, b1: boolean) -- line: 286
	-- upvalues: connectUserLayer (ref), mapTestVariable (copy)
	return connectUserLayer(t6, function(p5) -- line: 291
		-- upvalues: t5 (copy), mapTestVariable (copy)
		local t7 = {}

		for v73, v74 in t5 do
			local ixpTest = v74.ixpTest

			if ixpTest.isEnabled() then
				local v76 = if not ixpTest.usedExperimentCacheManager then p5[ixpTest.layer] else nil

				t7[v73] = mapTestVariable(v74, v76)
			end
		end

		return t7
	end, b1)
end

function t3.connectTestVariables(t8: {[any]: any}) -- line: 318
	-- upvalues: Dash (copy), doConnectTestVariables (copy)
	local t9 = {}
	local t10 = {}
	local t11 = {}
	local t12 = {}

	for v41, v42 in t8 do
		local ixpTest = v42.ixpTest

		if ixpTest.recordExposure then
			t10[ixpTest.layer] = true
			t12[v41] = v42
		else
			t9[ixpTest.layer] = true
			t11[v41] = v42
		end
	end

	local t13 = {}
	local v45 = Dash.keys(t9)

	if #v45 > 0 then
		table.sort(v45)
		table.insert(t13, doConnectTestVariables(t11, v45, false))
	end

	local v46 = Dash.keys(t10)

	if #v46 > 0 then
		table.sort(v46)
		table.insert(t13, doConnectTestVariables(t12, v46, true))
	end

	return Dash.pipe(table.unpack(t13))
end
function t3.useTestVariables(...) -- line: 360
	-- upvalues: ArgCheck (copy), useUserExperiment (copy), mapTestVariable (copy)
	local t14 = { ... }
	local ixpTest = nil

	for _, v50 in t14 do
		if ixpTest then
			ArgCheck.assert(v50.ixpTest == ixpTest, "All test variables passed to IXPUtils.useTestVariables must belong to same IXP test.")
		else
			ixpTest = v50.ixpTest
		end
	end

	return useUserExperiment({ ixpTest.layer }, function(p6) -- line: 374
		-- upvalues: ixpTest (ref), t14 (copy), mapTestVariable (copy)
		local v78 = ixpTest
		local v79 = if not v78.usedExperimentCacheManager then p6[v78.layer] else nil
		local t15 = {}

		for v81, v82 in t14 do
			if ixpTest.isEnabled() then
				t15[v81] = mapTestVariable(v82, v79)
			end
		end

		return table.unpack(t15)
	end, ixpTest.recordExposure)
end

local function readTestVariableImpl(p7, p8) -- line: 388
	-- upvalues: mapTestVariable (copy)
	local ixpTest = p7.ixpTest

	if not ixpTest.isEnabled() then
		return nil
	end

	local v54 = if not p8 then nil else p8[ixpTest.layer]

	return (mapTestVariable(p7, v54))
end

function t3.readTestVariable(p9) -- line: 403
	-- upvalues: readLayerVariablesForTest (copy), v11 (copy)
	if not p9.ixpTest.isEnabled() then
		return nil
	end

	local v56 = nil
	local ixpTest = p9.ixpTest

	if not v56 then
		v56 = readLayerVariablesForTest(ixpTest)
	end

	local v58 = p9.mapLayerToValue(v56, ixpTest.isEnabledForAll())

	if v58 ~= p9.lastValue then
		v11:info("[Read IXP Variable] {} {} = {}", ixpTest.name, p9.name, v58)
		p9.lastValue = v58
	end

	return v58
end
function t3.getFromLayers(t16: {[any]: any}, p10) -- line: 413
	-- upvalues: mapTestVariable (copy)
	local ixpTest = p10.ixpTest

	if not ixpTest.isEnabled() then
		return nil
	end

	local v62 = if not t16 then nil else t16[ixpTest.layer]

	return (mapTestVariable(p10, v62))
end
function t3.logExposure(p11) -- line: 417
	-- upvalues: v11 (copy), u13 (ref)
	v11:debug("LogUserLayerExposure: {}", p11.layer)
	u13:LogUserLayerExposure(p11.layer)
end
function t3.logLayerExposure(s1: string) -- line: 422
	-- upvalues: v11 (copy), u13 (ref)
	v11:debug("LogLayerExposure: {}", s1)
	u13:LogUserLayerExposure(s1)
end
function t3.logExperimentExposure(p12) -- line: 431
	-- upvalues: v11 (copy), readLayerVariablesForTest (copy), u13 (ref)
	v11:debug("LogExperimentExposure: {}", p12.layer)

	if p12.isEnabled() and (p12.getIsUserInExperiment and p12.getIsUserInExperiment((readLayerVariablesForTest(p12)))) then
		u13:LogUserLayerExposure(p12.layer)

		return true
	end

	return false
end
function t3.useLogExposureOnce(p13) -- line: 449
	-- upvalues: React (copy), t3 (copy)
	local v67 = React.useRef(false)

	return React.useCallback(function() -- line: 452
		-- upvalues: v67 (copy), t3 (copy), p13 (copy)
		if not v67.current then
			t3.logExposure(p13)
			v67.current = true
		end
	end, { p13.layer })
end
function t3.setMocksForTesting(p14, p15, p16) -- line: 460
	-- upvalues: u13 (ref), connectUserLayer (ref), default (ref)
	u13 = p14 or u13
	connectUserLayer = p15 or connectUserLayer
	default = p16 or default
end
function t3.restoreDefaultsAfterTesting() -- line: 466
	-- upvalues: u13 (ref), IXPService (copy), connectUserLayer (ref), RoactAppExperiment (copy), default (ref), ExperimentCacheManager (copy)
	u13 = IXPService
	connectUserLayer = RoactAppExperiment.connectUserLayer
	default = ExperimentCacheManager.default
end

return t3
