local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dXh")
local module2 = require("@luauforge/deferred/gJI")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function GenericPrompt(p2)
	local v5 = useSelector(function(p3)
		return p3.ScreenSize
	end, getUseSelectorDeepEquals())

	local v6 = React.useCallback(function()
		module.closeOverlay(p2.navigation)
	end, { p2.navigation })

	return React.createElement(interactiveAlert, {
		title = p2.navigation.state.params.titleText,
		bodyText = p2.navigation.state.params.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = v6,
						text = p2.navigation.state.params.buttonText
					}
				}
			}
		},
		screenSize = v5
	})
end

return module2(GenericPrompt)
