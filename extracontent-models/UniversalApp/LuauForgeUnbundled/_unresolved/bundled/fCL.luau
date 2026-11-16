local module = require("@luauforge/bundled/fCM")
local react = module.React
local useEffect = react.useEffect
local roactRodux = module.RoactRodux
local useLocalization = module.Localization.Hooks.useLocalization
local closeCentralOverlay = module.CentralOverlay.Thunks.CloseCentralOverlay
local constants = module.UIBlox.App.Style.Constants
local module2 = require("@luauforge/bundled/fDh")
local module3 = require("@luauforge/bundled/fDi")

local foundation = module.Foundation
local dialog = foundation.Dialog
local dialogSize = foundation.Enums.DialogSize
local buttonVariant = foundation.Enums.ButtonVariant
local orientation = foundation.Enums.Orientation
local colorMode = foundation.Enums.ColorMode
local uiModeStyleProvider = require("@luauforge/bundled/fCY").UiModeStyleProvider
local fFlagAccountSwitcherFocusNavigation = require("@luauforge/bundled/fDj").FFlagAccountSwitcherFocusNavigation

local fFlagFixLoginV2AccountSwitchOverlaySoftLock = require("@luauforge/bundled/fDj").FFlagFixLoginV2AccountSwitchOverlaySoftLock
local module4 = require("@luauforge/bundled/fDk")

return (roactRodux.connect(nil, function(callback)
	return {
		closeCentralOverlay = function()
			return callback(closeCentralOverlay())
		end
	}
end)(function(props)
	local v5

	if fFlagFixLoginV2AccountSwitchOverlaySoftLock then
		local ref = react.useRef(false)
		local ref2 = react.useRef(props.dismissedWithoutActionCallback)
		ref2.current = props.dismissedWithoutActionCallback

		useEffect(function()
			return function()
				local current = ref2.current

				if not ref.current and current then
					current()
				end
			end
		end, {})
		v5 = ref
	else
		v5 = nil
	end

	local v6

	if props.primaryButtonTextKey == nil or props.primaryButtonTextKey == "" then
		v6 = false
	else
		v6 = props.primaryButtonCallback ~= nil
	end

	local fn = v6 and function()
		if fFlagFixLoginV2AccountSwitchOverlaySoftLock and v5 then
			v5.current = true
		end

		module2.sendButtonClickEvent(
			module3.ctx.accountSwitcherConfirmation,
			module3.btn.primaryButton,
			props.errorType
		)

		props.primaryButtonCallback()
	end or nil
	local v7

	if props.secondaryButtonTextKey == nil or props.secondaryButtonTextKey == "" then
		v7 = false
	else
		v7 = props.secondaryButtonCallback ~= nil
	end

	local fn2 = v7 and function()
		if fFlagFixLoginV2AccountSwitchOverlaySoftLock and v5 then
			v5.current = true
		end

		module2.sendButtonClickEvent(
			module3.ctx.accountSwitcherConfirmation,
			module3.btn.secondaryButton,
			props.errorType
		)

		props.secondaryButtonCallback()
	end or nil

	local function onClose()
		if fn2 then
			fn2()
		else
			props.closeCentralOverlay()
		end
	end

	local v8 = useLocalization({
		titleText = props.titleTextKey,
		bodyTextKey = props.bodyTextKey,
		primaryButtonTextKey = props.primaryButtonTextKey,
		secondaryButtonTextKey = props.secondaryButtonTextKey
	})

	local v9 = module4()

	local bodyTextKey = v8.bodyTextKey

	if props.bodyUsername then
		bodyTextKey = string.gsub(bodyTextKey, "{username}", props.bodyUsername)
	end

	useEffect(function()
		module2.sendModalShownEvent(module3.ctx.accountSwitcherConfirmation, props.errorType)
	end, {})

	local createElement = react.createElement
	local root = dialog.Root
	local v10 = {
		size = dialogSize.Small,
		hasBackdrop = true,
		closeOnClickOutside = true,
		disablePortal = not props.portalToFoundationOverlay,
		onClose = onClose,
		ref = 0
	}

	if not fFlagAccountSwitcherFocusNavigation then
		v9 = nil
	end

	v10.ref = v9
	local element = createElement(root, v10, {
		DialogTitle = react.createElement(dialog.Title, { text = v8.titleText }),
		DialogContent = react.createElement(dialog.Content, nil, {
			DialogView = react.createElement(foundation.View, {
				tag = "col fill auto-xy items-start"
			}, {
				DialogText = react.createElement(dialog.Text, {
					Text = bodyTextKey,
					LayoutOrder = 1
				})
			})
		}),
		DialogActions = react.createElement(dialog.Actions, {
			orientation = orientation.Vertical,
			actions = {
				v6 and ({
					text = v8.primaryButtonTextKey,
					variant = buttonVariant.Alert,
					onActivated = fn
				} or nil) or nil,
				v7 and {
					text = v8.secondaryButtonTextKey,
					variant = buttonVariant.Standard,
					onActivated = fn2
				} or nil
			}
		})
	})

	if props.forceDarkTheme and not props.portalToFoundationOverlay then
		return react.createElement(uiModeStyleProvider, {
			style = { themeName = colorMode.Dark, fontName = constants.FontName.Gotham }
		}, { Child = element })
	end

	return element
end))
