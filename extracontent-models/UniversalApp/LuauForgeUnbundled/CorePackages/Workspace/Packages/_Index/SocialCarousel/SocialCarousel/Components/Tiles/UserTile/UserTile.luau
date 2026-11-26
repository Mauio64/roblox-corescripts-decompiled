local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialCommon")
local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/UserTile").LayoutMode
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")

local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local iconButton = Foundation.IconButton
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local convertToFoundationPresenceEnum = SocialCommon.Utils.convertToFoundationPresenceEnum
local presenceTypes = SocialCommon.Enums.PresenceTypes
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums")
local marqueePlayStatus = Enums.MarqueePlayStatus

local FFlagFriendsCarouselProfileFrameEnabled = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagFriendsCarouselProfileFrameEnabled")
local FFlagSocialCarouselShowPlusBadge = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselShowPlusBadge")
local fFlagSocialCarouselInGameTitleMarquee = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGameTitleMarquee
local fFlagShowRequestsInCarouselForAllUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagShowRequestsInCarouselForAllUsers
local fFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselBuildPresence
local FFlagSocialCarouselXSmallTileText = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselXSmallTileText")
local fFlagSocialCarouselInGamePlayIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGamePlayIcon
local useXSmallTileTypography = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Hooks/useXSmallTileTypography")
local marqueeScrollContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Stores/MarqueeSession/MarqueeScrollContext").MarqueeScrollContext

local v5 = if fFlagSocialCarouselInGameTitleMarquee then require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/MarqueeText/MarqueeText") else nil

local function UserTileMarqueeListener(data): nil
	local tileRef = data.tileRef
	local buttonRef = data.buttonRef
	local onManualMarqueeStart = data.onManualMarqueeStart
	local onManualMarqueeEnd = data.onManualMarqueeEnd
	local friendId = data.friendId
	local marqueeOnFocusEnabled = data.marqueeOnFocusEnabled

	React.useEffect(function()
		local current = if tileRef ~= nil then tileRef.current else nil

		if current == nil or not current:IsA("GuiObject") then
			return
		end

		current:SetAttribute(Enums.MarqueeFriendIdAttribute, friendId)
		local v6 = if fFlagSocialCarouselInGamePlayIcon and buttonRef ~= nil then buttonRef.current else nil

		if v6 == nil then
			if current:IsA("GuiButton") then
				v6 = current
			else
				v6 = current

				for i, button in current:GetDescendants() do
					if button:IsA("GuiButton") then
						v6 = button
						break
					end
				end
			end
		end

		local mouseEnterConnection = v6.MouseEnter:Connect(function()
			onManualMarqueeStart(friendId)
		end)
		local mouseLeaveConnection = v6.MouseLeave:Connect(function()
			if onManualMarqueeEnd then
				onManualMarqueeEnd(friendId)
			end
		end)
		local selectionGainedConnection, selectionLostConnection

		if marqueeOnFocusEnabled then
			local GuiService = game:GetService("GuiService")

			if GuiService.SelectedCoreObject == v6 then
				onManualMarqueeStart(friendId)
			end

			selectionGainedConnection = v6.SelectionGained:Connect(function()
				onManualMarqueeStart(friendId)
			end)
			selectionLostConnection = v6.SelectionLost:Connect(function()
				if onManualMarqueeEnd then
					onManualMarqueeEnd(friendId)
				end
			end)
		else
			selectionGainedConnection = nil
			selectionLostConnection = nil
		end

		return function()
			current:SetAttribute(Enums.MarqueeFriendIdAttribute, nil)
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
		buttonRef,
		onManualMarqueeStart,
		onManualMarqueeEnd,
		friendId,
		marqueeOnFocusEnabled
	})
	return nil
end

