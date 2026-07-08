local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local React = require(Parent.React)
local QRDeepLinkDialog = require(Parent.IdentityVerification).QRDeepLinkDialog
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local authButtonClick = require(Parent.AuthAnalytics).Events.authButtonClick

local function FAEWithQRCodeUpsell(t1: {[any]: any}) -- line: 19
	-- upvalues: useLocalization (copy), React (copy), authButtonClick (copy), QRDeepLinkDialog (copy)
	local appsFlyerLink = t1.appsFlyerLink
	local onCancel = t1.onCancel
	local sessionId = t1.sessionId
	local entryPointEventCtx = t1.entryPointEventCtx
	local v12 = useLocalization({
		title = "Amp.FAEUpsell.Modal.QRCode.Title",
		description = "Amp.FAEUpsell.Modal.QRCode.Description",
		footer = "Amp.FAEUpsell.Modal.QRCode.Footer"
	})
	local v13 = React.useCallback(function() -- line: 31
		-- upvalues: authButtonClick (copy), entryPointEventCtx (copy), sessionId (copy), onCancel (copy)
		authButtonClick(entryPointEventCtx, "closeFaeQR", sessionId)
		onCancel()
	end, {
		onCancel,
		sessionId,
		entryPointEventCtx
	})

	return React.createElement(QRDeepLinkDialog, {
		deeplink = appsFlyerLink,
		title = v12.title,
		description = v12.description,
		footer = v12.footer,
		onClose = v13
	})
end

return FAEWithQRCodeUpsell
