require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonTypes")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags").AppEventIngestService
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactUtils").Hooks.RoactRodux.useDispatch
local unlockPlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics").Events.unlockPlayIntent
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux")
local CloudClientOffer = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/CloudClientOffer")
local getFFlagLuaAppEnableVirtualEventPlaceId = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").GetFFlagLuaAppEnableVirtualEventPlaceId

return function(p2, p3, p4, p5, p6, callback)
	local v5 = useRoactService(appEventIngestService)
	local v6 = useDispatch()
	local ref = React.useRef(nil)

	React.useEffect(function()
		return function()
			local current = ref.current

			if current ~= nil then
				CloudClientOffer.GetCloudClientOfferStore(false).cancel(current)
			end
		end
	end, {})

	return React.useCallback(function(p7, p8, p9)
		local fFlagLuaAppEnableVirtualEventPlaceId = getFFlagLuaAppEnableVirtualEventPlaceId()
		local v7 = if fFlagLuaAppEnableVirtualEventPlaceId then not (p3 == nil) and p4 ~= nil else p4 ~= nil

		if not v7 or p9 ~= nil and p9.hasShownUpsell == true then
			callback(p7, p8, p9)
			return
		end

		local v8 = if fFlagLuaAppEnableVirtualEventPlaceId then p3 else p4
		local cloudClientOfferStore = CloudClientOffer.GetCloudClientOfferStore(false)
		local request = cloudClientOfferStore.request(tostring(v8), function(p10)
			ref.current = nil

			if p10.kind == "Stream" then
				callback(p7, p8, {
					cloudClientReservation = {
						reservationToken = p10.offer.reservationToken,
						offerKind = p10.offer.kind
					}
				})
			elseif p10.kind == "Local" then
				callback(p7, p8)
			end
		end, function(p10)
			ref.current = nil
			v6(CloudClientOffer.OpenCloudClientOfferSheet(cloudClientOfferStore, p10))
			unlockPlayIntent(v5, {
				universeId = p2,
				upsellName = p10.kind,
				playabilityStatus = p5 and p5.playabilityStatus or nil,
				pageName = p6
			})
		end)

		if request ~= nil then
			ref.current = request
		end
	end, { p2, p3, p4, p5, p6, callback, v6, v5 })
end
