local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local VerticalPager = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager")
local useMomentsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext").useMomentsSession
local makeJoinImpressionFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeJoinImpressionFields")
local MomentImpressionMemory = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentImpressionMemory")
local FFlagMomentsFixOverlayRemountImpressions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixOverlayRemountImpressions")

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames

local useSignalState = SignalsReact.useSignalState
local useVerticalPager = VerticalPager.useVerticalPager
local usePagerItem = VerticalPager.usePagerItem

local function useJoinCtaImpression(p2, p3)
	local v5 = useVerticalPager()
	local v6 = usePagerItem()
	local v7 = useMomentsSession()

	local item = v6.item

	local v9 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p4): boolean
			if item == nil then
				return false
			end

			return v5.store.getCurrentItem(p4) == item
		end)
	end, { v5, item })))

	local v10 = if FFlagMomentsFixOverlayRemountImpressions then MomentImpressionMemory.useImpressionRef("joinCta") else React.useRef(false)
	React.useEffect(function()
		local current = v10.current
		v10.current = v9

		if not p3 or p2 or (not v9 or current) then
			return
		end

		if item == nil or item.kind ~= "moment" then
			return
		end

		local v11 = makeJoinImpressionFields(item.moment, v7.getSessionSource(false))

		if v11 ~= nil then
			analytics.fireAnalyticsEvent(eventNames.FeedExperienceJoinImpression, v11)
		end
	end, { v9, p3, p2, item, v7 })
end

return useJoinCtaImpression
