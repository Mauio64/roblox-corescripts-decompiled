local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gjJ")
require("@luauforge/bundled/glG")
local externalIdentitySignInOptions = require("@luauforge/bundled/gme").Components.ExternalIdentitySignInOptions
local useModalFocus = require("@luauforge/bundled/gkd").useModalFocus
local fFlagLoginV2ModalFocusNavigation = require("@luauforge/bundled/gjO").FFlagLoginV2ModalFocusNavigation
local module3 = require("@luauforge/bundled/gma")

local dialog = module2.Dialog
local dialogSize = module2.Enums.DialogSize
local inputSize = module2.Enums.InputSize
local orientation = module2.Enums.Orientation

local function ExternalIdentityOtherSignInOptionsDialog(props)
	local v5 = if fFlagLoginV2ModalFocusNavigation then useModalFocus() else nil

	local createElement = module.createElement
	local root = dialog.Root
	local v6 = {
		ref = v5,
		size = props.size or dialogSize.Small,
		hasBackdrop = true,
		disablePortal = false,
		onClose = props.onClose,
		testId = "login-v2-other-sign-in-options-dialog"
	}

	local v7 = {
		DialogTitle = module.createElement(dialog.Title, { text = props.title }),
		DialogContent = 0
	}

	local createElement2 = module.createElement
	local content = dialog.Content
	local createElement3 = module.createElement
	local v11 = {
		providers = props.providers,
		size = 0,
		onActivated = 0,
		orientation = 0,
		showDivider = false
	}
	local v12 = if module3 then inputSize.Large else inputSize.Medium
	v11.size = v12
	v11.onActivated = props.onActivated
	v11.orientation = orientation.Vertical
	v7.DialogContent = createElement2(content, nil, {
		SignInOptions = createElement3(externalIdentitySignInOptions, v11)
	})
	return createElement(root, v6, v7)
end

return ExternalIdentityOtherSignInOptionsDialog
