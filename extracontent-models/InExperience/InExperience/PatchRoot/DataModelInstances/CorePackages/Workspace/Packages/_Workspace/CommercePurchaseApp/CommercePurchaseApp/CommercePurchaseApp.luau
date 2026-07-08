local GuiService = game:GetService("GuiService")
local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local CommercePurchaseAppParent = CommercePurchaseApp.Parent
local React = require(CommercePurchaseAppParent.React)
local useSelector = require(CommercePurchaseAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local Toast = require(CommercePurchaseAppParent.ToastLite).Components.Toast
local CommercePurchasePromptStateEnum = require(CommercePurchaseApp.Enums.CommercePurchasePromptStateEnum)
local CommercePurchaseErrorContainer = require(CommercePurchaseApp.Features.CommercePurchaseError.CommercePurchaseErrorContainer)
local ScreenSizeContext = require(CommercePurchaseAppParent.EconomyCommonCoreScriptHooks).ScreenSizeContext
local useBenefitStatusReceivedListenerEffect = require(CommercePurchaseApp.Hooks.useBenefitStatusReceivedListenerEffect)
local useCommerceProductPurchaseRequestListenerEffect = require(CommercePurchaseApp.Hooks.useCommerceProductPurchaseRequestListenerEffect)
local FocusNavigationModalSurface = require(CommercePurchaseAppParent.EconomyCommonCoreScriptHooks).FocusNavigationModalSurface
local usePurchaseBrowserClosedListenerEffect = require(CommercePurchaseApp.Hooks.usePurchaseBrowserClosedListenerEffect)
local selectPromptState = require(CommercePurchaseApp.Store.Selectors.selectPromptState)

local function CommercePurchaseApp2() -- line: 20
	-- upvalues: React (copy), useSelector (copy), selectPromptState (copy), useBenefitStatusReceivedListenerEffect (copy), usePurchaseBrowserClosedListenerEffect (copy), useCommerceProductPurchaseRequestListenerEffect (copy), CommercePurchasePromptStateEnum (copy), GuiService (copy), ScreenSizeContext (copy), FocusNavigationModalSurface (copy), CommercePurchaseErrorContainer (copy), Toast (copy)
	local v16, v17 = React.useState(Vector2.new(0, 0))
	local v18 = useSelector(selectPromptState)

	useBenefitStatusReceivedListenerEffect()
	usePurchaseBrowserClosedListenerEffect()
	useCommerceProductPurchaseRequestListenerEffect()
	React.useEffect(function() -- line: 28
		-- upvalues: v18 (copy), CommercePurchasePromptStateEnum (copy), GuiService (copy)
		if v18 == CommercePurchasePromptStateEnum.None then
			GuiService.SelectedCoreObject = nil
		end
	end, { v18 })

	if v18 == CommercePurchasePromptStateEnum.None then
		return nil
	end

	return (React.createElement(ScreenSizeContext.Provider, {
		value = v16
	}, React.createElement("ScreenGui", {
		[React.Change.AbsoluteSize] = function(p1) -- line: 39
			-- upvalues: v17 (copy)
			v17(p1.AbsoluteSize)
		end,
		ScreenInsets = Enum.ScreenInsets.None
	}, {
		FocusNavigationEffects = React.createElement(FocusNavigationModalSurface, {
			selectionGroupName = "CommercePurchaseApp"
		}, {
			Error = if v18 ~= CommercePurchasePromptStateEnum.Error then nil else React.createElement(CommercePurchaseErrorContainer),
			Toast = React.createElement(Toast)
		})
	})))
end

return CommercePurchaseApp2
