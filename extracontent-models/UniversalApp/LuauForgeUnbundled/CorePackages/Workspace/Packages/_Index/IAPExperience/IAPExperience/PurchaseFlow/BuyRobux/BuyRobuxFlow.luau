local HttpService = game:GetService("HttpService")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local BuyRobuxFlowState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/PurchaseFlow/BuyRobux/BuyRobuxFlowState")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Constants")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/LoadingOverlay")
local LoadingOverlayState = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/LoadingOverlayState")
local BuyRobuxPage = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/BuyRobux/BuyRobuxPage")
local PurchaseErrorPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PurchaseErrorPrompt")
local U13ConfirmPrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/U13ConfirmPrompt")

local getModalShownEventData = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getModalShownEventData")
local getUserInputEventData = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getUserInputEventData")

local verifiedParentalConsentDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/VerifiedParentalConsentDialog").VerifiedParentalConsentDialog

local extended = Roact.Component:extend("BuyRobuxFlow")

function extended:init()
	local v6 = if self.props.analyticId then self.props.analyticId else HttpService:GenerateGUID(false)
	self.state = { analyticId = v6 }
end

function extended:didUpdate(p2, p3)
	local props = self.props

	if p2.purchaseState ~= props.purchaseState then
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

	local v5 = getModalShownEventData(state.analyticId, "", "BuyRobux", BuyRobuxFlowState.toRawValue(props.purchaseState))

	props.onAnalyticEvent("UserPurchaseFlow", v5)
end

function extended:reportUserInput(p3)
	local props = self.props
	local state = self.state

	if not self.props.onAnalyticEvent then
		return
	end

	local v5 = getUserInputEventData(state.analyticId, "", "BuyRobux", BuyRobuxFlowState.toRawValue(props.purchaseState), p3)

	props.onAnalyticEvent("UserPurchaseFlow", v5)
end

function extended:purchaseStateToOverlayState(p3)
	if p3 == BuyRobuxFlowState.Loading then
		return LoadingOverlayState.Loading
	end

	if p3 == BuyRobuxFlowState.RobuxPurchasePending then
		return LoadingOverlayState.PurchasingRobux
	end

	if p3 == BuyRobuxFlowState.RobuxGrantPending then
		return LoadingOverlayState.WaitingForRobux
	end

	if not (p3 ~= BuyRobuxFlowState.PurchaseWarning and p3 ~= BuyRobuxFlowState.None) then
		return LoadingOverlayState.None
	end

	return nil
end

function extended:render()
	local props = self.props
	local state = self.state
	local purchaseState = props.purchaseState

	local purchaseStateToOverlayState = self:purchaseStateToOverlayState(props.purchaseState)

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		BuyRobuxFrame = Roact.createElement(BuyRobuxPage, {
			showCloseButton = props.showCloseButton,
			showBackground = props.showBackground,
			isConsoleSize = props.isConsoleSize,
			robuxBalance = props.robuxBalance,
			robuxPackages = props.robuxPackages,
			robuxPackageActivated = function(p2)
				self:reportUserInput("Confirm")
				props.purchaseRobux(p2)
			end,
			onPageClose = props.onPageClose,
			hasNativePurchaseSucceeded = purchaseState == BuyRobuxFlowState.Succeed,
			shouldAnimate = props.shouldAnimate,
			analyticId = state.analyticId,
			onAnalyticEvent = props.onAnalyticEvent
		}),
		LoadingOverlay = Roact.createElement(module4, {
			shouldAnimate = false,
			showOverlay = purchaseStateToOverlayState ~= nil,
			loadingState = purchaseStateToOverlayState
		})
	})
end

return extended
