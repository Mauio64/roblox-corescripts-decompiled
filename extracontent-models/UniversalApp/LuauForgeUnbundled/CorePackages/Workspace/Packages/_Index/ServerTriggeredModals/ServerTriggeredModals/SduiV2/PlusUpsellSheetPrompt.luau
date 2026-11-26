local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactNavigation")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SignalsReact")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/LinkingProtocol").LinkingProtocol.default
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/LocalUserIdStore").LocalUserIdStore
local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxSubscriptionPurchaseApp")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactUtils").Hooks.RoactRodux.useSelector
local Logger = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Logger")
local reportPromptImpression = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/reportPromptImpression")
local sendModalImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerTriggeredModalImpressions").sendModalImpressionEvent
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")
require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/Types/PromptsTypes")
require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/createModalSignalStore")
require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/EntryPoint")

local fFlagRobloxSubscriptionOnboardingSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags").FFlagRobloxSubscriptionOnboardingSheet

local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local robloxPlusSheetKind = RobloxSubscriptionPurchaseApp.RobloxPlusSheetKind
local robloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason

local currentUserIdSet = {}

local signal, v5 = Signals.createSignal(nil)

local function useIsScreenFocused()
	local v6 = React.useContext(RoactNavigation.Context)
	local useState = React.useState
	local v7 = not (v6 == nil) and v6.isFocused()
	local state, setState = useState(v7)

	React.useEffect(function()
		if v6 == nil then
			setState(false)
			return
		end

		local v8 = v6.addListener(RoactNavigation.Events.WillFocus, function()
			setState(true)
		end)
		local v9 = v6.addListener(RoactNavigation.Events.WillBlur, function()
			setState(false)
		end)
		setState(v6.isFocused())

		return function()
			v8.remove()
			v9.remove()
		end
	end, { v6 })

	return state
end

return {
	handlePromptsResponse = function(p2)
		if type(p2) ~= "table" then
			return
		end

		local custom_prompts = p2.custom_prompts

		if type(custom_prompts) ~= "table" or custom_prompts.PlusUpsellSheetHomeLaunch == nil then
			return
		end

		local currentUserId = localUserIdStore.getCurrentUserId(false)

		if currentUserId == "" or currentUserIdSet[currentUserId] then
			return
		end

		currentUserIdSet[currentUserId] = true
		v5(currentUserId)
	end,
	usePlusUpsellSheetPrompt = function(data)
		local entryPoint = data.entryPoint
		local hasShownKey = data.hasShownKey
		local modalSignalStore = data.modalSignalStore

		local v6 = SignalsReact.useSignalState(signal)
		local v7 = useIsScreenFocused()
		local v8 = useSelector(function(p2)
			return p2.CentralOverlay and p2.CentralOverlay.OverlayType
		end)

		React.useEffect(function()
			if entryPoint ~= PromptsEntryPoint.HomepageLaunch or v6 == nil or (not v7 or v8 ~= nil) then
				return
			end

			if signal(false) ~= v6 then
				return
			end

			if
				modalSignalStore.getHasShownGetter(hasShownKey)(false)
				or modalSignalStore.getMetadataGetter(hasShownKey)(false)
			then
				return
			end

			if v6 ~= localUserIdStore.getCurrentUserId(false) then
				v5(nil)
				return
			end

			v5(nil)
			modalSignalStore.setHasShown(hasShownKey, true)

			initiateRobloxSubscriptionPurchase(
				{ sheetKind = robloxPlusSheetKind.TT },
				fFlagRobloxSubscriptionOnboardingSheet and {
					onFlowComplete = function(p2)
						if p2 ~= robloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
							return
						end

						default:detectURL("roblox://navigation/plus_onboarding")
					end
				} or nil,
				nil,
				surfaceName.HomepageLaunchPrompt,
				surfaceContext.InApp
			)

			reportPromptImpression("PlusUpsellSheetHomeLaunch", "PlusUpsellSheetHomeLaunch"):catch(function()
				Logger:warning("Failed to report Plus upsell sheet prompt impression")
			end)
			sendModalImpressionEvent("PlusUpsellSheetHomeLaunch", "PlusUpsellSheetHomeLaunch")
		end, { entryPoint, v6, v7, v8, modalSignalStore, hasShownKey })
	end,
	resetForTests = function()
		table.clear(currentUserIdSet)
		v5(nil)
	end
}
