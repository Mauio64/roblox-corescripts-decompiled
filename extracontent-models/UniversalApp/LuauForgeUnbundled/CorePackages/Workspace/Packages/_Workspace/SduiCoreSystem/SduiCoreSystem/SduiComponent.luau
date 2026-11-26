local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")

local SduiBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilder")
local SduiBuilderTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local SduiConditionalPropWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ConditionalProps/SduiConditionalPropWrapper")
local SduiConfigTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local sduiErrorType = SduiErrors.SduiErrorType
local sduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase
local compareSduiProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/compareSduiProps")
local compareSduiAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/compareSduiAnalyticsContext")

local SduiCompat = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCompat")
local mapServerBindingProps = SduiCompat.mapServerBindingProps
local serverBindingPropMap = SduiCompat.ServerBindingPropMap
local parseProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/parseProps")
local validateInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/validateInterface")
local uiComponentInterface = SduiConfigTypes.UiComponentInterface
local SduiUsageRecorder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/SduiUsageRecorder")
local recordV1ComponentUsage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/recordV1ComponentUsage")

local v5 = {}

local fn

local function SduiErrorComponent(p2)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 100)
	})
end

local memo = React.memo(function(props)
	local __processed = props.componentConfig.__processed

	local v6 = if __processed then sduiBuilderProcessingPhase.Render else sduiBuilderProcessingPhase.Lazy

	local componentConfig = props.componentConfig
	local sduiContext = props.sduiContext
	local debugName = props.debugName
	local parentAnalyticsContext = props.parentAnalyticsContext
	local localAnalyticsData = props.localAnalyticsData
	local extraLocalProps = props.extraLocalProps
	local conditionalProps = props.conditionalProps

	local instrumentation = sduiContext.dependencies.instrumentation
	instrumentation:startTimerFlow("BuildPropsAndChildren")

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

	local componentType = SduiBuilder.getComponentType(componentConfig, sduiContext)

	if componentType == nil then
		sduiContext.dependencies.logger.reportError(sduiErrorType.NilComponentType, {
			message = `Unable to resolve componentType for component with template {componentConfig and componentConfig.templateKey or nil}`,
			name = debugName
		}, sduiContext.appPage)
		instrumentation:stopTimerFlow("BuildPropsAndChildren", sduiContext, true)
		return React.createElement(SduiErrorComponent)
	else
		local component = sduiContext.componentDefinitions:getComponent(componentType)

		if component == nil then
			sduiContext.dependencies.logger.reportError(
				sduiErrorType.NoComponentRegistered,
				{ componentType = componentType, name = debugName },
				sduiContext.appPage
			)
			instrumentation:stopTimerFlow("BuildPropsAndChildren", sduiContext, true)
			return React.createElement(SduiErrorComponent)
		else
			instrumentation:startTimerFlow("ParseProps")
			local joined = Cryo.Dictionary.join(componentConfig.props or v5, conditionalProps or v5)

			if not __processed then
				local v7, v8 = mapServerBindingProps(joined, serverBindingPropMap)

				if v7 then
					for k, v9 in v7 do
						joined[k] = v9
					end
				end

				if v8 then
					sduiContext.dependencies.logger.reportError(
						sduiErrorType.UnmappedServerBindingProp,
						{
							componentType = componentType,
							name = debugName,
							message = `Unmapped PascalCase props detected: {table.concat(v8, ", ")}. These props will not reach the camelCase component.`
						},
						sduiContext.appPage
					)
				end
			end

			parseProps(componentType, joined, debugName, sduiContext, current, nil, v6)

			if extraLocalProps then
				joined = Cryo.Dictionary.join(joined, extraLocalProps)
			end

			joined.componentConfig = componentConfig
			joined.sduiContext = sduiContext
			joined.debugName = debugName
			joined.analyticsContext = current

			local v7 = not __processed and sduiContext.componentDefinitions:getPropInterface(componentType)

			if v7 then
				local v8, v9 = validateInterface(joined, v7)

				if not v8 then
					instrumentation:stopTimerFlow("ParseProps", sduiContext, true)
					sduiContext.dependencies.logger.reportError(
						sduiErrorType.InvalidProps,
						{
							componentType = componentType,
							name = debugName,
							message = v9
						},
						sduiContext.appPage
					)
					return React.createElement(SduiErrorComponent)
				end
			end

			instrumentation:stopTimerFlow("ParseProps", sduiContext)

			local children = componentConfig.children and {} or nil

			if componentConfig.children then
				assert(children, "reactChildren must exist")

				for k, child in componentConfig.children do
					local formatted = `{child.componentType}_{k}`

					children[formatted] = React.createElement(fn, {
						componentConfig = child,
						sduiContext = sduiContext,
						parentAnalyticsContext = current,
						extraLocalProps = { index = k, layoutOrder = k },
						debugName = formatted
					})
				end
			end

			instrumentation:stopTimerFlow("BuildPropsAndChildren", sduiContext)
			return React.createElement(component, joined, children)
		end
	end
end, compareSduiProps)

fn = function(props)
	if not props.componentConfig then
		props.sduiContext.dependencies.logger.reportError(
			sduiErrorType.NilComponentConfig,
			{ name = props.debugName },
			props.sduiContext.appPage
		)
		return React.createElement(SduiErrorComponent)
	end

	if not props.componentConfig.__processed then
		if props.sduiContext.templateRegistry:shouldResolveTemplate(props.componentConfig) then
			props.sduiContext.templateRegistry:resolveTemplateForConfig(
				props.componentConfig,
				props.sduiContext
			)
		end

		local v6, v7 = validateInterface(props.componentConfig, uiComponentInterface, false)

		if not v6 then
			props.sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.InvalidComponentConfig,
				{
					message = `Invalid config for component. err: {v7}`,
					componentType = props.componentConfig.componentType,
					name = props.debugName
				},
				props.sduiContext.appPage
			)
		end
	end

	if not props.componentConfig.__usageRecorded then
		recordV1ComponentUsage(props.sduiContext.appPage, props.componentConfig)
		props.componentConfig.__usageRecorded = true
		SduiUsageRecorder.scheduleFlush()
	end

	if props.componentConfig.conditionalProps then
		return React.createElement(SduiConditionalPropWrapper, {
			wrappedComponent = memo,
			sduiContext = props.sduiContext,
			parentAnalyticsContext = props.parentAnalyticsContext,
			extraLocalProps = props.extraLocalProps,
			componentConfig = props.componentConfig,
			debugName = props.debugName,
			localAnalyticsData = props.localAnalyticsData
		})
	end

	return React.createElement(memo, props)
end

return React.memo(fn, compareSduiProps)
