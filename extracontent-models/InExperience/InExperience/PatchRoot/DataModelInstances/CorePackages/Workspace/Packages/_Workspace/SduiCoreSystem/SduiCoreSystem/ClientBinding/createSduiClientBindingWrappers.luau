local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local tutils = require(parent.tutils)

local compareSduiProps = require(SduiCoreSystem.compareSduiProps)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiErrorType = SduiErrors.SduiErrorType
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)
require(SduiCoreSystem.SduiComponentType)
local getSduiComponentRegistry = require(SduiCoreSystem.getSduiComponentRegistry)
local validateInterface = require(SduiCoreSystem.validateInterface)
local createSduiErrorLogger = require(SduiCoreSystem.createSduiErrorLogger)

local function SduiErrorComponent(_)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 100)
	})
end

local v = {}

local function useComponentSduiContext(p)
	local sduiContext = p.sduiContext
	local errorContext = p.componentConfig.errorContext
	return React.useMemo(function()
		local clone = table.clone(sduiContext)
		clone.dependencies = table.clone(sduiContext.dependencies)
		clone.dependencies.logger = createSduiErrorLogger(sduiContext.dependencies.logger, errorContext or v)
		return clone
	end, { sduiContext, errorContext })
end

local function buildWrappedComponent(callback, props, sduiContext, items)
	local componentType = props.componentConfig.componentType

	if props.localAnalyticsData then
		props.componentConfig.analyticsContext.setLocalAnalyticsData(props.localAnalyticsData)
	end

	local children = not props.componentConfig.props and {} or table.clone(props.componentConfig.props)
	local v2

	if props.componentConfig.nestedComponentConfigListPropSignalNames then
		v2 = props.componentConfig.nestedComponentConfigListPropSignalNames
	else
		v2 = v
	end

	if items then
		for k, item in items do
			if not (item.isNestedComponentConfig or v2[k]) then
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

	local v3 = data or props.componentConfig.nestedComponentConfigs

	if v3 then
		for k, componentConfig in v3 do
			local v4 = callback(componentConfig)
			children[k] = React.createElement(v4, {
				sduiContext = sduiContext,
				componentConfig = componentConfig,
				debugName = `{props.debugName}.{k}`
			})
		end
	end

	if items and next(v2) then
		for k in v2 do
			local item = items[k]

			if not item then
				continue
			end

			local data2 = item.data

			if not data2 then
				continue
			end

			local children2 = {}

			for k2, componentConfig in data2 do
				local v4 = callback(componentConfig)

				children2[`{k}_{k2}_{componentConfig.componentType}`] = React.createElement(v4, {
					sduiContext = sduiContext,
					componentConfig = componentConfig,
					extraLocalProps = { layoutOrder = k2 },
					debugName = `{props.debugName}.{k}[{k2}]`
				})
			end

			children[k] = children2
		end
	end

	local componentDefinition = getSduiComponentRegistry().getComponentDefinition(componentType)
	local component

	if componentDefinition then
		component = componentDefinition.component or nil
	end

	if component == nil then
		sduiContext.dependencies.logger.reportError(
			SduiErrorType.NoComponentRegistered,
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

local function createSduiClientBindingWrappers(callback)
	return {
		SduiClientBindingThinWrapper = React.memo(function(p)
			local v2 = p.sduiContext

			if FFlagSduiErrorPaths then
				v2 = useComponentSduiContext(p)
			end

			return buildWrappedComponent(callback, p, v2)
		end, compareSduiProps),
		SduiDataBindingWrapper = React.memo(function(data)
			local v2 = data.sduiContext

			if FFlagSduiErrorPaths then
				v2 = useComponentSduiContext(data)
			end

			local propSignals = data.componentConfig.propSignals
			local isComponentFilteredSignal = data.componentConfig.isComponentFilteredSignal
			local extraLocalPropSignals = data.extraLocalPropSignals

			local v3 = React.useMemo(function()
				assert(
					propSignals or isComponentFilteredSignal or extraLocalPropSignals,
					"propSignals, isComponentFilteredSignal, or extraLocalPropSignals must exist"
				)

				return Signals.createComputed(function(p)
					local result = {}

					if propSignals then
						for k, propSignal in propSignals do
							result[k] = propSignal(p)
						end
					end

					if extraLocalPropSignals then
						for k, extraLocalPropSignal in extraLocalPropSignals do
							result[k] = { data = extraLocalPropSignal(p) }
						end
					end

					if isComponentFilteredSignal and isComponentFilteredSignal(p).data == true then
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

			local v4 = SignalsReact.useSignalState(v3)

			if v4.__isComponentFiltered == true then
				return nil
			end

			return buildWrappedComponent(callback, data, v2, v4)
		end, compareSduiProps)
	}
end

return createSduiClientBindingWrappers
