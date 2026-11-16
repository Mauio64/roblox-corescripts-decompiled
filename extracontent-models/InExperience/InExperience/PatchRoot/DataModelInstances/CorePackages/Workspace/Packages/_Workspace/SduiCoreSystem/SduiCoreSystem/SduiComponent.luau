local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local SduiBuilder = require(SduiCoreSystem.SduiBuilder)
local SduiBuilderTypes = require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiComponentType)
local SduiConditionalPropWrapper = require(SduiCoreSystem.ConditionalProps.SduiConditionalPropWrapper)
local SduiConfigTypes = require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiErrorType = SduiErrors.SduiErrorType
local SduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase
local compareSduiProps = require(SduiCoreSystem.compareSduiProps)
local compareSduiAnalyticsContext = require(SduiCoreSystem.compareSduiAnalyticsContext)

local SduiCompat = require(parent.SduiCompat)
local mapServerBindingProps = SduiCompat.mapServerBindingProps
local ServerBindingPropMap = SduiCompat.ServerBindingPropMap
local parseProps = require(SduiCoreSystem.parseProps)
local validateInterface = require(SduiCoreSystem.validateInterface)
local UiComponentInterface = SduiConfigTypes.UiComponentInterface
local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)
local recordV1ComponentUsage = require(SduiCoreSystem.Analytics.recordV1ComponentUsage)

local v = {}

local fn

local function SduiErrorComponent(_)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 100)
	})
end

local memo = React.memo(function(props)
	local __processed = props.componentConfig.__processed
	local v2

	if __processed then
		v2 = SduiBuilderProcessingPhase.Render
	else
		v2 = SduiBuilderProcessingPhase.Lazy
	end

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

	local componentType = SduiBuilder.getComponentType(componentConfig, sduiContext)

	if componentType == nil then
		sduiContext.dependencies.logger.reportError(SduiErrorType.NilComponentType, {
			message = `Unable to resolve componentType for component with template {componentConfig and componentConfig.templateKey or nil}`,
			name = debugName
		}, sduiContext.appPage)
		instrumentation:stopTimerFlow("BuildPropsAndChildren", sduiContext, true)
		return React.createElement(SduiErrorComponent)
	else
		local component = sduiContext.componentDefinitions:getComponent(componentType)

		if component == nil then
			sduiContext.dependencies.logger.reportError(
				SduiErrorType.NoComponentRegistered,
				{ componentType = componentType, name = debugName },
				sduiContext.appPage
			)
			instrumentation:stopTimerFlow("BuildPropsAndChildren", sduiContext, true)
			return React.createElement(SduiErrorComponent)
		else
			instrumentation:startTimerFlow("ParseProps")
			local joined = Cryo.Dictionary.join(componentConfig.props or v, conditionalProps or v)

			if not __processed then
				local v3, v4 = mapServerBindingProps(joined, ServerBindingPropMap)

				if v3 then
					for k, v5 in v3 do
						joined[k] = v5
					end
				end

				if v4 then
					sduiContext.dependencies.logger.reportError(
						SduiErrorType.UnmappedServerBindingProp,
						{
							componentType = componentType,
							name = debugName,
							message = `Unmapped PascalCase props detected: {table.concat(v4, ", ")}. These props will not reach the camelCase component.`
						},
						sduiContext.appPage
					)
				end
			end

			parseProps(componentType, joined, debugName, sduiContext, current, nil, v2)

			if extraLocalProps then
				joined = Cryo.Dictionary.join(joined, extraLocalProps)
			end

			joined.componentConfig = componentConfig
			joined.sduiContext = sduiContext
			joined.debugName = debugName
			joined.analyticsContext = current

			local v3 = not __processed and sduiContext.componentDefinitions:getPropInterface(componentType)

			if v3 then
				local v4, message = validateInterface(joined, v3)

				if not v4 then
					instrumentation:stopTimerFlow("ParseProps", sduiContext, true)
					sduiContext.dependencies.logger.reportError(
						SduiErrorType.InvalidProps,
						{ componentType = componentType, name = debugName, message = message },
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
			SduiErrorType.NilComponentConfig,
			{ name = props.debugName },
			props.sduiContext.appPage
		)
		return React.createElement(SduiErrorComponent)
	end

	if not props.componentConfig.__processed then
		if props.sduiContext.templateRegistry:shouldResolveTemplate(props.componentConfig) then
			props.sduiContext.templateRegistry:resolveTemplateForConfig(props.componentConfig, props.sduiContext)
		end

		local v2, v3 = validateInterface(props.componentConfig, UiComponentInterface, false)

		if not v2 then
			props.sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.InvalidComponentConfig,
				{
					message = `Invalid config for component. err: {v3}`,
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
