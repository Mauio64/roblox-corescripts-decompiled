local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")

local SduiBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilder")
local SduiBuilderTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local sduiErrorType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors").SduiErrorType
local sduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase
local compareSduiProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/compareSduiProps")
local compareSduiAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/compareSduiAnalyticsContext")

local parseProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/parseProps")

local function SduiErrorComponent(p2)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 100)
	})
end

local v5 = {}

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
		ref.current = SduiBuilder.buildAnalyticsContext(
			componentConfig,
			parentAnalyticsContext,
			localAnalyticsData
		)
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

	local clone = table.clone(componentConfig.props or v5)
	parseProps(componentType, clone, debugName, sduiContext, current, nil, sduiBuilderProcessingPhase.Render)

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
		sduiErrorType.NoComponentRegistered,
		{ componentType = componentType, name = debugName },
		sduiContext.appPage
	)
	return React.createElement(SduiErrorComponent)
end

return React.memo(SduiFastPathComponent, compareSduiProps)
