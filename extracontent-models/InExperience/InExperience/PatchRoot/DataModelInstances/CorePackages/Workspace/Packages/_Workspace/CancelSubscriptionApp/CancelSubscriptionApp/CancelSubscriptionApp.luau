local GuiService = game:GetService("GuiService")

local cancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local parent = cancelSubscriptionApp.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local CancelUserSubscriptionRequestContainer = require(cancelSubscriptionApp.Features.CancelSubscriptionRequest.CancelUserSubscriptionRequestContainer)

local CancelUserSubscriptionErrorContainer = require(cancelSubscriptionApp.Features.CancelSubscriptionError.CancelUserSubscriptionErrorContainer)

local CancelUserSubscriptionSuccessContainer = require(cancelSubscriptionApp.Features.CancelSubscriptionSuccess.CancelUserSubscriptionSuccessContainer)
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local ScreenSizeContext = EconomyCommonCoreScriptHooks.ScreenSizeContext
local useCancelSubscriptionRequestedListenerEffect = require(cancelSubscriptionApp.Hooks.useCancelSubscriptionRequestedListenerEffect)
local selectPromptState = require(cancelSubscriptionApp.Store.Selectors.selectPromptState)
local CancelUserSubscriptionAsyncPromptStateEnum = require(cancelSubscriptionApp.Enums.CancelUserSubscriptionAsyncPromptStateEnum)
local EconomyCommonCoreScriptHooks2 = require(parent.EconomyCommonCoreScriptHooks)
local FocusNavigationModalSurface = EconomyCommonCoreScriptHooks2.FocusNavigationModalSurface

local function CancelSubscriptionApp()
	local state, setState = React.useState(Vector2.new(0, 0))
	local v = useSelector(selectPromptState)

	useCancelSubscriptionRequestedListenerEffect(v)

	React.useEffect(function()
		if v == CancelUserSubscriptionAsyncPromptStateEnum.None then
			GuiService.SelectedCoreObject = nil
		end
	end, { v })

	if v == CancelUserSubscriptionAsyncPromptStateEnum.None then
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

	if v == CancelUserSubscriptionAsyncPromptStateEnum.Error then
		err = React.createElement(CancelUserSubscriptionErrorContainer)
	end

	local success

	if v == CancelUserSubscriptionAsyncPromptStateEnum.Success then
		success = React.createElement(CancelUserSubscriptionSuccessContainer)
	end

	local request

	if v == CancelUserSubscriptionAsyncPromptStateEnum.Request then
		request = React.createElement(CancelUserSubscriptionRequestContainer)
	end

	return (createElement(provider, { value = state }, createElement2("ScreenGui", v2, {
		FocusNavigationEffects = createElement3(
			FocusNavigationModalSurface,
			{ selectionGroupName = "CancelSubscriptionApp" },
			{ Error = err, Success = success, Request = request }
		)
	})))
end

return CancelSubscriptionApp
