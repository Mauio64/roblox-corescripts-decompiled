local AvatarCreationService = game:GetService("AvatarCreationService")

local SelfieQr = script:FindFirstAncestor("SelfieQr")
local parent = SelfieQr.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local SelfieQRCode = require(SelfieQr.SelfieQRCode)

local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local useEventConnection = ReactUtils.useEventConnection

local function fn(p)
	local v = React.useCallback(function(url, jobId)
		p.displaySelfieQRCode(true)
		p.jobData.url = url
		p.jobData.jobId = jobId
	end)
	useEventConnection(AvatarCreationService.OpenSelfieQRCode, v)
	return React.createElement(React.Fragment, {}, {})
end

return function(_)
	local state, setState = React.useState(false)
	local current = React.useRef({ url = "", jobId = "" }).current
	local dialog

	if state then
		dialog = React.createElement(SelfieQRCode, {
			displaySelfieQRCode = setState,
			url = current.url,
			jobId = current.jobId
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v = {
		EventListener = React.createElement(fn, {
			displaySelfieQRCode = setState,
			jobData = current
		}),
		FocusNavigationCoreScriptsWrapper = 0
	}
	local focusNavigationCoreScriptsWrapper

	if dialog ~= nil then
		focusNavigationCoreScriptsWrapper = React.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{ Dialog = dialog }
		)
	end

	v.FocusNavigationCoreScriptsWrapper = focusNavigationCoreScriptsWrapper
	return createElement(fragment, {}, v)
end
