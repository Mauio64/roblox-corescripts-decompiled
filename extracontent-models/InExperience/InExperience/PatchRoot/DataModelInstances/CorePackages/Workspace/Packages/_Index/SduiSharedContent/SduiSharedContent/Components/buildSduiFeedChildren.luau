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
local v13 = game:DefineFastFlag("SduiFeedDebugNameWithImpressionsTag", false)
local t1 = {}

local function buildSduiFeedChildren(t2: {[any]: any}) -- line: 43
	-- upvalues: findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), SduiErrors (copy), getSduiComponentWrapper (copy), FFlagSduiPoolBackedFeed (copy), Cryo (copy), v12 (copy), React (copy), v13 (copy), SduiFeedItem (copy)
	local t3 = {}
	local sduiContext = t2.sduiContext
	local v19 = t2.extraLocalProps and t2.extraLocalProps.startRow
	local v20 = typeof(v19) ~= "number" and 1 or v19
	local maxConfigs = t2.maxConfigs

	for v22, v23 in t2.configs do
		if maxConfigs ~= nil and maxConfigs < v22 then
			return t3
		end

		local v24 = findAnalyticsField("componentType", v23.analyticsData or t1) or SduiBuilder.getComponentType(v23, sduiContext)

		if not v24 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentType, {
				componentType = t2.componentType,
				name = t2.debugName,
				message = `Nil componentType in { t2.componentType } at index { v22 }`
			}, sduiContext.appPage)
		else
			local v25 = `{ t2.componentType }{ v22 }_{ v24 }`
			local v26 = getSduiComponentWrapper(v23)
			local t4 = {
				feedItemPosition = v22,
				itemComponentType = v24,
				componentType = v24,
				collectionPosition = v22
			}
			local v28 = nil
			local extraLocalProps = t2.extraLocalProps
			local v32

			if FFlagSduiPoolBackedFeed then
				local startRowGetter = v23.startRowGetter

				v28 = if startRowGetter == nil then nil else {
					startRow = startRowGetter
				}

				local v31 = if startRowGetter == nil then v20 + v22 - 1 else Cryo.None

				v32 = Cryo.Dictionary.join(t2.extraLocalProps or t1, {
					startRow = v31
				})
			else
				v32 = Cryo.Dictionary.join(extraLocalProps, {
					startRow = v20 + v22 - 1
				})
			end

			if v12 then
				v32 = Cryo.Dictionary.join(v32, {
					index = v22
				})
			end

			local v33 = React.createElement(v26, {
				debugName = if not v13 or (t2.impressionsTag == nil or t2.impressionsTag == "") then v25 else `{ v25 }_{ t2.impressionsTag }`,
				componentConfig = v23,
				sduiContext = sduiContext,
				localAnalyticsData = t4,
				extraLocalProps = v32,
				extraLocalPropSignals = if not FFlagSduiPoolBackedFeed then nil else v28
			})
			local v34 = if not v23.props or v23.props.layoutOrder == nil then v22 else v23.props.layoutOrder
			local v35 = if not v23.props or v23.props.zIndex == nil then -v22 else v23.props.zIndex
			local v36 = if not t2.negateImpressionIndex then v22 else -v22

			t3[v25] = React.createElement(SduiFeedItem, {
				layoutOrder = v34,
				zIndex = v35,
				index = v36,
				impressionsTag = t2.impressionsTag,
				selectionBehaviorLeft = t2.selectionBehaviorLeft,
				selectionBehaviorRight = t2.selectionBehaviorRight
			}, {
				Item = v33
			})
		end
	end

	return t3
end

return buildSduiFeedChildren
