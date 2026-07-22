local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local React = require(InExperienceSideSheetParent.React)
local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local View = require(InExperienceSideSheetParent.Foundation).View
local FFlagEnableWhatsNew = require(InExperienceSideSheetParent.SharedFlags).FFlagEnableWhatsNew
local v7 = if not FFlagEnableWhatsNew then nil else require(InExperienceSideSheetParent.WhatsNew).WhatsNewAnchor
local ShortcutButton = require(InExperienceSideSheet.Components.ShortcutButton)
local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)
local GetSessionActionButtonsStore = require(InExperienceSideSheet.Stores.GetSessionActionButtonsStore)

local function getIsHeightSmall(p1) -- line: 26
	-- upvalues: GetSideSheetConfigStore (copy)
	return GetSideSheetConfigStore(p1).getIsHeightSmall(p1)
end
local function getSessionActionButtonConfigs(p2) -- line: 30
	-- upvalues: GetSessionActionButtonsStore (copy)
	return GetSessionActionButtonsStore(p2).sessionActionButtonConfigs
end
local function SessionActionButtons(t1: {[any]: any}) -- line: 34
	-- upvalues: SignalsReact (copy), getIsHeightSmall (copy), getSessionActionButtonConfigs (copy), React (copy), ShortcutButton (copy), View (copy), FFlagEnableWhatsNew (copy), v7 (copy)
	local v17 = SignalsReact.useSignalState(getIsHeightSmall)
	local t2 = {}

	for v19, v20 in (SignalsReact.useSignalState(getSessionActionButtonConfigs)) do
		t2[v20.name] = React.createElement(ShortcutButton, {
			label = v20.label,
			getShortcutIcon = v20.getShortcutIcon,
			getOnActivated = v20.getOnActivated,
			getIsEnabled = v20.getIsEnabled,
			isEmphasis = v20.isEmphasis,
			isSmall = v17,
			layoutOrder = v19
		})
	end

	local v21 = React.createElement(View, {
		tag = "size-full-0 auto-y row gap-small",
		LayoutOrder = t1.layoutOrder
	}, t2)

	if FFlagEnableWhatsNew then
		return React.createElement(v7, {
			anchorId = "LeaveRespawn",
			LayoutOrder = t1.layoutOrder
		}, {
			SessionActions = v21
		})
	end

	return v21
end

return React.memo(SessionActionButtons)
