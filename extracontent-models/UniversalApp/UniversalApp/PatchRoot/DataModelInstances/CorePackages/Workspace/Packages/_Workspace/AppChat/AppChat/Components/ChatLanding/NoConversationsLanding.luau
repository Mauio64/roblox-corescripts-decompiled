local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local GetFFlagIsSquadEnabled = require(Parent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagConnectionsToFriendsRename = require(Parent.SharedFlags).FFlagConnectionsToFriendsRename
local t1 = {
	friends = {
		icon = "rbxasset://textures/ui/LuaChat/icons/ic-friends.png",
		copy = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.MakeConnectionsToChat" or (not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.MakeConnectionsToParty" or "Feature.Chat.Message.MakeFriendsToParty"),
		cta = not FFlagConnectionsToFriendsRename and "Feature.SettingsHub.Label.NoConnectionsScreen" or "Feature.SettingsHub.Label.NoFriendsScreen"
	},
	regional = {
		icon = "icons/status/oof_xlarge",
		cta = nil,
		copy = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.ChatUnavailableRegion" or "Feature.Chat.Message.PartyUnavailableRegion"
	},
	privacy = {
		icon = "rbxasset://textures/ui/LuaChat/icons/ic-friends.png",
		cta = "Feature.Chat.Label.PrivacySettings",
		copy = if not GetFFlagIsSquadEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.EnableChat" or "Feature.Chat.Message.EnableChat.FriendsRename" else not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.EnableParty" or "Feature.Chat.Message.EnableParty.FriendsRename"
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

local function getEmptyStateFromProps(t2: {[any]: any}) -- line: 72
	if t2.chatEnabled then
		return "friends"
	end

	if not t2.globalRulesEnabled then
		return "regional"
	end

	if not t2.privacySettingsEnabled then
		return "privacy"
	end

	if not t2.thirdPartyPrivacySettingsEnabled then
		return "thirdParty"
	end

	return "fallback"
end
local function NoConversationsLanding(t3: {[any]: any}) -- line: 87
	-- upvalues: t1 (copy), useLocalization (copy), React (copy), Foundation (copy)
	local v12 = if not t3.chatEnabled then if t3.globalRulesEnabled then if t3.privacySettingsEnabled then t3.thirdPartyPrivacySettingsEnabled and "fallback" or "thirdParty" else "privacy" else "regional" else "friends"
	local v13 = t1[v12]
	local v14 = v13.cta ~= nil

	if v12 == "friends" and not t3.canNavigateToAddFriends then
		v14 = false
	elseif v12 == "privacy" and not t3.canNavigateToPrivacySettings then
		v14 = false
	end

	local v15 = useLocalization({
		callToAction = v13.cta or "Feature.Chat.Label.PrivacySettings",
		copy = v13.copy
	})

	React.useEffect(function() -- line: 102
		-- upvalues: t3 (copy), v12 (copy)
		if t3.fireRenderEvent then
			t3.fireRenderEvent(v12)
		end
	end, {
		t3.fireRenderEvent,
		v12
	})

	return React.createElement(Foundation.Empty, {
		icon = {
			size = "XLarge",
			name = v13.icon
		},
		text = v15.copy,
		button = if not v14 then nil else {
			icon = "icons/navigation/externallink_medium",
			text = v15.callToAction,
			onActivated = function() -- line: 118
				-- upvalues: t3 (copy), v12 (copy)
				t3.onCallToAction(v12)
			end
		}
	})
end

return NoConversationsLanding
