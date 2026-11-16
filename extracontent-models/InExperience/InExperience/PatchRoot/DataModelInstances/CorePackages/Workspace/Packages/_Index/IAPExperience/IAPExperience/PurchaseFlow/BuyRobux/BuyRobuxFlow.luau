local HttpService = game:GetService("HttpService")

local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)

local BuyRobuxFlowState = require(parent.BuyRobuxFlowState)

local Constants = require(parent2.Generic.Constants)
local LoadingOverlay = require(parent2.Generic.LoadingOverlay)
local LoadingOverlayState = require(parent2.Generic.LoadingOverlayState)
local BuyRobuxPage = require(parent2.BuyRobux.BuyRobuxPage)
local PurchaseErrorPrompt = require(parent2.Generic.PurchaseErrorPrompt)
local U13ConfirmPrompt = require(parent2.Generic.U13ConfirmPrompt)

local getModalShownEventData = require(parent2.Utility.getModalShownEventData)
local getUserInputEventData = require(parent2.Utility.getUserInputEventData)

local VerifiedParentalConsentDialog = require(parent3.VerifiedParentalConsentDialog)
local verifiedParentalConsentDialog = VerifiedParentalConsentDialog.VerifiedParentalConsentDialog

local extended = Roact.Component:extend(script.Name)

function extended:init()
	local analyticId

	if self.props.analyticId then
		analyticId = self.props.analyticId
	else
		analyticId = HttpService:GenerateGUID(false)
	end

	self.state = { analyticId = analyticId }
end

function extended:didUpdate(p, _)
	local props = self.props

	if p.purchaseState ~= props.purchaseState then
		self:reportModalShown()
		self:dispatchAndRenderModal(props)
	end
end

function extended:dispatchAndRenderModal(data)
	if data.purchaseState == BuyRobuxFlowState.Error then
		data.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, {
			shouldAnimate = data.shouldAnimate,
			shouldShow = data.purchaseState == BuyRobuxFlowState.Error,
			renderChildren = function()
				return Roact.createElement(PurchaseErrorPrompt, {
					screenSize = data.screenSize,
					errorType = data.errorType,
					economicRestrictionError = data.economicRestrictionError,
					doneControllerIcon = data.acceptControllerIcon,
					doneActivated = function()
						self:reportUserInput("Done")
						data.flowComplete()
						data.dispatchCentralOverlay()
					end
				})
			end
		})
	elseif data.purchaseState == BuyRobuxFlowState.PurchaseWarning then
		data.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, {
			shouldAnimate = data.shouldAnimate,
			shouldShow = data.purchaseState == BuyRobuxFlowState.PurchaseWarning,
			renderChildren = function()
				return Roact.createElement(U13ConfirmPrompt, {
					screenSize = data.screenSize,
					modalType = data.u13ConfirmType,
					doneActivated = function()
						self:reportUserInput("Confirm")
						data.acceptPurchaseWarning()
						data.dispatchCentralOverlay()
					end,
					cancelActivated = function()
						self:reportUserInput("Cancel")
						data.cancelPurchase()
						data.dispatchCentralOverlay()
					end
				})
			end
		})
	elseif data.purchaseState == BuyRobuxFlowState.PurchaseVPC then
		data.dispatchCentralOverlay(Constants.CENTRAL_OVERLAY_TYPE_ANIMATOR, {
			shouldAnimate = data.shouldAnimate,
			shouldShow = data.purchaseState == BuyRobuxFlowState.PurchaseVPC,
			renderChildren = function()
				return Roact.createElement(verifiedParentalConsentDialog, {
					screenSize = data.screenSize,
					isActionable = false,
					modalType = data.purchaseVPCType,
					onDismiss = function()
						self:reportUserInput("Close")
						data.flowComplete()
						data.dispatchCentralOverlay()
					end
				})
			end
		})
	end
end

function extended:reportModalShown()
	local props = self.props
	local state = self.state

	if not self.props.onAnalyticEvent then
		return
	end

	local modalShownEventData = getModalShownEventData(
		state.analyticId,
		"",
		"BuyRobux",
		BuyRobuxFlowState.toRawValue(props.purchaseState)
	)

	props.onAnalyticEvent("UserPurchaseFlow", modalShownEventData)
end

function extended:reportUserInput(p: string)
	local props = self.props
	local state = self.state

	if not self.props.onAnalyticEvent then
		return
	end

	local userInputEventData = getUserInputEventData(
		state.analyticId,
		"",
		"BuyRobux",
		BuyRobuxFlowState.toRawValue(props.purchaseState),
		p
	)

	props.onAnalyticEvent("UserPurchaseFlow", userInputEventData)
end

function extended:purchaseStateToOverlayState(p)
	if p == BuyRobuxFlowState.Loading then
		return LoadingOverlayState.Loading
	end

	if p == BuyRobuxFlowState.RobuxPurchasePending then
		return LoadingOverlayState.PurchasingRobux
	end

	if p == BuyRobuxFlowState.RobuxGrantPending then
		return LoadingOverlayState.WaitingForRobux
	end

	if not (p ~= BuyRobuxFlowState.PurchaseWarning and p ~= BuyRobuxFlowState.None) then
		return LoadingOverlayState.None
	end

	return nil
end

function extended:render()
	local props = self.props
	local state = self.state
	local purchaseState = props.purchaseState

	local purchaseStateToOverlayState = self:purchaseStateToOverlayState(props.purchaseState)

	return Roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		BuyRobuxFrame = Roact.createElement(BuyRobuxPage, {
			showCloseButton = props.showCloseButton,
			showBackground = props.showBackground,
			isConsoleSize = props.isConsoleSize,
			robuxBalance = props.robuxBalance,
			robuxPackages = props.robuxPackages,
			robuxPackageActivated = function(p: string)
				self:reportUserInput("Confirm")
				props.purchaseRobux(p)
			end,
			onPageClose = props.onPageClose,
			hasNativePurchaseSucceeded = purchaseState == BuyRobuxFlowState.Succeed,
			shouldAnimate = props.shouldAnimate,
			analyticId = state.analyticId,
			onAnalyticEvent = props.onAnalyticEvent
		}),
		LoadingOverlay = Roact.createElement(LoadingOverlay, {
			shouldAnimate = false,
			showOverlay = purchaseStateToOverlayState ~= nil,
			loadingState = purchaseStateToOverlayState
		})
	})
end

return extended
