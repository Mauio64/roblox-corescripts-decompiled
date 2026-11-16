local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local AppBlox = require(parent.AppBlox)
local Foundation = require(parent.Foundation)

local InfoTable = AppBlox.InfoTable
local View = Foundation.View
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local function SduiInfoTable(props)
	local layoutOrder = props.layoutOrder

	local v = not (props.numColumns and props.numColumns > 0) and 1 or props.numColumns
	local count = #props.items

	local v2 = math.ceil(count / v)
	local children = {}

	for k, item in props.items do
		local sduiComponentWrapper = getSduiComponentWrapper(item)

		local v3 = math.floor((k - 1) / v2) + 1
		local selectionOrder = ((k - 1) % v2 + 1 - 1) * v + v3

		local createElement = React.createElement
		local v4 = {
			componentConfig = item,
			sduiContext = props.sduiContext,
			parentAnalyticsContext = props.analyticsContext,
			extraLocalProps = 0
		}
		local extraLocalProps = {
			numColumns = props.numColumns,
			isLastInSingleColumn = 0,
			selectionOrder = 0
		}
		local isLastInSingleColumn

		if v == 1 then
			isLastInSingleColumn = k == count
		end

		extraLocalProps.isLastInSingleColumn = isLastInSingleColumn
		extraLocalProps.selectionOrder = selectionOrder
		v4.extraLocalProps = extraLocalProps
		children[k] = createElement(sduiComponentWrapper, v4)
	end

	local createElement = React.createElement
	local tag

	if props.tag then
		tag = {}
		tag[props.tag] = true
		tag["col size-full-0 auto-y"] = true
	else
		tag = { ["col size-full-0 auto-y"] = true }
	end

	local header

	if props.headerComponent then
		header = React.cloneElement(props.headerComponent, { layoutOrder = 1 })
	end

	return createElement(View, { tag = tag, LayoutOrder = layoutOrder }, {
		Header = header,
		Content = React.createElement(InfoTable, {
			LayoutOrder = 2,
			numColumns = props.numColumns,
			gridTag = props.gridTag,
			items = children
		})
	})
end

return React.memo(SduiInfoTable)
