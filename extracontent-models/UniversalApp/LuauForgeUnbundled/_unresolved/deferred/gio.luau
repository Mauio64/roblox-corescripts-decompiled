local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/bundled/dTM")
local module2 = require("@luauforge/deferred/gfc")

local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function CollectiblesInfoPrompt(p2)
	local v5 = useSelector(selectScreenSize, getUseSelectorDeepEquals())

	local v6 = React.useCallback(function()
		module.closeOverlay(p2.navigation)
	end, { p2.navigation })

	local v7 = useLocalization({
		titleText = "Feature.Catalog.Label.NewCollectibles",
		bodyText = "Feature.Catalog.Message.CollectiblesInfo",
		okButtonText = "CommonUI.Messages.Action.OK"
	})

	return React.createElement(interactiveAlert, {
		title = v7.titleText,
		bodyText = v7.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = v6, text = v7.okButtonText }
				}
			}
		},
		screenSize = v5
	})
end

return module2(CollectiblesInfoPrompt)
