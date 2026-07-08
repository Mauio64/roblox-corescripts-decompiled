local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local Overlay = UIBlox.App.Dialog.Overlay
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v7 = UIBlox.App.ImageSet.Images["icons/controls/keys/xboxA"]
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useIsGamepad = RoactUtils.Hooks.useIsGamepad
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local ParentParent = script.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: useIsGamepad (copy), useDispatch (copy), CloseOpenPrompt (copy), React (copy), Overlay (copy), InteractiveAlert (copy), ButtonType (copy), RobloxTranslator (copy), v7 (copy)
	local v15 = useIsGamepad()
	local v16 = useDispatch()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 3,
		Size = UDim2.fromScale(1, 1)
	}, {
		Overlay = React.createElement(Overlay, {
			showGradient = false,
			ZIndex = 3
		}),
		InteractiveAlertWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 4,
			Size = UDim2.fromScale(1, 1)
		}, {
			InteractiveAlert = React.createElement(InteractiveAlert, {
				title = "Something Went Wrong",
				bodyText = "Your creation could not be created due to an error. A report has been sent to the developer of this experience.",
				screenSize = t1.screenSize,
				buttonStackInfo = {
					buttons = {{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = function() -- line: 33
								-- upvalues: v16 (copy), CloseOpenPrompt (copy)
								v16(CloseOpenPrompt())
							end,
							text = RobloxTranslator:FormatByKey("InGame.CommonUI.Button.Ok"),
							inputIcon = v15 and v7 or nil
						}
					}}
				}
			})
		})
	})
end
