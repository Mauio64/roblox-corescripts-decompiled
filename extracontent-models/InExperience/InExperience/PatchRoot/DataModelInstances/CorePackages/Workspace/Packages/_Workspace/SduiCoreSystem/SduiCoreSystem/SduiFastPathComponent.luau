local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local SduiBuilder = require(SduiCoreSystem.SduiBuilder)
local SduiBuilderTypes = require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiErrorType = SduiErrors.SduiErrorType
local SduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase
local compareSduiProps = require(SduiCoreSystem.compareSduiProps)
local compareSduiAnalyticsContext = require(SduiCoreSystem.compareSduiAnalyticsContext)

local parseProps = require(SduiCoreSystem.parseProps)

local function SduiErrorComponent(_)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 100)
	})
end

local v = {}

local function SduiFastPathComponent(props)
	local componentConfig = props.componentConfig
	local componentType = componentConfig.componentType
	local sduiContext = props.sduiContext
	local debugName = props.debugName
	local parentAnalyticsContext = props.parentAnalyticsContext
	local localAnalyticsData = props.localAnalyticsData
	local extraLocalProps = props.extraLocalProps

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = SduiBuilder.buildAnalyticsContext(componentConfig, parentAnalyticsContext, localAnalyticsData)
	else
		local analyticsContext = SduiBuilder.buildAnalyticsContext(
			componentConfig,
			parentAnalyticsContext,
			localAnalyticsData
		)

		if not compareSduiAnalyticsContext(ref.current, analyticsContext) then
			ref.current = analyticsContext
		end
	end

	local current = ref.current

	local clone = table.clone(componentConfig.props or v)
	parseProps(componentType, clone, debugName, sduiContext, current, nil, SduiBuilderProcessingPhase.Render)

	if extraLocalProps then
		clone = Cryo.Dictionary.join(clone, extraLocalProps)
	end

	clone.componentConfig = componentConfig
	clone.sduiContext = sduiContext
	clone.debugName = debugName
	clone.analyticsContext = current

	local component = sduiContext.componentDefinitions:getComponent(componentType)

	if component ~= nil then
		return React.createElement(component, clone)
	end

	sduiContext.dependencies.logger.reportError(
		SduiErrorType.NoComponentRegistered,
		{ componentType = componentType, name = debugName },
		sduiContext.appPage
	)
	return React.createElement(SduiErrorComponent)
end

return React.memo(SduiFastPathComponent, compareSduiProps)
