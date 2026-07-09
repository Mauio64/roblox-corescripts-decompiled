local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local useSignalState = require(SchoolsParent.SignalsReact).useSignalState
local useLocalization = require(SchoolsParent.Localization).Hooks.useLocalization
local Constants = require(Schools.Common.Constants)

require(Schools.Common.Enums)

local TextKeys = require(Schools.Common.TextKeys)
local SchoolsPage = require(Schools.Components.Common.SchoolsPage)
local SchoolEntryStatus = require(Schools.Store.SchoolEntryStatus)
local SchoolWaitlist = require(script.Parent.SchoolWaitlist)

local function SchoolWaitlistContainer(t1: {[any]: any}) -- line: 24
	-- upvalues: useLocalization (copy), TextKeys (copy), useSignalState (copy), SchoolEntryStatus (copy), React (copy), SchoolsPage (copy), Constants (copy), SchoolWaitlist (copy)
	local navigation = t1.navigation
	local v14 = useLocalization({
		headerTitle = TextKeys.WaitlistHeaderTitle
	})
	local v15 = useSignalState(SchoolEntryStatus.getVariantSignal())
	local v16 = React.useCallback(function() -- line: 35
		-- upvalues: navigation (copy)
		navigation.pop()
	end, { navigation })
	local v17 = React.useCallback(function() -- line: 39
	end, {})

	return React.createElement(SchoolsPage, {
		fillContent = true,
		testId = "schools-waitlist-page",
		title = v14.headerTitle,
		onBack = v16,
		maxContentWidth = Constants.Waitlist.MAX_CONTENT_WIDTH
	}, {
		Content = React.createElement(SchoolWaitlist, {
			schoolName = "UCLA",
			remainingCount = 8,
			variant = v15,
			onShare = v17
		})
	})
end

return SchoolWaitlistContainer
