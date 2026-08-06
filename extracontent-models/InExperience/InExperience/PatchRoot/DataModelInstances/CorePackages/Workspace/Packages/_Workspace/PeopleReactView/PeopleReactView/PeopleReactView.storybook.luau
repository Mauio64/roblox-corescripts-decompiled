local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local ReactRoblox = require(PeopleReactViewParent.ReactRoblox)
local Signal = require(PeopleReactViewParent.AppCommonLib).Signal
local LocalizationProvider = require(PeopleReactViewParent.Localization).LocalizationProvider
local FoundationProvider = Foundation.FoundationProvider
local useStyleSheet = Foundation.Hooks.useStyleSheet
local t1 = {
	Default = "Desktop",
	Desktop = "Desktop",
	Console = "Console"
}
local t2 = {
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
local t3 = {
	Format = function(_, s1: string) -- line: 40
		-- upvalues: t2 (copy)
		return t2[s1] or s1
	end,
	changed = Signal.new(),
	GetLocale = function() -- line: 44
		return "en-us"
	end
}

local function StyleLinkPortal(t4: {[any]: any}) -- line: 49
	-- upvalues: useStyleSheet (copy), ReactRoblox (copy), React (copy)
	local v18 = useStyleSheet()

	return ReactRoblox.createPortal(React.createElement("StyleLink", {
		StyleSheet = v18
	}), t4.overlay)
end
local function StoryBookMapStory(p2) -- line: 60
	-- upvalues: React (copy), LocalizationProvider (copy), t3 (copy), FoundationProvider (copy), Foundation (copy), t1 (copy), StyleLinkPortal (copy)
	return function(p3) -- line: 61
		-- upvalues: React (copy), LocalizationProvider (copy), t3 (copy), FoundationProvider (copy), Foundation (copy), t1 (copy), p2 (copy), StyleLinkPortal (copy)
		local v21 = React.useRef(Instance.new("Frame"))

		if v21.current.Parent ~= p3.focus then
			v21.current.Parent = p3.focus
		end

		React.useLayoutEffect(function() -- line: 67
			-- upvalues: v21 (copy)
			v21.current.Size = UDim2.fromScale(1, 1)
			v21.current.BackgroundTransparency = 1
		end, {})

		return React.createElement(LocalizationProvider, {
			localization = t3
		}, {
			FoundationProvider = React.createElement(FoundationProvider, {
				theme = Foundation.Enums.Theme.Dark,
				device = p3 and t1[p3.platform] or t1.Default,
				overlayGui = v21.current
			}, {
				Child = React.createElement(p2, p3),
				StyleLink = React.createElement(StyleLinkPortal, {
					overlay = v21.current
				})
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
