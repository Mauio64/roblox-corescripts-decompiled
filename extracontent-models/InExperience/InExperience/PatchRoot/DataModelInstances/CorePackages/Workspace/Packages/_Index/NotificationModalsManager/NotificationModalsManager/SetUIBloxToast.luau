local ParentParent = script.Parent.Parent
local ReactRoblox = require(ParentParent.ReactRoblox)
local React = require(ParentParent.React)
local Toast = require(ParentParent.UIBlox).App.Dialog.Toast
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParent.InExperienceLocales).Localization
local LocalizationProvider = require(ParentParent.Localization).LocalizationProvider
local StyleProviderWithDefaultTheme = require(ParentParent.Style).StyleProviderWithDefaultTheme
local u9 = nil

local function v10(p1) -- line: 17
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), StyleProviderWithDefaultTheme (copy), Toast (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {}, {
			ToastWrapper = React.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
				DisplayOrder = 12,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
				Toast = React.createElement(Toast, {
					duration = 3,
					toastContent = p1
				})
			})
		})
	})
end

return function(p2) -- line: 37
	-- upvalues: u9 (ref), ReactRoblox (copy), React (copy), v10 (copy)
	if not u9 then
		local Folder = Instance.new("Folder")

		Folder.Name = "UIBloxToast"
		Folder.Parent = game:GetService("CoreGui")
		u9 = ReactRoblox.createRoot(Folder)
	end

	u9:render(React.createElement(v10, p2))
end
