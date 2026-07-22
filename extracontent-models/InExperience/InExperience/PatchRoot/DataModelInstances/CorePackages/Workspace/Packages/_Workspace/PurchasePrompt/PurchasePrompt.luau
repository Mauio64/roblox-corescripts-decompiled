local _script = script
local _scriptParent = _script.Parent
local PurchasePromptDeps = require(_scriptParent.PurchasePromptDeps)
local PurchasePromptLite = require(_scriptParent.PurchasePromptLite)
local RunService = game:GetService("RunService")
local SharedFlags = require(_scriptParent.SharedFlags)
local Roact = PurchasePromptDeps.Roact
local Rodux = PurchasePromptDeps.Rodux
local CoreGui = game:GetService("CoreGui")
local PurchasePromptApp = require(script.Components.PurchasePromptApp)
local Reducer = require(_script.Reducers.Reducer)
local ABTest = require(_script.Services.ABTest)
local Network = require(_script.Services.Network)
local Analytics = require(_script.Services.Analytics)
local PlatformInterface = require(_script.Services.PlatformInterface)
local ExternalSettings = require(_script.Services.ExternalSettings)
local PublicBindables = require(_script.Services.PublicBindables)
local Thunk = require(_script.Thunk)
local initiateAvatarCreationFeePurchase = require(_script.Thunks.initiateAvatarCreationFeePurchase)
local UnifiedPurchasePrompt = require(_script.Components.UnifiedPurchasePrompt)
local dispatchPurchaseForProductPayload = require(_script.Utils.dispatchPurchaseForProductPayload)
local SetProductPayload = require(_script.Actions.SetProductPayload)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require(_script.Parent.SharedFlags).FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagPurchasePromptCartPricingEnabled = require(_script.Flags.FFlagPurchasePromptCartPricingEnabled)
local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop
local FFlagSkipBuyDelayForExperienceShop = require(_script.Flags.FFlagSkipBuyDelayForExperienceShop)

require(_script.types)

local FFlagEnableUnifiedProductPurchaseFlow = require(_script.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagPurchasePromptSubtitleForTimedOptions = require(_script.Parent.SharedFlags).FFlagPurchasePromptSubtitleForTimedOptions
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop
local v31 = game:DefineFastFlag("PurchasePromptElevateDisplayOrder", false)
local WindowState = require(_script.Enums.WindowState)
local PromptState = require(_script.Enums.PromptState)
local PublishAssetAnalytics = require(_script.Utils.PublishAssetAnalytics)
local u35 = nil
local u36 = nil
local u37 = nil
local BindableEvent = Instance.new("BindableEvent")
local BindableEvent2 = Instance.new("BindableEvent")

local function createStore() -- line: 59
	-- upvalues: ABTest (copy), Network (copy), FFlagPurchasePromptCartPricingEnabled (copy), u37 (ref), Analytics (copy), PlatformInterface (copy), ExternalSettings (copy), PublicBindables (copy), BindableEvent (copy), u36 (ref), Rodux (copy), Reducer (copy), Thunk (copy), WindowState (copy), PromptState (copy), BindableEvent2 (copy), PurchasePromptLite (copy)
	local v42 = ABTest.new()
	local v43 = Network.new()

	if FFlagPurchasePromptCartPricingEnabled then
		u37 = v43
	end

	local v44 = Analytics.new()
	local v45 = PlatformInterface.new()
	local v46 = ExternalSettings.new()
	local v47 = PublicBindables.new({
		windowStateChangedBindable = BindableEvent
	})

	u36 = Rodux.Store.new(Reducer, {}, { Thunk.middleware({
		[ABTest] = v42,
		[Network] = if not FFlagPurchasePromptCartPricingEnabled then v43 else u37,
		[Analytics] = v44,
		[PlatformInterface] = v45,
		[ExternalSettings] = v46,
		[PublicBindables] = v47
	}) })
	u36.changed:connect(function(p1, p2) -- line: 85
		-- upvalues: BindableEvent (copy), WindowState (copy), PromptState (copy), BindableEvent2 (copy), FFlagPurchasePromptCartPricingEnabled (copy), PurchasePromptLite (copy)
		if p2.windowState ~= p1.windowState then
			BindableEvent:Fire({
				isShown = p1.windowState == WindowState.Shown,
				hasCompletedPurchase = p1.hasCompletedPurchase
			})
		end

		if p2.promptState ~= p1.promptState and p1.promptState == PromptState.None then
			BindableEvent2:Fire()
		end

		if FFlagPurchasePromptCartPricingEnabled and not p2.hasCompletedPurchase and p1.hasCompletedPurchase then
			PurchasePromptLite.Events.firePurchaseCompleted()
		end
	end)
end
local function UnifiedPurchasePromptContainer(t1: {[any]: any}) -- line: 209
	-- upvalues: createStore (copy), Roact (copy), UnifiedPurchasePrompt (copy), u36 (ref), FFlagPurchasePromptCartPricingEnabled (copy), u37 (ref), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy)
	createStore()

	return Roact.createElement(UnifiedPurchasePrompt, {
		store = u36,
		network = if not FFlagPurchasePromptCartPricingEnabled then nil else u37,
		productPayload = t1.productPayload,
		purchaseCallbacks = t1.purchaseCallbacks,
		postPurchaseActions = t1.postPurchaseActions,
		purchaseAnalyticsMetadata = t1.purchaseAnalyticsMetadata,
		purchaseOptions = if not FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then nil else t1.purchaseOptions,
		subtitleView = if not FFlagPurchasePromptSubtitleForTimedOptions then nil else t1.subtitleView
	})
