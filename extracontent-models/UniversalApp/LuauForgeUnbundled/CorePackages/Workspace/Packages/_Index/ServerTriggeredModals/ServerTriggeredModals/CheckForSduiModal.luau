local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppEnums")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/CentralOverlay")
local DeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/DeepLink")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SignalsReact").useSignalState
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactUtils").Hooks.RoactRodux.useDispatch
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactServiceTags")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppHooks").useRoactService
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")
local NotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/NotificationsUpsell")

local centralOverlayType = RobloxAppEnums.CentralOverlayType
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

local useModalSignalStore = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/useModalSignalStore")
local Logger = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Logger")
local EntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/EntryPoint")
local fetchModalMetadata = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/fetchModalMetadata")
local useHandleCustomModalCallback = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/useHandleCustomModalCallback")

local fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals = SharedFlags.FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals
local fFlagEnableDeepLinkHistoryWithModalAPI = SharedFlags.FFlagEnableDeepLinkHistoryWithModalAPI

local defineFastInt = game:DefineFastInt("ServerTriggeredModalTrafficPercent", 0)
local defineFastFlag = game:DefineFastFlag("LuaAppAvoidPushUpsellConflicts", false)

local function CheckForSduiModal(p2): nil
	local v5 = useRoactService(RoactServiceTags.RoactNetworking)
	local v6 = useDispatch()
	local v7 = useModalSignalStore()
	local v8 = useSignalState(v7.getMetadataGetter(EntryPoint.HomepageLaunch))
	local v9 = useSignalState(v7.getHasShownGetter(EntryPoint.HomepageLaunch))
	local v10

	if fFlagEnableDeepLinkHistoryWithModalAPI then
		v10 = useSignalState(DeepLink.DeepLinkLuaReceiverStatusStore(false).getDeepLinkLuaPostAuthReceiverStatus)
	else
		v10 = nil
	end

	local state, setState

	if defineFastFlag then
		state, setState = React.useState(false)
	else
		setState = nil
		state = nil
	end

	local state2, setState2

	if defineFastFlag then
		state2, setState2 = React.useState(false)
	else
		setState2 = nil
		state2 = nil
	end

	local isFocused = p2.isFocused
	local v11

	if fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
		v11 = useHandleCustomModalCallback(EntryPoint.HomepageLaunch, v5)
	else
		v11 = nil
	end

	if defineFastFlag then
		React.useEffect(function()
			setState2(true)
			NotificationsUpsell.setupPushNotificationsUpsell.ShouldShowUpsell(
				NotificationsUpsell.NotificationsUpsellConstants.ModalKey.PushUpsellHome,
				false
			):andThen(function(p3)
				if not p3 then
					return
				end

				setState(true)
			end):catch(function(p3)
				Logger:error(`Failed to evaluate push upsell: {p3}`)
			end):finally(function()
				setState2(false)
			end)
		end, {})
	end

	local function fn()
		if
			defineFastInt <= math.random(0, 99)
			or fFlagEnableDeepLinkHistoryWithModalAPI
			and v10 ~= DeepLink.DeepLinkLuaPostAuthReceiverStatus.Ready
		then
			return
		end

		local v12 = fetchModalMetadata(v5, EntryPoint.HomepageLaunch):catch(function(p3)
			Logger:error(`Failed to fetch modal metadata for home page launch: {p3}`)
		end)

		return function()
			v12:cancel()
		end
	end

	React.useEffect(fn, { v5, if fFlagEnableDeepLinkHistoryWithModalAPI then v10 else nil })

	local useEffect2 = React.useEffect
	local function fn2()
		if v9 or not v8 or not isFocused or defineFastFlag and (state2 or state) then
			return
		end

		v7.setHasShown(EntryPoint.HomepageLaunch, true)

		if not fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
			v6(setCentralOverlay(centralOverlayType.SduiModal, {
				sduiComponentConfig = v8.sduiConfig,
				modalId = v8.modalId,
				modalType = v8.modalType
			}))
		elseif v8.isCustomHandler then
			v11(v8)
		else
			v6(setCentralOverlay(centralOverlayType.SduiModal, {
				sduiComponentConfig = v8.sduiConfig,
				modalId = v8.modalId,
				modalType = v8.modalType
			}))
		end
	end

	local v15 = if fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then v11 else nil
	local v16 = if fFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then v7 else nil
	local v17 = if defineFastFlag then state2 else nil
	useEffect2(fn2, {
		v9,
		v8,
		isFocused,
		v6,
		v15,
		v16,
		v17,
		if defineFastFlag then state else nil
	})

	return nil
end

local v5 = RoactNavigation.withNavigationFocus(CheckForSduiModal)

return React.memo(v5)
