local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local view = Foundation.View
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local function SduiActionBar(props)
	if props.items == nil or #props.items == 0 then
		return nil
	end

	local children = {}

	for k, item in props.items do
		local sduiComponentWrapper = getSduiComponentWrapper(item)
		children["item_" .. tostring(k)] = React.createElement(sduiComponentWrapper, {
			componentConfig = item,
			sduiContext = props.sduiContext,
			extraLocalProps = { layoutOrder = k }
		})
	end

	if props.footer == nil then
		return React.createElement(view, {
			tag = props.rowTag or "row size-full-0 auto-y gap-small",
			size = props.size,
			anchorPoint = props.anchorPoint,
			position = props.position,
			LayoutOrder = props.layoutOrder,
			testId = props.testId
		}, children)
	end

	local element = React.createElement(view, {
		tag = props.rowTag or "row size-full-0 auto-y gap-small",
		layoutOrder = 1
	}, children)

	return React.createElement(view, {
		tag = props.wrapperTag or "col size-full-0 auto-y gap-small",
		size = props.size,
		anchorPoint = props.anchorPoint,
		position = props.position,
		LayoutOrder = props.layoutOrder,
		testId = props.testId
	}, { ItemsRow = element, Footer = props.footer })
end

return React.memo(SduiActionBar)
