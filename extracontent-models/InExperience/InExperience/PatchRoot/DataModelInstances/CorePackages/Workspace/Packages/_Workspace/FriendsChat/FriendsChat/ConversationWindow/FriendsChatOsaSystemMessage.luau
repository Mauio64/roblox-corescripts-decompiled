local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local UserProfiles = require(parent.UserProfiles)

local FriendsChatTextMessage = require(script.Parent.Parent.Message.FriendsChatTextMessage)
local buildRowDisplay = require(script.Parent.Parent.Message.MessageDisplayStore.buildRowDisplay)
local FriendsChatOsaAcknowledgement = require(script.Parent.FriendsChatOsaAcknowledgement)

local FFlagFriendsChatDiscloseUpdateSecondVersion = SharedFlags.FFlagFriendsChatDiscloseUpdateSecondVersion

local UserProfileStore = UserProfiles.Stores.UserProfileStore

local function getProfileDisplayName(p, p2)
	if p == nil then
		return nil, false
	end

	if p.status == "failed" then
		return nil, true
	end

	local v

	if p.data then
		v = p.data[1]
	end

	local names

	if v then
		names = v.names
	end

	if names == nil then
		return nil, false
	end

	local selected

	if names.getCombinedName then
		selected = names.getCombinedName(p2)
	end

	if selected ~= nil and selected ~= "" then
		return selected, false
	end

	local selected2

	if names.getDisplayName then
		selected2 = names.getDisplayName(p2)
	end

	if selected2 ~= nil and selected2 ~= "" then
		return selected2, false
	end

	local v2

	if names.getUsername then
		v2 = names.getUsername(p2)
	end

	return v2, false
end

local function buildDisplay(profileDisplayName: string?, flag: boolean, localize, systemTextSize: number?)
	local canSeeChatTerminology = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
	local v = flag or profileDisplayName == nil
	local v2

	if canSeeChatTerminology then
		if v then
			v2 = FFlagFriendsChatDiscloseUpdateSecondVersion and "Feature.Chat.Heading.FirstConversationWithThisUser"
				or "Feature.Chat.Heading.SafeChattingWithThisUser"
		else
			v2 = FFlagFriendsChatDiscloseUpdateSecondVersion and {
				"Feature.Chat.Heading.FirstConversationWith",
				displayName = profileDisplayName
			} or {
				"Feature.Chat.Heading.SafeChattingWithUsername",
				displayName = profileDisplayName
			}
		end
	else
		v2 = v and "Feature.Chat.Heading.FirstInteractionWithThisPerson" or {
			"Feature.Chat.Heading.FirstInteractionWith",
			displayName = profileDisplayName
		}
	end

	return buildRowDisplay({
		kind = "systemMessage",
		body = `{localize(v2)}\n{localize(canSeeChatTerminology and "Feature.Chat.Description.InlineContextCardDescription" or "Feature.Chat.Description.OSAContextCardDescription")}`,
		variant = "default"
	}, {}, { systemTextSize = systemTextSize })
end

local function FriendsChatOsaSystemMessage(props)
	local ref = React.useRef(nil)
	FriendsChatOsaAcknowledgement.useAcknowledgement({
		conversationId = props.conversationId,
		userId = props.userId,
		guiObjectRef = ref
	})

	local v = React.useMemo(function()
		return UserProfileStore.get().fetchNamesByUserIds({ props.userId })
	end, { props.userId })
	local getDisplayId = React.useCallback(function()
		return `osa-system-message-{props.conversationId}`
	end, { props.conversationId })
	local getLayoutOrder = React.useCallback(function(): number
		return 0
	end, {})
	local getDisplayFromId = React.useCallback(function(_: string?, p, p2)
		local profileDisplayName, v2 = getProfileDisplayName(v(p), p)
		local localize

		if p2 and p2.localize then
			localize = p2.localize
		else
			localize = props.localize
		end

		local v3

		if p2 then
			v3 = p2.systemTextSize
		end

		return buildDisplay(profileDisplayName, v2, localize, v3)
	end, { v, props.localize })

	return React.createElement(FriendsChatTextMessage, {
		getDisplayId = getDisplayId,
		getDisplayFromId = getDisplayFromId,
		getLayoutOrder = getLayoutOrder,
		chatWindowSettings = props.chatWindowSettings,
		textTransparency = props.textTransparency,
		isSpatialUIEnabled = props.isSpatialUIEnabled,
		localize = props.localize,
		guiObjectRef = ref
	})
end

return FriendsChatOsaSystemMessage
