local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider

local FoundationProvider = Foundation.FoundationProvider
local useStyleSheet = Foundation.Hooks.useStyleSheet

local v = { Default = "Desktop", Desktop = "Desktop", Console = "Console" }

local v2 = {
	["Feature.SettingsHub.Action.Block"] = "Block",
	["Feature.SettingsHub.Action.Unblock"] = "Unblock",
	["Feature.SettingsHub.Label.Mute"] = "Mute",
	["Feature.SettingsHub.Label.Unmute"] = "Unmute",
	["CoreScripts.InGameMenu.QuickActions.Report"] = "Report",
	["CoreScripts.InGameMenu.GameSettings.Volume"] = "Volume",
	["Feature.SettingsHub.Label.VoiceChat"] = "Voice chat",
	["CoreScripts.InGameMenu.VoiceChatVolumeLower"] = "Voice chat volume",
	["Feature.SettingsHub.Prompt.BuyWhatTheyreWearing"] = "Buy what they’re wearing\t",
	["Feature.SettingsHub.Description.SelectAvatarToCheckoutItems"] = "Select an avatar to check out their items.",
	["Feature.SettingsHub.Description.SelectUsernameToViewProfile"] = "View profiles by selecting a username.",
	["Feature.SettingsHub.Action.Ok"] = "Ok"
}

local localization = {
	Format = function(_, p: string)
		return v2[p] or p
	end,
	changed = Signal.new(),
	GetLocale = function(): string
		return "en-us"
	end
}

local function StyleLinkPortal(p)
	local styleSheet = useStyleSheet()
	return ReactRoblox.createPortal(React.createElement("StyleLink", { StyleSheet = styleSheet }), p.overlay)
end

local function StoryBookMapStory(p)
	return function(p2)
		local ref = React.useRef(Instance.new("Frame"))

		if ref.current.Parent ~= p2.focus then
			ref.current.Parent = p2.focus
		end

		React.useLayoutEffect(function()
			ref.current.Size = UDim2.fromScale(1, 1)
			ref.current.BackgroundTransparency = 1
		end, {})

		return React.createElement(LocalizationProvider, { localization = localization }, {
			FoundationProvider = React.createElement(FoundationProvider, {
				colorMode = Foundation.Enums.ColorMode.Dark,
				device = p2 and v[p2.platform] or "Desktop",
				overlayGui = ref.current
			}, {
				Child = React.createElement(p, p2),
				StyleLink = React.createElement(StyleLinkPortal, { overlay = ref.current })
			})
		})
	end
end

return {
	name = PeopleReactView.Name,
	storyRoot = PeopleReactView,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = StoryBookMapStory
}
