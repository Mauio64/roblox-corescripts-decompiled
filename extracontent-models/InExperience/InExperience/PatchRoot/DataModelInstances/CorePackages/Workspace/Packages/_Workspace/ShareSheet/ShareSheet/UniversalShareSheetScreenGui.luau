local Parent = script:FindFirstAncestor("ShareSheet").Parent
local Foundation = require(Parent.Foundation)
local InExperienceLocales = require(Parent.InExperienceLocales)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local SignalsReact = require(Parent.SignalsReact)
local UniversalShareSheetHost = require(script.Parent.Components.UniversalShareSheet.UniversalShareSheetHost)
local GetLocalizationServiceStore = Localization.GetLocalizationServiceStore
local Localization2 = InExperienceLocales.Localization
local LocalizationProvider = Localization.LocalizationProvider

local function UniversalShareSheetScreenGui() -- line: 22
	-- upvalues: React (copy), GetLocalizationServiceStore (copy), SignalsReact (copy), Localization2 (copy), Foundation (copy), LocalizationProvider (copy), UniversalShareSheetHost (copy)
	local v13, v14 = React.useState(nil)
	local v15 = GetLocalizationServiceStore()
	local v16 = SignalsReact.useSignalState(v15.getRobloxLocaleId)
	local v17 = React.useMemo(function() -- line: 26
		-- upvalues: Localization2 (copy), v16 (copy)
		return Localization2.new(v16)
	end, { v16 })

	return React.createElement("ScreenGui", {
		DisplayOrder = 15,
		IgnoreGuiInset = true,
		Name = "UniversalShareSheetScreenGui",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ref = v14
	}, {
		FoundationProvider = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			LocalizationProvider = React.createElement(LocalizationProvider, {
				localization = v17
			}, {
				OverlayProvider = if v13 == nil then nil else React.createElement(Foundation.OverlayProvider, {
					gui = v13
				}, {
					Host = React.createElement(UniversalShareSheetHost)
				})
			})
		})
	})
end

return {
	mount = function(p1) -- line: 56
		-- upvalues: ReactRoblox (copy), React (copy), UniversalShareSheetScreenGui (copy)
		local Folder = Instance.new("Folder")

		Folder.Name = "UniversalShareSheetScreenGuiRoot"
		Folder.Parent = p1

		local v20 = ReactRoblox.createRoot(Folder)

		v20:render(React.createElement(UniversalShareSheetScreenGui))

		return v20
	end
}
