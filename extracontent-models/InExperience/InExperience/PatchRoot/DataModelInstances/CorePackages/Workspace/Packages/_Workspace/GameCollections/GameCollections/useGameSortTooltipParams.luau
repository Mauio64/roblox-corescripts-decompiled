local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local CloseCentralOverlay = require(Parent.CentralOverlay).Thunks.CloseCentralOverlay
local Responsive = require(Parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local GameTopicIds = require(Parent.DiscoveryTypes).GameTopicIds
local OpenInfoPeekView = require(Parent.DiscoveryRouting).OpenInfoPeekView
local OpenCloseOnlyInteractiveAlert = require(Parent.DiscoveryRouting).OpenCloseOnlyInteractiveAlert

local function isSponsoredSort(p1, b1: boolean) -- line: 15
	-- upvalues: GameTopicIds (copy)
	if b1 then
		if p1 and p1.topicId == GameTopicIds.Sponsored then
			return true
		end
	elseif p1 and p1.gameSetTypeId == "27" then
		return true
	end

	return false
end
local function useGameSortTooltipParams(p2, b2: boolean, s1: string?) -- line: 31
	-- upvalues: useDispatch (copy), useLocalization (copy), usePreferredInput (copy), GameTopicIds (copy), React (copy), Responsive (copy), OpenInfoPeekView (copy), OpenCloseOnlyInteractiveAlert (copy), CloseCentralOverlay (copy)
	local v18 = useDispatch()
	local v19 = useLocalization({
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic",
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds"
	})
	local v20 = usePreferredInput()
	local SponsoredDisclosure = v19.SponsoredDisclosure
	local SponsoredTitle = v19.SponsoredTitle
	local v23 = if not b2 then not not p2 and p2.gameSetTypeId == "27" else not not p2 and p2.topicId == GameTopicIds.Sponsored
	local v24 = if not v23 or s1 ~= nil then s1 else SponsoredDisclosure
	local v25 = if not v23 then p2 and p2.displayName or "" else SponsoredTitle

	return React.useCallback(function() -- line: 44
		-- upvalues: v20 (copy), Responsive (copy), v18 (copy), OpenInfoPeekView (copy), v25 (copy), v24 (copy), OpenCloseOnlyInteractiveAlert (copy), CloseCentralOverlay (copy)
		if v20 == Responsive.Input.Touch then
			v18(OpenInfoPeekView(v25, v24))

			return
		end

		v18(OpenCloseOnlyInteractiveAlert(v25, v24, function() -- line: 48
			-- upvalues: v18 (copy), CloseCentralOverlay (copy)
			return v18(CloseCentralOverlay())
		end))
	end, {
		v25,
		v24,
		v20
	}), v24
end

return useGameSortTooltipParams
