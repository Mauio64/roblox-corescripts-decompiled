local GuiService = game:GetService("GuiService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Roact = require(PurchasePromptParent.PurchasePromptDeps).Roact
local React = require(PurchasePromptParent.React)
local ToastRodux = require(PurchasePromptParent.ToastRodux)
local CoreGui = game:GetService("CoreGui")

CoreGui:WaitForChild("RobloxGui")

local CoreScriptsRootProvider = require(PurchasePromptParent.CoreScriptsRoactCommon).CoreScriptsRootProvider
local FocusNavigationUtils = require(PurchasePromptParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local RequestType = require(PurchasePrompt.Enums.RequestType)
local completeRequest = require(PurchasePrompt.Thunks.completeRequest)
local launchSubscriptionPurchase = require(PurchasePrompt.Thunks.launchSubscriptionPurchase)
local sendEvent = require(PurchasePrompt.Thunks.sendEvent)
local connectToStore = require(PurchasePrompt.connectToStore)
local ExternalEventConnection = require(PurchasePrompt.Components.Connection.ExternalEventConnection)
local SubscriptionPurchaseOverlay = require(script.Parent.SubscriptionPurchaseOverlay)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local v20 = Roact.Component:extend(script.Name)
local GetFFlagFixPlayerGuiSelectionBugOnPromptExit = require(PurchasePrompt.Flags.GetFFlagFixPlayerGuiSelectionBugOnPromptExit)
local GetFFlagEnableSubscriptionPurchaseToast = require(PurchasePrompt.Flags.GetFFlagEnableSubscriptionPurchaseToast)
local FFlagSetMenuOnPurchasePrompt = require(PurchasePrompt.Flags.FFlagSetMenuOnPurchasePrompt)

function v20.init(p1) -- line: 35
	-- upvalues: GetFFlagFixPlayerGuiSelectionBugOnPromptExit (copy)
	p1.state = {
		screenSize = Vector2.new(0, 0)
	}

	function p1.changeScreenSize(p2) -- line: 40
		-- upvalues: p1 (copy)
		if p1.state.screenSize ~= p2.AbsoluteSize then
			p1:setState({
				screenSize = p2.AbsoluteSize
			})
		end
	end

	if GetFFlagFixPlayerGuiSelectionBugOnPromptExit() then
		p1.savedSelectedCoreObject = nil

		function p1.endPurchase() -- line: 49
			-- upvalues: p1 (copy)
			p1:restoreSelectedObject()
			p1.props.completeRequest()
		end
	end
end
function v20.saveSelectedObject(p3) -- line: 56
	-- upvalues: GetFFlagFixPlayerGuiSelectionBugOnPromptExit (copy), GuiService (copy)
	if not GetFFlagFixPlayerGuiSelectionBugOnPromptExit() then
		return
	end

	p3.savedSelectedCoreObject = GuiService.SelectedCoreObject
	GuiService.SelectedCoreObject = nil
end
function v20.restoreSelectedObject(p4) -- line: 65
	-- upvalues: GetFFlagFixPlayerGuiSelectionBugOnPromptExit (copy), CoreGui (copy), GuiService (copy)
	if not GetFFlagFixPlayerGuiSelectionBugOnPromptExit() then
		return
	end

	if p4.savedSelectedCoreObject == nil or p4.savedSelectedCoreObject:IsDescendantOf(CoreGui) then
		GuiService.SelectedCoreObject = p4.savedSelectedCoreObject
	end
end
function v20.createElement(p5) -- line: 76
	-- upvalues: GetFFlagFixPlayerGuiSelectionBugOnPromptExit (copy), Roact (copy), SubscriptionPurchaseOverlay (copy), ExternalEventConnection (copy), GuiService (copy), FFlagSetMenuOnPurchasePrompt (copy)
	local props = p5.props
	local state = p5.state

	if GetFFlagFixPlayerGuiSelectionBugOnPromptExit() then
		p5:saveSelectedObject()
	end

	local PrimaryPaymentProviderType = nil
	local v31 = nil
	local subscriptionPurchaseInfo = props.subscriptionPurchaseInfo

	if subscriptionPurchaseInfo ~= nil then
		PrimaryPaymentProviderType = subscriptionPurchaseInfo.PrimaryPaymentProviderType
		v31 = if not subscriptionPurchaseInfo.AllPaymentProviderTypes then nil else subscriptionPurchaseInfo.AllPaymentProviderTypes[2]
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = p5.changeScreenSize,
		BackgroundTransparency = 1
	}, {
		Prompt = Roact.createElement(SubscriptionPurchaseOverlay, {
			screenSize = state.screenSize,
			promptState = props.promptState,
			purchaseError = props.purchaseError,
			economicRestrictionError = props.economicRestrictionError,
			subscriptionId = props.subscriptionId,
			name = props.subscriptionPurchaseInfo.Name,
			subscriptionProviderId = props.subscriptionPurchaseInfo.SubscriptionProviderId,
			subscriptionProviderName = props.subscriptionPurchaseInfo.SubscriptionProviderName,
			priceTier = props.subscriptionPurchaseInfo.PriceTier,
			displayPrice = props.subscriptionPurchaseInfo.DisplayPrice,
			period = props.subscriptionPurchaseInfo.DisplaySubscriptionPeriod,
			disclaimerText = props.subscriptionPurchaseInfo.DisclaimerText,
			description = props.subscriptionPurchaseInfo.Description,
			itemIcon = props.subscriptionPurchaseInfo.ImageUrl,
			primaryPaymentMethod = PrimaryPaymentProviderType,
			secondaryPaymentMethod = v31,
			isGamepadEnabled = props.isGamepadEnabled,
			isTestingMode = props.subscriptionPurchaseInfo.IsTestingMode,
			promptSubscriptionPurchase = props.promptSubscriptionPurchase,
			endPurchase = if not GetFFlagFixPlayerGuiSelectionBugOnPromptExit() then props.completeRequest else p5.endPurchase,
			onAnalyticEvent = props.onAnalyticEvent,
			setCurrentToastMessage = props.setCurrentToastMessage
		}),
		ModalFix = Roact.createElement("ImageButton", {
			BackgroundTransparency = 0,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		OnCoreGuiMenuOpened = Roact.createElement(ExternalEventConnection, {
			event = GuiService.MenuOpened,
			callback = function() -- line: 136
				-- upvalues: FFlagSetMenuOnPurchasePrompt (copy), p5 (copy), props (copy)
				if FFlagSetMenuOnPurchasePrompt and p5.menuOpenedBySelf then
					p5.menuOpenedBySelf = false

					return
				end

				props.completeRequest()
			end
		})
	})
end
function v20.render(p6) -- line: 147
	-- upvalues: RequestType (copy), FFlagSetMenuOnPurchasePrompt (copy), GuiService (copy), Roact (copy), CoreScriptsRootProvider (copy), React (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	if p6.props.requestType ~= RequestType.Subscription then
		if FFlagSetMenuOnPurchasePrompt then
			GuiService:SetMenuIsOpen(false, "SubscriptionUpsellContainer")
		end

		return nil
	end

	local v34 = p6:createElement()

	if FFlagSetMenuOnPurchasePrompt then
		if v34 ~= nil then
			p6.menuOpenedBySelf = true
		end

		GuiService:SetMenuIsOpen(v34 ~= nil, "SubscriptionUpsellContainer")
	end

	return Roact.createElement(CoreScriptsRootProvider, {}, {
		FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			SubscriptionPurchaseContainer = v34
		})
	})
end

return (connectToStore(function(p7) -- line: 174
	return {
		requestType = p7.promptRequest.requestType,
		promptState = p7.promptState,
		purchaseError = p7.purchaseError,
		economicRestrictionError = p7.economicRestrictionError,
		subscriptionPurchaseInfo = p7.subscriptionPurchaseInfo,
		subscriptionId = p7.promptRequest.id,
		isGamepadEnabled = p7.gamepadEnabled
	}
end, function(p8) -- line: 186
	-- upvalues: launchSubscriptionPurchase (copy), completeRequest (copy), sendEvent (copy), GetFFlagEnableSubscriptionPurchaseToast (copy), SetCurrentToastMessage (copy)
	return {
		promptSubscriptionPurchase = function(p9) -- line: 188
			-- upvalues: p8 (copy), launchSubscriptionPurchase (copy)
			return p8(launchSubscriptionPurchase(p9))
		end,
		completeRequest = function() -- line: 191
			-- upvalues: p8 (copy), completeRequest (copy)
			return p8(completeRequest())
		end,
		onAnalyticEvent = function(p10, p11) -- line: 194
			-- upvalues: p8 (copy), sendEvent (copy)
			return p8(sendEvent(p10, p11))
		end,
		setCurrentToastMessage = if not GetFFlagEnableSubscriptionPurchaseToast() then nil else function(p12) -- line: 198
			-- upvalues: p8 (copy), SetCurrentToastMessage (copy)
			p8(SetCurrentToastMessage(p12))
		end
	}
end)(v20))
