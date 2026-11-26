local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite")
local RunService = game:GetService("RunService")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")

local roact = PurchasePromptDeps.Roact
local rodux = PurchasePromptDeps.Rodux

local CoreGui = game:GetService("CoreGui")
local PurchasePromptApp = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/PurchasePromptApp")
local Reducer = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Reducers/Reducer")
local ABTest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ABTest")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local PlatformInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/PlatformInterface")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local PublicBindables = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/PublicBindables")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/initiateAvatarCreationFeePurchase")
local UnifiedPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/UnifiedPurchasePrompt")
local dispatchPurchaseForProductPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/dispatchPurchaseForProductPayload")
local SetProductPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetProductPayload")
local SetPurchaseAnalyticsMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseAnalyticsMetadata")

local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local fFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop
local fFlagPassShopPurchaseSurfaceToBuyModal = SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal
local FFlagSkipBuyDelayForExperienceShop = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagSkipBuyDelayForExperienceShop")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local fFlagPurchasePromptSubtitleForTimedOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagPurchasePromptSubtitleForTimedOptions
local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local fFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop
local defineFastFlag = game:DefineFastFlag("PurchasePromptElevateDisplayOrder", false)

local WindowState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/WindowState")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local module21 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/PublishAssetAnalytics")

local v5 = nil
local store = nil

local v6 = nil

local bindableEvent = Instance.new("BindableEvent")
local bindableEvent2 = Instance.new("BindableEvent")

local function createStore()
	local v7 = ABTest.new()
	v6 = Network.new()

	local v8 = Analytics.new()
	local v9 = PlatformInterface.new()
	local v10 = ExternalSettings.new()

	local v11 = PublicBindables.new({ windowStateChangedBindable = bindableEvent })

	store = rodux.Store.new(Reducer, {}, { Thunk.middleware({
			[ABTest] = v7,
			[Network] = v6,
			[Analytics] = v8,
			[PlatformInterface] = v9,
			[ExternalSettings] = v10,
			[PublicBindables] = v11
		}) })

	store.changed:connect(function(data, data2)
		if data2.windowState ~= data.windowState then
			bindableEvent:Fire({
				isShown = data.windowState == WindowState.Shown,
				hasCompletedPurchase = data.hasCompletedPurchase
			})
		end

		if data2.promptState ~= data.promptState and data.promptState == PromptState.None then
			bindableEvent2:Fire()
		end

		if not data2.hasCompletedPurchase and data.hasCompletedPurchase then
			PurchasePromptLite.Events.firePurchaseCompleted()
		end
	end)
end

local function UnifiedPurchasePromptContainer(props)
	createStore()

	local createElement = roact.createElement
	local v8 = {
		store = store,
		network = v6,
		productPayload = props.productPayload,
		purchaseCallbacks = props.purchaseCallbacks,
		postPurchaseActions = props.postPurchaseActions,
		purchaseAnalyticsMetadata = props.purchaseAnalyticsMetadata,
		purchaseOptions = 0,
		subtitleView = 0
	}

	local v9 = if fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then props.purchaseOptions else nil
	v8.purchaseOptions = v9

	local v10 = if fFlagPurchasePromptSubtitleForTimedOptions then props.subtitleView else nil
	v8.subtitleView = v10
	return createElement(UnifiedPurchasePrompt, v8)
end

local v7 = {
	mountPurchasePrompt = function()
		if RunService:IsStudio() and RunService:IsEdit() or v5 then
			return nil
		end

		createStore()

		local v8 = { AutoLocalize = false, IgnoreGuiInset = true }

		if defineFastFlag then
			v8.DisplayOrder = 10
		end

		local element = roact.createElement("ScreenGui", v8, {
			roact.createElement(PurchasePromptApp, { store = store, network = v6 })
		})

		v5 = roact.mount(element, CoreGui, "PurchasePromptApp")

		return v5
	end,
	initiateAvatarCreationFeePurchase = function(p2, p3, p4, p5)
		if not store then
			error("initiateAvatarCreationFeePurchase cannot be called when the PurchasePrompt has not been mounted")
		end

		store:dispatch(module13(p2, p3, p4, p5))
	end,
	initiatePurchaseForProductPayload = function(p2, p3)
		if not store then
			warn("initiatePurchaseForProductPayload called before mountPurchasePrompt; ignoring.")
			return
		end

		if fFlagEnablePurchasePayloadInExperienceShop or FFlagSkipBuyDelayForExperienceShop then
			store:dispatch(SetProductPayload(p2))
		end

		if fFlagPassShopPurchaseSurfaceToBuyModal and p3 then
			store:dispatch(SetPurchaseAnalyticsMetadata({
				surface = p3.surface,
				productUniverseId = p3.productUniverseId
			}))
		end

		dispatchPurchaseForProductPayload(function(p4)
			store:dispatch(p4)
		end, p2, nil, false)
	end,
	windowStateChangedEvent = bindableEvent.Event,
	promptStateSetToNoneEvent = bindableEvent2.Event,
	Utils = fFlagAXMISWithBlackbird and {
		getBlackbirdUpsellBannerProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getBlackbirdUpsellBannerProductInfo")
	} or {},
	PublishAssetAnalytics = module21,
	UnifiedPurchasePromptContainer = UnifiedPurchasePromptContainer,
	launchRobuxPackagePurchase = 0
}

local v8 = if fFlagEnableRobuxInExperienceShop then require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/launchRobuxPackagePurchase") else nil
v7.launchRobuxPackagePurchase = v8
return v7
