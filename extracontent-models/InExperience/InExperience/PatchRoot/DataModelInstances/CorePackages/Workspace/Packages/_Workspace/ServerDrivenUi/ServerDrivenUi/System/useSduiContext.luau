local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)

local CollectionViews = require(parent.CollectionViews)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local Signals = require(parent.Signals)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiComponentDefinitions = require(ServerDrivenUi.System.SduiComponentDefinitions)
local SduiInstrumentation = SduiCoreSystem.SduiInstrumentation
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiTemplateRegistry = SduiCoreSystem.SduiTemplateRegistry
local SduiUsageRecorder = SduiCoreSystem.SduiUsageRecorder
local recordV1RegisteredTemplates = SduiCoreSystem.recordV1RegisteredTemplates
local useSduiDataStore = require(ServerDrivenUi.DataStore.useSduiDataStore)
local SduiErrors = SduiCoreSystem.SduiErrors

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext

local v = {
	numColumns = 3,
	fractionalItemAmount = 0,
	columnGap = 24,
	sideMargin = 24,
	verticalPadding = 16
}

local useSduiDependencies = require(ServerDrivenUi.System.useSduiDependencies)

local function useSduiContext(data)
	local v2 = React.useMemo(function()
		return SduiInstrumentation.new()
	end, {})
	v2:startTimerFlow("useSduiContext")

	local dependencies = useSduiDependencies(v2)

	local componentDefinitions = React.useMemo(function()
		return data.componentDefinitions or SduiComponentDefinitions.new()
	end, { data.componentDefinitions })

	local templateRegistry = React.useMemo(function()
		return SduiTemplateRegistry.new(data.templates)
	end, { data.templates })
	React.useEffect(function()
		recordV1RegisteredTemplates(data.appPage, data.templates)
		SduiUsageRecorder.scheduleFlush()
	end, { data.appPage, data.templates })

	local dataStore = useSduiDataStore()
	local v3

	if FFlagLuaAppLayoutParamsInContext then
		local v4 = React.useMemo(function()
			return Signals.createSignal(v)
		end, {})

		v3 = React.useCallback(function(p)
			return Signals.createComputed(function(p2)
				if data.pageLayoutConfig then
					return (data.pageLayoutConfig[p] or data.pageLayoutConfig[CollectionItemSize.Small])(p2)
				end

				SduiLogger.reportError(
					SduiErrors.SduiErrorType.NoPageLayoutConfig,
					{
						message = `No page layout config available for {data.appPage}, returning default config`
					},
					data.appPage
				)

				return (v4(p2))
			end)
		end, { data.pageLayoutConfig })
	else
		v3 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		local v4 = {
			dependencies = dependencies,
			appPage = data.appPage,
			dataUpdatedTimestamp = data.dataUpdatedTimestamp,
			componentDefinitions = componentDefinitions,
			templateRegistry = templateRegistry,
			dataStore = dataStore,
			getPageLayoutConfig = 0
		}
		local getPageLayoutConfig

		if FFlagLuaAppLayoutParamsInContext then
			getPageLayoutConfig = v3
		end

		v4.getPageLayoutConfig = getPageLayoutConfig

		setmetatable(v4, {
			__tostring = function(): string
				return "SduiContext"
			end
		})

		return v4
	end

	local appPage = data.appPage
	local dataUpdatedTimestamp = data.dataUpdatedTimestamp
	local v4

	if FFlagLuaAppLayoutParamsInContext then
		v4 = v3
	end

	local v5 = useMemo(fn, {
		dependencies,
		appPage,
		dataUpdatedTimestamp,
		componentDefinitions,
		templateRegistry,
		dataStore,
		v4
	})

	v2:stopTimerFlow("useSduiContext", v5)
	return v5
end

return useSduiContext
