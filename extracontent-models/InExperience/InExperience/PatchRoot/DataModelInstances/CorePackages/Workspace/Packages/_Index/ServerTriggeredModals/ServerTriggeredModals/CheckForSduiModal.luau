local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local React = require(ServerTriggeredModalsParent.React)
local RobloxAppEnums = require(ServerTriggeredModalsParent.RobloxAppEnums)
local CentralOverlay = require(ServerTriggeredModalsParent.CentralOverlay)
local DeepLink = require(ServerTriggeredModalsParent.DeepLink)
local useSignalState = require(ServerTriggeredModalsParent.SignalsReact).useSignalState
local useDispatch = require(ServerTriggeredModalsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local RoactServiceTags = require(ServerTriggeredModalsParent.RoactServiceTags)
local useRoactService = require(ServerTriggeredModalsParent.RobloxAppHooks).useRoactService
local RoactNavigation = require(ServerTriggeredModalsParent.RoactNavigation)
local SharedFlags = require(ServerTriggeredModalsParent.SharedFlags)
local NotificationsUpsell = require(ServerTriggeredModalsParent.NotificationsUpsell)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local useModalSignalStore = require(ServerTriggeredModals.SignalStores.useModalSignalStore)
local Logger = require(ServerTriggeredModals.Logger)
local EntryPoint = require(ServerTriggeredModals.EntryPoint)
local fetchModalMetadata = require(ServerTriggeredModals.fetchModalMetadata)
local useHandleCustomModalCallback = require(ServerTriggeredModals.useHandleCustomModalCallback)
local FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals = SharedFlags.FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals
local FFlagEnableDeepLinkHistoryWithModalAPI = SharedFlags.FFlagEnableDeepLinkHistoryWithModalAPI
local v23 = game:DefineFastInt("ServerTriggeredModalTrafficPercent", 0)
local v24 = game:DefineFastFlag("LuaAppAvoidPushUpsellConflicts", false)

local function CheckForSduiModal(t1: {[any]: any}) -- line: 36
	-- upvalues: useRoactService (copy), RoactServiceTags (copy), useDispatch (copy), useModalSignalStore (copy), useSignalState (copy), EntryPoint (copy), FFlagEnableDeepLinkHistoryWithModalAPI (copy), DeepLink (copy), v24 (copy), React (copy), FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals (copy), useHandleCustomModalCallback (copy), NotificationsUpsell (copy), Logger (copy), v23 (copy), fetchModalMetadata (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	local v28 = useRoactService(RoactServiceTags.RoactNetworking)
	local v29 = useDispatch()
	local v30 = useModalSignalStore()
	local v31 = useSignalState(v30.getMetadataGetter(EntryPoint.HomepageLaunch))
	local v32 = useSignalState(v30.getHasShownGetter(EntryPoint.HomepageLaunch))
	local u33 = nil

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		local v34 = DeepLink.DeepLinkLuaReceiverStatusStore(false)

		u33 = useSignalState(v34.getDeepLinkLuaPostAuthReceiverStatus)
	end

	local u35 = nil
	local u36 = nil

	if v24 then
		local v37, v38 = React.useState(false)

		u35 = v37
		u36 = v38
	end

	local u39 = nil
	local u40 = nil

	if v24 then
		local v41, v42 = React.useState(false)

		u39 = v41
		u40 = v42
	end

	local isFocused = t1.isFocused
	local v44 = if not FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then nil else useHandleCustomModalCallback(EntryPoint.HomepageLaunch, v28)

	if v24 then
		React.useEffect(function() -- line: 67
			-- upvalues: u40 (ref), NotificationsUpsell (copy), u36 (ref), Logger (copy)
			u40(true)
			NotificationsUpsell.setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsell.NotificationsUpsellConstants.ModalKey.PushUpsellHome, false):andThen(function(p1) -- line: 71
				-- upvalues: u36 (ref)
				if p1 then
					u36(true)

					return
				end
			end):catch(function(p2) -- line: 77
				-- upvalues: Logger (copy)
				Logger:error(`Failed to evaluate push upsell: { p2 }`)
			end):finally(function() -- line: 80
				-- upvalues: u40 (ref)
				u40(false)
			end)
		end, {})
	end

	React.useEffect(function() -- line: 86
		-- upvalues: v23 (copy), FFlagEnableDeepLinkHistoryWithModalAPI (copy), u33 (ref), DeepLink (copy), fetchModalMetadata (copy), v28 (copy), EntryPoint (copy), Logger (copy)
		if v23 <= math.random(0, 99) then
			return
		end

		if FFlagEnableDeepLinkHistoryWithModalAPI and u33 ~= DeepLink.DeepLinkLuaPostAuthReceiverStatus.Ready then
			return
		end

		local v45 = fetchModalMetadata(v28, EntryPoint.HomepageLaunch):catch(function(p3) -- line: 97
			-- upvalues: Logger (copy)
			Logger:error(`Failed to fetch modal metadata for home page launch: { p3 }`)
		end)

		return function() -- line: 101
			-- upvalues: v45 (copy)
			v45:cancel()
		end
	end, {
		v28,
		if not FFlagEnableDeepLinkHistoryWithModalAPI then nil else u33
	})
	React.useEffect(function() -- line: 107
		-- upvalues: v32 (copy), v31 (copy), isFocused (copy), v24 (copy), u39 (ref), u35 (ref), v30 (copy), EntryPoint (copy), FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals (copy), v44 (copy), v29 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
		if v32 then
			return
		end

		if not v31 then
			return
		end

		if not isFocused then
			return
		end

		if v24 and (u39 or u35) then
			return
		end

		v30.setHasShown(EntryPoint.HomepageLaunch, true)

		if FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
			if v31.isCustomHandler then
				v44(v31)

				return
			end

			v29(SetCentralOverlay(CentralOverlayType.SduiModal, {
				sduiComponentConfig = v31.sduiConfig,
				modalId = v31.modalId,
				modalType = v31.modalType
			}))

			return
		end

		v29(SetCentralOverlay(CentralOverlayType.SduiModal, {
			sduiComponentConfig = v31.sduiConfig,
			modalId = v31.modalId,
			modalType = v31.modalType
		}))
	end, {
		v32,
		v31,
		isFocused,
		v29,
		if not FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then nil else v44,
		if not FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then nil else v30,
		if not v24 then nil else u39,
		if not v24 then nil else u35
	})

	return nil
end

local v26 = RoactNavigation.withNavigationFocus(CheckForSduiModal)

return React.memo(v26)
