local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local SocialCommon = require(parent.SocialCommon)
local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum
local PresenceTypes = SocialCommon.Enums.PresenceTypes
local Enums = require(SocialCarousel.Common.Enums)
local MarqueePlayStatus = Enums.MarqueePlayStatus

local FFlagFriendsCarouselProfileFrameEnabled = require(SocialCarousel.Flags.FFlagFriendsCarouselProfileFrameEnabled)
local FFlagSocialCarouselShowPlusBadge = require(SocialCarousel.Flags.FFlagSocialCarouselShowPlusBadge)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselInGameTitleMarquee = SharedFlags.FFlagSocialCarouselInGameTitleMarquee
local SharedFlags2 = require(parent.SharedFlags)
local FFlagShowRequestsInCarouselForAllUsers = SharedFlags2.FFlagShowRequestsInCarouselForAllUsers
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSocialCarouselBuildPresence = SharedFlags3.FFlagSocialCarouselBuildPresence
local MarqueeText

if FFlagSocialCarouselInGameTitleMarquee then
	MarqueeText = require(SocialCarousel.Components.MarqueeText.MarqueeText)
else
	MarqueeText = nil
end

local function UserTileMarqueeListener(data): nil
	local tileRef = data.tileRef
	local onManualMarqueeStart = data.onManualMarqueeStart
	local onManualMarqueeEnd = data.onManualMarqueeEnd
	local friendId = data.friendId
	local marqueeOnFocusEnabled = data.marqueeOnFocusEnabled

	React.useEffect(function()
		local guiObject

		if tileRef ~= nil then
			guiObject = tileRef.current
		end

		if guiObject == nil or not guiObject:IsA("GuiObject") then
			return
		end

		if not guiObject:IsA("GuiButton") then
			for _, button in guiObject:GetDescendants() do
				if button:IsA("GuiButton") then
					guiObject = button
					break
				end
			end
		end

		local mouseEnterConnection = guiObject.MouseEnter:Connect(function()
			onManualMarqueeStart(friendId)
		end)
		local mouseLeaveConnection = guiObject.MouseLeave:Connect(function()
			if onManualMarqueeEnd then
				onManualMarqueeEnd(friendId)
			end
		end)
		local selectionGainedConnection, selectionLostConnection

		if marqueeOnFocusEnabled then
			local GuiService = game:GetService("GuiService")

			if GuiService.SelectedCoreObject == guiObject then
				onManualMarqueeStart(friendId)
			end

			selectionGainedConnection = guiObject.SelectionGained:Connect(function()
				onManualMarqueeStart(friendId)
			end)
			selectionLostConnection = guiObject.SelectionLost:Connect(function()
				if onManualMarqueeEnd then
					onManualMarqueeEnd(friendId)
				end
			end)
		else
			selectionGainedConnection = nil
			selectionLostConnection = nil
		end

		return function()
			mouseEnterConnection:Disconnect()
			mouseLeaveConnection:Disconnect()

			if selectionGainedConnection then
				selectionGainedConnection:Disconnect()
			end

			if selectionLostConnection then
				selectionLostConnection:Disconnect()
			end

			if onManualMarqueeEnd then
				onManualMarqueeEnd(friendId)
			end
		end
	end, { tileRef, onManualMarqueeStart, onManualMarqueeEnd, friendId, marqueeOnFocusEnabled })
	return nil
end

local function UserTile3(props)
	local v = useTokens()
	local userPresenceType

	if props.item.presence == nil then
		userPresenceType = Foundation.Enums.UserPresence.None
	else
		userPresenceType = Foundation.Enums.UserPresence[convertToFoundationPresenceEnum(props.item.presence.userPresenceType)]
	end

	local subtitle = props.contextualText

	if FFlagSocialCarouselInGameTitleMarquee then
		local presence = props.item.presence
		local lastLocation

		if presence and presence.userPresenceType == PresenceTypes.InGame then
			lastLocation = presence.lastLocation
		end

		if lastLocation ~= nil and lastLocation ~= "" and props.contextualText == lastLocation and MarqueeText then
			local onMarqueeFinished = props.onMarqueeFinished
			subtitle = React.createElement(MarqueeText, {
				text = lastLocation,
				playStatus = props.playStatus or MarqueePlayStatus.Idle,
				fontStyle = v.Typography.LabelSmall,
				LayoutOrder = 2,
				maxLoops = onMarqueeFinished ~= nil and 1 or nil,
				runId = props.marqueeRunId,
				holdForNextLoop = onMarqueeFinished ~= nil,
				requiresOverflow = props.onManualMarqueeStart ~= nil,
				onFinished = onMarqueeFinished ~= nil and function()
					onMarqueeFinished(props.item.id)
				end or nil
			})
		end
	end

	local createElement = React.createElement
	local v2 = {
		tag = "auto-none",
		Size = props.itemSize,
		LayoutOrder = props.index,
		ref = props.tileRef,
		selection = props.selectionOrder and {
			SelectionOrder = props.selectionOrder,
			Selectable = true
		} or nil
	}
	local marqueeListener

	if FFlagSocialCarouselInGameTitleMarquee and props.onManualMarqueeStart ~= nil then
		marqueeListener = React.createElement(UserTileMarqueeListener, {
			tileRef = props.tileRef,
			friendId = props.item.id,
			onManualMarqueeStart = props.onManualMarqueeStart,
			onManualMarqueeEnd = props.onManualMarqueeEnd,
			marqueeOnFocusEnabled = props.marqueeOnFocusEnabled
		})
	end

	local createElement2 = React.createElement
	local v3 = {
		layoutMode = LayoutMode.compact,
		userId = props.item.id,
		title = props.name,
		subtitle = subtitle,
		titleStyle = v.Typography.TitleSmall,
		subtitleStyle = v.Typography.LabelSmall,
		contextualInfo = 0,
		contextualInfoIcon = 0,
		contextualInfoStyle = 0,
		userPresenceType = 0,
		onActivated = 0,
		titleIcon = 0,
		overlayIcon = 0,
		includeProfileFrame = 0,
		isRobloxSubscriber = 0
	}
	local contextualInfo

	if FFlagSocialCarouselBuildPresence then
		contextualInfo = props.contextualInfo
	end

	v3.contextualInfo = contextualInfo
	local contextualInfoIcon

	if FFlagSocialCarouselBuildPresence then
		contextualInfoIcon = props.contextualInfoIcon
	end

	v3.contextualInfoIcon = contextualInfoIcon
	local contextualInfoStyle

	if FFlagSocialCarouselBuildPresence then
		contextualInfoStyle = v.Typography.LabelSmall
	end

	v3.contextualInfoStyle = contextualInfoStyle
	v3.userPresenceType = userPresenceType
	v3.onActivated = props.onActivated
	v3.titleIcon = props.titleIcon
	local overlayIcon

	if FFlagShowRequestsInCarouselForAllUsers then
		overlayIcon = props.overlayIcon
	end

	v3.overlayIcon = overlayIcon
	v3.includeProfileFrame = FFlagFriendsCarouselProfileFrameEnabled
	local isRobloxSubscriber

	if FFlagSocialCarouselShowPlusBadge then
		isRobloxSubscriber = props.isRobloxSubscriber
	end

	v3.isRobloxSubscriber = isRobloxSubscriber
	return createElement(View, v2, {
		MarqueeListener = marqueeListener,
		Content = createElement2(userTile, v3)
	})
end

return UserTile3
