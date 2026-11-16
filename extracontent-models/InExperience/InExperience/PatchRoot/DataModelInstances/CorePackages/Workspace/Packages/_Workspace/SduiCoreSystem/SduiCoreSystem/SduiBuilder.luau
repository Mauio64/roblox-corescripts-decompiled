local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local Cryo = require(parent.Cryo)
local tutils = require(parent.tutils)

local SduiBuilderTypes = require(SduiCoreSystem.SduiBuilderTypes)
local SduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase
require(SduiCoreSystem.SduiComponentType)
local SduiConfigTypes = require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiErrorType = SduiErrors.SduiErrorType
local parseProps = require(SduiCoreSystem.parseProps)
local validateInterface = require(SduiCoreSystem.validateInterface)
local UiComponentInterface = SduiConfigTypes.UiComponentInterface

local SduiCompat = require(parent.SduiCompat)
local mapServerBindingProps = SduiCompat.mapServerBindingProps
local ServerBindingPropMap = SduiCompat.ServerBindingPropMap
local SduiUsageRecorder = require(SduiCoreSystem.Analytics.SduiUsageRecorder)
local recordV1ComponentUsage = require(SduiCoreSystem.Analytics.recordV1ComponentUsage)

local v = {}
local SduiBuilder = {}

function SduiBuilder.getComponentType(p, p2)
	if not p.__isClientBinding and p2.templateRegistry:shouldResolveTemplate(p) then
		p2.templateRegistry:resolveTemplateForConfig(p, p2)
	end

	return p.componentType
end

function SduiBuilder.buildAnalyticsContext(p, p2, p3)
	local v2 = p2 or v
	local analyticsData = p.analyticsData or v
	local joined = Cryo.Dictionary.join(v2.ancestorAnalyticsData or v, v2.analyticsData or v)

	local getCollectionData = v2.getCollectionData

	if p3 then
		analyticsData = Cryo.Dictionary.join(analyticsData, p3)
	end

	return {
		analyticsData = analyticsData,
		ancestorAnalyticsData = joined,
		getCollectionData = getCollectionData
	}
end

function SduiBuilder.tryCreateEagerProcessedComponentConfig(p, data, name: string, p2, flag: boolean?)
	local instrumentation = data.dependencies.instrumentation
	instrumentation:startTimerFlow("EagerProcess")

	if p then
		assert(p, "componentConfig must exist")

		if p.__processed then
			data.dependencies.logger.reportError(
				SduiErrorType.EagerReprocessing,
				{
					message = "Eagerly evaluating a component that has already been processed",
					componentType = p.componentType,
					name = name
				},
				data.appPage
			)
			instrumentation:stopTimerFlow("EagerProcess", data, true)
			return true, p
		else
			local v2

			if flag then
				v2 = tutils.deepCopy(p)
			else
				v2 = p
			end

			if data.templateRegistry:shouldResolveTemplate(v2) then
				local props = v2.props

				if props and props.itemTemplateKey then
					if props.items then
						for _, item in props.items do
							if item.templateKey == nil then
								item.templateKey = props.itemTemplateKey
							end
						end
					elseif props.item and props.item.templateKey == nil then
						props.item.templateKey = props.itemTemplateKey
					end
				end

				if not data.templateRegistry:resolveTemplateForConfig(v2, data) then
					instrumentation:stopTimerFlow("EagerProcess", data, true)
					return false, p
				end
			end

			local componentType = v2.componentType

			if data.componentDefinitions:getComponent(componentType) == nil then
				data.dependencies.logger.reportError(
					SduiErrorType.NoComponentRegistered,
					{ componentType = componentType, name = name },
					data.appPage
				)
				instrumentation:stopTimerFlow("EagerProcess", data, true)
				return false, p
			else
				local v3, v4 = validateInterface(v2, UiComponentInterface, false)

				if v3 then
					if v2.props then
						local v5, v6 = mapServerBindingProps(v2.props, ServerBindingPropMap)

						if v5 then
							for k, v7 in v5 do
								v2.props[k] = v7
							end
						end

						if v6 then
							data.dependencies.logger.reportError(
								SduiErrorType.UnmappedServerBindingProp,
								{
									componentType = componentType,
									name = name,
									message = `Unmapped PascalCase props detected: {table.concat(v6, ", ")}. These props will not reach the camelCase component.`
								},
								data.appPage
							)
						end
					end

					if not v2.__usageRecorded then
						recordV1ComponentUsage(data.appPage, v2)
						v2.__usageRecorded = true
						SduiUsageRecorder.scheduleFlush()
					end

					if v2.props then
						parseProps(componentType, v2.props, name, data, p2, nil, SduiBuilderProcessingPhase.Eager)
					end

					if v2.conditionalProps then
						for _, conditionalProp in v2.conditionalProps do
							local v5, v6 = mapServerBindingProps(conditionalProp.propOverrides, ServerBindingPropMap)

							if v5 then
								for k, v7 in v5 do
									conditionalProp.propOverrides[k] = v7
								end
							end

							if v6 then
								data.dependencies.logger.reportError(
									SduiErrorType.UnmappedServerBindingProp,
									{
										componentType = componentType,
										name = name,
										message = `Unmapped PascalCase conditional props detected: {table.concat(v6, ", ")}. These props will not reach the camelCase component.`
									},
									data.appPage
								)
							end

							parseProps(
								componentType,
								conditionalProp.propOverrides,
								name,
								data,
								p2,
								nil,
								SduiBuilderProcessingPhase.Eager
							)
						end
					end

					local propInterface = data.componentDefinitions:getPropInterface(componentType)

					if propInterface then
						local v5, message = validateInterface(v2.props, propInterface)

						if not v5 then
							data.dependencies.logger.reportError(
								SduiErrorType.InvalidProps,
								{ componentType = componentType, name = name, message = message },
								data.appPage
							)
							instrumentation:stopTimerFlow("EagerProcess", data, true)
							return false, p
						end
					end

					v2.__processed = true

					instrumentation:stopTimerFlow("EagerProcess", data)
					return true, v2
				end

				data.dependencies.logger.reportError(
					SduiErrorType.InvalidComponentConfig,
					{
						message = `(Eager) Invalid config for component. err: {v4}`,
						componentType = componentType,
						name = name,
						value = v2
					},
					data.appPage
				)
				instrumentation:stopTimerFlow("EagerProcess", data, true)
				return false, p
			end
		end
	else
		data.dependencies.logger.reportError(SduiErrorType.NilComponentConfig, { name = name }, data.appPage)
		instrumentation:stopTimerFlow("EagerProcess", data, true)
		return false, p
	end
end

return SduiBuilder
