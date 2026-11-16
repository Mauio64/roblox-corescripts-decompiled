local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Players = game:GetService("Players")

local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local VerticalPager = require(Moments.Components.VerticalPager)
local FeedContext = require(Moments.Components.Feed.FeedContext)
local useFeedOptional = FeedContext.useFeedOptional
require(Moments.Components.Feed.Items.Moment.createMomentStore)
local firePostInsightsCoachmarkEvent = require(script.Parent.firePostInsightsCoachmarkEvent)
local getPostInsightsCoachmarkSessionStore = require(script.Parent.getPostInsightsCoachmarkSessionStore)
local getPostInsightsPageStore = require(script.Parent.getPostInsightsPageStore)
local postInsightsCoachmarkImpressionCache = require(script.Parent.postInsightsCoachmarkImpressionCache)
local postInsightsStrings = require(script.Parent.postInsightsStrings)
local getCommentsSheetStore

if SharedFlags.FFlagMomentsComments then
	getCommentsSheetStore = require(Moments.Components.Comments.Sheet.getCommentsSheetStore)
else
	getCommentsSheetStore = nil
end

local EventNames = MomentsCommon.Analytics.EventNames
local RecommendationSource = MomentsCommon.Analytics.RecommendationSource
local GetFIntMomentsCoachmarkMaxImpressions = MomentsCommon.Flags.GetFIntMomentsCoachmarkMaxImpressions
local GetFIntMomentsCoachmarkAutoDismissSeconds = MomentsCommon.Flags.GetFIntMomentsCoachmarkAutoDismissSeconds

local useLocalization = Localization.Hooks.useLocalization

local function onImpression()
	firePostInsightsCoachmarkEvent(EventNames.FTUXTooltipImpression)
end

local function onDismissed()
	firePostInsightsCoachmarkEvent(EventNames.FTUXTooltipDismissed)
end

local function usePostInsightsCoachmarkViewModel(data)
	local v = useLocalization(postInsightsStrings.TOOLTIP_KEYS)
	local v2 = useFeedOptional()
	local v3 = VerticalPager.useVerticalPager()
	local item = VerticalPager.usePagerItem().item

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			return item ~= nil and v3.store.getCurrentItem(p) == item
		end)
	end, { v3, item })
	local v5 = SignalsReact.useSignalState(v4)

	local v6 = SignalsReact.useSignalState(getPostInsightsPageStore(false).getIsOpen)
	local v7

	if getCommentsSheetStore == nil then
		v7 = false
	else
		v7 = SignalsReact.useSignalState(getCommentsSheetStore(false).getIsOpen)
	end

	local v8

	if v2 == nil or v2.recommendationSource ~= RecommendationSource.Profile or data.momentStore == nil then
		v8 = false
	else
		v8 = not data.isDisabled

		if v8 then
			local creatorId = data.moment.creatorId
			local v9

			if Players.LocalPlayer then
				v9 = Players.LocalPlayer.UserId
			end

			v8 = creatorId == v9
		end
	end

	if v8 then
		if v5 then
			v5 = not (v2 == nil) and v2.isActiveFeed
		end
	else
		v5 = v8
	end

	local state, setState = React.useState(false)
	React.useEffect(function()
		if v5 then
			setState(true)
		end
	end, { v5 })

	local state2, setState2 = React.useState(false)
	React.useEffect(function()
		if data.isMenuOpen then
			setState2(true)
		end
	end, { data.isMenuOpen })

	local postInsightsCoachmarkSessionStore = getPostInsightsCoachmarkSessionStore(false)

	return {
		shouldMount = v8 and (v5 or state),
		hidden = not v5 or data.isMenuOpen or state2 or v7 or v6,
		title = v.title,
		text = v.text,
		impressionCache = postInsightsCoachmarkImpressionCache,
		maxImpressions = GetFIntMomentsCoachmarkMaxImpressions(),
		autoDismissSeconds = GetFIntMomentsCoachmarkAutoDismissSeconds(),
		isSessionHandled = postInsightsCoachmarkSessionStore.getIsHandled(false),
		onSessionHandled = postInsightsCoachmarkSessionStore.markHandled,
		onImpression = onImpression,
		onDismissed = onDismissed
	}
end

return usePostInsightsCoachmarkViewModel