local function UserTile(props)
	local v6 = useTokens()
	local v7 = if FFlagSocialCarouselXSmallTileText then useXSmallTileTypography() else nil
	local ref = if fFlagSocialCarouselInGamePlayIcon then React.useRef(nil) else nil
	local v8

	if props.item.presence == nil then
		v8 = Foundation.Enums.UserPresence.None
	else
		v8 = Foundation.Enums.UserPresence[convertToFoundationPresenceEnum(props.item.presence.userPresenceType)]
	end

	local v9 = props.contextualText

	if fFlagSocialCarouselInGameTitleMarquee then
		local v10 = React.useContext(marqueeScrollContext)
		React.useEffect(function()
			if v10 ~= nil and props.playStatus == marqueePlayStatus.Idle then
				v10.clearCurrentScroll(props.item.id)
			end
		end, { v10, props.playStatus, props.item.id })
		local presence = props.item.presence
		local lastLocation

		if presence and presence.userPresenceType == presenceTypes.InGame then
			lastLocation = presence.lastLocation
		end

		if
			lastLocation ~= nil
			and lastLocation ~= ""
			and props.contextualText == lastLocation
			and props.playStatus ~= nil
			and v5
		then
			local onMarqueeFinished = props.onMarqueeFinished
			local v11 = if props.playStatus == nil then marqueePlayStatus.Idle else props.playStatus
			local id = props.item.id
			local v12 = v11 ~= marqueePlayStatus.Idle
			local createElement = React.createElement

			local v15 = if v7 then v7.label else v6.Typography.LabelSmall
			local v14 = {
				text = lastLocation,
				playStatus = v11,
				fontStyle = v15,
				LayoutOrder = 2,
				maxLoops = onMarqueeFinished ~= nil and 1 or nil,
				runId = props.marqueeRunId,
				holdForNextLoop = onMarqueeFinished ~= nil,
				marqueeShortTitlesEnabled = props.marqueeShortTitlesEnabled == true,
				initialOffset = 0,
				saveOffset = 0,
				onFinished = 0
			}
			local v16 = if v10 ~= nil and not not v12 then v10.initialOffsetFor(id) else nil
			v14.initialOffset = v16
			v14.saveOffset = v10 ~= nil and v12 and function(p2)
				v10.saveOffset(id, p2)
			end or nil

			v14.onFinished = (v10 ~= nil or onMarqueeFinished ~= nil) and function()
				if v10 ~= nil then
					v10.clearCurrentScroll(id)
				end

				if onMarqueeFinished ~= nil then
					onMarqueeFinished(id)
				end
			end or nil
			v9 = createElement(v5, v14)
		end
	end

	local createElement = React.createElement
	local v11 = {
		tag = "auto-none",
		Size = props.itemSize,
		LayoutOrder = props.index,
		ref = props.tileRef,
		selection = props.selectionOrder and {
			SelectionOrder = props.selectionOrder,
			Selectable = true
		} or nil
	}

	local v13 = if fFlagSocialCarouselInGameTitleMarquee and props.onManualMarqueeStart ~= nil then React.createElement(UserTileMarqueeListener, {
		tileRef = props.tileRef,
		buttonRef = ref,
		friendId = props.item.id,
		onManualMarqueeStart = props.onManualMarqueeStart,
		onManualMarqueeEnd = props.onManualMarqueeEnd,
		marqueeOnFocusEnabled = props.marqueeOnFocusEnabled
	}) else nil

	local createElement2 = React.createElement
	local v15 = {
		layoutMode = layoutMode.compact,
		userId = props.item.id,
		title = props.name,
		subtitle = v9,
		titleStyle = 0,
		subtitleStyle = 0,
		contextualInfo = 0,
		contextualInfoIcon = 0,
		contextualInfoStyle = 0,
		userPresenceType = 0,
		onActivated = 0,
		titleIcon = 0,
		overlayIcon = 0,
		includeProfileFrame = 0,
		isRobloxSubscriber = 0,
		buttonRef = 0
	}

	local v16 = if v7 then v7.title else v6.Typography.TitleSmall
	v15.titleStyle = v16
	local v17 = if v7 then v7.label else v6.Typography.LabelSmall
	v15.subtitleStyle = v17
	local v18 = if fFlagSocialCarouselBuildPresence then props.contextualInfo else nil
	v15.contextualInfo = v18
	local v19 = if fFlagSocialCarouselBuildPresence then props.contextualInfoIcon else nil
	v15.contextualInfoIcon = v19
	local v20

	if fFlagSocialCarouselBuildPresence then
		v20 = if v7 then v7.label else v6.Typography.LabelSmall
	end

	v15.contextualInfoStyle = v20

	v15.userPresenceType = v8
	v15.onActivated = props.onActivated
	v15.titleIcon = props.titleIcon
	local v21 = if fFlagShowRequestsInCarouselForAllUsers then props.overlayIcon else nil
	v15.overlayIcon = v21
	v15.includeProfileFrame = FFlagFriendsCarouselProfileFrameEnabled
	local v22 = if FFlagSocialCarouselShowPlusBadge then props.isRobloxSubscriber else nil
	v15.isRobloxSubscriber = v22
	v15.buttonRef = ref
	local v12 = {
		MarqueeListener = v13,
		Content = createElement2(userTile, v15),
		TextTapTarget = 0,
		AvatarTapTarget = 0,
		PlayIconOverlay = 0
	}

	local v23 = if fFlagSocialCarouselInGamePlayIcon and props.onTextActivated then React.createElement(view, {
		tag = "size-full-full",
		ZIndex = 2,
		onActivated = props.onTextActivated,
		testId = `--social-social-carousel-view-tile-text-{props.item.id}`,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		selection = { Selectable = false }
	}) else nil
	v12.TextTapTarget = v23

	local v24 = if fFlagSocialCarouselInGamePlayIcon and props.onTextActivated then React.createElement(view, {
		tag = "size-full-full aspect-1-1",
		ZIndex = 3,
		onActivated = props.onActivated,
		testId = `--social-social-carousel-view-tile-avatar-{props.item.id}`,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		selection = { Selectable = false }
	}) else nil
	v12.AvatarTapTarget = v24

	local v25 = if fFlagSocialCarouselInGamePlayIcon and props.showPlayIcon then React.createElement(
		view,
		{ tag = "size-full-full aspect-1-1", ZIndex = 4 },
		{
			PlayIconBackplate = React.createElement(view, {
				tag = "anchor-center-center size-800-800 radius-circle bg-surface-0",
				Position = UDim2.new(0.5, 0, 1, -v6.Gap.Small)
			}, {
				PlayIcon = React.createElement(iconButton, {
					icon = "play-large",
					variant = buttonVariant.Standard,
					size = inputSize.XSmall,
					isCircular = true,
					onActivated = props.onPlayIconActivated or props.onActivated,
					testId = `--social-social-carousel-iconbutton-play-{props.item.id}`,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Selectable = false
				})
			})
		}
	) else nil
	v12.PlayIconOverlay = v25
	return createElement(view, v11, v12)
end

return UserTile
