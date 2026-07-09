local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local default = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local function PhotoboothShareModal(t1: {[any]: any}) -- line: 23
	-- upvalues: useLocalization (copy), React (copy), default (copy), ButtonType (copy), InteractiveAlert (copy)
	local v10 = useLocalization({
		title = "Feature.Captures.Title.ShareCapturePrompt",
		bodyText = "Feature.Captures.Body.ShareCapturePrompt",
		shareButton = "Feature.Captures.Action.Share",
		cancelButton = "Feature.Captures.Action.NoThanks",
		shareSheetTitle = "Feature.Captures.Action.ShareYourCapture"
	})
	local v11 = React.useCallback(function() -- line: 32
		-- upvalues: t1 (copy), default (copy), v10 (copy)
		if t1.screenshotPath and default then
			default:shareImage({
				context = "Photobooth",
				image = t1.screenshotPath,
				shareSheetTitle = v10.shareSheetTitle
			})
		end

		t1.onClose()
	end, {
		t1.screenshotPath,
		t1.onClose
	})
	local v12 = React.useCallback(function() -- line: 43
		-- upvalues: t1 (copy)
		t1.onClose()
	end, { t1.onClose })
	local v13 = React.useMemo(function() -- line: 47
		-- upvalues: v12 (copy), v10 (copy), ButtonType (copy), v11 (copy)
		return {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = v12,
						text = v10.cancelButton
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v11,
						text = v10.shareButton
					}
				}
			}
		}
	end, {
		v10,
		v11,
		v12
	})

	if not t1.isVisible then
		return nil
	end

	return React.createElement("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		[React.Event.Activated] = v12,
		ZIndex = 9999
	}, {
		Modal = React.createElement(InteractiveAlert, {
			title = v10.title,
			bodyText = v10.bodyText,
			buttonStackInfo = v13,
			screenSize = Vector2.new(1000, 1000)
		})
	})
end

return PhotoboothShareModal
