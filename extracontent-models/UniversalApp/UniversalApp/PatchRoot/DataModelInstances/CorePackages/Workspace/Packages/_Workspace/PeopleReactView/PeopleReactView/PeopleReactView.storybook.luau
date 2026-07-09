local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local ReactRoblox = require(PeopleReactViewParent.ReactRoblox)
local Signal = require(PeopleReactViewParent.AppCommonLib).Signal
local LocalizationProvider = require(PeopleReactViewParent.Localization).LocalizationProvider
local FoundationProvider = Foundation.FoundationProvider
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
	["Feature.SettingsHub.Prompt.BuyWhatTheyreWearing"] = "Buy what they’re wearing\t",
	["Feature.SettingsHub.Description.SelectAvatarToCheckoutItems"] = "Select an avatar to check out their items.",
	["Feature.SettingsHub.Description.SelectUsernameToViewProfile"] = "View profiles by selecting a username.",
	["Feature.SettingsHub.Action.Ok"] = "Ok"
}
local t3 = {
	Format = function(_, s1: string) -- line: 36
		-- upvalues: t2 (copy)
		return t2[s1] or s1
	end,
	changed = Signal.new(),
	GetLocale = function() -- line: 40
		return "en-us"
	end
}

local function StoryBookMapStory(p2) -- line: 46
	-- upvalues: React (copy), LocalizationProvider (copy), t3 (copy), FoundationProvider (copy), Foundation (copy), t1 (copy)
	return function(p3) -- line: 47
		-- upvalues: React (copy), LocalizationProvider (copy), t3 (copy), FoundationProvider (copy), Foundation (copy), t1 (copy), p2 (copy)
		return React.createElement(LocalizationProvider, {
			localization = t3
		}, {
			FoundationProvider = React.createElement(FoundationProvider, {
				theme = Foundation.Enums.Theme.Dark,
				device = p3 and t1[p3.platform] or t1.Default
			}, {
				Child = React.createElement(p2, p3)
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
