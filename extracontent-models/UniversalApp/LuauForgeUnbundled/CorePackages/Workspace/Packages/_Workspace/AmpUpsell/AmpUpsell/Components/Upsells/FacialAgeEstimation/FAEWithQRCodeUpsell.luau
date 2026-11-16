local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")

local qrDeepLinkDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/IdentityVerification").QRDeepLinkDialog
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization

local authButtonClick = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthAnalytics").Events.authButtonClick

local function FAEWithQRCodeUpsell(props)
	local appsFlyerLink = props.appsFlyerLink
	local onCancel = props.onCancel
	local sessionId = props.sessionId
	local entryPointEventCtx = props.entryPointEventCtx

	local v5 = useLocalization({
		title = "Amp.FAEUpsell.Modal.QRCode.Title",
		description = "Amp.FAEUpsell.Modal.QRCode.Description",
		footer = "Amp.FAEUpsell.Modal.QRCode.Footer"
	})

	local v6 = React.useCallback(function()
		authButtonClick(entryPointEventCtx, "closeFaeQR", sessionId)
		onCancel()
	end, { onCancel, sessionId, entryPointEventCtx })

	return React.createElement(qrDeepLinkDialog, {
		deeplink = appsFlyerLink,
		title = v5.title,
		description = v5.description,
		footer = v5.footer,
		onClose = v6
	})
end

return FAEWithQRCodeUpsell
