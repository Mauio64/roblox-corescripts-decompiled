local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local CoreScriptsPlayerFeedbackParent = CoreScriptsPlayerFeedback.Parent
local React = require(CoreScriptsPlayerFeedbackParent.React)
local ReactRoblox = require(CoreScriptsPlayerFeedbackParent.ReactRoblox)
local LocalizationProvider = require(CoreScriptsPlayerFeedbackParent.Localization).LocalizationProvider
local Localization = require(CoreScriptsPlayerFeedbackParent.InExperienceLocales).Localization
local PlayerFeedbackPrompts = require(CoreScriptsPlayerFeedback.Components.PlayerFeedbackPrompts)
local GetFFlagEnablePlayerSupportPrompt = require(CoreScriptsPlayerFeedback.Flags.GetFFlagEnablePlayerSupportPrompt)
local CoreGui = game:GetService("CoreGui")
local v10 = CoreGui:FindFirstChild("RobloxGui") or CoreGui:WaitForChild("RobloxGui")
local v11 = GetFFlagEnablePlayerSupportPrompt()
local ok, result = pcall(function() -- line: 21
	-- upvalues: v10 (copy)
	if v10 then
		return require(v10.Modules.Common.renderWithCoreScriptsStyleProvider)
	end

	return nil
end)
local u14 = ok and result or function(p1) -- line: 31
	return p1.App
end

local function createApp(p2) -- line: 37
	-- upvalues: u14 (ref), v11 (copy), ReactRoblox (copy), React (copy), LocalizationProvider (copy), Localization (copy), PlayerFeedbackPrompts (copy)
	local v18 = p2 or u14
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.IgnoreGuiInset = not v11
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.AutoLocalize = false
	ScreenGui.DisplayOrder = -1

	local v20 = ReactRoblox.createRoot(ScreenGui)
	local LocalizationService = game:GetService("LocalizationService")

	v20:render((v18({
		App = React.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			PlayerFeedbackPrompts = React.createElement(PlayerFeedbackPrompts, {
				enableInputDelayed = true
			})
		})
	})))

	return {
		instance = ScreenGui,
		unmount = function() -- line: 67
			-- upvalues: v20 (copy)
			v20:unmount()
		end
	}
end

return createApp
