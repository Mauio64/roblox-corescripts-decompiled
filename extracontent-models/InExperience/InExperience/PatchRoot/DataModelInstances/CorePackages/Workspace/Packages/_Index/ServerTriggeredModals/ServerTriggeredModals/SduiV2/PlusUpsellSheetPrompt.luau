local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local LinkingProtocol = require(parent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Logger = require(ServerTriggeredModals.Logger)
local reportPromptImpression = require(ServerTriggeredModals.reportPromptImpression)
local ServerTriggeredModalImpressions = require(parent.ServerTriggeredModalImpressions)
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent
local PromptsEntryPoint = require(script.Parent.PromptsEntryPoint)
require(script.Parent.Types.PromptsTypes)
require(ServerTriggeredModals.SignalStores.createModalSignalStore)
require(ServerTriggeredModals.EntryPoint)

local SharedFlags = require(parent.SharedFlags)
local FFlagRobloxSubscriptionOnboardingSheet = SharedFlags.FFlagRobloxSubscriptionOnboardingSheet

local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local RobloxPlusSheetKind = RobloxSubscriptionPurchaseApp.RobloxPlusSheetKind
local RobloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason

local currentUserIdSet = {}

local signal, v = Signals.createSignal(nil)

local function useIsScreenFocused()
	local v2 = React.useContext(RoactNavigation.Context)
	local useState = React.useState
	local v3

	if v2 == nil then
		v3 = false
	else
		v3 = v2.isFocused()
	end

	local state, setState = useState(v3)

	React.useEffect(function()
		if v2 == nil then
			setState(false)
			return
		end

		local v4 = v2.addListener(RoactNavigation.Events.WillFocus, function()
			setState(true)
		end)
		local v5 = v2.addListener(RoactNavigation.Events.WillBlur, function()
			setState(false)
		end)
		setState(v2.isFocused())

		return function()
			v4.remove()
			v5.remove()
		end
	end, { v2 })

	return state
end

local PlusUpsellSheetPrompt = {}

function PlusUpsellSheetPrompt.handlePromptsResponse(p)
	if type(p) ~= "table" then
		return
	end

	local custom_prompts = p.custom_prompts

	if type(custom_prompts) ~= "table" or custom_prompts.PlusUpsellSheetHomeLaunch == nil then
		return
	end

	local currentUserId = localUserIdStore.getCurrentUserId(false)

	if currentUserId == "" or currentUserIdSet[currentUserId] then
		return
	end

	currentUserIdSet[currentUserId] = true
	v(currentUserId)
end

function PlusUpsellSheetPrompt.usePlusUpsellSheetPrompt(data)
	local entryPoint = data.entryPoint
	local hasShownKey = data.hasShownKey
	local modalSignalStore = data.modalSignalStore

	local v2 = SignalsReact.useSignalState(signal)
	local v3 = useIsScreenFocused()
	local v4 = useSelector(function(p)
		return p.CentralOverlay and p.CentralOverlay.OverlayType
	end)

	React.useEffect(function()
		if entryPoint ~= PromptsEntryPoint.HomepageLaunch or v2 == nil or (not v3 or v4 ~= nil) then
			return
		end

		if signal(false) ~= v2 then
			return
		end

		if
			modalSignalStore.getHasShownGetter(hasShownKey)(false)
			or modalSignalStore.getMetadataGetter(hasShownKey)(false)
		then
			return
		end

		if v2 ~= localUserIdStore.getCurrentUserId(false) then
			v(nil)
			return
		end

		v(nil)
		modalSignalStore.setHasShown(hasShownKey, true)

		initiateRobloxSubscriptionPurchase(
			{ sheetKind = RobloxPlusSheetKind.TT },
			FFlagRobloxSubscriptionOnboardingSheet and {
				onFlowComplete = function(p)
					if p ~= RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
						return
					end

					default:detectURL("roblox://navigation/plus_onboarding")
				end
			} or nil,
			nil,
			SurfaceName.HomepageLaunchPrompt,
			SurfaceContext.InApp
		)

		reportPromptImpression("PlusUpsellSheetHomeLaunch", "PlusUpsellSheetHomeLaunch"):catch(function()
			Logger:warning("Failed to report Plus upsell sheet prompt impression")
		end)
		sendModalImpressionEvent("PlusUpsellSheetHomeLaunch", "PlusUpsellSheetHomeLaunch")
	end, { entryPoint, v2, v3, v4, modalSignalStore, hasShownKey })
end

function PlusUpsellSheetPrompt.resetForTests()
	table.clear(currentUserIdSet)
	v(nil)
end

return PlusUpsellSheetPrompt
