local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlay = require(parent.CentralOverlay)
local DeepLink = require(parent.DeepLink)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactServiceTags = require(parent.RoactServiceTags)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactNavigation = require(parent.RoactNavigation)
local SharedFlags = require(parent.SharedFlags)
local NotificationsUpsell = require(parent.NotificationsUpsell)

local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

local useModalSignalStore = require(ServerTriggeredModals.SignalStores.useModalSignalStore)
local Logger = require(ServerTriggeredModals.Logger)
local EntryPoint = require(ServerTriggeredModals.EntryPoint)
local fetchModalMetadata = require(ServerTriggeredModals.fetchModalMetadata)
local useHandleCustomModalCallback = require(ServerTriggeredModals.useHandleCustomModalCallback)

local FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals = SharedFlags.FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals
local FFlagEnableDeepLinkHistoryWithModalAPI = SharedFlags.FFlagEnableDeepLinkHistoryWithModalAPI

local defineFastInt = game:DefineFastInt("ServerTriggeredModalTrafficPercent", 0)
local defineFastFlag = game:DefineFastFlag("LuaAppAvoidPushUpsellConflicts", false)

local function CheckForSduiModal(p): nil
	local v = useRoactService(RoactServiceTags.RoactNetworking)
	local v2 = useDispatch()
	local v3 = useModalSignalStore()
	local v4 = useSignalState(v3.getMetadataGetter(EntryPoint.HomepageLaunch))
	local v5 = useSignalState(v3.getHasShownGetter(EntryPoint.HomepageLaunch))
	local v6

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		v6 = useSignalState(DeepLink.DeepLinkLuaReceiverStatusStore(false).getDeepLinkLuaPostAuthReceiverStatus)
	else
		v6 = nil
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

	local isFocused = p.isFocused
	local v7

	if FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
		v7 = useHandleCustomModalCallback(EntryPoint.HomepageLaunch, v)
	else
		v7 = nil
	end

	if defineFastFlag then
		React.useEffect(function()
			setState2(true)
			NotificationsUpsell.setupPushNotificationsUpsell.ShouldShowUpsell(
				NotificationsUpsell.NotificationsUpsellConstants.ModalKey.PushUpsellHome,
				false
			):andThen(function(p2)
				if not p2 then
					return
				end

				setState(true)
			end):catch(function(p2)
				Logger:error(`Failed to evaluate push upsell: {p2}`)
			end):finally(function()
				setState2(false)
			end)
		end, {})
	end

	local useEffect = React.useEffect
	local function fn()
		if
			defineFastInt <= math.random(0, 99)
			or FFlagEnableDeepLinkHistoryWithModalAPI and v6 ~= DeepLink.DeepLinkLuaPostAuthReceiverStatus.Ready
		then
			return
		end

		local v8 = fetchModalMetadata(v, EntryPoint.HomepageLaunch):catch(function(p2)
			Logger:error(`Failed to fetch modal metadata for home page launch: {p2}`)
		end)

		return function()
			v8:cancel()
		end
	end

	local v8

	if FFlagEnableDeepLinkHistoryWithModalAPI then
		v8 = v6
	end

	useEffect(fn, { v, v8 })

	local useEffect2 = React.useEffect
	local function fn2()
		if v5 or not v4 or not isFocused or defineFastFlag and (state2 or state) then
			return
		end

		v3.setHasShown(EntryPoint.HomepageLaunch, true)

		if not FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
			v2(SetCentralOverlay(CentralOverlayType.SduiModal, {
				sduiComponentConfig = v4.sduiConfig,
				modalId = v4.modalId,
				modalType = v4.modalType
			}))
		elseif v4.isCustomHandler then
			v7(v4)
		else
			v2(SetCentralOverlay(CentralOverlayType.SduiModal, {
				sduiComponentConfig = v4.sduiConfig,
				modalId = v4.modalId,
				modalType = v4.modalType
			}))
		end
	end

	local v9

	if FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
		v9 = v7
	end

	local v10

	if FFlagLuaAppSupportNonSduiTypeForServerTriggeredModals then
		v10 = v3
	end

	local v11

	if defineFastFlag then
		v11 = state2
	end

	local v12

	if defineFastFlag then
		v12 = state
	end

	useEffect2(fn2, { v5, v4, isFocused, v2, v9, v10, v11, v12 })

	return nil
end

local v = RoactNavigation.withNavigationFocus(CheckForSduiModal)

return React.memo(v)
