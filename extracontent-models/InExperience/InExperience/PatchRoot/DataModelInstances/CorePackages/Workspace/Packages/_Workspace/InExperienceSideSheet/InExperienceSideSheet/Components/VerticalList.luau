local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent

require(InExperienceSideSheetParent.Chrome)

local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)

require(InExperienceSideSheetParent.Signals)

local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local View = Foundation.View
local VerticalItem = require(InExperienceSideSheet.Components.VerticalItem)
local FFlagSideSheetFocusNav = require(InExperienceSideSheetParent.SharedFlags).FFlagSideSheetFocusNav

local function VerticalList(t1: {[any]: any}) -- line: 25
	-- upvalues: SignalsReact (copy), React (copy), VerticalItem (copy), FFlagSideSheetFocusNav (copy), View (copy)
	local integrationsGetter = t1.integrationsGetter
	local t2 = {}

	for v13, v14 in (SignalsReact.useSignalState(integrationsGetter)) do
		t2[v14.id] = React.createElement(VerticalItem, {
			label = v14.integration.label,
			layoutOrder = v13,
			onActivated = v14.activated,
			icon = v14.component,
			disableGamepadDirections = if not FFlagSideSheetFocusNav then nil else {
				right = true,
				left = true
			},
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v13 ~= 1 then nil else t1.firstIntegrationToFocusCallback
		})
	end

	return React.createElement(View, {
		tag = "col size-full-0 auto-y padding-y-xsmall padding-right-xlarge",
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(VerticalList)
