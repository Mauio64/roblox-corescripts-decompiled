local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Localization").Hooks.useLocalization
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/CentralOverlay").Thunks.CloseCentralOverlay
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local gameTopicIds = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameTopicIds
local openInfoPeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryRouting").OpenInfoPeekView
local openCloseOnlyInteractiveAlert = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryRouting").OpenCloseOnlyInteractiveAlert

local function isSponsoredSort(p2, p3): boolean
	if p3 then
		if p2 and p2.topicId == gameTopicIds.Sponsored then
			return true
		end
	elseif p2 and p2.gameSetTypeId == "27" then
		return true
	end

	return false
end

local function useGameSortTooltipParams(data, p2, p3)
	local v5 = useDispatch()
	local v6 = useLocalization({
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic",
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds"
	})

	local v7 = usePreferredInput()
	local sponsoredDisclosure = v6.SponsoredDisclosure
	local sponsoredTitle = v6.SponsoredTitle
	local v8

	if p2 then
		v8 = data and data.topicId == gameTopicIds.Sponsored and true or false
	else
		v8 = data and data.gameSetTypeId == "27" and true or false
	end

	if v8 and p3 == nil then
		p3 = sponsoredDisclosure
	end

	local displayName = not v8 and (data and data.displayName or "") or sponsoredTitle

	return React.useCallback(function()
		if v7 == Responsive.Input.Touch then
			v5(openInfoPeekView(displayName, p3))
		else
			v5(openCloseOnlyInteractiveAlert(displayName, p3, function()
				return v5(closeCentralOverlay())
			end))
		end
	end, { displayName, p3, v7 }), p3
end

return useGameSortTooltipParams
