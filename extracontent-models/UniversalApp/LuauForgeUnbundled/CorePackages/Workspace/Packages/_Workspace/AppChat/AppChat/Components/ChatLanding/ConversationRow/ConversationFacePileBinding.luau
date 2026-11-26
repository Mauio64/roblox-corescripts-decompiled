local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local FFlagAppChatUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseProfileFrameThumbnail")
local FFlagAppChatBindingFacePileUserTileParity = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatBindingFacePileUserTileParity")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb

local avatar = Foundation.Avatar
local avatarSize = Foundation.Enums.AvatarSize
local image = Foundation.Image
local view = Foundation.View
local useCumulativeBackground = Foundation.Hooks.useCumulativeBackground
local v5 = DataHydration.Presence.PresenceStore.get()
local presenceType = DataHydration.Presence.PresenceEnums.PresenceType

local function getParticipantId(p2)
	if type(p2) == "table" then
		local id = p2.id or p2.userId

		if id == nil then
			return nil
		end

		return (tostring(id))
	elseif p2 == nil then
		return nil
	else
		return (tostring(p2))
	end
end

local function getParticipantIds(p2, p3)
	local presentationSignal = p2.presentationSignal(p3)
	local v6 = presentationSignal.localUserId == nil and "" or tostring(presentationSignal.localUserId)
	local conversation = GetConversationStore(false).getConversation(p2.id, p3)
	local v7 = (conversation == nil or conversation.participants == nil) and {} or conversation.participants
	local participantIds = {}

	if #v7 == 1 then
		table.insert(participantIds, v6)
		return participantIds
	end

	for k, v8 in v7 do
		local v9

		if type(v8) == "table" then
			local id = v8.id or v8.userId

			if id ~= nil then
				v9 = tostring(id)
			end
		elseif v8 ~= nil then
			v9 = tostring(v8)
		end

		if v9 ~= nil and v9 ~= v6 then
			table.insert(participantIds, v9)
		end
	end

	return participantIds
end

local function getAvatarIds(p2, p3)
	local participantIds = getParticipantIds(p2, p3)
	return {
		primary = participantIds[1] or "",
		secondary = participantIds[2]
	}
end

local function getHeadshotImage(userId, p2, p3)
	if p2 and userId ~= 0 then
		return getStandardSizeAvatarHeadShotRbxthumb(tostring(userId), p3)
	end

	return ""
end

