local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch

return function(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), useLocalization (copy), useDispatch (copy), CloseCentralOverlay (copy), InteractiveAlert (copy), ButtonType (copy)
	local v11, v12 = React.useState(false)
	local v13 = useLocalization({
		newAppAvailableText = "Authentication.Login.Heading.NewAppAvailable",
		descriptionText = "Authentication.Login.Description.DownloadNewVersion",
		downloadNowText = "Authentication.Login.Action.DownloadNow"
	})
	local v14 = useDispatch()
	local v15 = React.useCallback(function() -- line: 28
		-- upvalues: v14 (copy), CloseCentralOverlay (copy)
		v14(CloseCentralOverlay())
	end, { v14 })

	return React.createElement("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Text = "",
		Visible = true,
		[React.Event.Activated] = function() -- line: 40
			-- upvalues: v15 (copy)
			v15()
		end
	}, {
		Alert = React.createElement(InteractiveAlert, {
			title = v13.newAppAvailableText,
			bodyText = v13.descriptionText,
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDefaultChild = true,
						text = v13.downloadNowText,
						isDisabled = v11,
						isLoading = v11,
						onActivated = function() -- line: 56
							-- upvalues: v12 (copy), t1 (copy), v15 (copy)
							v12(true)

							if t1.onButtonActivated then
								t1.onButtonActivated()
							end

							v15()
						end
					}
				}}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = Vector2.new(300, nil)
		})
	})
end
