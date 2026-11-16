local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow

local module = require("@luauforge/bundled/fvl")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

return function(p2)
	local state, setState = React.useState(false)
	local v5 = useLocalization({
		newAppAvailableText = "Authentication.Login.Heading.NewAppAvailable",
		descriptionText = "Authentication.Login.Description.DownloadNewVersion",
		downloadNowText = "Authentication.Login.Action.DownloadNow"
	})

	local v6 = useDispatch()
	local v7 = React.useCallback(function()
		v6(module())
	end, { v6 })

	local createElement = React.createElement
	local v9 = {
		["Size"] = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Text = "",
		Visible = true
	}

	local tag = React.Tag
	local v10 = if fFlagLuaAppAddTestIdsForArrow then getTestId("auth-login-new-app-alert-action") else nil
	v9[tag] = v10

	v9[React.Event.Activated] = function()
		v7()
	end

	return createElement("TextButton", v9, {
		Alert = React.createElement(interactiveAlert, {
			title = v5.newAppAvailableText,
			bodyText = v5.descriptionText,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							text = v5.downloadNowText,
							isDefaultChild = true,
							isDisabled = state,
							isLoading = state,
							onActivated = function()
								setState(true)

								if p2.onButtonActivated then
									p2.onButtonActivated()
								end

								v7()
							end
						}
					}
				}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = Vector2.new(300, nil)
		})
	})
end
