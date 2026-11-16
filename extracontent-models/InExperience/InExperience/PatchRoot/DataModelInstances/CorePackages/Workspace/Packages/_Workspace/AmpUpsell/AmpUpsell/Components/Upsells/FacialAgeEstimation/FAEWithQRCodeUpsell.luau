local parent = script:FindFirstAncestor("AmpUpsell").Parent

local React = require(parent.React)

local IdentityVerification = require(parent.IdentityVerification)
local QRDeepLinkDialog = IdentityVerification.QRDeepLinkDialog
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AuthAnalytics = require(parent.AuthAnalytics)
local authButtonClick = AuthAnalytics.Events.authButtonClick

local function FAEWithQRCodeUpsell(props)
	local appsFlyerLink = props.appsFlyerLink
	local onCancel = props.onCancel
	local sessionId = props.sessionId
	local entryPointEventCtx = props.entryPointEventCtx

	local v = useLocalization({
		title = "Amp.FAEUpsell.Modal.QRCode.Title",
		description = "Amp.FAEUpsell.Modal.QRCode.Description",
		footer = "Amp.FAEUpsell.Modal.QRCode.Footer"
	})

	local onClose = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "closeFaeQR", sessionId)
		onCancel()
	end, { onCancel, sessionId, entryPointEventCtx })

	return React.createElement(QRDeepLinkDialog, {
		deeplink = appsFlyerLink,
		title = v.title,
		description = v.description,
		footer = v.footer,
		onClose = onClose
	})
end

return FAEWithQRCodeUpsell
