local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local NotApprovedPageProvider = require(NotApprovedPage.Contexts.NotApprovedPageContext).NotApprovedPageProvider
local PageNavigationProvider = require(NotApprovedPage.Contexts.PageNavigationContext).PageNavigationProvider
local PageAnalyticsProvider = require(NotApprovedPage.Contexts.PageAnalyticsContext).PageAnalyticsProvider
local React = require(NotApprovedPageParent.React)
local ReactRoblox = require(NotApprovedPageParent.Dev.ReactRoblox)
local UnitTestHelpers = require(NotApprovedPageParent.Dev.UnitTestHelpers)

require(NotApprovedPage.Common.Types)

local t1 = {
	punishedUserId = 12345,
	messageToUser = "This is a test moderator message",
	punishmentTypeDescription = "Warn",
	punishmentId = 67890,
	beginDate = "",
	endDate = "",
	verificationCategory = "",
	interventionId = "intervention-123",
	consequenceTransparencyMessage = "",
	showAppealsProcessLink = false,
	badUtterances = {}
}

local function MockProviders(t2: {[any]: any}) -- line: 46
	-- upvalues: t1 (copy), UnitTestHelpers (copy), React (copy), NotApprovedPageProvider (copy), PageNavigationProvider (copy), PageAnalyticsProvider (copy)
	local v12 = if not t2.moderationDetail then t1 else t2.moderationDetail
	local children = t2.children

	return UnitTestHelpers.mockProviders(React.createElement(NotApprovedPageProvider, {
		translations = t2.translations,
		moderationDetail = v12,
		commutationEligibility = t2.commutationEligibility
	}, React.createElement(PageNavigationProvider, {
		moderationDetail = v12
	}, React.createElement(PageAnalyticsProvider, nil, children))), {
		mockFoundation = true
	})
end

return {
	renderWithProviders = function(p1, p2, t3: {[any]: any}, p3, p4) -- line: 70
		-- upvalues: MockProviders (copy), React (copy), ReactRoblox (copy)
		local v19 = MockProviders({
			children = React.createElement(p2, t3),
			translations = p3,
			moderationDetail = p4
		})

		ReactRoblox.act(function() -- line: 83
			-- upvalues: p1 (copy), v19 (copy)
			p1:render(v19)
		end)
	end,
	MockProviders = MockProviders,
	DEFAULT_MODERATION_DETAIL = table.clone(t1)
}
