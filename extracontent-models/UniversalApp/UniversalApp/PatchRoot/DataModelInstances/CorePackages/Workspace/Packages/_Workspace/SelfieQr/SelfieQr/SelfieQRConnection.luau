local AvatarCreationService = game:GetService("AvatarCreationService")
local SelfieQr = script:FindFirstAncestor("SelfieQr")
local SelfieQrParent = SelfieQr.Parent
local FocusNavigationUtils = require(SelfieQrParent.FocusNavigationUtils)
local React = require(SelfieQrParent.React)
local ReactUtils = require(SelfieQrParent.ReactUtils)
local SelfieQRCode = require(SelfieQr.SelfieQRCode)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useEventConnection = ReactUtils.useEventConnection

local function v11(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), useEventConnection (copy), AvatarCreationService (copy)
	local v13 = React.useCallback(function(p1, p2) -- line: 22
		-- upvalues: t1 (copy)
		t1.displaySelfieQRCode(true)
		t1.jobData.url = p1
		t1.jobData.jobId = p2
	end)

	useEventConnection(AvatarCreationService.OpenSelfieQRCode, v13)

	return React.createElement(React.Fragment, {}, {})
end

return function(_: {[any]: any}) -- line: 31
	-- upvalues: React (copy), SelfieQRCode (copy), v11 (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v15, v16 = React.useState(false)
	local current = React.useRef({
		url = "",
		jobId = ""
	}).current
	local v18 = nil

	if v15 then
		v18 = React.createElement(SelfieQRCode, {
			displaySelfieQRCode = v16,
			url = current.url,
			jobId = current.jobId
		})
	end

	return React.createElement(React.Fragment, {}, {
		EventListener = React.createElement(v11, {
			displaySelfieQRCode = v16,
			jobData = current
		}),
		FocusNavigationCoreScriptsWrapper = if v18 == nil then nil else React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			Dialog = v18
		})
	})
end
