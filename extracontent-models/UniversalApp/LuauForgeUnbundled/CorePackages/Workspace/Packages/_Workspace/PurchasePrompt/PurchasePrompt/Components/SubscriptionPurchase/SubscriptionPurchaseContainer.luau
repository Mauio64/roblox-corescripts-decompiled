local GuiService = game:GetService("GuiService")

local roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Roact
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/ToastRodux")

local CoreGui = game:GetService("CoreGui")

local coreScriptsRootProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/CoreScriptsRoactCommon").CoreScriptsRootProvider
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completeRequest")
local launchSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/launchSubscriptionPurchase")
local sendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/sendEvent")
local connectToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/connectToStore")

local ExternalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/ExternalEventConnection")
local SubscriptionPurchaseOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/SubscriptionPurchase/SubscriptionPurchaseOverlay")

local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local extended = roact.Component:extend("SubscriptionPurchaseContainer")

local GetFFlagEnableSubscriptionPurchaseToast = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableSubscriptionPurchaseToast")
local FFlagSetMenuOnPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagSetMenuOnPurchasePrompt")

function extended:init()
	self.state = { screenSize = Vector2.new(0, 0) }

	function self.changeScreenSize(p2)
		if self.state.screenSize ~= p2.AbsoluteSize then
			self:setState({ screenSize = p2.AbsoluteSize })
		end
	end
	self.savedSelectedCoreObject = nil
	function self.endPurchase()
		self:restoreSelectedObject()
		self.props.completeRequest()
	end
end

function extended:saveSelectedObject()
	self.savedSelectedCoreObject = GuiService.SelectedCoreObject
	GuiService.SelectedCoreObject = nil
end

function extended:restoreSelectedObject()
	if self.savedSelectedCoreObject == nil or self.savedSelectedCoreObject:IsDescendantOf(CoreGui) then
		GuiService.SelectedCoreObject = self.savedSelectedCoreObject
	end
end

function extended:createElement()
	local props = self.props
	local state = self.state

	self:saveSelectedObject()

	local subscriptionPurchaseInfo = props.subscriptionPurchaseInfo
	local primaryPaymentProviderType, v5

	if subscriptionPurchaseInfo ~= nil then
		primaryPaymentProviderType = subscriptionPurchaseInfo.PrimaryPaymentProviderType

		if subscriptionPurchaseInfo.AllPaymentProviderTypes then
			v5 = subscriptionPurchaseInfo.AllPaymentProviderTypes[2]
		end
	end

	return roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			[roact.Change.AbsoluteSize] = self.changeScreenSize,
			BackgroundTransparency = 1
		},
		{
			Prompt = roact.createElement(SubscriptionPurchaseOverlay, {
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
				primaryPaymentMethod = primaryPaymentProviderType,
				secondaryPaymentMethod = v5,
				isGamepadEnabled = props.isGamepadEnabled,
				isTestingMode = props.subscriptionPurchaseInfo.IsTestingMode,
				promptSubscriptionPurchase = props.promptSubscriptionPurchase,
				endPurchase = self.endPurchase,
				onAnalyticEvent = props.onAnalyticEvent,
				setCurrentToastMessage = props.setCurrentToastMessage
			}),
			ModalFix = roact.createElement("ImageButton", {
				BackgroundTransparency = 0,
				Modal = true,
				Size = UDim2.new(0, 0, 0, 0)
			}),
			OnCoreGuiMenuOpened = roact.createElement(ExternalEventConnection, {
				event = GuiService.MenuOpened,
				callback = function()
					if FFlagSetMenuOnPurchasePrompt and self.menuOpenedBySelf then
						self.menuOpenedBySelf = false
					else
						props.completeRequest()
					end
				end
			})
		}
	)
end

function extended:render()
	if self.props.requestType == RequestType.Subscription then
		local element = self:createElement()

		if FFlagSetMenuOnPurchasePrompt then
			if element ~= nil then
				self.menuOpenedBySelf = true
			end

			GuiService:SetMenuIsOpen(element ~= nil, "SubscriptionUpsellContainer")
		end

		return roact.createElement(coreScriptsRootProvider, {}, {
			FocusNavigationCoreScriptsWrapper = React.createElement(
				focusRoot,
				{
					surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
					isIsolated = true,
					isAutoFocusRoot = true
				},
				{ SubscriptionPurchaseContainer = element }
			)
		})
	end

	if FFlagSetMenuOnPurchasePrompt then
		GuiService:SetMenuIsOpen(false, "SubscriptionUpsellContainer")
	end

	return nil
end

return (connectToStore(function(data)
	return {
		requestType = data.promptRequest.requestType,
		promptState = data.promptState,
		purchaseError = data.purchaseError,
		economicRestrictionError = data.economicRestrictionError,
		subscriptionPurchaseInfo = data.subscriptionPurchaseInfo,
		subscriptionId = data.promptRequest.id,
		isGamepadEnabled = data.gamepadEnabled
	}
end, function(callback)
	return {
		promptSubscriptionPurchase = function(p2)
			return callback(launchSubscriptionPurchase(p2))
		end,
		completeRequest = function()
			return callback(module5())
		end,
		onAnalyticEvent = function(p2, p3)
			return callback(sendEvent(p2, p3))
		end,
		setCurrentToastMessage = GetFFlagEnableSubscriptionPurchaseToast() and function(p2)
			callback(setCurrentToastMessage(p2))
		end or nil
	}
end)(extended))
