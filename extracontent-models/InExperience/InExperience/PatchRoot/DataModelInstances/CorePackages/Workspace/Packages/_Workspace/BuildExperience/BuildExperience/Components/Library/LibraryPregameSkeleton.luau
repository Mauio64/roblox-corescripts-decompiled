local LocalizationService = game:GetService("LocalizationService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Motion = require(parent.Motion)
local React = require(parent.React)
local RobloxAppLocales = require(parent.RobloxAppLocales)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
local LibraryBrowserView = require(script.Parent.LibraryBrowser.LibraryBrowserView)
local LibraryExperienceView = require(script.Parent.LibraryExperienceView)
local LibraryThemeProvider = require(script.Parent.LibraryThemeProvider)
local useLibraryStrings = require(script.Parent.useLibraryStrings)

local function noop() end

local function useSlideIn()
	local v = Foundation.Hooks.useTokens()
	local v2 = not (Foundation.Hooks.usePreferences().reducedMotion or UserGameSettings.ReducedMotion)
	local state, setState = React.useState(v2)
	local v3, v4 = Motion.useMotion({
		offset = v2 and 1 or 0
	})
	React.useEffect(function()
		if not v2 then
			return nil
		end

		local v5 = false

		local transition = Motion.transition({
			duration = v.Time.Time_400,
			easingStyle = v.Ease.StandardOut
		})
		v4(Motion.createState({ offset = 0 }, { default = transition }), {
			onAnimationComplete = function()
				if not v5 then
					setState(false)
				end
			end
		})

		return function()
			v5 = true
		end
	end, { v2, v4, v })

	if v2 then
		return v3.offset:map(function(p: number)
			return UDim2.fromScale(p, 0)
		end), state
	end

	return nil, false
end

local function LibraryPregameContent(p)
	local strings = useLibraryStrings()
	local v = {
		categories = {},
		status = "Loading",
		strings = strings,
		worldCutout = { title = strings.world, onActivated = noop, onRectChanged = noop }
	}

	local element = React.createElement(LibraryExperienceView, {
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

	if not FFlagBuildExperienceLibrary then
		return element
	end

	local position, clipsDescendants = useSlideIn()
	return React.createElement(Foundation.View, {
		Position = position,
		ClipsDescendants = clipsDescendants,
		tag = "size-full",
		backgroundStyle = { Transparency = 1 },
		testId = "Library.Pregame.Page"
	}, { Experience = element })
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
