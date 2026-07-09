local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)
local React = require(SduiCoreSystemParent.React)
local SduiBuilder = require(SduiCoreSystem.SduiBuilder)
local SduiBuilderTypes = require(SduiCoreSystem.SduiBuilderTypes)

require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiConfigTypes)

local SduiErrorType = require(SduiCoreSystem.SduiErrors).SduiErrorType
local SduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase
local compareSduiProps = require(SduiCoreSystem.compareSduiProps)
local compareSduiAnalyticsContext = require(SduiCoreSystem.compareSduiAnalyticsContext)
local parseProps = require(SduiCoreSystem.parseProps)

local function SduiErrorComponent(_) -- line: 29
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 100)
	})
end

local t1 = {}

local function SduiFastPathComponent(p2) -- line: 39
	-- upvalues: React (copy), SduiBuilder (copy), compareSduiAnalyticsContext (copy), t1 (copy), parseProps (copy), SduiBuilderProcessingPhase (copy), Cryo (copy), SduiErrorType (copy), SduiErrorComponent (copy)
	local componentConfig = p2.componentConfig
	local componentType = componentConfig.componentType
	local sduiContext = p2.sduiContext
	local debugName = p2.debugName
	local parentAnalyticsContext = p2.parentAnalyticsContext
	local localAnalyticsData = p2.localAnalyticsData
	local extraLocalProps = p2.extraLocalProps
	local v24 = React.useRef(nil)

	if v24.current == nil then
		v24.current = SduiBuilder.buildAnalyticsContext(componentConfig, parentAnalyticsContext, localAnalyticsData)
	else
		local v25 = SduiBuilder.buildAnalyticsContext(componentConfig, parentAnalyticsContext, localAnalyticsData)

		if not compareSduiAnalyticsContext(v24.current, v25) then
			v24.current = v25
		end
	end

	local current = v24.current
	local v27 = table.clone(componentConfig.props or t1)

	parseProps(componentType, v27, debugName, sduiContext, current, nil, SduiBuilderProcessingPhase.Render)

	if extraLocalProps then
		v27 = Cryo.Dictionary.join(v27, extraLocalProps)
	end

	v27.componentConfig = componentConfig
	v27.sduiContext = sduiContext
	v27.debugName = debugName
	v27.analyticsContext = current

	local v28 = sduiContext.componentDefinitions:getComponent(componentType)

	if v28 == nil then
		sduiContext.dependencies.logger.reportError(SduiErrorType.NoComponentRegistered, {
			componentType = componentType,
			name = debugName
		}, sduiContext.appPage)

		return React.createElement(SduiErrorComponent)
	end

	return React.createElement(v28, v27)
end

return React.memo(SduiFastPathComponent, compareSduiProps)
