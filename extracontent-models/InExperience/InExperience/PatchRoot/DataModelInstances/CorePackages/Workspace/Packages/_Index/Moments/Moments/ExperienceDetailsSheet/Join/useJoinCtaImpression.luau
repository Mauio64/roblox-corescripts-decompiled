local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local MomentsCommon = require(parent.MomentsCommon)
local VerticalPager = require(Moments.Components.VerticalPager)
local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local useMomentsSession = MomentsSessionContext.useMomentsSession
local makeJoinImpressionFields = require(Moments.Analytics.makeJoinImpressionFields)
local MomentImpressionMemory = require(Moments.Components.Feed.Items.Moment.MomentImpressionMemory)
local FFlagMomentsFixOverlayRemountImpressions = require(Moments.Flags.FFlagMomentsFixOverlayRemountImpressions)

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames

local useSignalState = SignalsReact.useSignalState
local useVerticalPager = VerticalPager.useVerticalPager
local usePagerItem = VerticalPager.usePagerItem

local function useJoinCtaImpression(flag: boolean, flag2: boolean)
	local v = useVerticalPager()
	local v2 = usePagerItem()
	local v3 = useMomentsSession()

	local item = v2.item

	local current2 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			return item ~= nil and v.store.getCurrentItem(p) == item
		end)
	end, { v, item })))
	local v4

	if FFlagMomentsFixOverlayRemountImpressions then
		v4 = MomentImpressionMemory.useImpressionRef("joinCta")
	else
		v4 = React.useRef(false)
	end

	React.useEffect(function()
		local current = v4.current
		v4.current = current2

		if not flag2 or flag or (not current2 or current) then
			return
		end

		if item == nil or item.kind ~= "moment" then
			return
		end

		local joinImpressionFields = makeJoinImpressionFields(item.moment, v3.getSessionSource(false))

		if joinImpressionFields ~= nil then
			Analytics.fireAnalyticsEvent(EventNames.FeedExperienceJoinImpression, joinImpressionFields)
		end
	end, { current2, flag2, flag, item, v3 })
end

return useJoinCtaImpression
