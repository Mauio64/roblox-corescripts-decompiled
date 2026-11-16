local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
require(GamePlayButton.PlayButtonTypes)

local parent = GamePlayButton.Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local unlockPlayIntent = DiscoveryAnalytics.Events.unlockPlayIntent
require(parent.PlayabilityRodux)
local CloudClientOffer = require(parent.CloudClientOffer)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppEnableVirtualEventPlaceId = SharedFlags.GetFFlagLuaAppEnableVirtualEventPlaceId

return function(universeId, p, p2, p3, pageName: string?, callback)
	local v = useRoactService(AppEventIngestService)
	local v2 = useDispatch()
	local ref = React.useRef(nil)

	React.useEffect(function()
		return function()
			local current = ref.current

			if current ~= nil then
				CloudClientOffer.GetCloudClientOfferStore(false).cancel(current)
			end
		end
	end, {})

	return React.useCallback(function(callback2, p4: string?, p5)
		local fFlagLuaAppEnableVirtualEventPlaceId = GetFFlagLuaAppEnableVirtualEventPlaceId()
		local v3

		if fFlagLuaAppEnableVirtualEventPlaceId then
			if p == nil then
				v3 = false
			else
				v3 = p2 ~= nil
			end
		else
			v3 = p2 ~= nil
		end

		if not v3 or p5 ~= nil and p5.hasShownUpsell == true then
			callback(callback2, p4, p5)
			return
		end

		local v4

		if fFlagLuaAppEnableVirtualEventPlaceId then
			v4 = p
		else
			v4 = p2
		end

		local cloudClientOfferStore = CloudClientOffer.GetCloudClientOfferStore(false)
		local request = cloudClientOfferStore.request(tostring(v4), function(p6)
			ref.current = nil

			if p6.kind == "Stream" then
				callback(callback2, p4, {
					cloudClientReservation = {
						reservationToken = p6.offer.reservationToken,
						offerKind = p6.offer.kind
					}
				})
			elseif p6.kind == "Local" then
				callback(callback2, p4)
			end
		end, function(p6)
			ref.current = nil
			v2(CloudClientOffer.OpenCloudClientOfferSheet(cloudClientOfferStore, p6))
			unlockPlayIntent(v, {
				universeId = universeId,
				upsellName = p6.kind,
				playabilityStatus = p3 and p3.playabilityStatus or nil,
				pageName = pageName
			})
		end)

		if request ~= nil then
			ref.current = request
		end
	end, { universeId, p, p2, p3, pageName, callback, v2, v })
end
