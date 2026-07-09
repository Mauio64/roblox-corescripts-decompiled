local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local View = Foundation.View
local GetIntegrationsStore = require(InExperienceSideSheet.Stores.GetIntegrationsStore)
local UnibarItem = require(InExperienceSideSheet.Components.UnibarItem)

local function getIntegrations(p1) -- line: 18
	-- upvalues: GetIntegrationsStore (copy)
	return GetIntegrationsStore(p1).getUnibarIntegrations(p1)
end
local function UnibarList(t1: {[any]: any}) -- line: 23
	-- upvalues: SignalsReact (copy), getIntegrations (copy), React (copy), UnibarItem (copy), View (copy)
	local v13 = SignalsReact.useSignalState(getIntegrations)

	if #v13 == 0 then
		return nil
	end

	local t2 = {}

	for v15, v16 in v13 do
		t2[v16.id] = React.createElement(UnibarItem, {
			label = v16.integration.label,
			layoutOrder = v15,
			onActivated = v16.activated,
			icon = v16.component,
			notification = v16.integration.notification
		})
	end

	return React.createElement(View, {
		tag = "auto-xy row gap-xsmall align-y-center",
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(UnibarList)
