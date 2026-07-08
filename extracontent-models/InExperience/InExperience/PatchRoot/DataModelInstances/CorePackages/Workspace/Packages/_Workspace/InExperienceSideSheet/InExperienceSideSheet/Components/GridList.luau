local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent

require(InExperienceSideSheetParent.Chrome)

local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local SharedFlags = require(InExperienceSideSheetParent.SharedFlags)

require(InExperienceSideSheetParent.Signals)

local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local View = Foundation.View
local GridItem = require(InExperienceSideSheet.Components.GridItem)
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal

local function GridList(t1: {[any]: any}) -- line: 25
	-- upvalues: SignalsReact (copy), React (copy), GridItem (copy), FFlagChromeActivatedMappedSignal (copy), View (copy)
	local t2 = {}

	for v13, v14 in (SignalsReact.useSignalState(t1.integrationsGetter)) do
		t2[v14.id] = React.createElement(GridItem, {
			icon = v14.component,
			label = v14.integration.label,
			layoutOrder = v13,
			notification = v14.integration.notification,
			onActivated = v14.activated,
			isActivated = if not FFlagChromeActivatedMappedSignal then nil else v14.integration.isActivated
		})
	end

	return React.createElement(View, {
		tag = "row wrap gap-medium size-full-0 auto-y padding-y-large",
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(GridList)
