local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SignalsReact")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/tutils")

local compareSduiProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/compareSduiProps")
local sduiErrorType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors").SduiErrorType
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local getSduiComponentRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/getSduiComponentRegistry")
local validateInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/validateInterface")
local createSduiErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/createSduiErrorLogger")

local function SduiErrorComponent(p2)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 100)
	})
end

local v5 = {}

local function useComponentSduiContext(p2)
	local sduiContext = p2.sduiContext
	local errorContext = p2.componentConfig.errorContext
	return React.useMemo(function()
		local clone = table.clone(sduiContext)
		clone.dependencies = table.clone(sduiContext.dependencies)
		clone.dependencies.logger = createSduiErrorLogger(sduiContext.dependencies.logger, errorContext or v5)
		return clone
	end, { sduiContext, errorContext })
end

local function buildWrappedComponent(callback, props, sduiContext, items)
	local componentType = props.componentConfig.componentType

	if props.localAnalyticsData then
		props.componentConfig.analyticsContext.setLocalAnalyticsData(props.localAnalyticsData)
	end

	local children = not props.componentConfig.props and {} or table.clone(props.componentConfig.props)
	local v6

	if props.componentConfig.nestedComponentConfigListPropSignalNames then
		v6 = props.componentConfig.nestedComponentConfigListPropSignalNames
	else
		v6 = v5
	end

	if items then
		for k, item in items do
			if not (item.isNestedComponentConfig or v6[k]) then
				children[k] = item.data
			end
		end
	end

	if props.extraLocalProps then
		for k, extraLocalProp in props.extraLocalProps do
			children[k] = extraLocalProp
		end
	end

	children.componentConfig = props.componentConfig
	children.sduiContext = sduiContext
	children.debugName = props.debugName
	children.analyticsContext = props.componentConfig.analyticsContext

	local data = nil

	if items then
		for k, item in items do
			if not item.isNestedComponentConfig then
				continue
			end

			if data == nil then
				data = not props.componentConfig.nestedComponentConfigs and {}
					or table.clone(props.componentConfig.nestedComponentConfigs)
			end

			data[k] = item.data
		end
	end

	local v7 = data or props.componentConfig.nestedComponentConfigs

	if v7 then
		for k, v8 in v7 do
			local v9 = callback(v8)
			children[k] = React.createElement(v9, {
				sduiContext = sduiContext,
				componentConfig = v8,
				debugName = `{props.debugName}.{k}`
			})
		end
	end

	if items and next(v6) then
		for k in v6 do
			local item = items[k]

			if not item then
				continue
			end

			local data2 = item.data

			if not data2 then
				continue
			end

			local children2 = {}

			for k2, v8 in data2 do
				local v9 = callback(v8)

				children2[`{k}_{k2}_{v8.componentType}`] = React.createElement(v9, {
					sduiContext = sduiContext,
					componentConfig = v8,
					extraLocalProps = { layoutOrder = k2 },
					debugName = `{props.debugName}.{k}[{k2}]`
				})
			end

			children[k] = children2
		end
	end

	local componentDefinition = getSduiComponentRegistry().getComponentDefinition(componentType)
	local component = if componentDefinition then componentDefinition.component or nil else nil

	if component == nil then
		sduiContext.dependencies.logger.reportError(
			sduiErrorType.NoComponentRegistered,
			{ componentType = componentType, name = props.debugName },
			sduiContext.appPage
		)
		return React.createElement(SduiErrorComponent)
	end

	local propInterface = componentDefinition and componentDefinition.propInterface

	if propInterface and not validateInterface(children, propInterface) then
		return nil
	end

	return React.createElement(component, children)
end

local function createSduiClientBindingWrappers(p2)
	return {
		SduiClientBindingThinWrapper = React.memo(function(p3)
			local v6 = p3.sduiContext

			if fFlagSduiErrorPaths then
				v6 = useComponentSduiContext(p3)
			end

			return buildWrappedComponent(p2, p3, v6)
		end, compareSduiProps),
		SduiDataBindingWrapper = React.memo(function(data)
			local v6 = data.sduiContext

			if fFlagSduiErrorPaths then
				v6 = useComponentSduiContext(data)
			end

			local propSignals = data.componentConfig.propSignals
			local isComponentFilteredSignal = data.componentConfig.isComponentFilteredSignal
			local extraLocalPropSignals = data.extraLocalPropSignals

			local v7 = React.useMemo(function()
				assert(
					propSignals or isComponentFilteredSignal or extraLocalPropSignals,
					"propSignals, isComponentFilteredSignal, or extraLocalPropSignals must exist"
				)

				return Signals.createComputed(function(p3)
					local result = {}

					if propSignals then
						for k, propSignal in propSignals do
							result[k] = propSignal(p3)
						end
					end

					if extraLocalPropSignals then
						for k, extraLocalPropSignal in extraLocalPropSignals do
							result[k] = { data = extraLocalPropSignal(p3) }
						end
					end

					if isComponentFilteredSignal and isComponentFilteredSignal(p3).data == true then
						result.__isComponentFiltered = true
					end

					return result
				end, tutils.shallowEqual)
			end, {
				propSignals,
				isComponentFilteredSignal,
				extraLocalPropSignals,
				data.componentConfig.componentType
			})

			local v8 = SignalsReact.useSignalState(v7)

			if v8.__isComponentFiltered == true then
				return nil
			end

			return buildWrappedComponent(p2, data, v6, v8)
		end, compareSduiProps)
	}
end

return createSduiClientBindingWrappers