local function ConversationFacePileBinding(p2)
	local v6 = Foundation.Hooks.useTokens()
	local shift_300 = v6.Color.Shift.Shift_300

	local v7 = React.useCallback(function(p3, p4)
		local participantIds = getParticipantIds(p3, p4)
		return tonumber(({
			primary = participantIds[1] or "",
			secondary = participantIds[2]
		}).primary) or 0
	end, {})
	local v8 = React.useCallback(function(p3, p4)
		local participantIds = getParticipantIds(p3, p4)
		return tonumber(({
			primary = participantIds[1] or "",
			secondary = participantIds[2]
		}).secondary) or 0
	end, {})
	local v9 = React.useCallback(function(p3, p4): boolean
		local participantIds = getParticipantIds(p3, p4)
		return ({
			primary = participantIds[1] or "",
			secondary = participantIds[2]
		}).secondary ~= nil
	end, {})
	local v10 = React.useCallback(function(p3, p4): boolean
		for k, v11 in getParticipantIds(p3, p4) do
			local data = v5.GetPresenceByUserId(v11).data(p4)

			if data == nil then
				continue
			end

			local userPresenceType = data.userPresenceType

			if
				userPresenceType == presenceType.InGame
				or userPresenceType == presenceType.InStudio
				or userPresenceType == presenceType.Online
			then
				return true
			end
		end

		return false
	end, {})

	local v11 = SignalsReact.useSignalBinding(function(p3)
		return v7(p2.itemSignal(p3), p3)
	end)

	local v12 = SignalsReact.useSignalBinding(function(p3)
		return v8(p2.itemSignal(p3), p3)
	end)

	local v13 = SignalsReact.useSignalBinding(function(p3)
		return v9(p2.itemSignal(p3), p3)
	end)

	local v14 = SignalsReact.useSignalBinding(function(p3)
		return v10(p2.itemSignal(p3), p3)
	end)

	local mapped = v13:map(function(p3): boolean
		return not p3
	end)

	local v15 = if FFlagAppChatBindingFacePileUserTileParity then useCumulativeBackground(v6.Color.Surface.Surface_0, shift_300) else nil

	local element = React.createElement(image, {
		Image = "component_assets/circle_16",
		Position = UDim2.new(0.8536, v6.Stroke.Thicker, 0.8536, v6.Stroke.Thicker),
		Size = UDim2.new(0.125, 4, 0.125, 4),
		Visible = v14,
		ZIndex = 3,
		imageStyle = v6.Color.System.Success,
		stroke = {
			Thickness = v6.Stroke.Thicker,
			Color = v6.Color.Surface.Surface_100.Color3
		},
		tag = "anchor-center-center radius-circle bg-surface-100",
		testId = "conversation-face-pile-presence"
	})

	if not FFlagAppChatBindingFacePileUserTileParity then
		return React.createElement(
			view,
			{ tag = "position-center-center anchor-center-center size-full" },
			{
				Primary = React.createElement(avatar, {
					backgroundStyle = shift_300,
					includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
					size = avatarSize.Medium,
					testId = "conversation-face-pile-primary",
					userId = v11,
					Visible = mapped
				}),
				Group = React.createElement(
					view,
					{
						tag = "size-full",
						testId = "conversation-face-pile-group",
						Visible = v13
					},
					{
						Primary = React.createElement(avatar, {
							AnchorPoint = Vector2.new(0, 1),
							backplateStyle = v6.Color.Surface.Surface_0,
							backgroundStyle = shift_300,
							Position = UDim2.fromScale(0, 1),
							size = avatarSize.Small,
							testId = "conversation-face-pile-group-primary",
							userId = v11,
							ZIndex = 2
						}),
						Secondary = React.createElement(avatar, {
							AnchorPoint = Vector2.new(1, 0),
							backplateStyle = v6.Color.Surface.Surface_0,
							backgroundStyle = shift_300,
							Position = UDim2.fromScale(1, 0),
							size = avatarSize.Small,
							testId = "conversation-face-pile-group-secondary",
							userId = v12,
							ZIndex = 1
						})
					}
				),
				Presence = element
			}
		)
	end

	local joinBindings = React.joinBindings({ userId = v11, hasSecondary = v13 })
	local mapped2 = joinBindings:map(function(p3)
		return getHeadshotImage(p3.userId, not p3.hasSecondary, FFlagAppChatUseProfileFrameThumbnail)
	end)

	local mapped3 = joinBindings:map(function(p3)
		return getHeadshotImage(p3.userId, p3.hasSecondary)
	end)

	local mapped4 = React.joinBindings({ userId = v12, hasSecondary = v13 }):map(function(p3)
		return getHeadshotImage(p3.userId, p3.hasSecondary)
	end)

	return React.createElement(view, {
		tag = "position-center-center anchor-center-center size-full"
	}, {
		Primary = React.createElement(
			view,
			{
				tag = "size-full",
				testId = "conversation-face-pile-primary",
				Visible = mapped
			},
			{
				Image = React.createElement(image, {
					backgroundStyle = shift_300,
					Image = mapped2,
					tag = "position-center-center anchor-center-center size-full aspect-1-1 radius-circle",
					testId = "conversation-face-pile-primary--image"
				})
			}
		),
		Group = React.createElement(
			view,
			{
				tag = "size-full",
				testId = "conversation-face-pile-group",
				Visible = v13
			},
			{
				Primary = React.createElement(image, {
					backgroundStyle = v15,
					Image = mapped3,
					Size = UDim2.fromScale(0.7, 0.7),
					tag = "position-bottom-left anchor-bottom-left aspect-1-1 radius-circle",
					testId = "conversation-face-pile-group-primary--image",
					ZIndex = 2
				}),
				Secondary = React.createElement(image, {
					backgroundStyle = v15,
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
