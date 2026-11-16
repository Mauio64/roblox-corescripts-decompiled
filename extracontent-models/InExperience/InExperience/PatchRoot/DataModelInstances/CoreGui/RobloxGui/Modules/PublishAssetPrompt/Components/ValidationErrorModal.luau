local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local Overlay = UIBlox.App.Dialog.Overlay
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local iconscontrolskeysxboxA = UIBlox.App.ImageSet.Images["icons/controls/keys/xboxA"]
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useIsGamepad = RoactUtils.Hooks.useIsGamepad
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local React = require(CorePackages.Packages.React)

local parent = script.Parent.Parent
local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)

return function(p)
	local v = useIsGamepad()

	local v2 = useDispatch()
	local function onActivated()
		v2(CloseOpenPrompt())
	end
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 3
	}, {
		Overlay = React.createElement(Overlay, { showGradient = false, ZIndex = 3 }),
		InteractiveAlertWrapper = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 4 },
			{
				InteractiveAlert = React.createElement(InteractiveAlert, {
					title = "Something Went Wrong",
					bodyText = "Your creation could not be created due to an error. A report has been sent to the developer of this experience.",
					screenSize = p.screenSize,
					buttonStackInfo = {
						buttons = {
							{
								buttonType = ButtonType.PrimarySystem,
								props = {
									onActivated = onActivated,
									text = RobloxTranslator:FormatByKey("InGame.CommonUI.Button.Ok"),
									inputIcon = v and iconscontrolskeysxboxA or nil
								}
							}
						}
					}
				})
			}
		)
	})
end
