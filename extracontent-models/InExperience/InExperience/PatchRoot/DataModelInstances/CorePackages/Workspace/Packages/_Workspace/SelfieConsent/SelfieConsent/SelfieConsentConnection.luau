local parent = script.Parent
local parent2 = parent.Parent

local AvatarCreationService = game:GetService("AvatarCreationService")

local FocusNavigationUtils = require(parent2.FocusNavigationUtils)
local ReactUtils = require(parent2.ReactUtils)
local React = require(parent2.React)

local SelfieConsentPrompt = require(parent.SelfieConsentPrompt)

local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local useEventConnection = ReactUtils.useEventConnection

local function fn(p)
	local v = React.useCallback(function()
		p.displaySelfieConsent(true)
	end)
	useEventConnection(AvatarCreationService.OpenSelfieConsent, v)
	return React.createElement(React.Fragment, {}, {})
end

return function(_)
	local state, setState = React.useState(false)
	local prompt

	if state then
		prompt = React.createElement(SelfieConsentPrompt, { displaySelfieConsent = setState })
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v = {
		EventListener = React.createElement(fn, { displaySelfieConsent = setState }),
		FocusNavigationCoreScriptsWrapper = 0
	}
	local focusNavigationCoreScriptsWrapper

	if prompt ~= nil then
		focusNavigationCoreScriptsWrapper = React.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{ Prompt = prompt }
		)
	end

	v.FocusNavigationCoreScriptsWrapper = focusNavigationCoreScriptsWrapper
	return createElement(fragment, {}, v)
end
