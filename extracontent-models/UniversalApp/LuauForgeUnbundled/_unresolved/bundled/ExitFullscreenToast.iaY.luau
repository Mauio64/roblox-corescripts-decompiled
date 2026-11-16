local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/edC")
local module2 = require("@luauforge/bundled/dwA")
local module3 = require("@luauforge/bundled/gdZ")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local withStyle = UIBlox.Style.withStyle
local toast = UIBlox.App.Dialog.Toast

local v5 = UserInputService:GetPlatform() == Enum.Platform.OSX and "Ctrl + Command + F" or "F11"

local function ExitFullscreenToast(p2)
	return module({ titleText = "CommonUI.Messages.Label.ToExitFullscreen" })(function(p3)
		return withStyle(function(p4)
			local element = Roact.createElement(toast, {
				duration = 3,
				toastContent = { toastTitle = v5, toastSubtitle = p3.titleText }
			})

			return Roact.createElement(Roact.Portal, { target = CoreGui }, {
				ExitFullscreenToastScreen = Roact.createElement(
					module3,
					{
						ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
						DisplayOrder = module2.DisplayOrder.Toast
					},
					{ Toast = element }
				)
			})
		end)
	end)
end

return ExitFullscreenToast
