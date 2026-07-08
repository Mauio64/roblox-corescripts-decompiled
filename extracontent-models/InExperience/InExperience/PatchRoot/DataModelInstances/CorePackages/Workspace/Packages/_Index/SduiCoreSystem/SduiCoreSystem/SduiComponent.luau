local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)
local React = require(SduiCoreSystemParent.React)
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
local SduiCompat = require(SduiCoreSystemParent.SduiCompat)
local mapServerBindingProps = SduiCompat.mapServerBindingProps
local ServerBindingPropMap = SduiCompat.ServerBindingPropMap
local parseProps = require(SduiCoreSystem.parseProps)
local validateInterface = require(SduiCoreSystem.validateInterface)
local UiComponentInterface = SduiConfigTypes.UiComponentInterface
local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)
local recordV1ComponentUsage = require(SduiCoreSystem.Analytics.recordV1ComponentUsage)
local FFlagSduiUsageTelemetry = require(SduiCoreSystemParent.SharedFlags).FFlagSduiUsageTelemetry
local t1 = {}
local u24 = nil

local function SduiErrorComponent(_) -- line: 45
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 100)
	})
end

local v26 = React.memo(function(p2) -- line: 53
	-- upvalues: SduiBuilderProcessingPhase (copy), React (copy), SduiBuilder (copy), compareSduiAnalyticsContext (copy), SduiErrorType (copy), SduiErrorComponent (copy), Cryo (copy), t1 (copy), mapServerBindingProps (copy), ServerBindingPropMap (copy), parseProps (copy), validateInterface (copy), u24 (ref)
	local __processed = p2.componentConfig.__processed
	local v30 = if not __processed then SduiBuilderProcessingPhase.Lazy else SduiBuilderProcessingPhase.Render
	local componentConfig = p2.componentConfig
	local sduiContext = p2.sduiContext
	local debugName = p2.debugName
	local parentAnalyticsContext = p2.parentAnalyticsContext
	local localAnalyticsData = p2.localAnalyticsData
	local extraLocalProps = p2.extraLocalProps
	local conditionalProps = p2.conditionalProps
	local instrumentation = sduiContext.dependencies.instrumentation

	instrumentation:startTimerFlow("BuildPropsAndChildren")

	local v39 = React.useRef(nil)

	if v39.current == nil then
		v39.current = SduiBuilder.buildAnalyticsContext(componentConfig, parentAnalyticsContext, localAnalyticsData)
	else
		local v40 = SduiBuilder.buildAnalyticsContext(componentConfig, parentAnalyticsContext, localAnalyticsData)

		if not compareSduiAnalyticsContext(v39.current, v40) then
			v39.current = v40
		end
	end

	local current = v39.current
	local v42 = SduiBuilder.getComponentType(componentConfig, sduiContext)

	if v42 == nil then
		sduiContext.dependencies.logger.reportError(SduiErrorType.NilComponentType, {
			message = `Unable to resolve componentType for component with template { componentConfig and componentConfig.templateKey or nil }`,
			name = debugName
		}, sduiContext.appPage)
		instrumentation:stopTimerFlow("BuildPropsAndChildren", sduiContext, true)

		return React.createElement(SduiErrorComponent)
	end

	local v43 = sduiContext.componentDefinitions:getComponent(v42)

	if v43 == nil then
		sduiContext.dependencies.logger.reportError(SduiErrorType.NoComponentRegistered, {
			componentType = v42,
			name = debugName
		}, sduiContext.appPage)
		instrumentation:stopTimerFlow("BuildPropsAndChildren", sduiContext, true)

		return React.createElement(SduiErrorComponent)
	end

	instrumentation:startTimerFlow("ParseProps")

	local v44 = Cryo.Dictionary.join(componentConfig.props or t1, conditionalProps or t1)

	if not __processed then
		local v45, v46 = mapServerBindingProps(v44, ServerBindingPropMap)

		if v45 then
			for v47, v48 in v45 do
				v44[v47] = v48
			end
		end

		if v46 then
			sduiContext.dependencies.logger.reportError(SduiErrorType.UnmappedServerBindingProp, {
				componentType = v42,
				name = debugName,
				message = `Unmapped PascalCase props detected: { table.concat(v46, ", ") }. These props will not reach the camelCase component.`
			}, sduiContext.appPage)
		end
	end

	parseProps(v42, v44, debugName, sduiContext, current, nil, v30)

	if extraLocalProps then
		v44 = Cryo.Dictionary.join(v44, extraLocalProps)
	end

	v44.componentConfig = componentConfig
	v44.sduiContext = sduiContext
	v44.debugName = debugName
	v44.analyticsContext = current

	if not __processed then
		local v49 = sduiContext.componentDefinitions:getPropInterface(v42)

		if v49 then
			local v50, v51 = validateInterface(v44, v49)

			if not v50 then
				instrumentation:stopTimerFlow("ParseProps", sduiContext, true)
				sduiContext.dependencies.logger.reportError(SduiErrorType.InvalidProps, {
					componentType = v42,
					name = debugName,
					message = v51
				}, sduiContext.appPage)

				return React.createElement(SduiErrorComponent)
			end
		end
	end

	instrumentation:stopTimerFlow("ParseProps", sduiContext)

	local v52 = if not componentConfig.children then nil else {}

	if componentConfig.children then
		assert(v52, "reactChildren must exist")

		for v53, v54 in componentConfig.children do
			local v55 = `{ v54.componentType }_{ v53 }`

			v52[v55] = React.createElement(u24, {
				componentConfig = v54,
				sduiContext = sduiContext,
				parentAnalyticsContext = current,
				extraLocalProps = {
					index = v53,
					layoutOrder = v53
				},
				debugName = v55
			})
		end
	end

	instrumentation:stopTimerFlow("BuildPropsAndChildren", sduiContext)

	return React.createElement(v43, v44, v52)
end, compareSduiProps)

