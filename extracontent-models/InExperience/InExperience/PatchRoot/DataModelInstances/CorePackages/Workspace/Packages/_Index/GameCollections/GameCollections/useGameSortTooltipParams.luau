local parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameTopicIds = DiscoveryTypes.GameTopicIds
local DiscoveryRouting = require(parent.DiscoveryRouting)
local OpenInfoPeekView = DiscoveryRouting.OpenInfoPeekView
local DiscoveryRouting2 = require(parent.DiscoveryRouting)
local OpenCloseOnlyInteractiveAlert = DiscoveryRouting2.OpenCloseOnlyInteractiveAlert

local function isSponsoredSort(p, flag: boolean): boolean -- 1 equivalent call inferred from this helper
	if flag then
		if p and p.topicId == GameTopicIds.Sponsored then
			return true
		end
	elseif p and p.gameSetTypeId == "27" then
		return true
	end

	return false
end

local function useGameSortTooltipParams(p, flag: boolean, p2: string?)
	local v = useDispatch()
	local v2 = useLocalization({
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic",
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds"
	})

	local v3 = usePreferredInput()
	local sponsoredDisclosure = v2.SponsoredDisclosure
	local sponsoredTitle = v2.SponsoredTitle
	local sponsoredSort = isSponsoredSort(p, flag) -- inferred equivalent call

	if sponsoredSort and p2 == nil then
		p2 = sponsoredDisclosure
	end

	local displayName = not sponsoredSort and (p and p.displayName or "") or sponsoredTitle

	return React.useCallback(function()
		if v3 == Responsive.Input.Touch then
			v(OpenInfoPeekView(displayName, p2))
		else
			v(OpenCloseOnlyInteractiveAlert(displayName, p2, function()
				return v(CloseCentralOverlay())
			end))
		end
	end, { displayName, p2, v3 }), p2
end

return useGameSortTooltipParams
