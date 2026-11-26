local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")

local infoTable = AppBlox.InfoTable
local view = Foundation.View
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local function SduiInfoTable(props)
	local layoutOrder = props.layoutOrder

	local v5 = not (props.numColumns and props.numColumns > 0) and 1 or props.numColumns
	local count = #props.items

	local v6 = math.ceil(count / v5)
	local children = {}

	for k, item in props.items do
		local sduiComponentWrapper = getSduiComponentWrapper(item)

		local v7 = math.floor((k - 1) / v6) + 1
		local v8 = ((k - 1) % v6 + 1 - 1) * v5 + v7

		local createElement = React.createElement
		local v9 = {
			componentConfig = item,
			sduiContext = props.sduiContext,
			parentAnalyticsContext = props.analyticsContext,
			extraLocalProps = 0
		}
		local v10 = {
			numColumns = props.numColumns,
			isLastInSingleColumn = 0,
			selectionOrder = 0
		}
		local v11 = if v5 == 1 then k == count else nil
		v10.isLastInSingleColumn = v11
		v10.selectionOrder = v8
		v9.extraLocalProps = v10
		children[k] = createElement(sduiComponentWrapper, v9)
	end

	local createElement = React.createElement
	local v9

	if props.tag then
		v9 = {}
		v9[props.tag] = true
		v9["col size-full-0 auto-y"] = true
	else
		v9 = { ["col size-full-0 auto-y"] = true }
	end

	local v11 = if props.headerComponent then React.cloneElement(props.headerComponent, {
		layoutOrder = 1
	}) else nil
	return createElement(view, { tag = v9, LayoutOrder = layoutOrder }, {
		Header = v11,
		Content = React.createElement(infoTable, {
			LayoutOrder = 2,
			numColumns = props.numColumns,
			gridTag = props.gridTag,
			items = children
		})
	})
end

return React.memo(SduiInfoTable)
