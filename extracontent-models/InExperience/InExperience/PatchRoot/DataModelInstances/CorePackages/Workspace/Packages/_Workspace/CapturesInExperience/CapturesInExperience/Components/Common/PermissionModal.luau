local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Localization = require(ParentParentParent.Localization)
local default = require(ParentParentParent.PermissionsProtocol).PermissionsProtocol.default
local React = require(ParentParentParent.React)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local UIBlox = require(ParentParentParent.UIBlox)
local useCallback = React.useCallback
local useLocalization = Localization.Hooks.useLocalization
local useScreenSize = RobloxAppHooks.useScreenSize
local useStyle = UIBlox.Core.Style.useStyle
local EventNames = require(ParentParent.Analytics.EventNames)
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useScreenSize (copy), useStyle (copy), useAnalytics (copy), useLocalization (copy), useCallback (copy), default (copy), EventNames (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v17 = useScreenSize()
	local v18 = useStyle()
	local v19 = useAnalytics()
	local v20 = useLocalization({
		alertBody = "Feature.Captures.Description.AllowPhotoAccessInfo",
		alertTitle = "Feature.Captures.Title.AllowPhotoAccessInfo",
		accessDeniedCTA = "Feature.Captures.Action.AllowPhotoAccessDeclined",
		accessAllowedCTA = "Feature.Captures.Action.AllowPhotoAccessAccepted"
	})
	local Theme = v18.Theme
	local v22 = useCallback(function() -- line: 42
		-- upvalues: default (copy), v19 (copy), EventNames (copy), t1 (copy)
		default:requestPermissions({ default.Permissions.WRITE_MEDIA_STORAGE })
		v19.fireEvent(EventNames.CapturesSavePermissionModalAllowPressed)
		t1.closeModal()
	end, { t1.closeModal })
	local v23 = useCallback(function() -- line: 48
		-- upvalues: v19 (copy), EventNames (copy), t1 (copy)
		v19.fireEvent(EventNames.CapturesSavePermissionModalCancelPressed)
		t1.closeModal()
	end, { t1.closeModal })

	return React.createElement("Frame", {
		Active = true,
		BackgroundColor3 = Theme.Overlay.Color,
		BackgroundTransparency = Theme.Overlay.Transparency,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = t1.visible,
		ZIndex = t1.zIndex
	}, {
		Alert = React.createElement(InteractiveAlert, {
			isMiddleContentFocusable = false,
			bodyText = v20.alertBody,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = v23,
							text = v20.accessDeniedCTA
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = v22,
							text = v20.accessAllowedCTA
						}
					}
				}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = v17,
			title = v20.alertTitle
		})
	})
end
