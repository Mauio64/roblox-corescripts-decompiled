local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local InExperienceLocales = require(parent.InExperienceLocales)
local localization = InExperienceLocales.Localization

local PlayerFeedbackPrompts = require(CoreScriptsPlayerFeedback.Components.PlayerFeedbackPrompts)
local GetFFlagEnablePlayerSupportPrompt = require(CoreScriptsPlayerFeedback.Flags.GetFFlagEnablePlayerSupportPrompt)

local CoreGui = game:GetService("CoreGui")
local robloxGui = CoreGui:FindFirstChild("RobloxGui") or CoreGui:WaitForChild("RobloxGui")
local fFlagEnablePlayerSupportPrompt = GetFFlagEnablePlayerSupportPrompt()

local success, result = pcall(function()
	if robloxGui then
		return require(robloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
	end

	return nil
end)

local v = success and result or function(p)
	return p.App
end

local function createApp(p)
	local screenGui = Instance.new("ScreenGui")
	screenGui.IgnoreGuiInset = not fFlagEnablePlayerSupportPrompt
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.AutoLocalize = false
	screenGui.DisplayOrder = -1

	local root = ReactRoblox.createRoot(screenGui)

	local LocalizationService = game:GetService("LocalizationService")

	root:render(((p or v)({
		App = React.createElement(
			LocalizationProvider,
			{
				localization = localization.new(LocalizationService.RobloxLocaleId)
			},
			{
				PlayerFeedbackPrompts = React.createElement(PlayerFeedbackPrompts, {
					enableInputDelayed = true
				})
			}
		)
	})))

	return {
		instance = screenGui,
		unmount = function()
			root:unmount()
		end
	}
end

return createApp
