local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local React = require(InExperienceSideSheetParent.React)
local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local View = require(InExperienceSideSheetParent.Foundation).View
local ShortcutButton = require(InExperienceSideSheet.Components.ShortcutButton)
local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)
local GetSessionActionButtonsStore = require(InExperienceSideSheet.Stores.GetSessionActionButtonsStore)

local function getIsHeightSmall(p1) -- line: 19
	-- upvalues: GetSideSheetConfigStore (copy)
	return GetSideSheetConfigStore(p1).getIsHeightSmall(p1)
end
local function getSessionActionButtonConfigs(p2) -- line: 23
	-- upvalues: GetSessionActionButtonsStore (copy)
	return GetSessionActionButtonsStore(p2).sessionActionButtonConfigs
end
local function SessionActionButtons(t1: {[any]: any}) -- line: 27
	-- upvalues: SignalsReact (copy), getIsHeightSmall (copy), getSessionActionButtonConfigs (copy), React (copy), ShortcutButton (copy), View (copy)
	local v15 = SignalsReact.useSignalState(getIsHeightSmall)
	local t2 = {}

	for v17, v18 in (SignalsReact.useSignalState(getSessionActionButtonConfigs)) do
		t2[v18.name] = React.createElement(ShortcutButton, {
			label = v18.label,
			getShortcutIcon = v18.getShortcutIcon,
			getOnActivated = v18.getOnActivated,
			getIsEnabled = v18.getIsEnabled,
			isEmphasis = v18.isEmphasis,
			isSmall = v15,
			layoutOrder = v17
		})
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y row gap-small",
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(SessionActionButtons)
