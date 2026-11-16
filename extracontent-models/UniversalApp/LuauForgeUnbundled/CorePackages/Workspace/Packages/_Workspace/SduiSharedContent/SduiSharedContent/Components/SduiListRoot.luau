local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiErrorPaths

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields

local list = Foundation.List
local inputSize = Foundation.Enums.InputSize

local frozen = table.freeze({})

local function SduiListRoot(props)
	local children = {}

	for k, v5 in props.items or frozen do
		local componentType = sduiBuilder.getComponentType(v5, props.sduiContext)

		if componentType then
			local sduiComponentWrapper = getSduiComponentWrapper(v5)

			local formatted = `Item_{k}_{componentType}`
			local createElement = React.createElement
			local v6 = {
				LayoutOrder = k,
				componentConfig = v5,
				sduiContext = props.sduiContext,
				extraLocalProps = { index = k, layoutOrder = k },
				debugName = 0,
				localAnalyticsData = 0
			}

			local v7 = if props.debugName then `{props.debugName}.Item_{k}` else `Item_{k}`
			v6.debugName = v7
			v6.localAnalyticsData = {
				itemPosition = k,
				itemComponentType = componentType,
				componentType = componentType
			}
			children[formatted] = createElement(sduiComponentWrapper, v6)
		else
			local v6 = {
				name = props.debugName,
				message = `Nil componentType in SduiListRoot at index {k}`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v6, v5.errorContext)
			end

			props.sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilComponentType,
				v6,
				props.sduiContext.appPage
			)
		end
	end

	local v5 = props.hasDivider ~= false and {
		hasDivider = true,
		isInset = props.isInset ~= false
	} or false

	local v6 = props.isContained and true or {
		isContained = false,
		hasMargin = props.hasMargin ~= false
	}

	return React.createElement(list.Root, {
		size = props.size or inputSize.Medium,
		hasDivider = v5,
		isContained = v6,
		LayoutOrder = props.layoutOrder,
		testId = props.testId
	}, children)
end

return React.memo(SduiListRoot)
