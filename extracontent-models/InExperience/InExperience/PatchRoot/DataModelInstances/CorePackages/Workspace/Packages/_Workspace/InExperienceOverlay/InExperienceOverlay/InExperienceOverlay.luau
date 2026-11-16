local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("InExperienceOverlay").Parent

local CoreGuiCommon = require(parent.CoreGuiCommon)
local Foundation = require(parent.Foundation)
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Songbird = require(parent.Songbird)

local Components = CoreGuiCommon.Components
local View = Foundation.View

local FFlagEnableUISelector = CoreGuiCommon.Flags.FFlagEnableUISelector

local function renderInExperienceOverlay()
	local inExperienceOverlay = Instance.new("ScreenGui")
	inExperienceOverlay.Name = "InExperienceOverlay"
	inExperienceOverlay.DisplayOrder = 6
	inExperienceOverlay.IgnoreGuiInset = true
	inExperienceOverlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	inExperienceOverlay.ClipToDeviceSafeArea = false
	inExperienceOverlay.ScreenInsets = Enum.ScreenInsets.None
	inExperienceOverlay.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	inExperienceOverlay.Parent = CoreGui

	local createElement = React.createElement
	local foundationProvider = Foundation.FoundationProvider
	local v = { colorMode = Foundation.Enums.ColorMode.Dark }

	local createElement2 = React.createElement
	local localizationProvider = Localization2.LocalizationProvider
	local v2 = {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}

	local createElement3 = React.createElement

	local v3 = {
		HeadsetDisconnectDialog = React.createElement(Components.HeadsetDisconnectDialog),
		HurtOverlay = React.createElement(Components.HurtOverlay),
		InExperienceUiSelector = 0
	}
	local inExperienceUiSelector

	if FFlagEnableUISelector then
		inExperienceUiSelector = React.createElement(Components.InExperienceUiSelector)
	end

	v3.InExperienceUiSelector = inExperienceUiSelector
	local element = createElement(foundationProvider, v, {
		LocalizationProvider = createElement2(localizationProvider, v2, {
			Popups = createElement3(View, { tag = "size-full" }, v3),
			Binders = React.createElement(React.Fragment, {}, {
				SongbirdDebugAudio = React.createElement(Songbird.DebugAudioEmitters)
			})
		})
	})

	local root = ReactRoblox.createRoot(inExperienceOverlay)
	root:render(element)

	return root
end

return renderInExperienceOverlay
