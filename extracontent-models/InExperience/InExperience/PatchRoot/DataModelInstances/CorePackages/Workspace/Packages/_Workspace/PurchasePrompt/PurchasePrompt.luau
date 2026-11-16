local script2 = script
local parent = script2.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local PurchasePromptLite = require(parent.PurchasePromptLite)
local RunService = game:GetService("RunService")
local SharedFlags = require(parent.SharedFlags)

local Roact = PurchasePromptDeps.Roact
local Rodux = PurchasePromptDeps.Rodux

local CoreGui = game:GetService("CoreGui")
local PurchasePromptApp = require(script.Components.PurchasePromptApp)
local Reducer = require(script2.Reducers.Reducer)
local ABTest = require(script2.Services.ABTest)
local Network = require(script2.Services.Network)
local Analytics = require(script2.Services.Analytics)
local PlatformInterface = require(script2.Services.PlatformInterface)
local ExternalSettings = require(script2.Services.ExternalSettings)
local PublicBindables = require(script2.Services.PublicBindables)
local Thunk = require(script2.Thunk)
local initiateAvatarCreationFeePurchase = require(script2.Thunks.initiateAvatarCreationFeePurchase)
local UnifiedPurchasePrompt = require(script2.Components.UnifiedPurchasePrompt)
local dispatchPurchaseForProductPayload = require(script2.Utils.dispatchPurchaseForProductPayload)
local SetProductPayload = require(script2.Actions.SetProductPayload)
local SetPurchaseAnalyticsMetadata = require(script2.Actions.SetPurchaseAnalyticsMetadata)

local SharedFlags2 = require(script2.Parent.SharedFlags)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags2.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop
local FFlagPassShopPurchaseSurfaceToBuyModal = SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal
local FFlagSkipBuyDelayForExperienceShop = require(script2.Flags.FFlagSkipBuyDelayForExperienceShop)
require(script2.types)

local SharedFlags3 = require(script2.Parent.SharedFlags)
local FFlagPurchasePromptSubtitleForTimedOptions = SharedFlags3.FFlagPurchasePromptSubtitleForTimedOptions
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop
local defineFastFlag = game:DefineFastFlag("PurchasePromptElevateDisplayOrder", false)

local WindowState = require(script2.Enums.WindowState)
local PromptState = require(script2.Enums.PromptState)
local PublishAssetAnalytics = require(script2.Utils.PublishAssetAnalytics)

local v = nil
local store = nil

local network = nil

local bindableEvent = Instance.new("BindableEvent")
local bindableEvent2 = Instance.new("BindableEvent")

local function createStore()
	local v2 = ABTest.new()
	network = Network.new()

	local v3 = Analytics.new()
	local v4 = PlatformInterface.new()
	local v5 = ExternalSettings.new()

	local v6 = PublicBindables.new({ windowStateChangedBindable = bindableEvent })

	store = Rodux.Store.new(Reducer, {}, { Thunk.middleware({
			[ABTest] = v2,
			[Network] = network,
			[Analytics] = v3,
			[PlatformInterface] = v4,
			[ExternalSettings] = v5,
			[PublicBindables] = v6
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

	local createElement = Roact.createElement
	local v2 = {
		store = store,
		network = network,
		productPayload = props.productPayload,
		purchaseCallbacks = props.purchaseCallbacks,
		postPurchaseActions = props.postPurchaseActions,
		purchaseAnalyticsMetadata = props.purchaseAnalyticsMetadata,
		purchaseOptions = 0,
		subtitleView = 0
	}
	local purchaseOptions

	if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
		purchaseOptions = props.purchaseOptions
	end

	v2.purchaseOptions = purchaseOptions
	local subtitleView

	if FFlagPurchasePromptSubtitleForTimedOptions then
		subtitleView = props.subtitleView
	end

	v2.subtitleView = subtitleView
	return createElement(UnifiedPurchasePrompt, v2)
end

local PurchasePrompt = {
	["mountPurchasePrompt"] = nil,
	["mountPurchasePrompt"] = nil,
	["mountPurchasePrompt"] = nil,
	["mountPurchasePrompt"] = nil,
	mountPurchasePrompt = function()
		if RunService:IsStudio() and RunService:IsEdit() or v then
			return nil
		end

		createStore()

		local v2 = { AutoLocalize = false, IgnoreGuiInset = true }

		if defineFastFlag then
			v2.DisplayOrder = 10
		end

		local element = Roact.createElement("ScreenGui", v2, {
			Roact.createElement(PurchasePromptApp, { store = store, network = network })
		})

		v = Roact.mount(element, CoreGui, "PurchasePromptApp")

		return v
	end,
	initiateAvatarCreationFeePurchase = function(p, p2, p3, p4)
		if not store then
			error("initiateAvatarCreationFeePurchase cannot be called when the PurchasePrompt has not been mounted")
		end

		store:dispatch(initiateAvatarCreationFeePurchase(p, p2, p3, p4))
	end,
	initiatePurchaseForProductPayload = function(p, p2)
		if not store then
			warn("initiatePurchaseForProductPayload called before mountPurchasePrompt; ignoring.")
			return
		end

		if FFlagEnablePurchasePayloadInExperienceShop or FFlagSkipBuyDelayForExperienceShop then
			store:dispatch(SetProductPayload(p))
		end

		if FFlagPassShopPurchaseSurfaceToBuyModal and p2 then
			store:dispatch(SetPurchaseAnalyticsMetadata({
				surface = p2.surface,
				productUniverseId = p2.productUniverseId
			}))
		end

		dispatchPurchaseForProductPayload(function(p3)
			store:dispatch(p3)
		end, p, nil, false)
	end,
	windowStateChangedEvent = bindableEvent.Event,
	promptStateSetToNoneEvent = bindableEvent2.Event
}
local utils

if FFlagAXMISWithBlackbird then
	utils = { getBlackbirdUpsellBannerProductInfo = 0 }
	utils.getBlackbirdUpsellBannerProductInfo = require(script2.Utils.getBlackbirdUpsellBannerProductInfo)
else
	utils = {}
end

PurchasePrompt.Utils = utils

PurchasePrompt.PublishAssetAnalytics = PublishAssetAnalytics
PurchasePrompt.UnifiedPurchasePromptContainer = UnifiedPurchasePromptContainer
local launchRobuxPackagePurchase

if FFlagEnableRobuxInExperienceShop then
	launchRobuxPackagePurchase = require(script2.launchRobuxPackagePurchase)
end

PurchasePrompt.launchRobuxPackagePurchase = launchRobuxPackagePurchase

PurchasePrompt["jest.config"] = script["jest.config"]
PurchasePrompt["jest.main.config"] = script["jest.main.config"]
PurchasePrompt["jest.mockDataModel.config"] = script["jest.mockDataModel.config"]
return PurchasePrompt
