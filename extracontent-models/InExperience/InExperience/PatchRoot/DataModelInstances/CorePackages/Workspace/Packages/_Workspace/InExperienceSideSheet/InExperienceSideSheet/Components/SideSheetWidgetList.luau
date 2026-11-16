local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent

require(parent.Chrome)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View

local SharedFlags = require(parent.SharedFlags)
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav

local function SideSheetWidgetList(props)
	local v = SignalsReact.useSignalState(props.integrationsGetter)

	if #v == 0 then
		return nil
	end

	local children = {}

	for k, v2 in v do
		local id = v2.id
		local createElement = React.createElement
		local component = v2.component
		local v3 = {
			layoutOrder = k,
			placement = props.placement,
			firstIntegrationToFocusCallback = 0
		}
		local firstIntegrationToFocusCallback

		if FFlagSideSheetFocusNav and k == 1 then
			firstIntegrationToFocusCallback = props.firstIntegrationToFocusCallback
		end

		v3.firstIntegrationToFocusCallback = firstIntegrationToFocusCallback
		children[id] = createElement(component, v3)
	end

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = props.layoutOrder
	}, children)
end

return React.memo(SideSheetWidgetList)
