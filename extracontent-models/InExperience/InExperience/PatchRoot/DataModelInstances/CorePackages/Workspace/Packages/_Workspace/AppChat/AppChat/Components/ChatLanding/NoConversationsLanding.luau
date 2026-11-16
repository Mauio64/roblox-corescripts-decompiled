local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

local v = {
	friends = {
		icon = "rbxasset://textures/ui/LuaChat/icons/ic-friends.png",
		copy = GetFFlagIsSquadEnabled() and "Feature.Chat.Message.MakeFriendsToParty" or "Feature.Chat.Message.MakeConnectionsToChat",
		cta = "Feature.SettingsHub.Label.NoFriendsScreen"
	},
	regional = {
		icon = "icons/status/oof_xlarge",
		copy = GetFFlagIsSquadEnabled() and "Feature.Chat.Message.PartyUnavailableRegion" or "Feature.Chat.Message.ChatUnavailableRegion",
		cta = nil
	},
	privacy = {
		icon = "rbxasset://textures/ui/LuaChat/icons/ic-friends.png",
		copy = GetFFlagIsSquadEnabled() and "Feature.Chat.Message.EnableParty.FriendsRename" or "Feature.Chat.Message.EnableChat.FriendsRename",
		cta = "Feature.Chat.Label.PrivacySettings"
	},
	thirdParty = {
		icon = "rbxasset://textures/ui/LuaChat/icons/ic-friends.png",
		copy = "Feature.Chat.Message.ChatIsDisabledByPrivacySetting",
		cta = nil
	},
	fallback = {
		icon = "icons/status/oof_xlarge",
		copy = "CommonUI.Messages.Response.PageError",
		cta = nil
	}
}

local function getEmptyStateFromProps(props): string -- 1 equivalent call inferred from this helper
	if props.chatEnabled then
		return "friends"
	end

	if not props.globalRulesEnabled then
		return "regional"
	end

	if not props.privacySettingsEnabled then
		return "privacy"
	end

	if props.thirdPartyPrivacySettingsEnabled then
		return "fallback"
	end

	return "thirdParty"
end

local function NoConversationsLanding(props)
	local emptyStateFromProps = getEmptyStateFromProps(props) -- inferred equivalent call
	local v2 = v[emptyStateFromProps]
	local v3 = v2.cta ~= nil

	if emptyStateFromProps == "friends" and not props.canNavigateToAddFriends then
		v3 = false
	elseif emptyStateFromProps == "privacy" and not props.canNavigateToPrivacySettings then
		v3 = false
	end

	local v4 = useLocalization({
		callToAction = v2.cta or "Feature.Chat.Label.PrivacySettings",
		copy = v2.copy
	})

	React.useEffect(function()
		if props.fireRenderEvent then
			props.fireRenderEvent(emptyStateFromProps)
		end
	end, { props.fireRenderEvent, emptyStateFromProps })

	return React.createElement(Foundation.Empty, {
		icon = { name = v2.icon, size = "XLarge" },
		text = v4.copy,
		button = v3 and {
			text = v4.callToAction,
			icon = "icons/navigation/externallink_medium",
			onActivated = function()
				props.onCallToAction(emptyStateFromProps)
			end
		} or nil
	})
end

return NoConversationsLanding
