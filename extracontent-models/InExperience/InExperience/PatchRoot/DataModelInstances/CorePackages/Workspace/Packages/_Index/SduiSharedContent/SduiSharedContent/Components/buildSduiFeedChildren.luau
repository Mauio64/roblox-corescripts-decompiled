local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local SduiSharedContentParent = SduiSharedContent.Parent
local React = require(SduiSharedContentParent.React)
local Cryo = require(SduiSharedContentParent.Cryo)
local SduiCoreSystem = require(SduiSharedContentParent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiFeedItem = require(SduiSharedContent.Components.SduiFeedItem)
local FFlagSduiPoolBackedFeed = require(SduiSharedContentParent.SharedFlags).FFlagSduiPoolBackedFeed
local v12 = game:DefineFastFlag("SduiFeedIndexInExtraLocalProps", false)
local t1 = {}

local function buildSduiFeedChildren(t2: {[any]: any}) -- line: 42
	-- upvalues: findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), SduiErrors (copy), getSduiComponentWrapper (copy), FFlagSduiPoolBackedFeed (copy), Cryo (copy), v12 (copy), React (copy), SduiFeedItem (copy)
	local t3 = {}
	local sduiContext = t2.sduiContext
	local v18 = t2.extraLocalProps and t2.extraLocalProps.startRow
	local v19 = typeof(v18) ~= "number" and 1 or v18
	local maxConfigs = t2.maxConfigs

	for v21, v22 in t2.configs do
		if maxConfigs ~= nil and maxConfigs < v21 then
			return t3
		end

		local v23 = findAnalyticsField("componentType", v22.analyticsData or t1) or SduiBuilder.getComponentType(v22, sduiContext)

		if not v23 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentType, {
				componentType = t2.componentType,
				name = t2.debugName,
				message = `Nil componentType in { t2.componentType } at index { v21 }`
			}, sduiContext.appPage)
		else
			local v24 = `{ t2.componentType }{ v21 }_{ v23 }`
			local v25 = getSduiComponentWrapper(v22)
			local t4 = {
				feedItemPosition = v21,
				itemComponentType = v23,
				componentType = v23,
				collectionPosition = v21
			}
			local v27 = nil
			local extraLocalProps = t2.extraLocalProps
			local v31

			if FFlagSduiPoolBackedFeed then
				local startRowGetter = v22.startRowGetter

				v27 = if startRowGetter == nil then nil else {
					startRow = startRowGetter
				}

				local v30 = if startRowGetter == nil then v19 + v21 - 1 else Cryo.None

				v31 = Cryo.Dictionary.join(t2.extraLocalProps or t1, {
					startRow = v30
				})
			else
				v31 = Cryo.Dictionary.join(extraLocalProps, {
					startRow = v19 + v21 - 1
				})
			end

			if v12 then
				v31 = Cryo.Dictionary.join(v31, {
					index = v21
				})
			end

			local v32 = React.createElement(v25, {
				debugName = v24,
				componentConfig = v22,
				sduiContext = sduiContext,
				localAnalyticsData = t4,
				extraLocalProps = v31,
				extraLocalPropSignals = if not FFlagSduiPoolBackedFeed then nil else v27
			})
			local v33 = if not v22.props or v22.props.layoutOrder == nil then v21 else v22.props.layoutOrder
			local v34 = if not v22.props or v22.props.zIndex == nil then -v21 else v22.props.zIndex
			local v35 = if not t2.negateImpressionIndex then v21 else -v21

			t3[v24] = React.createElement(SduiFeedItem, {
				layoutOrder = v33,
				zIndex = v34,
				index = v35,
				impressionsTag = t2.impressionsTag,
				selectionBehaviorLeft = t2.selectionBehaviorLeft,
				selectionBehaviorRight = t2.selectionBehaviorRight
			}, {
				Item = v32
			})
		end
	end

	return t3
end

return buildSduiFeedChildren
