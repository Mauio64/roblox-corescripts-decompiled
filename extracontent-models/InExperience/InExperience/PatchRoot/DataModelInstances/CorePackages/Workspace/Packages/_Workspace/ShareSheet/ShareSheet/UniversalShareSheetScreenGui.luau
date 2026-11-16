local parent = script:FindFirstAncestor("ShareSheet").Parent

local Foundation = require(parent.Foundation)
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = require(parent.Localization)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local SignalsReact = require(parent.SignalsReact)

local UniversalShareSheetHost = require(script.Parent.Components.UniversalShareSheet.UniversalShareSheetHost)

local GetLocalizationServiceStore = Localization.GetLocalizationServiceStore
local localization = InExperienceLocales.Localization
local LocalizationProvider = Localization.LocalizationProvider

local function UniversalShareSheetScreenGui()
	local state, setState = React.useState(nil)
	local localizationServiceStore = GetLocalizationServiceStore()
	local v = SignalsReact.useSignalState(localizationServiceStore.getRobloxLocaleId)
	local localization2 = React.useMemo(function()
		return localization.new(v)
	end, { v })

	local createElement = React.createElement
	local v2 = {
		DisplayOrder = 15,
		IgnoreGuiInset = true,
		Name = "UniversalShareSheetScreenGui",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ref = setState
	}

	local createElement2 = React.createElement
	local foundationProvider = Foundation.FoundationProvider
	local v3 = { colorMode = Foundation.Enums.ColorMode.Dark }

	local createElement3 = React.createElement
	local overlayProvider

	if state ~= nil then
		overlayProvider = React.createElement(Foundation.OverlayProvider, { gui = state }, {
			Host = React.createElement(UniversalShareSheetHost)
		})
	end

	return createElement("ScreenGui", v2, {
		FoundationProvider = createElement2(foundationProvider, v3, {
			LocalizationProvider = createElement3(LocalizationProvider, {
				localization = localization2
			}, {
				OverlayProvider = overlayProvider
			})
		})
	})
end

return {
	mount = function(parent2)
		local universalShareSheetScreenGuiRoot = Instance.new("Folder")
		universalShareSheetScreenGuiRoot.Name = "UniversalShareSheetScreenGuiRoot"
		universalShareSheetScreenGuiRoot.Parent = parent2

		local root = ReactRoblox.createRoot(universalShareSheetScreenGuiRoot)
		root:render(React.createElement(UniversalShareSheetScreenGui))

		return root
	end
}
