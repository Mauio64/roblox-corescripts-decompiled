local parent = script.Parent.Parent
local ReactRoblox = require(parent.ReactRoblox)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local Toast = UIBlox.App.Dialog.Toast

local LocalizationService = game:GetService("LocalizationService")
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme

local v = nil

local function fn(toastContent)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {}, {
				ToastWrapper = React.createElement(
					"ScreenGui",
					{
						IgnoreGuiInset = true,
						ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
						ResetOnSpawn = false,
						DisplayOrder = 12
					},
					{
						Toast = React.createElement(Toast, {
							duration = 3,
							toastContent = toastContent
						})
					}
				)
			})
		}
	)
end

return function(p)
	if not v then
		local uiBloxToast = Instance.new("Folder")
		uiBloxToast.Name = "UIBloxToast"
		uiBloxToast.Parent = game:GetService("CoreGui")
		v = ReactRoblox.createRoot(uiBloxToast)
	end

	v:render(React.createElement(fn, p))
end
