local LocalizationService = game:GetService("LocalizationService")

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local RobloxAppLocales = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RobloxAppLocales")

local BuildExperienceCompositionStyleSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildExperienceCompositionStyleSheet")
local LibraryBrowserView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryBrowser/LibraryBrowserView")
local LibraryExperienceView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryExperienceView")
local LibraryThemeProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryThemeProvider")
local useLibraryStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/useLibraryStrings")

local function noop() end

local function LibraryPregameContent(p2)
	local v5 = useLibraryStrings()
	local v6 = {
		categories = {},
		status = "Loading",
		strings = v5,
		worldCutout = { title = v5.world, onActivated = noop, onRectChanged = noop }
	}

	return React.createElement(LibraryExperienceView, {
		isOpen = true,
		assetLabel = v5.title,
		worldLabel = v5.world,
		title = v5.title,
		searchPlaceholder = v5.searchPlaceholder,
		onShowLibrary = noop,
		onShowWorld = noop,
		onLeave = p2.onCancel
	}, {
		Browser = React.createElement(LibraryBrowserView, v6)
	})
end

local function LibraryPregameSkeleton(p2)
	local v5 = React.useMemo(function()
		return RobloxAppLocales.Localization.new(LocalizationService.RobloxLocaleId)
	end, {})
	return React.createElement("ScreenGui", {
		DisplayOrder = p2.displayOrder,
		ResetOnSpawn = false,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ClipToDeviceSafeArea = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Localization = React.createElement(module.LocalizationProvider, {
			localization = v5
		}, {
			Theme = React.createElement(LibraryThemeProvider, { displayOrder = p2.displayOrder }, {
				CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
				Content = React.createElement(LibraryPregameContent, p2)
			})
		})
	})
end

return LibraryPregameSkeleton
