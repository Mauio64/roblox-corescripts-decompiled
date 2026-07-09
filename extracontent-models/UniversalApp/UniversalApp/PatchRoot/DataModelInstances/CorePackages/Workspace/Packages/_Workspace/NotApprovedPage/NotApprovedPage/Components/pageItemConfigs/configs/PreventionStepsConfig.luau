local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)

require(NotApprovedPage.Common.Types)

local Constants = require(NotApprovedPageParent.NotApprovedPageShared).Constants
local INTERVENTION_TYPES = Constants.INTERVENTION_TYPES
local EVENT_TYPES = Constants.EVENT_TYPES
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = Constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP
local React = require(NotApprovedPageParent.React)
local AppPage = require(NotApprovedPageParent.RobloxAppEnums).AppPage
local NavigateDown = require(NotApprovedPageParent.NavigationRodux).Thunks.NavigateDown
local UrlBuilder = require(NotApprovedPageParent.UrlBuilder).UrlBuilder
local useCallback = React.useCallback
local FFlagSignalsNavP3Dispatch = require(NotApprovedPageParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v14 = if not FFlagSignalsNavP3Dispatch then nil else require(NotApprovedPageParent.RobloxAppNavigation).NavigationCommands
local Foundation = require(NotApprovedPageParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local useOpenLink = require(NotApprovedPage.Utils.useOpenLink)

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local FFlagEnableNapNewWebView = require(NotApprovedPage.Flags.FFlagEnableNapNewWebView)

local function PreventionSteps(p1) -- line: 47
	-- upvalues: useNotApprovedPageContext (copy), FFlagEnableNapNewWebView (copy), useOpenLink (copy), UrlBuilder (copy), useCallback (copy), sendNotApprovedPageEvent (copy), EVENT_TYPES (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy), React (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local translations = useNotApprovedPageContext().translations
	local dispatch = p1.dispatch
	local hasEducationalPages = p1.hasEducationalPages
	local showUGCAvatarGuidelinesLink = p1.moderationDetail.showUGCAvatarGuidelinesLink
	local isAltInformed = p1.moderationDetail.isAltInformed
	local v31 = if not FFlagEnableNapNewWebView then nil else useOpenLink(if not showUGCAvatarGuidelinesLink then UrlBuilder.static.about.guidelines() else UrlBuilder.static.creatorHub() .. "/docs/marketplace/marketplace-policy#general-creation-guidelines", if not showUGCAvatarGuidelinesLink then translations.communityStandardsLabel else translations.avatarGuidelinesLabel)
	local v32 = useCallback(function() -- line: 66
		-- upvalues: sendNotApprovedPageEvent (copy), showUGCAvatarGuidelinesLink (copy), EVENT_TYPES (copy), FFlagEnableNapNewWebView (copy), v31 (copy), AppPage (copy), UrlBuilder (copy), translations (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), dispatch (copy), NavigateDown (copy)
		sendNotApprovedPageEvent({
			eventType = if not showUGCAvatarGuidelinesLink then EVENT_TYPES.CommunityGuidelineClicked else EVENT_TYPES.UGCGuidelinesClicked
		})

		if FFlagEnableNapNewWebView and v31 then
			v31()

			return
		end

		local t1 = {
			name = AppPage.GenericWebPage,
			detail = if not showUGCAvatarGuidelinesLink then UrlBuilder.static.about.guidelines() else UrlBuilder.static.creatorHub() .. "/docs/marketplace/marketplace-policy#general-creation-guidelines",
			extraProps = {
				title = if not showUGCAvatarGuidelinesLink then translations.communityStandardsLabel else translations.avatarGuidelinesLabel
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v14.down(v14.fromLegacyPage(t1))

			return
		end

		dispatch(NavigateDown(t1))
	end, {
		dispatch,
		v31
	})

	return React.createElement(View, {
		tag = "col size-full-0 auto-y gap-medium",
		LayoutOrder = p1.layoutOrder
	}, {
		Heading = React.createElement(FoundationText, {
			tag = "auto-xy text-align-x-left text-wrap text-heading-medium content-emphasis",
			LayoutOrder = 1,
			Text = translations.preventionStepsHeading
		}),
		Content = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-medium",
			LayoutOrder = 3
		}, {
			Description = React.createElement(FoundationText, {
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 3,
				Text = translations.foreshadowDescription
			}),
			LinkedAccountsDescription = isAltInformed and React.createElement(FoundationText, {
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 4,
				Text = translations.linkedAccountsDescription
			}),
			GuidelinesLink = (not hasEducationalPages or showUGCAvatarGuidelinesLink) and React.createElement(Button, {
				LayoutOrder = 5,
				text = if not showUGCAvatarGuidelinesLink then translations.viewRulesButton else translations.avatarGuidelinesLabel,
				onActivated = v32,
				variant = ButtonVariant.Standard,
				size = InputSize.Small,
				width = UDim.new(1, 0)
			})
		})
	})
end

return {
	getIsVisible = function(p2) -- line: 136
		-- upvalues: PUNISHMENT_TYPE_TO_INTERVENTION_MAP (copy), INTERVENTION_TYPES (copy)
		return PUNISHMENT_TYPE_TO_INTERVENTION_MAP[p2.punishmentTypeDescription] ~= INTERVENTION_TYPES.Deleted
	end,
	renderComponent = React.memo(PreventionSteps)
}
