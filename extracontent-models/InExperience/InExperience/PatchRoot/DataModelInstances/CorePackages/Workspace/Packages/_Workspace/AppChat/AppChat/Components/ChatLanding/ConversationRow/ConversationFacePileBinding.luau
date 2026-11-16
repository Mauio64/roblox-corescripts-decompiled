local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local FFlagAppChatUseProfileFrameThumbnail = require(AppChat.Flags.FFlagAppChatUseProfileFrameThumbnail)
local FFlagAppChatBindingFacePileUserTileParity = require(AppChat.Flags.FFlagAppChatBindingFacePileUserTileParity)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local Avatar = Foundation.Avatar
local AvatarSize = Foundation.Enums.AvatarSize
local Image = Foundation.Image
local View = Foundation.View
local useCumulativeBackground = Foundation.Hooks.useCumulativeBackground
local v = DataHydration.Presence.PresenceStore.get()
local PresenceType = DataHydration.Presence.PresenceEnums.PresenceType

local function getParticipantId(p) -- 1 equivalent call inferred from this helper
	if type(p) == "table" then
		local id = p.id or p.userId

		if id == nil then
			return nil
		end

		return (tostring(id))
	elseif p == nil then
		return nil
	else
		return (tostring(p))
	end
end

local function getParticipantIds(p, p2)
	local presentationSignal = p.presentationSignal(p2)
	local v2 = presentationSignal.localUserId == nil and "" or tostring(presentationSignal.localUserId)
	local conversation = GetConversationStore(false).getConversation(p.id, p2)
	local v3 = (conversation == nil or conversation.participants == nil) and {} or conversation.participants
	local participantIds = {}

	if #v3 == 1 then
		table.insert(participantIds, v2)
		return participantIds
	end

	for _, v4 in v3 do
		local participantId = getParticipantId(v4) -- inferred equivalent call

		if participantId ~= nil and participantId ~= v2 then
			table.insert(participantIds, participantId)
		end
	end

	return participantIds
end

local function getAvatarIds(p, p2) -- 3 equivalent calls inferred from this helper
	local participantIds = getParticipantIds(p, p2)
	return {
		primary = participantIds[1] or "",
		secondary = participantIds[2]
	}
end

local function getHeadshotImage(userId: number, flag: boolean, flag2: boolean?)
	if flag and userId ~= 0 then
		return getStandardSizeAvatarHeadShotRbxthumb(tostring(userId), flag2)
	end

	return ""
end

