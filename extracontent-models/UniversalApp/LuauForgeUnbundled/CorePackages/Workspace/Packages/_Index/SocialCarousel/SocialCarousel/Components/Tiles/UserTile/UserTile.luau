local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialCommon")
local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/UserTile").LayoutMode
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")

local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum
local presenceTypes = SocialCommon.Enums.PresenceTypes
local marqueePlayStatus = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums").MarqueePlayStatus

local FFlagFriendsCarouselProfileFrameEnabled = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagFriendsCarouselProfileFrameEnabled")
local FFlagSocialCarouselShowPlusBadge = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselShowPlusBadge")
local fFlagSocialCarouselInGameTitleMarquee = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGameTitleMarquee
local fFlagShowRequestsInCarouselForAllUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagShowRequestsInCarouselForAllUsers
local fFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselBuildPresence

local v5 = if fFlagSocialCarouselInGameTitleMarquee then require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/MarqueeText/MarqueeText") else nil

local function UserTileMarqueeListener(data): nil
	local tileRef = data.tileRef
	local onManualMarqueeStart = data.onManualMarqueeStart
	local onManualMarqueeEnd = data.onManualMarqueeEnd
	local friendId = data.friendId
	local marqueeOnFocusEnabled = data.marqueeOnFocusEnabled

	React.useEffect(function()
		local guiObject = if tileRef ~= nil then tileRef.current else nil

		if guiObject == nil or not guiObject:IsA("GuiObject") then
			return
		end

		if not guiObject:IsA("GuiButton") then
			for i, button in guiObject:GetDescendants() do
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
	end, {
		tileRef,
		onManualMarqueeStart,
		onManualMarqueeEnd,
		friendId,
		marqueeOnFocusEnabled
	})
	return nil
end

local function UserTile(props)
	local v6 = useTokens()
	local v7

	if props.item.presence == nil then
		v7 = Foundation.Enums.UserPresence.None
	else
		v7 = Foundation.Enums.UserPresence[convertToFoundationPresenceEnum(props.item.presence.userPresenceType)]
	end

	local v8 = props.contextualText

	if fFlagSocialCarouselInGameTitleMarquee then
		local presence = props.item.presence
		local lastLocation

		if presence and presence.userPresenceType == presenceTypes.InGame then
			lastLocation = presence.lastLocation
		end

		if lastLocation ~= nil and lastLocation ~= "" and props.contextualText == lastLocation and v5 then
			local onMarqueeFinished = props.onMarqueeFinished
			v8 = React.createElement(v5, {
				text = lastLocation,
				playStatus = props.playStatus or marqueePlayStatus.Idle,
				fontStyle = v6.Typography.LabelSmall,
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
	local v10 = {
		tag = "auto-none",
		Size = props.itemSize,
		LayoutOrder = props.index,
		ref = props.tileRef,
		selection = props.selectionOrder and {
			SelectionOrder = props.selectionOrder,
			Selectable = true
		} or nil
	}

	local v12 = if fFlagSocialCarouselInGameTitleMarquee and props.onManualMarqueeStart ~= nil then React.createElement(UserTileMarqueeListener, {
		tileRef = props.tileRef,
		friendId = props.item.id,
		onManualMarqueeStart = props.onManualMarqueeStart,
		onManualMarqueeEnd = props.onManualMarqueeEnd,
		marqueeOnFocusEnabled = props.marqueeOnFocusEnabled
	}) else nil

	local createElement2 = React.createElement
	local v14 = {
		layoutMode = layoutMode.compact,
		userId = props.item.id,
		title = props.name,
		subtitle = v8,
		titleStyle = v6.Typography.TitleSmall,
		subtitleStyle = v6.Typography.LabelSmall,
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
	local v15 = if fFlagSocialCarouselBuildPresence then props.contextualInfo else nil
	v14.contextualInfo = v15
	local v16 = if fFlagSocialCarouselBuildPresence then props.contextualInfoIcon else nil
	v14.contextualInfoIcon = v16
	local v17 = if fFlagSocialCarouselBuildPresence then v6.Typography.LabelSmall else nil
	v14.contextualInfoStyle = v17
	v14.userPresenceType = v7
	v14.onActivated = props.onActivated
	v14.titleIcon = props.titleIcon
	local v18 = if fFlagShowRequestsInCarouselForAllUsers then props.overlayIcon else nil
	v14.overlayIcon = v18
	v14.includeProfileFrame = FFlagFriendsCarouselProfileFrameEnabled
	local v19 = if FFlagSocialCarouselShowPlusBadge then props.isRobloxSubscriber else nil
	v14.isRobloxSubscriber = v19
	return createElement(view, v10, {
		MarqueeListener = v12,
		Content = createElement2(userTile, v14)
	})
end

return UserTile