end

return {
	mountPurchasePrompt = function() -- line: 115
		-- upvalues: RunService (copy), u35 (ref), createStore (copy), v31 (copy), Roact (copy), PurchasePromptApp (copy), u36 (ref), FFlagPurchasePromptCartPricingEnabled (copy), u37 (ref), CoreGui (copy)
		if RunService:IsStudio() and RunService:IsEdit() or u35 then
			return nil
		end

		createStore()

		local t2 = {
			AutoLocalize = false,
			IgnoreGuiInset = true
		}

		if v31 then
			t2.DisplayOrder = 10
		end

		local v49 = Roact.createElement("ScreenGui", t2, { Roact.createElement(PurchasePromptApp, {
			store = u36,
			network = if not FFlagPurchasePromptCartPricingEnabled then nil else u37
		}) })

		u35 = Roact.mount(v49, CoreGui, "PurchasePromptApp")

		return u35
	end,
	initiateAvatarCreationFeePurchase = function(p3, p4, p5, p6) -- line: 149
		-- upvalues: u36 (ref), initiateAvatarCreationFeePurchase (copy)
		if not u36 then
			error("initiateAvatarCreationFeePurchase cannot be called when the PurchasePrompt has not been mounted")
		end

		u36:dispatch(initiateAvatarCreationFeePurchase(p3, p4, p5, p6))
	end,
	initiatePurchaseForProductPayload = function(p7) -- line: 176
		-- upvalues: u36 (ref), FFlagEnablePurchasePayloadInExperienceShop (copy), FFlagSkipBuyDelayForExperienceShop (copy), SetProductPayload (copy), dispatchPurchaseForProductPayload (copy)
		if not u36 then
			warn("initiatePurchaseForProductPayload called before mountPurchasePrompt; ignoring.")

			return
		end

		if FFlagEnablePurchasePayloadInExperienceShop or FFlagSkipBuyDelayForExperienceShop then
			u36:dispatch(SetProductPayload(p7))
		end

		dispatchPurchaseForProductPayload(function(p8) -- line: 192
			-- upvalues: u36 (ref)
			u36:dispatch(p8)
		end, p7, nil, false)
	end,
	windowStateChangedEvent = BindableEvent.Event,
	promptStateSetToNoneEvent = BindableEvent2.Event,
	Utils = if not FFlagAXMISWithBlackbird then {} else {
		getBlackbirdUpsellBannerProductInfo = require(_script.Utils.getBlackbirdUpsellBannerProductInfo)
	},
	PublishAssetAnalytics = PublishAssetAnalytics,
	UnifiedPurchasePromptContainer = if not FFlagEnableUnifiedProductPurchaseFlow then nil else UnifiedPurchasePromptContainer,
	launchRobuxPackagePurchase = if not FFlagEnableRobuxInExperienceShop then nil else require(_script.launchRobuxPackagePurchase),
	["jest.config"] = script["jest.config"],
	["jest.main.config"] = script["jest.main.config"],
	["jest.mockDataModel.config"] = script["jest.mockDataModel.config"]
}
