local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local navigateDownToAvatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateDownToAvatarScreen
local module = require("@luauforge/bundled/eib")
local module2 = require("@luauforge/bundled/eic")
local titleKey = module.TitleKey
local Cryo = require(CorePackages.Packages.Cryo)
local module3 = require("@luauforge/bundled/ect")
local fFlagQRCodePageVisualRefresh = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagQRCodePageVisualRefresh

return function(p2)
	local v5 = {
		playEmote = true,
		renderContent = function(p3)
			return React.createElement(module3, {
				includeStatusBar = true,
				BackgroundTransparency = 1
			}, {
				QRCode = React.createElement(module2, Cryo.Dictionary.join(p2, p3))
			})
		end,
		title = titleKey,
		isTopBarVisible = false,
		hideAvatarBackground = fFlagQRCodePageVisualRefresh and true or nil
	}

	return function(object)
		object:dispatch(require("@luauforge/bundled/dKU").Actions.NavigatedToNonTryOnPage())
		return object:dispatch(navigateDownToAvatarScreen(avatarScreen.AvatarBackground, "QRCode", v5))
	end
end
