local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local View = Foundation.View
local GetIntegrationsStore = require(InExperienceSideSheet.Stores.GetIntegrationsStore)
local UnibarItem = require(InExperienceSideSheet.Components.UnibarItem)
local FFlagSideSheetFocusNav = require(InExperienceSideSheetParent.SharedFlags).FFlagSideSheetFocusNav

local function getIntegrations(p1) -- line: 21
	-- upvalues: GetIntegrationsStore (copy)
	return GetIntegrationsStore(p1).getUnibarIntegrations(p1)
end
local function UnibarList(t1: {[any]: any}) -- line: 26
	-- upvalues: SignalsReact (copy), getIntegrations (copy), React (copy), UnibarItem (copy), FFlagSideSheetFocusNav (copy), View (copy)
	local v14 = SignalsReact.useSignalState(getIntegrations)

	if #v14 == 0 then
		return nil
	end

	local t2 = {}

	for v16, v17 in v14 do
		t2[v17.id] = React.createElement(UnibarItem, {
			label = v17.integration.label,
			layoutOrder = v16,
			onActivated = v17.activated,
			icon = v17.component,
			notification = v17.integration.notification,
			disableGamepadDirections = if not FFlagSideSheetFocusNav or v16 ~= 1 then nil else {
				left = true
			}
		})
	end

	return React.createElement(View, {
		tag = "auto-xy row gap-xsmall align-y-center",
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(UnibarList)
