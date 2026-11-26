local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/bundled/dXh")
local module2 = require("@luauforge/deferred/gJI")

local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function ResaleFeePolicyPrompt(p2)
	local v5 = useSelector(function(p3)
		return p3.ScreenSize
	end, getUseSelectorDeepEquals())

	local v6 = React.useCallback(function()
		module.closeOverlay(p2.navigation)
	end, { p2.navigation })

	local v7 = useLocalization({
		titleText = "Feature.Catalog.Label.ResaleFeePolicy",
		bodyText = "Feature.Catalog.Message.ResaleFeePolicy",
		gotItButtonText = "Feature.Avatar.Action.GotIt"
	})

	local v8 = v7.bodyText:gsub("({yourSharePercent})", p2.navigation.state.params.yourSharePercent):gsub(
		"({robloxFeePercent})",
		p2.navigation.state.params.robloxFeePercent
	)

	return React.createElement(interactiveAlert, {
		title = v7.titleText,
		bodyText = v8,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = v6, text = v7.gotItButtonText }
				}
			}
		},
		screenSize = v5
	})
end

return module2(ResaleFeePolicyPrompt)
