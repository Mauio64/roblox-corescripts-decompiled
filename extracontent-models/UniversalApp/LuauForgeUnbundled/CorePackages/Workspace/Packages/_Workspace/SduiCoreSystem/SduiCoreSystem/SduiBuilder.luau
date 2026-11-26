local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/tutils")

local sduiBuilderProcessingPhase = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes").SduiBuilderProcessingPhase
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local SduiConfigTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local sduiErrorType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors").SduiErrorType
local parseProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/parseProps")
local validateInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/validateInterface")
local uiComponentInterface = SduiConfigTypes.UiComponentInterface

local SduiCompat = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCompat")
local mapServerBindingProps = SduiCompat.mapServerBindingProps
local serverBindingPropMap = SduiCompat.ServerBindingPropMap
local SduiUsageRecorder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/SduiUsageRecorder")
local recordV1ComponentUsage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/recordV1ComponentUsage")

local v5 = {}

return {
	getComponentType = function(p2, p3)
		if not p2.__isClientBinding and p3.templateRegistry:shouldResolveTemplate(p2) then
			p3.templateRegistry:resolveTemplateForConfig(p2, p3)
		end

		return p2.componentType
	end,
	buildAnalyticsContext = function(p2, p3, p4)
		local v6 = p3 or v5
		local analyticsData = p2.analyticsData or v5
		local joined = Cryo.Dictionary.join(v6.ancestorAnalyticsData or v5, v6.analyticsData or v5)

		local getCollectionData = v6.getCollectionData

		if p4 then
			analyticsData = Cryo.Dictionary.join(analyticsData, p4)
		end

		return {
			analyticsData = analyticsData,
			ancestorAnalyticsData = joined,
			getCollectionData = getCollectionData
		}
	end,
	tryCreateEagerProcessedComponentConfig = function(p2, data, p3, p4, p5)
		local instrumentation = data.dependencies.instrumentation
		instrumentation:startTimerFlow("EagerProcess")

		if p2 then
			assert(p2, "componentConfig must exist")

			if p2.__processed then
				data.dependencies.logger.reportError(
					sduiErrorType.EagerReprocessing,
					{
						message = "Eagerly evaluating a component that has already been processed",
						componentType = p2.componentType,
						name = p3
					},
					data.appPage
				)
				instrumentation:stopTimerFlow("EagerProcess", data, true)
				return true, p2
			else
				local v6 = if p5 then tutils.deepCopy(p2) else p2

				if data.templateRegistry:shouldResolveTemplate(v6) then
					local props = v6.props

					if props and props.itemTemplateKey then
						if props.items then
							for k, item in props.items do
								if item.templateKey == nil then
									item.templateKey = props.itemTemplateKey
								end
							end
						elseif props.item and props.item.templateKey == nil then
							props.item.templateKey = props.itemTemplateKey
						end
					end

					if not data.templateRegistry:resolveTemplateForConfig(v6, data) then
						instrumentation:stopTimerFlow("EagerProcess", data, true)
						return false, p2
					end
				end

				local componentType = v6.componentType

				if data.componentDefinitions:getComponent(componentType) == nil then
					data.dependencies.logger.reportError(
						sduiErrorType.NoComponentRegistered,
						{ componentType = componentType, name = p3 },
						data.appPage
					)
					instrumentation:stopTimerFlow("EagerProcess", data, true)
					return false, p2
				else
					local v7, v8 = validateInterface(v6, uiComponentInterface, false)

					if v7 then
						if v6.props then
							local v9, v10 = mapServerBindingProps(v6.props, serverBindingPropMap)

							if v9 then
								for k, v11 in v9 do
									v6.props[k] = v11
								end
							end

							if v10 then
								data.dependencies.logger.reportError(
									sduiErrorType.UnmappedServerBindingProp,
									{
										componentType = componentType,
										name = p3,
										message = `Unmapped PascalCase props detected: {table.concat(v10, ", ")}. These props will not reach the camelCase component.`
									},
									data.appPage
								)
							end
						end

						if not v6.__usageRecorded then
							recordV1ComponentUsage(data.appPage, v6)
							v6.__usageRecorded = true
							SduiUsageRecorder.scheduleFlush()
						end

						if v6.props then
							parseProps(
								componentType,
								v6.props,
								p3,
								data,
								p4,
								nil,
								sduiBuilderProcessingPhase.Eager
							)
						end

						if v6.conditionalProps then
							for k, conditionalProp in v6.conditionalProps do
								local v9, v10 = mapServerBindingProps(
									conditionalProp.propOverrides,
									serverBindingPropMap
								)

								if v9 then
									for k2, v11 in v9 do
										conditionalProp.propOverrides[k2] = v11
									end
								end

								if v10 then
									data.dependencies.logger.reportError(
										sduiErrorType.UnmappedServerBindingProp,
										{
											componentType = componentType,
											name = p3,
											message = `Unmapped PascalCase conditional props detected: {table.concat(v10, ", ")}. These props will not reach the camelCase component.`
										},
										data.appPage
									)
								end

								parseProps(
									componentType,
									conditionalProp.propOverrides,
									p3,
									data,
									p4,
									nil,
									sduiBuilderProcessingPhase.Eager
								)
							end
						end

						local propInterface = data.componentDefinitions:getPropInterface(componentType)

						if propInterface then
							local v9, v10 = validateInterface(v6.props, propInterface)

							if not v9 then
								data.dependencies.logger.reportError(
									sduiErrorType.InvalidProps,
									{
										componentType = componentType,
										name = p3,
										message = v10
									},
									data.appPage
								)
								instrumentation:stopTimerFlow("EagerProcess", data, true)
								return false, p2
							end
						end

						v6.__processed = true

						instrumentation:stopTimerFlow("EagerProcess", data)
						return true, v6
					end

					data.dependencies.logger.reportError(
						sduiErrorType.InvalidComponentConfig,
						{
							message = `(Eager) Invalid config for component. err: {v8}`,
							componentType = componentType,
							name = p3,
							value = v6
						},
						data.appPage
					)
					instrumentation:stopTimerFlow("EagerProcess", data, true)
					return false, p2
				end
			end
		else
			data.dependencies.logger.reportError(
				sduiErrorType.NilComponentConfig,
				{ name = p3 },
				data.appPage
			)
			instrumentation:stopTimerFlow("EagerProcess", data, true)
			return false, p2
		end
	end
}
