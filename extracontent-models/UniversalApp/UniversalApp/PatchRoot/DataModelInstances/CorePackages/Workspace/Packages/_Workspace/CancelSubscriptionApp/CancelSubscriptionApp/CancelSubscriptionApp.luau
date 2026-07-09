local GuiService = game:GetService("GuiService")
local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local CancelSubscriptionAppParent = CancelSubscriptionApp.Parent
local React = require(CancelSubscriptionAppParent.React)
local useSelector = require(CancelSubscriptionAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local CancelUserSubscriptionRequestContainer = require(CancelSubscriptionApp.Features.CancelSubscriptionRequest.CancelUserSubscriptionRequestContainer)
local CancelUserSubscriptionErrorContainer = require(CancelSubscriptionApp.Features.CancelSubscriptionError.CancelUserSubscriptionErrorContainer)
local CancelUserSubscriptionSuccessContainer = require(CancelSubscriptionApp.Features.CancelSubscriptionSuccess.CancelUserSubscriptionSuccessContainer)
local ScreenSizeContext = require(CancelSubscriptionAppParent.EconomyCommonCoreScriptHooks).ScreenSizeContext
local useCancelSubscriptionRequestedListenerEffect = require(CancelSubscriptionApp.Hooks.useCancelSubscriptionRequestedListenerEffect)
local selectPromptState = require(CancelSubscriptionApp.Store.Selectors.selectPromptState)
local CancelUserSubscriptionAsyncPromptStateEnum = require(CancelSubscriptionApp.Enums.CancelUserSubscriptionAsyncPromptStateEnum)
local FocusNavigationModalSurface = require(CancelSubscriptionAppParent.EconomyCommonCoreScriptHooks).FocusNavigationModalSurface

local function CancelSubscriptionApp2() -- line: 20
	-- upvalues: React (copy), useSelector (copy), selectPromptState (copy), useCancelSubscriptionRequestedListenerEffect (copy), CancelUserSubscriptionAsyncPromptStateEnum (copy), GuiService (copy), ScreenSizeContext (copy), FocusNavigationModalSurface (copy), CancelUserSubscriptionErrorContainer (copy), CancelUserSubscriptionSuccessContainer (copy), CancelUserSubscriptionRequestContainer (copy)
	local v15, v16 = React.useState(Vector2.new(0, 0))
	local v17 = useSelector(selectPromptState)

	useCancelSubscriptionRequestedListenerEffect(v17)
	React.useEffect(function() -- line: 26
		-- upvalues: v17 (copy), CancelUserSubscriptionAsyncPromptStateEnum (copy), GuiService (copy)
		if v17 == CancelUserSubscriptionAsyncPromptStateEnum.None then
			GuiService.SelectedCoreObject = nil
		end
	end, { v17 })

	if v17 == CancelUserSubscriptionAsyncPromptStateEnum.None then
		return nil
	end

	return (React.createElement(ScreenSizeContext.Provider, {
		value = v15
	}, React.createElement("ScreenGui", {
		[React.Change.AbsoluteSize] = function(p1) -- line: 37
			-- upvalues: v16 (copy)
			v16(p1.AbsoluteSize)
		end,
		ScreenInsets = Enum.ScreenInsets.None
	}, {
		FocusNavigationEffects = React.createElement(FocusNavigationModalSurface, {
			selectionGroupName = "CancelSubscriptionApp"
		}, {
			Error = if v17 ~= CancelUserSubscriptionAsyncPromptStateEnum.Error then nil else React.createElement(CancelUserSubscriptionErrorContainer),
			Success = if v17 ~= CancelUserSubscriptionAsyncPromptStateEnum.Success then nil else React.createElement(CancelUserSubscriptionSuccessContainer),
			Request = if v17 ~= CancelUserSubscriptionAsyncPromptStateEnum.Request then nil else React.createElement(CancelUserSubscriptionRequestContainer)
		})
	})))
end

return CancelSubscriptionApp2
