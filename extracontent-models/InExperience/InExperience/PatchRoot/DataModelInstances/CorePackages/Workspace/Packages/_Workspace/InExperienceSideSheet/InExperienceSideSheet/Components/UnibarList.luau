local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local parent = InExperienceSideSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View

local GetIntegrationsStore = require(InExperienceSideSheet.Stores.GetIntegrationsStore)
local UnibarItem = require(InExperienceSideSheet.Components.UnibarItem)

local SharedFlags = require(parent.SharedFlags)
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav

local function getIntegrations(p)
	return GetIntegrationsStore(p).getUnibarIntegrations(p)
end

local function UnibarList(p)
	local v = SignalsReact.useSignalState(getIntegrations)

	if #v == 0 then
		return nil
	end

	local children = {}

	for k, v2 in v do
		children[v2.id] = React.createElement(UnibarItem, {
			label = v2.integration.label,
			layoutOrder = k,
			onActivated = v2.activated,
			icon = v2.component,
			notification = v2.integration.notification,
			disableGamepadDirections = FFlagSideSheetFocusNav and k == 1 and { left = true } or nil
		})
	end

	return React.createElement(
		View,
		{ tag = "auto-xy row gap-xsmall align-y-center", LayoutOrder = p.layoutOrder },
		children
	)
end

return React.memo(UnibarList)
