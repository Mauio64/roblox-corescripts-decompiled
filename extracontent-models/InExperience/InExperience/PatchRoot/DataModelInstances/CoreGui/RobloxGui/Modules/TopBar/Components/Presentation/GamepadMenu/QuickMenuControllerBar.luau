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

local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local _ = {
	back = "CoreScripts.TopBar.Back",
	leave = "CoreScripts.TopBar.Leave",
	respawn = "CoreScripts.TopBar.Respawn",
	showChat = "CoreScripts.TopBar.ShowChat",
	hideChat = "CoreScripts.TopBar.HideChat"
}

local function QuickMenuControllerBar(p1) -- line: 27
	-- upvalues: Localization (copy), LocalizationService (copy), React (copy), useSelector (copy), Roact (copy), CoreGui (copy), InGameMenuConstants (copy), ControllerBar (copy)
	local v15 = Localization.new(LocalizationService.RobloxLocaleId)
	local t1 = {
		{
			text = v15:Format("CoreScripts.TopBar.Respawn"),
			keyCode = Enum.KeyCode.ButtonY
		},
		{
			text = v15:Format("CoreScripts.TopBar.Leave"),
			keyCode = Enum.KeyCode.ButtonX
		}
	}

	if p1.chatMenuEnabled then
		local v17 = React.useCallback(function(p2) -- line: 44
			return p2.chat.visible
		end)

		table.insert(t1, 1, {
			text = v15:Format(not useSelector(v17) and "CoreScripts.TopBar.ShowChat" or "CoreScripts.TopBar.HideChat"),
			keyCode = Enum.KeyCode.ButtonR1
		})
	end

	return React.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		QuickMenuControllerBar = React.createElement("ScreenGui", {
			DisplayOrder = InGameMenuConstants.DisplayOrder.ControllerBar
		}, {
			ControllerBar = React.createElement(ControllerBar, {
				leftHint = {
					text = v15:Format("CoreScripts.TopBar.Back"),
					keyCode = Enum.KeyCode.ButtonB
				},
				rightHints = t1
			})
		})
	})
end

return QuickMenuControllerBar
