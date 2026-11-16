local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/ReactRoblox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/React")
local toast = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/UIBlox").App.Dialog.Toast

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/NotificationModalsManager/InExperienceLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/Localization").LocalizationProvider
local styleProviderWithDefaultTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/Style").StyleProviderWithDefaultTheme

local v5 = nil

local function fn(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			StyleProvider = React.createElement(styleProviderWithDefaultTheme, {}, {
				ToastWrapper = React.createElement(
					"ScreenGui",
					{
						IgnoreGuiInset = true,
						ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
						ResetOnSpawn = false,
						DisplayOrder = 12
					},
					{
						Toast = React.createElement(toast, {
							duration = 3,
							toastContent = p2
						})
					}
				)
			})
		}
	)
end

return function(p2)
	if not v5 then
		local uiBloxToast = Instance.new("Folder")
		uiBloxToast.Name = "UIBloxToast"
		uiBloxToast.Parent = game:GetService("CoreGui")
		v5 = ReactRoblox.createRoot(uiBloxToast)
	end

	v5:render(React.createElement(fn, p2))
end
