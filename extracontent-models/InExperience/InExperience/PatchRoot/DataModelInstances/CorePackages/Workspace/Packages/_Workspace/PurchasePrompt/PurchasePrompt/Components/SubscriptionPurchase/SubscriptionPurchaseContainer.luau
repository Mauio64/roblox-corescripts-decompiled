local GuiService = game:GetService("GuiService")

local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact
local React = require(parent.React)
local ToastRodux = require(parent.ToastRodux)

local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")
local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
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

local extended = Roact.Component:extend(script.Name)

local GetFFlagEnableSubscriptionPurchaseToast = require(PurchasePrompt.Flags.GetFFlagEnableSubscriptionPurchaseToast)
local FFlagSetMenuOnPurchasePrompt = require(PurchasePrompt.Flags.FFlagSetMenuOnPurchasePrompt)

function extended:init()
	self.state = { screenSize = Vector2.new(0, 0) }

	function self.changeScreenSize(p)
		if self.state.screenSize ~= p.AbsoluteSize then
			self:setState({ screenSize = p.AbsoluteSize })
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
	local primaryPaymentProviderType, secondaryPaymentMethod

	if subscriptionPurchaseInfo ~= nil then
		primaryPaymentProviderType = subscriptionPurchaseInfo.PrimaryPaymentProviderType

		if subscriptionPurchaseInfo.AllPaymentProviderTypes then
			secondaryPaymentMethod = subscriptionPurchaseInfo.AllPaymentProviderTypes[2]
		end
	end

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			[Roact.Change.AbsoluteSize] = self.changeScreenSize,
			BackgroundTransparency = 1
		},
		{
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
				primaryPaymentMethod = primaryPaymentProviderType,
				secondaryPaymentMethod = secondaryPaymentMethod,
				isGamepadEnabled = props.isGamepadEnabled,
				isTestingMode = props.subscriptionPurchaseInfo.IsTestingMode,
				promptSubscriptionPurchase = props.promptSubscriptionPurchase,
				endPurchase = self.endPurchase,
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

		return Roact.createElement(CoreScriptsRootProvider, {}, {
			FocusNavigationCoreScriptsWrapper = React.createElement(
				FocusRoot,
				{
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
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
		promptSubscriptionPurchase = function(p)
			return callback(launchSubscriptionPurchase(p))
		end,
		completeRequest = function()
			return callback(completeRequest())
		end,
		onAnalyticEvent = function(p, p2)
			return callback(sendEvent(p, p2))
		end,
		setCurrentToastMessage = GetFFlagEnableSubscriptionPurchaseToast() and function(p)
			callback(SetCurrentToastMessage(p))
		end or nil
	}
end)(extended))
