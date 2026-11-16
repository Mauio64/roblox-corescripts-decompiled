local GuiService = game:GetService("GuiService")

local commercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local parent = commercePurchaseApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local ToastLite = require(parent.ToastLite)
local Toast = ToastLite.Components.Toast

local CommercePurchasePromptStateEnum = require(commercePurchaseApp.Enums.CommercePurchasePromptStateEnum)
local CommercePurchaseErrorContainer = require(commercePurchaseApp.Features.CommercePurchaseError.CommercePurchaseErrorContainer)
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local ScreenSizeContext = EconomyCommonCoreScriptHooks.ScreenSizeContext
local useBenefitStatusReceivedListenerEffect = require(commercePurchaseApp.Hooks.useBenefitStatusReceivedListenerEffect)

local useCommerceProductPurchaseRequestListenerEffect = require(commercePurchaseApp.Hooks.useCommerceProductPurchaseRequestListenerEffect)
local EconomyCommonCoreScriptHooks2 = require(parent.EconomyCommonCoreScriptHooks)
local FocusNavigationModalSurface = EconomyCommonCoreScriptHooks2.FocusNavigationModalSurface
local usePurchaseBrowserClosedListenerEffect = require(commercePurchaseApp.Hooks.usePurchaseBrowserClosedListenerEffect)
local selectPromptState = require(commercePurchaseApp.Store.Selectors.selectPromptState)

local function CommercePurchaseApp()
	local state, setState = React.useState(Vector2.new(0, 0))
	local v = useSelector(selectPromptState)

	useBenefitStatusReceivedListenerEffect()
	usePurchaseBrowserClosedListenerEffect()
	useCommerceProductPurchaseRequestListenerEffect()

	React.useEffect(function()
		if v == CommercePurchasePromptStateEnum.None then
			GuiService.SelectedCoreObject = nil
		end
	end, { v })

	if v == CommercePurchasePromptStateEnum.None then
		return nil
	end

	local createElement = React.createElement
	local provider = ScreenSizeContext.Provider

	local createElement2 = React.createElement
	local v2 = {
		[React.Change.AbsoluteSize] = function(p)
			setState(p.AbsoluteSize)
		end,
		ScreenInsets = Enum.ScreenInsets.None
	}

	local createElement3 = React.createElement
	local err

	if v == CommercePurchasePromptStateEnum.Error then
		err = React.createElement(CommercePurchaseErrorContainer)
	end

	return (createElement(provider, { value = state }, createElement2("ScreenGui", v2, {
		FocusNavigationEffects = createElement3(
			FocusNavigationModalSurface,
			{ selectionGroupName = "CommercePurchaseApp" },
			{ Error = err, Toast = React.createElement(Toast) }
		)
	})))
end

return CommercePurchaseApp
