local GuiService = game:GetService("GuiService")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useSelector = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local FocusNavigableSurfaceIdentifierEnum = require(BulkPurchaseAppParent.FocusNavigationUtils).FocusNavigableSurfaceIdentifierEnum
local BulkPurchasePromptStateEnum = require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)
local BulkPurchaseErrorContainer = require(BulkPurchaseApp.Features.BulkPurchaseError.BulkPurchaseErrorContainer)
local BulkPurchaseSuccessContainer = require(BulkPurchaseApp.Features.BulkPurchaseSuccess.BulkPurchaseSuccessContainer)
local BulkPurchasePartialSuccessContainer = require(BulkPurchaseApp.Features.BulkPurchasePartialSuccess.BulkPurchasePartialSuccessContainer)
local BulkPurchaseRequestContainer = require(BulkPurchaseApp.Features.BulkPurchaseRequest.BulkPurchaseRequestContainer)
local ScreenSizeContext = require(BulkPurchaseAppParent.EconomyCommonCoreScriptHooks).ScreenSizeContext
local useBulkPurchaseRequestListenerEffect = require(BulkPurchaseApp.Hooks.useBulkPurchaseRequestListenerEffect)
local useFocusNavigationSurface = require(BulkPurchaseAppParent.EconomyCommonCoreScriptHooks).useFocusNavigationSurface
local FocusNavigationModalSurface = require(BulkPurchaseAppParent.EconomyCommonCoreScriptHooks).FocusNavigationModalSurface
local selectPromptState = require(BulkPurchaseApp.Store.Selectors.selectPromptState)
local v17 = game:DefineFastFlag("FixBulkPurchaseInputPerf", false)

local function BulkPurchaseApp2() -- line: 24
	-- upvalues: React (copy), useSelector (copy), selectPromptState (copy), v17 (copy), useFocusNavigationSurface (copy), FocusNavigableSurfaceIdentifierEnum (copy), useBulkPurchaseRequestListenerEffect (copy), BulkPurchasePromptStateEnum (copy), GuiService (copy), ScreenSizeContext (copy), FocusNavigationModalSurface (copy), BulkPurchaseErrorContainer (copy), BulkPurchaseSuccessContainer (copy), BulkPurchaseRequestContainer (copy), BulkPurchasePartialSuccessContainer (copy)
	local v19, v20 = React.useState(Vector2.new(0, 0))
	local v21 = useSelector(selectPromptState)
	local v22 = if not v17 then useFocusNavigationSurface({
		selectionGroupName = "BulkPurchaseApp",
		focusNavigableSurfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
	}) else nil

	useBulkPurchaseRequestListenerEffect()
	React.useEffect(function() -- line: 36
		-- upvalues: v21 (copy), BulkPurchasePromptStateEnum (copy), GuiService (copy)
		if v21 == BulkPurchasePromptStateEnum.None then
			GuiService.SelectedCoreObject = nil
		end
	end, { v21 })

	return React.createElement(ScreenSizeContext.Provider, {
		value = v19
	}, React.createElement("ScreenGui", {
		[React.Change.AbsoluteSize] = function(p1) -- line: 46
			-- upvalues: v20 (copy)
			v20(p1.AbsoluteSize)
		end,
		ScreenInsets = Enum.ScreenInsets.None
	}, {
		FocusNavigationEffects = if not v17 then React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ref = if v21 ~= BulkPurchasePromptStateEnum.None then v22 else nil,
			Size = UDim2.fromScale(1, 1),
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		}, {
			Error = if v21 ~= BulkPurchasePromptStateEnum.Error then nil else React.createElement(BulkPurchaseErrorContainer),
			Success = if v21 ~= BulkPurchasePromptStateEnum.Success then nil else React.createElement(BulkPurchaseSuccessContainer),
			Request = if v21 ~= BulkPurchasePromptStateEnum.Request then nil else React.createElement(BulkPurchaseRequestContainer),
			PartialSuccess = if v21 ~= BulkPurchasePromptStateEnum.PartialSuccess then nil else React.createElement(BulkPurchasePartialSuccessContainer)
		}) else if v21 == BulkPurchasePromptStateEnum.None then nil else React.createElement(FocusNavigationModalSurface, {
			selectionGroupName = "BulkPurchaseApp"
		}, {
			Error = if v21 ~= BulkPurchasePromptStateEnum.Error then nil else React.createElement(BulkPurchaseErrorContainer),
			Success = if v21 ~= BulkPurchasePromptStateEnum.Success then nil else React.createElement(BulkPurchaseSuccessContainer),
			Request = if v21 ~= BulkPurchasePromptStateEnum.Request then nil else React.createElement(BulkPurchaseRequestContainer),
			PartialSuccess = if v21 ~= BulkPurchasePromptStateEnum.PartialSuccess then nil else React.createElement(BulkPurchasePartialSuccessContainer)
		})
	}))
end

return BulkPurchaseApp2
