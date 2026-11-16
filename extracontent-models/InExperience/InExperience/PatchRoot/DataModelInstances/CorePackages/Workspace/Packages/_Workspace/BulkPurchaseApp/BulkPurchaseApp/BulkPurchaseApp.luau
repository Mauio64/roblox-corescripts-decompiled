local GuiService = game:GetService("GuiService")

local bulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = bulkPurchaseApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local BulkPurchasePromptStateEnum = require(bulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)

local BulkPurchaseErrorContainer = require(bulkPurchaseApp.Features.BulkPurchaseError.BulkPurchaseErrorContainer)
local BulkPurchaseSuccessContainer = require(bulkPurchaseApp.Features.BulkPurchaseSuccess.BulkPurchaseSuccessContainer)

local BulkPurchasePartialSuccessContainer = require(bulkPurchaseApp.Features.BulkPurchasePartialSuccess.BulkPurchasePartialSuccessContainer)
local BulkPurchaseRequestContainer = require(bulkPurchaseApp.Features.BulkPurchaseRequest.BulkPurchaseRequestContainer)
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local ScreenSizeContext = EconomyCommonCoreScriptHooks.ScreenSizeContext
local useBulkPurchaseRequestListenerEffect = require(bulkPurchaseApp.Hooks.useBulkPurchaseRequestListenerEffect)
local EconomyCommonCoreScriptHooks2 = require(parent.EconomyCommonCoreScriptHooks)
local useFocusNavigationSurface = EconomyCommonCoreScriptHooks2.useFocusNavigationSurface
local EconomyCommonCoreScriptHooks3 = require(parent.EconomyCommonCoreScriptHooks)
local FocusNavigationModalSurface = EconomyCommonCoreScriptHooks3.FocusNavigationModalSurface
local selectPromptState = require(bulkPurchaseApp.Store.Selectors.selectPromptState)
local defineFastFlag = game:DefineFastFlag("FixBulkPurchaseInputPerf", false)

local function BulkPurchaseApp()
	local state, setState = React.useState(Vector2.new(0, 0))
	local v = useSelector(selectPromptState)
	local ref

	if not defineFastFlag then
		ref = useFocusNavigationSurface({
			selectionGroupName = "BulkPurchaseApp",
			focusNavigableSurfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		})
	end

	useBulkPurchaseRequestListenerEffect()

	React.useEffect(function()
		if v == BulkPurchasePromptStateEnum.None then
			GuiService.SelectedCoreObject = nil
		end
	end, { v })

	local createElement = React.createElement
	local provider = ScreenSizeContext.Provider

	local createElement2 = React.createElement
	local v2 = {
		[React.Change.AbsoluteSize] = function(p)
			setState(p.AbsoluteSize)
		end,
		ScreenInsets = Enum.ScreenInsets.None
	}
	local focusNavigationEffects

	if defineFastFlag then
		if v ~= BulkPurchasePromptStateEnum.None then
			local createElement3 = React.createElement
			local err

			if v == BulkPurchasePromptStateEnum.Error then
				err = React.createElement(BulkPurchaseErrorContainer)
			end

			local success

			if v == BulkPurchasePromptStateEnum.Success then
				success = React.createElement(BulkPurchaseSuccessContainer)
			end

			local request

			if v == BulkPurchasePromptStateEnum.Request then
				request = React.createElement(BulkPurchaseRequestContainer)
			end

			local partialSuccess

			if v == BulkPurchasePromptStateEnum.PartialSuccess then
				partialSuccess = React.createElement(BulkPurchasePartialSuccessContainer)
			end

			focusNavigationEffects = createElement3(
				FocusNavigationModalSurface,
				{ selectionGroupName = "BulkPurchaseApp" },
				{
					Error = err,
					Success = success,
					Request = request,
					PartialSuccess = partialSuccess
				}
			)
		end
	else
		local createElement3 = React.createElement

		if v == BulkPurchasePromptStateEnum.None then
			ref = nil
		end

		local v3 = {
			ref = ref,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		}
		local err

		if v == BulkPurchasePromptStateEnum.Error then
			err = React.createElement(BulkPurchaseErrorContainer)
		end

		local success

		if v == BulkPurchasePromptStateEnum.Success then
			success = React.createElement(BulkPurchaseSuccessContainer)
		end

		local request

		if v == BulkPurchasePromptStateEnum.Request then
			request = React.createElement(BulkPurchaseRequestContainer)
		end

		local partialSuccess

		if v == BulkPurchasePromptStateEnum.PartialSuccess then
			partialSuccess = React.createElement(BulkPurchasePartialSuccessContainer)
		end

		focusNavigationEffects = createElement3("Frame", v3, {
			Error = err,
			Success = success,
			Request = request,
			PartialSuccess = partialSuccess
		})
	end

	return createElement(
		provider,
		{ value = state },
		createElement2("ScreenGui", v2, { FocusNavigationEffects = focusNavigationEffects })
	)
end

return BulkPurchaseApp
