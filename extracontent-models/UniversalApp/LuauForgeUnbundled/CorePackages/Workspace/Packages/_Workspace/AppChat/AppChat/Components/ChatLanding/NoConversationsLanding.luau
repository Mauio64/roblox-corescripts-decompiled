local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled

local v5 = {
	friends = {
		icon = "rbxasset://textures/ui/LuaChat/icons/ic-friends.png",
		copy = getFFlagIsSquadEnabled() and "Feature.Chat.Message.MakeFriendsToParty" or "Feature.Chat.Message.MakeConnectionsToChat",
		cta = "Feature.SettingsHub.Label.NoFriendsScreen"
	},
	regional = {
		icon = "icons/status/oof_xlarge",
		copy = getFFlagIsSquadEnabled() and "Feature.Chat.Message.PartyUnavailableRegion" or "Feature.Chat.Message.ChatUnavailableRegion",
		cta = nil
	},
	privacy = {
		icon = "rbxasset://textures/ui/LuaChat/icons/ic-friends.png",
		copy = getFFlagIsSquadEnabled() and "Feature.Chat.Message.EnableParty.FriendsRename" or "Feature.Chat.Message.EnableChat.FriendsRename",
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

local function getEmptyStateFromProps(data): string
	if data.chatEnabled then
		return "friends"
	end

	if not data.globalRulesEnabled then
		return "regional"
	end

	if not data.privacySettingsEnabled then
		return "privacy"
	end

	if data.thirdPartyPrivacySettingsEnabled then
		return "fallback"
	end

	return "thirdParty"
end

local function NoConversationsLanding(props)
	local v6 = props.chatEnabled and "friends"
		or props.globalRulesEnabled
		and (props.privacySettingsEnabled and (props.thirdPartyPrivacySettingsEnabled and "fallback" or "thirdParty") or "privacy")
		or "regional"

	local v7 = v5[v6]
	local v8 = v7.cta ~= nil

	if v6 == "friends" and not props.canNavigateToAddFriends then
		v8 = false
	elseif v6 == "privacy" and not props.canNavigateToPrivacySettings then
		v8 = false
	end

	local v9 = useLocalization({
		callToAction = v7.cta or "Feature.Chat.Label.PrivacySettings",
		copy = v7.copy
	})

	React.useEffect(function()
		if props.fireRenderEvent then
			props.fireRenderEvent(v6)
		end
	end, { props.fireRenderEvent, v6 })

	return React.createElement(Foundation.Empty, {
		icon = { name = v7.icon, size = "XLarge" },
		text = v9.copy,
		button = v8 and {
			text = v9.callToAction,
			icon = "icons/navigation/externallink_medium",
			onActivated = function()
				props.onCallToAction(v6)
			end
		} or nil
	})
end

return NoConversationsLanding
