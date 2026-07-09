local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local withLocalization = require(Modules.LuaApp.withLocalization)
local Constants = require(Modules.LuaApp.Constants)
local ScreenGuiWithBlurControl = require(Modules.LuaApp.Components.ScreenGuiWithBlurControl)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Toast = UIBlox.App.Dialog.Toast
local s1 = "F11"

if UserInputService:GetPlatform() == Enum.Platform.OSX then
	s1 = "Ctrl + Command + F"
end

local function ExitFullscreenToast(_) -- line: 26
	-- upvalues: withLocalization (copy), withStyle (copy), Roact (copy), Toast (copy), s1 (ref), CoreGui (copy), ScreenGuiWithBlurControl (copy), Constants (copy)
	return withLocalization({
		titleText = "CommonUI.Messages.Label.ToExitFullscreen"
	})(function(p2) -- line: 29
		-- upvalues: withStyle (copy), Roact (copy), Toast (copy), s1 (ref), CoreGui (copy), ScreenGuiWithBlurControl (copy), Constants (copy)
		return withStyle(function(_) -- line: 30
			-- upvalues: Roact (copy), Toast (copy), s1 (ref), p2 (copy), CoreGui (copy), ScreenGuiWithBlurControl (copy), Constants (copy)
			local v17 = Roact.createElement(Toast, {
				duration = 3,
				toastContent = {
					toastTitle = s1,
					toastSubtitle = p2.titleText
				}
			})

			return Roact.createElement(Roact.Portal, {
				target = CoreGui
			}, {
				ExitFullscreenToastScreen = Roact.createElement(ScreenGuiWithBlurControl, {
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					DisplayOrder = Constants.DisplayOrder.Toast
				}, {
					Toast = v17
				})
			})
		end)
	end)
end

return ExitFullscreenToast
