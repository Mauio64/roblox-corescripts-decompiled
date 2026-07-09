local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local withStyle = require(Parent.UIBlox).Style.withStyle
local withLocalization = require(Parent.Localization).withLocalization
local UniversalAppPolicy = require(Parent.UniversalAppPolicy).UniversalAppPolicy
local ChatDisabledIndicator = require(script.Parent.ChatDisabledIndicator)
local GetFFlagIsSquadEnabled = require(Parent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagConnectionsToFriendsRename = require(Parent.SharedFlags).FFlagConnectionsToFriendsRename
local v9 = Roact.PureComponent:extend("EmptyConversationList")

v9.defaultProps = {
	chatEnabled = false,
	privacyButtonKey = "Feature.Chat.Label.PrivacySettings",
	privacyButtonEnabled = true,
	renameFriendsToConnections = true,
	navigateToPrivacy = function() -- line: 19
	end,
	makeFriendsToChatKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.MakeFriendsToChat" or "Feature.Chat.Message.MakeFriendsToParty",
	turnOnChatKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.TurnOnChat" or "Feature.Chat.Message.TurnOnParty"
}

local t1 = {
	makeFriendsToChatKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.MakeConnectionsToChat" or "Feature.Chat.Message.MakeConnectionsToParty",
	turnOnChatKey = if not GetFFlagIsSquadEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.EnableChat" or "Feature.Chat.Message.EnableChat.FriendsRename" else not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.EnableParty" or "Feature.Chat.Message.EnableParty.FriendsRename"
}

function v9.didMount(p1) -- line: 45
	if p1.props.fireRenderEvent then
		p1.props.fireRenderEvent()
	end
end
function v9.render(p2) -- line: 51
	-- upvalues: t1 (copy), withLocalization (copy), withStyle (copy), Roact (copy), ChatDisabledIndicator (copy)
	local makeFriendsToChatKey = p2.props.makeFriendsToChatKey
	local turnOnChatKey = p2.props.turnOnChatKey

	if p2.props.renameFriendsToConnections then
		makeFriendsToChatKey = t1[makeFriendsToChatKey]
		turnOnChatKey = t1[turnOnChatKey]
	end

	return withLocalization({
		privacyButtonText = p2.props.privacyButtonKey,
		chatDisabledText = p2.props.chatEnabled and makeFriendsToChatKey or turnOnChatKey
	})(function(p3) -- line: 61
		-- upvalues: withStyle (copy), Roact (copy), ChatDisabledIndicator (copy), p2 (copy)
		return withStyle(function(p4) -- line: 62
			-- upvalues: Roact (copy), ChatDisabledIndicator (copy), p2 (copy), p3 (copy)
			return Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = p4.Theme.BackgroundDefault.Color,
				BackgroundTransparency = p4.Tokens.Color.None.Transparency,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				ChatDisabledIndicator = Roact.createElement(ChatDisabledIndicator, {
					chatEnabled = p2.props.chatEnabled,
					navigateToPrivacy = p2.props.navigateToPrivacy,
					chatDisabledText = p3.chatDisabledText,
					privacyButtonText = p3.privacyButtonText,
					privacyButtonEnabled = p2.props.privacyButtonEnabled
				})
			})
		end)
	end)
end

return UniversalAppPolicy.connect(function(p5) -- line: 82
	return {
		renameFriendsToConnections = p5.getRenameFriendsToConnections()
	}
end)(v9)
