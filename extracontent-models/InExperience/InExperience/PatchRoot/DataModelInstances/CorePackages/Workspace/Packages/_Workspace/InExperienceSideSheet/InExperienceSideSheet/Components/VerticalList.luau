local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent

require(InExperienceSideSheetParent.Chrome)

local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)

require(InExperienceSideSheetParent.Signals)

local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local View = Foundation.View
local VerticalItem = require(InExperienceSideSheet.Components.VerticalItem)

local function VerticalList(t1: {[any]: any}) -- line: 21
	-- upvalues: SignalsReact (copy), React (copy), VerticalItem (copy), View (copy)
	local integrationsGetter = t1.integrationsGetter
	local t2 = {}

	for v12, v13 in (SignalsReact.useSignalState(integrationsGetter)) do
		t2[v13.id] = React.createElement(VerticalItem, {
			label = v13.integration.label,
			layoutOrder = v12,
			onActivated = v13.activated,
			icon = v13.component
		})
	end

	return React.createElement(View, {
		tag = "col size-full-0 auto-y padding-y-xsmall padding-right-xlarge",
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(VerticalList)
