local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local AvatarCreationService = game:GetService("AvatarCreationService")
local FocusNavigationUtils = require(scriptParentParent.FocusNavigationUtils)
local ReactUtils = require(scriptParentParent.ReactUtils)
local React = require(scriptParentParent.React)
local SelfieConsentPrompt = require(scriptParent.SelfieConsentPrompt)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useEventConnection = ReactUtils.useEventConnection

local function v11(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), useEventConnection (copy), AvatarCreationService (copy)
	local v13 = React.useCallback(function() -- line: 22
		-- upvalues: t1 (copy)
		t1.displaySelfieConsent(true)
	end)

	useEventConnection(AvatarCreationService.OpenSelfieConsent, v13)

	return React.createElement(React.Fragment, {}, {})
end

return function(_: {[any]: any}) -- line: 29
	-- upvalues: React (copy), SelfieConsentPrompt (copy), v11 (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v15, v16 = React.useState(false)
	local v17 = nil

	if v15 then
		v17 = React.createElement(SelfieConsentPrompt, {
			displaySelfieConsent = v16
		})
	end

	return React.createElement(React.Fragment, {}, {
		EventListener = React.createElement(v11, {
			displaySelfieConsent = v16
		}),
		FocusNavigationCoreScriptsWrapper = if v17 == nil then nil else React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			Prompt = v17
		})
	})
end
