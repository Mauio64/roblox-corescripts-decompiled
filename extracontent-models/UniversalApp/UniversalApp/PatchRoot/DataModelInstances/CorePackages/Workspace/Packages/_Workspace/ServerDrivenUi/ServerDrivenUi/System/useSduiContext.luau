local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local CollectionItemSize = require(ServerDrivenUiParent.CollectionViews).CollectionViewTypes.CollectionItemSize
local Signals = require(ServerDrivenUiParent.Signals)
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiComponentDefinitions = require(ServerDrivenUi.System.SduiComponentDefinitions)
local SduiInstrumentation = SduiCoreSystem.SduiInstrumentation
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiTemplateRegistry = SduiCoreSystem.SduiTemplateRegistry
local SduiUsageRecorder = SduiCoreSystem.SduiUsageRecorder
local recordV1RegisteredTemplates = SduiCoreSystem.recordV1RegisteredTemplates
local useSduiDataStore = require(ServerDrivenUi.DataStore.useSduiDataStore)
local SduiErrors = SduiCoreSystem.SduiErrors
local FFlagLuaAppLayoutParamsInContext = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppLayoutParamsInContext
local FFlagSduiUsageTelemetry = require(ServerDrivenUiParent.SharedFlags).FFlagSduiUsageTelemetry
local t1 = {
	numColumns = 3,
	fractionalItemAmount = 0,
	columnGap = 24,
	sideMargin = 24,
	verticalPadding = 16
}
local useSduiDependencies = require(ServerDrivenUi.System.useSduiDependencies)

local function useSduiContext(t2: {[any]: any}) -- line: 59
	-- upvalues: React (copy), SduiInstrumentation (copy), useSduiDependencies (copy), SduiComponentDefinitions (copy), SduiTemplateRegistry (copy), FFlagSduiUsageTelemetry (copy), recordV1RegisteredTemplates (copy), SduiUsageRecorder (copy), useSduiDataStore (copy), FFlagLuaAppLayoutParamsInContext (copy), Signals (copy), t1 (copy), CollectionItemSize (copy), SduiLogger (copy), SduiErrors (copy)
	local v21 = React.useMemo(function() -- line: 60
		-- upvalues: SduiInstrumentation (copy)
		return SduiInstrumentation.new()
	end, {})

	v21:startTimerFlow("useSduiContext")

	local v22 = useSduiDependencies(v21)
	local v23 = React.useMemo(function() -- line: 69
		-- upvalues: t2 (copy), SduiComponentDefinitions (copy)
		return t2.componentDefinitions or SduiComponentDefinitions.new()
	end, { t2.componentDefinitions })
	local v24 = React.useMemo(function() -- line: 73
		-- upvalues: SduiTemplateRegistry (copy), t2 (copy)
		return SduiTemplateRegistry.new(t2.templates)
	end, { t2.templates })

	if FFlagSduiUsageTelemetry then
		React.useEffect(function() -- line: 81
			-- upvalues: recordV1RegisteredTemplates (copy), t2 (copy), SduiUsageRecorder (copy)
			recordV1RegisteredTemplates(t2.appPage, t2.templates)
			SduiUsageRecorder.scheduleFlush()
		end, {
			t2.appPage,
			t2.templates
		})
	end

	local v25 = useSduiDataStore()
	local u26 = nil

	if FFlagLuaAppLayoutParamsInContext then
		local v27 = React.useMemo(function() -- line: 91
			-- upvalues: Signals (copy), t1 (copy)
			return Signals.createSignal(t1)
		end, {})

		u26 = React.useCallback(function(p1) -- line: 95
			-- upvalues: Signals (copy), t2 (copy), CollectionItemSize (copy), SduiLogger (copy), SduiErrors (copy), v27 (copy)
			return Signals.createComputed(function(p2) -- line: 96
				-- upvalues: t2 (copy), p1 (copy), CollectionItemSize (copy), SduiLogger (copy), SduiErrors (copy), v27 (copy)
				if t2.pageLayoutConfig then
					return (t2.pageLayoutConfig[p1] or t2.pageLayoutConfig[CollectionItemSize.Small])(p2)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.NoPageLayoutConfig, {
					message = `No page layout config available for { t2.appPage }, returning default config`
				}, t2.appPage)

				return (v27(p2))
			end)
		end, { t2.pageLayoutConfig })
	end

	local v28 = React.useMemo(function() -- line: 113
		-- upvalues: v22 (copy), t2 (copy), v23 (copy), v24 (copy), v25 (copy), FFlagLuaAppLayoutParamsInContext (copy), u26 (ref)
		local t3 = {
			dependencies = v22,
			appPage = t2.appPage,
			dataUpdatedTimestamp = t2.dataUpdatedTimestamp,
			componentDefinitions = v23,
			templateRegistry = v24,
			dataStore = v25,
			getPageLayoutConfig = if not FFlagLuaAppLayoutParamsInContext then nil else u26
		}

		setmetatable(t3, {
			__tostring = function() -- line: 125
				return "SduiContext"
			end
		})

		return t3
	end, {
		v22,
		t2.appPage,
		t2.dataUpdatedTimestamp,
		v23,
		v24,
		v25,
		if not FFlagLuaAppLayoutParamsInContext then nil else u26
	})

	v21:stopTimerFlow("useSduiContext", v28)

	return v28
end

return useSduiContext
