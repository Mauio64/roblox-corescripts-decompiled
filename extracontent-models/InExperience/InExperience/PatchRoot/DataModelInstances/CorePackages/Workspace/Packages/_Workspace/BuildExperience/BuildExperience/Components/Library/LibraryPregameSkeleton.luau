local LocalizationService = game:GetService("LocalizationService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Localization = require(parent.Localization)
local React = require(parent.React)
local RobloxAppLocales = require(parent.RobloxAppLocales)

local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
local LibraryBrowserView = require(script.Parent.LibraryBrowser.LibraryBrowserView)
local LibraryExperienceView = require(script.Parent.LibraryExperienceView)
local LibraryThemeProvider = require(script.Parent.LibraryThemeProvider)
local useLibraryStrings = require(script.Parent.useLibraryStrings)

local function noop() end

local function LibraryPregameContent(p)
	local strings = useLibraryStrings()
	local v = {
		categories = {},
		status = "Loading",
		strings = strings,
		worldCutout = { title = strings.world, onActivated = noop, onRectChanged = noop }
	}

	return React.createElement(LibraryExperienceView, {
		isOpen = true,
		assetLabel = strings.title,
		worldLabel = strings.world,
		title = strings.title,
		searchPlaceholder = strings.searchPlaceholder,
		onShowLibrary = noop,
		onShowWorld = noop,
		onLeave = p.onCancel
	}, {
		Browser = React.createElement(LibraryBrowserView, v)
	})
end

local function LibraryPregameSkeleton(p)
	local localization = React.useMemo(function()
		return RobloxAppLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})
	return React.createElement("ScreenGui", {
		DisplayOrder = p.displayOrder,
		ResetOnSpawn = false,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Localization = React.createElement(Localization.LocalizationProvider, {
			localization = localization
		}, {
			Theme = React.createElement(LibraryThemeProvider, { displayOrder = p.displayOrder }, {
				CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
				Content = React.createElement(LibraryPregameContent, p)
			})
		})
	})
end

return LibraryPregameSkeleton
