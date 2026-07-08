local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)
local tutils = require(SduiCoreSystemParent.tutils)
local SduiBuilderProcessingPhase = require(SduiCoreSystem.SduiBuilderTypes).SduiBuilderProcessingPhase

require(SduiCoreSystem.SduiComponentType)

local SduiConfigTypes = require(SduiCoreSystem.SduiConfigTypes)
local SduiErrorType = require(SduiCoreSystem.SduiErrors).SduiErrorType
local parseProps = require(SduiCoreSystem.parseProps)
local validateInterface = require(SduiCoreSystem.validateInterface)
local UiComponentInterface = SduiConfigTypes.UiComponentInterface
local SduiCompat = require(SduiCoreSystemParent.SduiCompat)
local mapServerBindingProps = SduiCompat.mapServerBindingProps
local ServerBindingPropMap = SduiCompat.ServerBindingPropMap
local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)
local recordV1ComponentUsage = require(SduiCoreSystem.Analytics.recordV1ComponentUsage)
local FFlagSduiUsageTelemetry = require(SduiCoreSystemParent.SharedFlags).FFlagSduiUsageTelemetry
local t1 = {}

return {
	getComponentType = function(p1, p2) -- line: 37
		if not p1.__isClientBinding and p2.templateRegistry:shouldResolveTemplate(p1) then
			p2.templateRegistry:resolveTemplateForConfig(p1, p2)
		end

		return p1.componentType
	end,
	buildAnalyticsContext = function(p3, p4, t2: {[any]: any}?) -- line: 47
		-- upvalues: t1 (copy), Cryo (copy)
		local v23 = p4 or t1
		local v24 = p3.analyticsData or t1
		local v25 = Cryo.Dictionary.join(v23.ancestorAnalyticsData or t1, v23.analyticsData or t1)
		local getCollectionData = v23.getCollectionData

		if t2 then
			v24 = Cryo.Dictionary.join(v24, t2)
		end

		return {
			analyticsData = v24,
			ancestorAnalyticsData = v25,
			getCollectionData = getCollectionData
		}
	end,
	tryCreateEagerProcessedComponentConfig = function(p5, p6, s1: string, p7, b1: boolean?) -- line: 81
		-- upvalues: SduiErrorType (copy), tutils (copy), validateInterface (copy), UiComponentInterface (copy), mapServerBindingProps (copy), ServerBindingPropMap (copy), FFlagSduiUsageTelemetry (copy), recordV1ComponentUsage (copy), SduiUsageRecorder (copy), parseProps (copy), SduiBuilderProcessingPhase (copy)
		local instrumentation = p6.dependencies.instrumentation

		instrumentation:startTimerFlow("EagerProcess")

		if not p5 then
			p6.dependencies.logger.reportError(SduiErrorType.NilComponentConfig, {
				name = s1
			}, p6.appPage)
			instrumentation:stopTimerFlow("EagerProcess", p6, true)

			return false, p5
		end

		assert(p5, "componentConfig must exist")

		if p5.__processed then
			p6.dependencies.logger.reportError(SduiErrorType.EagerReprocessing, {
				message = "Eagerly evaluating a component that has already been processed",
				componentType = p5.componentType,
				name = s1
			}, p6.appPage)
			instrumentation:stopTimerFlow("EagerProcess", p6, true)

			return true, p5
		end

		local v33 = if not b1 then p5 else tutils.deepCopy(p5)

		if p6.templateRegistry:shouldResolveTemplate(v33) then
			local props = v33.props

			if props and props.itemTemplateKey then
				if props.items then
					for _, v36 in props.items do
						if v36.templateKey == nil then
							v36.templateKey = props.itemTemplateKey
						end
					end
				elseif props.item and props.item.templateKey == nil then
					props.item.templateKey = props.itemTemplateKey
				end
			end

			if not p6.templateRegistry:resolveTemplateForConfig(v33, p6) then
				instrumentation:stopTimerFlow("EagerProcess", p6, true)

				return false, p5
			end
		end

		local componentType = v33.componentType

		if p6.componentDefinitions:getComponent(componentType) == nil then
			p6.dependencies.logger.reportError(SduiErrorType.NoComponentRegistered, {
				componentType = componentType,
				name = s1
			}, p6.appPage)
			instrumentation:stopTimerFlow("EagerProcess", p6, true)

			return false, p5
		end

		local v38, v39 = validateInterface(v33, UiComponentInterface, false)

		if not v38 then
			p6.dependencies.logger.reportError(SduiErrorType.InvalidComponentConfig, {
				message = `(Eager) Invalid config for component. err: { v39 }`,
				componentType = componentType,
				name = s1,
				value = v33
			}, p6.appPage)
			instrumentation:stopTimerFlow("EagerProcess", p6, true)

			return false, p5
		end

		if v33.props then
			local v40, v41 = mapServerBindingProps(v33.props, ServerBindingPropMap)

			if v40 then
				for v42, v43 in v40 do
					v33.props[v42] = v43
				end
			end

			if v41 then
				p6.dependencies.logger.reportError(SduiErrorType.UnmappedServerBindingProp, {
					componentType = componentType,
					name = s1,
					message = `Unmapped PascalCase props detected: { table.concat(v41, ", ") }. These props will not reach the camelCase component.`
				}, p6.appPage)
			end
		end

		if FFlagSduiUsageTelemetry and not v33.__usageRecorded then
			recordV1ComponentUsage(p6.appPage, v33)
			v33.__usageRecorded = true
			SduiUsageRecorder.scheduleFlush()
		end

		if v33.props then
			parseProps(componentType, v33.props, s1, p6, p7, nil, SduiBuilderProcessingPhase.Eager)
		end

		if v33.conditionalProps then
			for _, v45 in v33.conditionalProps do
				local v46, v47 = mapServerBindingProps(v45.propOverrides, ServerBindingPropMap)

				if v46 then
					for v48, v49 in v46 do
						v45.propOverrides[v48] = v49
					end
				end

				if v47 then
					p6.dependencies.logger.reportError(SduiErrorType.UnmappedServerBindingProp, {
						componentType = componentType,
						name = s1,
						message = `Unmapped PascalCase conditional props detected: { table.concat(v47, ", ") }. These props will not reach the camelCase component.`
					}, p6.appPage)
				end

				parseProps(componentType, v45.propOverrides, s1, p6, p7, nil, SduiBuilderProcessingPhase.Eager)
			end
		end

		local v50 = p6.componentDefinitions:getPropInterface(componentType)

		if v50 then
			local v51, v52 = validateInterface(v33.props, v50)

			if not v51 then
				p6.dependencies.logger.reportError(SduiErrorType.InvalidProps, {
					componentType = componentType,
					name = s1,
					message = v52
				}, p6.appPage)
				instrumentation:stopTimerFlow("EagerProcess", p6, true)

				return false, p5
			end
		end

		v33.__processed = true
		instrumentation:stopTimerFlow("EagerProcess", p6)

		return true, v33
	end
}
