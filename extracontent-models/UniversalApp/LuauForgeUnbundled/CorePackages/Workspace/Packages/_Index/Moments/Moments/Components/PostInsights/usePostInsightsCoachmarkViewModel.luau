local Players = game:GetService("Players")

local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local VerticalPager = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager")
local useFeedOptional = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext").useFeedOptional
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/createMomentStore")
local firePostInsightsCoachmarkEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/firePostInsightsCoachmarkEvent")
local getPostInsightsCoachmarkSessionStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/getPostInsightsCoachmarkSessionStore")
local getPostInsightsPageStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/getPostInsightsPageStore")
local postInsightsCoachmarkImpressionCache = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/postInsightsCoachmarkImpressionCache")
local postInsightsStrings = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/postInsightsStrings")

local v5 = if SharedFlags.FFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore") else nil

local eventNames = MomentsCommon.Analytics.EventNames
local recommendationSource = MomentsCommon.Analytics.RecommendationSource
local getFIntMomentsCoachmarkMaxImpressions = MomentsCommon.Flags.GetFIntMomentsCoachmarkMaxImpressions
local getFIntMomentsCoachmarkAutoDismissSeconds = MomentsCommon.Flags.GetFIntMomentsCoachmarkAutoDismissSeconds

local useLocalization = Localization.Hooks.useLocalization

local function onImpression()
	firePostInsightsCoachmarkEvent(eventNames.FTUXTooltipImpression)
end

local function onDismissed()
	firePostInsightsCoachmarkEvent(eventNames.FTUXTooltipDismissed)
end

local function usePostInsightsCoachmarkViewModel(data)
	local v6 = useLocalization(postInsightsStrings.TOOLTIP_KEYS)
	local v7 = useFeedOptional()
	local v8 = VerticalPager.useVerticalPager()
	local item = VerticalPager.usePagerItem().item

	local v9 = React.useMemo(function()
		return Signals.createComputed(function(p2): boolean
			return item ~= nil and v8.store.getCurrentItem(p2) == item
		end)
	end, { v8, item })
	local v10 = SignalsReact.useSignalState(v9)

	local v11 = SignalsReact.useSignalState(getPostInsightsPageStore(false).getIsOpen)

	local v12 = not (v5 == nil) and SignalsReact.useSignalState(v5(false).getIsOpen)
	local v13

	if v7 == nil or v7.recommendationSource ~= recommendationSource.Profile or data.momentStore == nil then
		v13 = false
	else
		v13 = not data.isDisabled

		if v13 then
			local creatorId = data.moment.creatorId
			local v14 = if Players.LocalPlayer then Players.LocalPlayer.UserId else nil
			v13 = creatorId == v14
		end
	end

	if v13 then
		if v10 then
			v10 = not (v7 == nil) and v7.isActiveFeed
		end
	else
		v10 = v13
	end

	local state, setState = React.useState(false)
	React.useEffect(function()
		if v10 then
			setState(true)
		end
	end, { v10 })

	local state2, setState2 = React.useState(false)
	React.useEffect(function()
		if data.isMenuOpen then
			setState2(true)
		end
	end, { data.isMenuOpen })

	local v14 = getPostInsightsCoachmarkSessionStore(false)

	return {
		shouldMount = v13 and (v10 or state),
		hidden = not v10 or data.isMenuOpen or state2 or v12 or v11,
		title = v6.title,
		text = v6.text,
		impressionCache = postInsightsCoachmarkImpressionCache,
		maxImpressions = getFIntMomentsCoachmarkMaxImpressions(),
		autoDismissSeconds = getFIntMomentsCoachmarkAutoDismissSeconds(),
		isSessionHandled = v14.getIsHandled(false),
		onSessionHandled = v14.markHandled,
		onImpression = onImpression,
		onDismissed = onDismissed
	}
end

return usePostInsightsCoachmarkViewModel