function u24(p3) -- line: 174
	-- upvalues: SduiErrorType (copy), React (copy), SduiErrorComponent (copy), validateInterface (copy), UiComponentInterface (copy), SduiErrors (copy), FFlagSduiUsageTelemetry (copy), recordV1ComponentUsage (copy), SduiUsageRecorder (copy), SduiConditionalPropWrapper (copy), v26 (copy)
	if not p3.componentConfig then
		p3.sduiContext.dependencies.logger.reportError(SduiErrorType.NilComponentConfig, {
			name = p3.debugName
		}, p3.sduiContext.appPage)

		return React.createElement(SduiErrorComponent)
	end

	if not p3.componentConfig.__processed then
		if p3.sduiContext.templateRegistry:shouldResolveTemplate(p3.componentConfig) then
			p3.sduiContext.templateRegistry:resolveTemplateForConfig(p3.componentConfig, p3.sduiContext)
		end

		local v57, v58 = validateInterface(p3.componentConfig, UiComponentInterface, false)

		if not v57 then
			p3.sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidComponentConfig, {
				message = `Invalid config for component. err: { v58 }`,
				componentType = p3.componentConfig.componentType,
				name = p3.debugName
			}, p3.sduiContext.appPage)
		end
	end

	if FFlagSduiUsageTelemetry and not p3.componentConfig.__usageRecorded then
		recordV1ComponentUsage(p3.sduiContext.appPage, p3.componentConfig)
		p3.componentConfig.__usageRecorded = true
		SduiUsageRecorder.scheduleFlush()
	end

	if p3.componentConfig.conditionalProps then
		return React.createElement(SduiConditionalPropWrapper, {
			wrappedComponent = v26,
			sduiContext = p3.sduiContext,
			parentAnalyticsContext = p3.parentAnalyticsContext,
			extraLocalProps = p3.extraLocalProps,
			componentConfig = p3.componentConfig,
			debugName = p3.debugName,
			localAnalyticsData = p3.localAnalyticsData
		})
	end

	return React.createElement(v26, p3)
end

return React.memo(u24, compareSduiProps)
