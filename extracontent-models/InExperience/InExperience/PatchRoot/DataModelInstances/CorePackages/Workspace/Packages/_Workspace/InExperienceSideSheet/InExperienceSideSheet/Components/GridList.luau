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
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav

local function GridList(t1: {[any]: any}) -- line: 28
	-- upvalues: SignalsReact (copy), React (copy), GridItem (copy), FFlagSideSheetFocusNav (copy), FFlagChromeActivatedMappedSignal (copy), View (copy)
	local v13 = SignalsReact.useSignalState(t1.integrationsGetter)
	local t2 = {}

	for v15, v16 in v13 do
		t2[v16.id] = React.createElement(GridItem, {
			icon = v16.component,
			label = v16.integration.label,
			layoutOrder = v15,
			notification = v16.integration.notification,
			onActivated = v16.activated,
			disableGamepadDirections = if not FFlagSideSheetFocusNav or v15 ~= #v13 then nil else {
				right = true
			},
			isActivated = if not FFlagChromeActivatedMappedSignal then nil else v16.integration.isActivated,
			firstIntegrationToFocusCallback = if not FFlagSideSheetFocusNav or v15 ~= 1 then nil else t1.firstIntegrationToFocusCallback
		})
	end

	return React.createElement(View, {
		tag = "row wrap gap-medium size-full-0 auto-y padding-y-large",
		LayoutOrder = t1.layoutOrder,
		ref = if not FFlagSideSheetFocusNav then nil else t1.ref
	}, t2)
end

return React.memo(GridList)
