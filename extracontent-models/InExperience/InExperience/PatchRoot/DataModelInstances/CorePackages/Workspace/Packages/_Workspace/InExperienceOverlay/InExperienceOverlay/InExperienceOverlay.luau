local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("InExperienceOverlay").Parent
local CoreGuiCommon = require(Parent.CoreGuiCommon)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.InExperienceLocales).Localization
local Localization2 = require(Parent.Localization)
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local Songbird = require(Parent.Songbird)
local Components = CoreGuiCommon.Components
local View = Foundation.View
local FFlagEnableUISelector = CoreGuiCommon.Flags.FFlagEnableUISelector

local function renderInExperienceOverlay() -- line: 24
	-- upvalues: CoreGui (copy), React (copy), Foundation (copy), Localization2 (copy), Localization (copy), LocalizationService (copy), View (copy), Components (copy), FFlagEnableUISelector (copy), Songbird (copy), ReactRoblox (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "InExperienceOverlay"
	ScreenGui.DisplayOrder = 6
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ClipToDeviceSafeArea = false
	ScreenGui.ScreenInsets = Enum.ScreenInsets.None
	ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	ScreenGui.Parent = CoreGui

	local v16 = React.createElement(Foundation.FoundationProvider, {
		theme = Foundation.Enums.Theme.Dark
	}, {
		LocalizationProvider = React.createElement(Localization2.LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			Popups = React.createElement(View, {
				tag = "size-full"
			}, {
				HeadsetDisconnectDialog = React.createElement(Components.HeadsetDisconnectDialog),
				HurtOverlay = React.createElement(Components.HurtOverlay),
				InExperienceUiSelector = if not FFlagEnableUISelector then nil else React.createElement(Components.InExperienceUiSelector)
			}),
			Binders = React.createElement(React.Fragment, {}, {
				SongbirdDebugAudio = React.createElement(Songbird.DebugAudioEmitters)
			})
		})
	})
	local v17 = ReactRoblox.createRoot(ScreenGui)

	v17:render(v16)

	return v17
end

return renderInExperienceOverlay