local function ConversationFacePileBinding(p)
	local v2 = Foundation.Hooks.useTokens()
	local shift_300 = v2.Color.Shift.Shift_300

	local v3 = React.useCallback(function(p2, p3)
		return tonumber(getAvatarIds(p2, p3).primary) or 0 -- inferred equivalent call
	end, {})
	local v4 = React.useCallback(function(p2, p3)
		return tonumber(getAvatarIds(p2, p3).secondary) or 0 -- inferred equivalent call
	end, {})
	local v5 = React.useCallback(function(p2, p3): boolean
		return getAvatarIds(p2, p3).secondary ~= nil -- inferred equivalent call
	end, {})
	local v6 = React.useCallback(function(p2, p3): boolean
		for _, v6 in getParticipantIds(p2, p3) do
			local data = v.GetPresenceByUserId(v6).data(p3)

			if data == nil then
				continue
			end

			local userPresenceType = data.userPresenceType

			if
				userPresenceType == PresenceType.InGame
				or userPresenceType == PresenceType.InStudio
				or userPresenceType == PresenceType.Online
			then
				return true
			end
		end

		return false
	end, {})

	local userId = SignalsReact.useSignalBinding(function(p2)
		return v3(p.itemSignal(p2), p2)
	end)

	local userId2 = SignalsReact.useSignalBinding(function(p2)
		return v4(p.itemSignal(p2), p2)
	end)

	local v7 = SignalsReact.useSignalBinding(function(p2)
		return v5(p.itemSignal(p2), p2)
	end)

	local visible = SignalsReact.useSignalBinding(function(p2)
		return v6(p.itemSignal(p2), p2)
	end)

	local mapped = v7:map(function(p2): boolean
		return not p2
	end)
	local backgroundStyle

	if FFlagAppChatBindingFacePileUserTileParity then
		backgroundStyle = useCumulativeBackground(v2.Color.Surface.Surface_0, shift_300)
	end

	local element = React.createElement(Image, {
		Image = "component_assets/circle_16",
		Position = UDim2.new(0.8536, v2.Stroke.Thicker, 0.8536, v2.Stroke.Thicker),
		Size = UDim2.new(0.125, 4, 0.125, 4),
		Visible = visible,
		ZIndex = 3,
		imageStyle = v2.Color.System.Success,
		stroke = { Thickness = v2.Stroke.Thicker, Color = v2.Color.Surface.Surface_100.Color3 },
		tag = "anchor-center-center radius-circle bg-surface-100",
		testId = "conversation-face-pile-presence"
	})

	if not FFlagAppChatBindingFacePileUserTileParity then
		return React.createElement(View, {
			tag = "position-center-center anchor-center-center size-full"
		}, {
			Primary = React.createElement(Avatar, {
				backgroundStyle = shift_300,
				includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
				size = AvatarSize.Medium,
				testId = "conversation-face-pile-primary",
				userId = userId,
				Visible = mapped
			}),
			Group = React.createElement(
				View,
				{ tag = "size-full", testId = "conversation-face-pile-group", Visible = v7 },
				{
					Primary = React.createElement(Avatar, {
						AnchorPoint = Vector2.new(0, 1),
						backplateStyle = v2.Color.Surface.Surface_0,
						backgroundStyle = shift_300,
						Position = UDim2.fromScale(0, 1),
						size = AvatarSize.Small,
						testId = "conversation-face-pile-group-primary",
						userId = userId,
						ZIndex = 2
					}),
					Secondary = React.createElement(Avatar, {
						AnchorPoint = Vector2.new(1, 0),
						backplateStyle = v2.Color.Surface.Surface_0,
						backgroundStyle = shift_300,
						Position = UDim2.fromScale(1, 0),
						size = AvatarSize.Small,
						testId = "conversation-face-pile-group-secondary",
						userId = userId2,
						ZIndex = 1
					})
				}
			),
			Presence = element
		})
	end

	local joinBindings = React.joinBindings({ userId = userId, hasSecondary = v7 })
	local mapped2 = joinBindings:map(function(p2)
		return getHeadshotImage(p2.userId, not p2.hasSecondary, FFlagAppChatUseProfileFrameThumbnail)
	end)

	local mapped3 = joinBindings:map(function(p2)
		return getHeadshotImage(p2.userId, p2.hasSecondary)
	end)

	local mapped4 = React.joinBindings({ userId = userId2, hasSecondary = v7 }):map(function(p2)
		return getHeadshotImage(p2.userId, p2.hasSecondary)
	end)

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full"
	}, {
		Primary = React.createElement(
			View,
			{ tag = "size-full", testId = "conversation-face-pile-primary", Visible = mapped },
			{
				Image = React.createElement(Image, {
					backgroundStyle = shift_300,
					Image = mapped2,
					tag = "position-center-center anchor-center-center size-full aspect-1-1 radius-circle",
					testId = "conversation-face-pile-primary--image"
				})
			}
		),
		Group = React.createElement(
			View,
			{ tag = "size-full", testId = "conversation-face-pile-group", Visible = v7 },
			{
				Primary = React.createElement(Image, {
					backgroundStyle = backgroundStyle,
					Image = mapped3,
					Size = UDim2.fromScale(0.7, 0.7),
					tag = "position-bottom-left anchor-bottom-left aspect-1-1 radius-circle",
					testId = "conversation-face-pile-group-primary--image",
					ZIndex = 2
				}),
				Secondary = React.createElement(Image, {
					backgroundStyle = backgroundStyle,
					Image = mapped4,
					Size = UDim2.fromScale(0.7, 0.7),
					tag = "position-top-right anchor-top-right aspect-1-1 radius-circle",
					testId = "conversation-face-pile-group-secondary--image",
					ZIndex = 1
				})
			}
		),
		Presence = element
	})
end

return ConversationFacePileBinding
