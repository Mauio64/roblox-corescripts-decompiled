local LocalizationService = game:GetService("LocalizationService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Motion")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local RobloxAppLocales = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RobloxAppLocales")
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceLibrary
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local BuildExperienceCompositionStyleSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildExperienceCompositionStyleSheet")
local LibraryBrowserView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryBrowser/LibraryBrowserView")
local LibraryExperienceView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryExperienceView")
local LibraryThemeProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryThemeProvider")
local useLibraryStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/useLibraryStrings")

local function noop() end

local function useSlideIn()
	local v5 = Foundation.Hooks.useTokens()
	local v6 = not (Foundation.Hooks.usePreferences().reducedMotion or UserGameSettings.ReducedMotion)
	local state, setState = React.useState(v6)
	local v7, v8 = Motion.useMotion({
		offset = v6 and 1 or 0
	})
	React.useEffect(function()
		if not v6 then
			return nil
		end

		local v9 = false

		local transition = Motion.transition({
			duration = v5.Time.Time_400,
			easingStyle = v5.Ease.StandardOut
		})
		v8(Motion.createState({ offset = 0 }, { default = transition }), {
			onAnimationComplete = function()
				if not v9 then
					setState(false)
				end
			end
		})

		return function()
			v9 = true
		end
	end, { v6, v8, v5 })

	if v6 then
		return v7.offset:map(function(p2)
			return UDim2.fromScale(p2, 0)
		end), state
	end

	return nil, false
end

local function LibraryPregameContent(p2)
	local v5 = useLibraryStrings()
	local v6 = {
		categories = {},
		status = "Loading",
		strings = v5,
		worldCutout = { title = v5.world, onActivated = noop, onRectChanged = noop }
	}

	local element = React.createElement(LibraryExperienceView, {
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

	if not fFlagBuildExperienceLibrary then
		return element
	end

	local v7, v8 = useSlideIn()
	return React.createElement(Foundation.View, {
		Position = v7,
		ClipsDescendants = v8,
		tag = "size-full",
		backgroundStyle = { Transparency = 1 },
		testId = "Library.Pregame.Page"
	}, { Experience = element })
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
		Localization = React.createElement(module2.LocalizationProvider, {
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
