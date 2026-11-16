local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Localization = require(parent2.Localization)
local PermissionsProtocol = require(parent2.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default
local React = require(parent2.React)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local UIBlox = require(parent2.UIBlox)

local useCallback = React.useCallback
local useLocalization = Localization.Hooks.useLocalization
local useScreenSize = RobloxAppHooks.useScreenSize
local useStyle = UIBlox.Core.Style.useStyle

local EventNames = require(parent.Analytics.EventNames)
local useAnalytics = require(parent.Analytics.useAnalytics)

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

return function(props)
	local screenSize = useScreenSize()
	local v = useStyle()

	local v2 = useAnalytics()

	local v3 = useLocalization({
		alertBody = "Feature.Captures.Description.AllowPhotoAccessInfo",
		alertTitle = "Feature.Captures.Title.AllowPhotoAccessInfo",
		accessDeniedCTA = "Feature.Captures.Action.AllowPhotoAccessDeclined",
		accessAllowedCTA = "Feature.Captures.Action.AllowPhotoAccessAccepted"
	})

	local theme = v.Theme

	local onActivated = useCallback(function()
		default:requestPermissions({ default.Permissions.WRITE_MEDIA_STORAGE })
		v2.fireEvent(EventNames.CapturesSavePermissionModalAllowPressed)
		props.closeModal()
	end, { props.closeModal })

	local onActivated2 = useCallback(function()
		v2.fireEvent(EventNames.CapturesSavePermissionModalCancelPressed)
		props.closeModal()
	end, { props.closeModal })

	return React.createElement("Frame", {
		Active = true,
		BackgroundColor3 = theme.Overlay.Color,
		BackgroundTransparency = theme.Overlay.Transparency,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = props.visible,
		ZIndex = props.zIndex
	}, {
		Alert = React.createElement(InteractiveAlert, {
			bodyText = v3.alertBody,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = { onActivated = onActivated2, text = v3.accessDeniedCTA }
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = { onActivated = onActivated, text = v3.accessAllowedCTA }
					}
				}
			},
			isMiddleContentFocusable = false,
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = screenSize,
			title = v3.alertTitle
		})
	})
end
