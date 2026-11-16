local parent = script:FindFirstAncestor("SduiSharedContent").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields

local Accordion = Foundation.Accordion

local frozen = table.freeze({})

local function SduiAccordion(props)
	local children = {}

	for k, componentConfig in props.items or frozen do
		local componentType = SduiBuilder.getComponentType(componentConfig, props.sduiContext)

		if componentType then
			local sduiComponentWrapper = getSduiComponentWrapper(componentConfig)

			local formatted = `Item_{k}_{componentType}`
			local createElement = React.createElement
			local v = {
				componentConfig = componentConfig,
				sduiContext = props.sduiContext,
				extraLocalProps = { index = k, layoutOrder = k },
				debugName = 0,
				localAnalyticsData = 0
			}
			local debugName

			if props.debugName then
				debugName = `{props.debugName}.Item_{k}`
			else
				debugName = `Item_{k}`
			end

			v.debugName = debugName
			v.localAnalyticsData = {
				itemPosition = k,
				itemComponentType = componentType,
				componentType = componentType
			}
			children[formatted] = createElement(sduiComponentWrapper, v)
		else
			local v = {
				name = props.debugName,
				message = `Nil componentType in SduiAccordion at index {k}`
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v, componentConfig.errorContext)
			end

			props.sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilComponentType,
				v,
				props.sduiContext.appPage
			)
		end
	end

	return React.createElement(Accordion.Root, {
		size = props.size,
		isContained = props.isContained,
		chevronPosition = props.chevronPosition,
		LayoutOrder = props.layoutOrder,
		testId = props.testId
	}, children)
end

return React.memo(SduiAccordion)
