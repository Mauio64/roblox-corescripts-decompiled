local GuiService = game:GetService("GuiService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Roact = require(PurchasePromptParent.PurchasePromptDeps).Roact
local React = require(PurchasePromptParent.React)
local CoreGui = game:GetService("CoreGui")

CoreGui:WaitForChild("RobloxGui")

local CoreScriptsRootProvider = require(PurchasePromptParent.CoreScriptsRoactCommon).CoreScriptsRootProvider
local FocusNavigationUtils = require(PurchasePromptParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local RequestType = require(PurchasePrompt.Enums.RequestType)
local completeRequest = require(PurchasePrompt.Thunks.completeRequest)
local launchPremiumUpsell = require(PurchasePrompt.Thunks.launchPremiumUpsell)
local sendEvent = require(PurchasePrompt.Thunks.sendEvent)
local connectToStore = require(PurchasePrompt.connectToStore)
local initiatePremiumPrecheck = require(PurchasePrompt.Thunks.initiatePremiumPrecheck)
local ExternalEventConnection = require(PurchasePrompt.Components.Connection.ExternalEventConnection)
local PremiumUpsellOverlay = require(script.Parent.PremiumUpsellOverlay)
local GetFFLagUseCoreScriptsRootProviderForUpsellModal = require(PurchasePrompt.Flags.GetFFLagUseCoreScriptsRootProviderForUpsellModal)
local FFlagSetMenuOnPurchasePrompt = require(PurchasePrompt.Flags.FFlagSetMenuOnPurchasePrompt)
local v21 = Roact.Component:extend(script.Name)

function v21.init(p1) -- line: 34
	p1.state = {
		screenSize = Vector2.new(0, 0)
	}

	function p1.changeScreenSize(p2) -- line: 39
		-- upvalues: p1 (copy)
		if p1.state.screenSize ~= p2.AbsoluteSize then
			p1:setState({
				screenSize = p2.AbsoluteSize
			})
		end
	end

	p1.savedSelectedCoreObject = nil

	function p1.endPurchase() -- line: 47
		-- upvalues: p1 (copy)
		p1:restoreSelectedObject()
		p1.props.completeRequest()
	end
end
function v21.saveSelectedObject(p3) -- line: 53
	-- upvalues: GuiService (copy)
	p3.savedSelectedCoreObject = GuiService.SelectedCoreObject
	GuiService.SelectedCoreObject = nil
end
function v21.restoreSelectedObject(p4) -- line: 58
	-- upvalues: CoreGui (copy), GuiService (copy)
	if p4.savedSelectedCoreObject == nil or p4.savedSelectedCoreObject:IsDescendantOf(CoreGui) then
		GuiService.SelectedCoreObject = p4.savedSelectedCoreObject
	end
end
function v21.createElement(p5) -- line: 65
	-- upvalues: RequestType (copy), Roact (copy), PremiumUpsellOverlay (copy), ExternalEventConnection (copy), GuiService (copy), FFlagSetMenuOnPurchasePrompt (copy)
	local props = p5.props
	local state = p5.state

	if props.requestType ~= RequestType.Premium then
		return nil
	end

	p5:saveSelectedObject()

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = p5.changeScreenSize,
		BackgroundTransparency = 1
	}, {
		Prompt = Roact.createElement(PremiumUpsellOverlay, {
			screenSize = state.screenSize,
			promptState = props.promptState,
			purchaseError = props.purchaseError,
			economicRestrictionError = props.economicRestrictionError,
			currencySymbol = props.premiumProductInfo.currencySymbol,
			robuxPrice = props.premiumProductInfo.price,
			robuxAmount = props.premiumProductInfo.robuxAmount,
			isGamepadEnabled = props.isGamepadEnabled,
			promptPremiumPurchase = props.promptPremiumPurchase,
			dispatchPremiumPrecheck = props.dispatchPremiumPrecheck,
			endPurchase = p5.endPurchase,
			onAnalyticEvent = props.onAnalyticEvent
		}),
		ModalFix = Roact.createElement("ImageButton", {
			BackgroundTransparency = 0,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		OnCoreGuiMenuOpened = Roact.createElement(ExternalEventConnection, {
			event = GuiService.MenuOpened,
			callback = function() -- line: 107
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
function v21.render(p6) -- line: 118
	-- upvalues: FFlagSetMenuOnPurchasePrompt (copy), GuiService (copy), GetFFLagUseCoreScriptsRootProviderForUpsellModal (copy), Roact (copy), CoreScriptsRootProvider (copy), React (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v29 = p6:createElement()

	if FFlagSetMenuOnPurchasePrompt then
		if v29 ~= nil then
			p6.menuOpenedBySelf = true
		end

		GuiService:SetMenuIsOpen(v29 ~= nil, "PremiumUpsellContainer")
	end

	if GetFFLagUseCoreScriptsRootProviderForUpsellModal() then
		return Roact.createElement(CoreScriptsRootProvider, {}, {
			FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
				isIsolated = true,
				isAutoFocusRoot = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
			}, {
				PremiumUpsellContainer = v29
			})
		})
	end

	return v29
end

return (connectToStore(function(p7) -- line: 142
	return {
		requestType = p7.promptRequest.requestType,
		promptState = p7.promptState,
		purchaseError = p7.purchaseError,
		economicRestrictionError = p7.economicRestrictionError,
		premiumProductInfo = p7.premiumProductInfo,
		isGamepadEnabled = p7.gamepadEnabled
	}
end, function(p8) -- line: 154
	-- upvalues: launchPremiumUpsell (copy), completeRequest (copy), sendEvent (copy), initiatePremiumPrecheck (copy)
	return {
		promptPremiumPurchase = function() -- line: 156
			-- upvalues: p8 (copy), launchPremiumUpsell (copy)
			return p8(launchPremiumUpsell())
		end,
		completeRequest = function() -- line: 159
			-- upvalues: p8 (copy), completeRequest (copy)
			return p8(completeRequest())
		end,
		onAnalyticEvent = function(p9, p10) -- line: 162
			-- upvalues: p8 (copy), sendEvent (copy)
			return p8(sendEvent(p9, p10))
		end,
		dispatchPremiumPrecheck = function() -- line: 165
			-- upvalues: p8 (copy), initiatePremiumPrecheck (copy)
			return p8(initiatePremiumPrecheck())
		end
	}
end)(v21))
