local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local InGameMenuConstants = require(RobloxGui.Modules.InGameMenuConstants)
local ControllerBar = UIBlox.App.Bar.ControllerBar

require(CorePackages.Workspace.Packages.RobloxTranslator)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local _ = {
	back = "CoreScripts.TopBar.Back",
	leave = "CoreScripts.TopBar.Leave",
	respawn = "CoreScripts.TopBar.Respawn",
	showChat = "CoreScripts.TopBar.ShowChat",
	hideChat = "CoreScripts.TopBar.HideChat"
}

local function QuickMenuControllerBar(p)
	local v = Localization.new(LocalizationService.RobloxLocaleId)

	local rightHints = {
		{
			text = v:Format("CoreScripts.TopBar.Respawn"),
			keyCode = Enum.KeyCode.ButtonY
		},
		{
			text = v:Format("CoreScripts.TopBar.Leave"),
			keyCode = Enum.KeyCode.ButtonX
		}
	}

	if p.chatMenuEnabled then
		local v2 = React.useCallback(function(p2)
			return p2.chat.visible
		end)

		table.insert(rightHints, 1, {
			text = v:Format(useSelector(v2) and "CoreScripts.TopBar.HideChat" or "CoreScripts.TopBar.ShowChat"),
			keyCode = Enum.KeyCode.ButtonR1
		})
	end

	return React.createElement(Roact.Portal, { target = CoreGui }, {
		QuickMenuControllerBar = React.createElement(
			"ScreenGui",
			{ DisplayOrder = InGameMenuConstants.DisplayOrder.ControllerBar },
			{
				ControllerBar = React.createElement(ControllerBar, {
					leftHint = {
						text = v:Format("CoreScripts.TopBar.Back"),
						keyCode = Enum.KeyCode.ButtonB
					},
					rightHints = rightHints
				})
			}
		)
	})
end

return QuickMenuControllerBar
