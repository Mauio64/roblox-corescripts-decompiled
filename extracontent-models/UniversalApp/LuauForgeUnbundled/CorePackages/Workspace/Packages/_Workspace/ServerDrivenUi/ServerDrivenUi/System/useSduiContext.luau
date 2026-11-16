local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")

local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews").CollectionViewTypes.CollectionItemSize
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local SduiComponentDefinitions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/SduiComponentDefinitions")
local sduiInstrumentation = SduiCoreSystem.SduiInstrumentation
local sduiLogger = SduiCoreSystem.SduiLogger
local sduiTemplateRegistry = SduiCoreSystem.SduiTemplateRegistry
local sduiUsageRecorder = SduiCoreSystem.SduiUsageRecorder
local recordV1RegisteredTemplates = SduiCoreSystem.recordV1RegisteredTemplates
local useSduiDataStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/useSduiDataStore")
local sduiErrors = SduiCoreSystem.SduiErrors

local fFlagLuaAppLayoutParamsInContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppLayoutParamsInContext

local v5 = {
	numColumns = 3,
	fractionalItemAmount = 0,
	columnGap = 24,
	sideMargin = 24,
	verticalPadding = 16
}

local useSduiDependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/useSduiDependencies")

local function useSduiContext(data)
	local v6 = React.useMemo(function()
		return sduiInstrumentation.new()
	end, {})
	v6:startTimerFlow("useSduiContext")

	local v7 = useSduiDependencies(v6)

	local v8 = React.useMemo(function()
		return data.componentDefinitions or SduiComponentDefinitions.new()
	end, { data.componentDefinitions })

	local v9 = React.useMemo(function()
		return sduiTemplateRegistry.new(data.templates)
	end, { data.templates })
	React.useEffect(function()
		recordV1RegisteredTemplates(data.appPage, data.templates)
		sduiUsageRecorder.scheduleFlush()
	end, { data.appPage, data.templates })

	local v10 = useSduiDataStore()
	local v11

	if fFlagLuaAppLayoutParamsInContext then
		local v12 = React.useMemo(function()
			return Signals.createSignal(v5)
		end, {})

		v11 = React.useCallback(function(p2)
			return Signals.createComputed(function(p3)
				if data.pageLayoutConfig then
					return (data.pageLayoutConfig[p2] or data.pageLayoutConfig[collectionItemSize.Small])(p3)
				end

				sduiLogger.reportError(
					sduiErrors.SduiErrorType.NoPageLayoutConfig,
					{
						message = `No page layout config available for {data.appPage}, returning default config`
					},
					data.appPage
				)

				return v12(p3)
			end)
		end, { data.pageLayoutConfig })
	else
		v11 = nil
	end

	local function fn()
		local v12 = {
			dependencies = v7,
			appPage = data.appPage,
			dataUpdatedTimestamp = data.dataUpdatedTimestamp,
			componentDefinitions = v8,
			templateRegistry = v9,
			dataStore = v10,
			getPageLayoutConfig = if fFlagLuaAppLayoutParamsInContext then v11 else nil
		}

		setmetatable(v12, {
			__tostring = function(): string
				return "SduiContext"
			end
		})

		return v12
	end

	local v14 = React.useMemo(fn, {
		v7,
		data.appPage,
		data.dataUpdatedTimestamp,
		v8,
		v9,
		v10,
		if fFlagLuaAppLayoutParamsInContext then v11 else nil
	})

	v6:stopTimerFlow("useSduiContext", v14)
	return v14
end

return useSduiContext
