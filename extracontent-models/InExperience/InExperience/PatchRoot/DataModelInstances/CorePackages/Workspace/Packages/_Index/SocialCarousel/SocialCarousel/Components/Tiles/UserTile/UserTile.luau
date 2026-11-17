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
local IconButton = Foundation.IconButton
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
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
local FFlagSocialCarouselXSmallTileText = require(SocialCarousel.Flags.FFlagSocialCarouselXSmallTileText)
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSocialCarouselInGamePlayIcon = SharedFlags4.FFlagSocialCarouselInGamePlayIcon
local useXSmallTileTypography = require(SocialCarousel.Hooks.useXSmallTileTypography)
local MarqueeScrollContext = require(SocialCarousel.Stores.MarqueeSession.MarqueeScrollContext)
local marqueeScrollContext = MarqueeScrollContext.MarqueeScrollContext
local MarqueeText

if FFlagSocialCarouselInGameTitleMarquee then
	MarqueeText = require(SocialCarousel.Components.MarqueeText.MarqueeText)
else
	MarqueeText = nil
end

local function UserTileMarqueeListener(data): nil
	local tileRef = data.tileRef
	local buttonRef = data.buttonRef
	local onManualMarqueeStart = data.onManualMarqueeStart
	local onManualMarqueeEnd = data.onManualMarqueeEnd
	local friendId = data.friendId
	local marqueeOnFocusEnabled = data.marqueeOnFocusEnabled

	React.useEffect(function()
		local current

		if tileRef == nil then
			current = nil
		else
			current = tileRef.current
		end

		if current == nil or not current:IsA("GuiObject") then
			return
		end

		current:SetAttribute(Enums.MarqueeFriendIdAttribute, friendId)
		local v

		if FFlagSocialCarouselInGamePlayIcon and buttonRef ~= nil then
			v = buttonRef.current
		end

		if v == nil then
			if current:IsA("GuiButton") then
				v = current
			else
				v = current

				for _, button in current:GetDescendants() do
					if button:IsA("GuiButton") then
						v = button
						break
					end
				end
			end
		end

		local mouseEnterConnection = v.MouseEnter:Connect(function()
			onManualMarqueeStart(friendId)
		end)
		local mouseLeaveConnection = v.MouseLeave:Connect(function()
			if onManualMarqueeEnd then
				onManualMarqueeEnd(friendId)
			end
		end)
		local selectionGainedConnection, selectionLostConnection

		if marqueeOnFocusEnabled then
			local GuiService = game:GetService("GuiService")

			if GuiService.SelectedCoreObject == v then
				onManualMarqueeStart(friendId)
			end

			selectionGainedConnection = v.SelectionGained:Connect(function()
				onManualMarqueeStart(friendId)
			end)
			selectionLostConnection = v.SelectionLost:Connect(function()
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

local function UserTile3(props)
	local v = useTokens()
	local v2

	if FFlagSocialCarouselXSmallTileText then
		v2 = useXSmallTileTypography()
	end

	local ref

	if FFlagSocialCarouselInGamePlayIcon then
		ref = React.useRef(nil)
	end

	local userPresenceType

	if props.item.presence == nil then
		userPresenceType = Foundation.Enums.UserPresence.None
	else
		userPresenceType = Foundation.Enums.UserPresence[convertToFoundationPresenceEnum(props.item.presence.userPresenceType)]
	end

	local subtitle = props.contextualText

	if FFlagSocialCarouselInGameTitleMarquee then
		local v3 = React.useContext(marqueeScrollContext)
		React.useEffect(function()
			if v3 ~= nil and props.playStatus == MarqueePlayStatus.Idle then
				v3.clearCurrentScroll(props.item.id)
			end
		end, { v3, props.playStatus, props.item.id })
		local presence = props.item.presence
		local lastLocation

		if presence and presence.userPresenceType == PresenceTypes.InGame then
			lastLocation = presence.lastLocation
		end

		if
			lastLocation ~= nil
			and lastLocation ~= ""
			and props.contextualText == lastLocation
			and props.playStatus ~= nil
			and MarqueeText
		then
			local onMarqueeFinished = props.onMarqueeFinished
			local playStatus

			if props.playStatus == nil then
				playStatus = MarqueePlayStatus.Idle
			else
				playStatus = props.playStatus
			end

			local id = props.item.id
			local v4 = playStatus ~= MarqueePlayStatus.Idle
			local createElement = React.createElement
			local fontStyle

			if v2 then
				fontStyle = v2.label
			else
				fontStyle = v.Typography.LabelSmall
			end

			local v5 = {
				text = lastLocation,
				playStatus = playStatus,
				fontStyle = fontStyle,
				LayoutOrder = 2,
				maxLoops = onMarqueeFinished ~= nil and 1 or nil,
				runId = props.marqueeRunId,
				holdForNextLoop = onMarqueeFinished ~= nil,
				marqueeShortTitlesEnabled = props.marqueeShortTitlesEnabled == true,
				initialOffset = 0,
				saveOffset = 0,
				onFinished = 0
			}
			local initialOffset

			if not (v3 == nil or not v4) then
				initialOffset = v3.initialOffsetFor(id)
			end

			v5.initialOffset = initialOffset
			v5.saveOffset = v3 ~= nil and v4 and function(p: number)
				v3.saveOffset(id, p)
			end or nil

			v5.onFinished = (v3 ~= nil or onMarqueeFinished ~= nil) and function()
				if v3 ~= nil then
					v3.clearCurrentScroll(id)
				end

				if onMarqueeFinished ~= nil then
					onMarqueeFinished(id)
				end
			end or nil
			subtitle = createElement(MarqueeText, v5)
		end
	end

	local createElement = React.createElement
	local v3 = {
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
			buttonRef = ref,
			friendId = props.item.id,
			onManualMarqueeStart = props.onManualMarqueeStart,
			onManualMarqueeEnd = props.onManualMarqueeEnd,
			marqueeOnFocusEnabled = props.marqueeOnFocusEnabled
		})
	end

	local createElement2 = React.createElement
	local v4 = {
		layoutMode = LayoutMode.compact,
		userId = props.item.id,
		title = props.name,
		subtitle = subtitle,
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

	local titleStyle = if v2 then v2.title else v.Typography.TitleSmall
	v4.titleStyle = titleStyle
	local subtitleStyle

	if v2 then
		subtitleStyle = v2.label
	else
		subtitleStyle = v.Typography.LabelSmall
	end

	v4.subtitleStyle = subtitleStyle
	local contextualInfo

	if FFlagSocialCarouselBuildPresence then
		contextualInfo = props.contextualInfo
	end

	v4.contextualInfo = contextualInfo
	local contextualInfoIcon

	if FFlagSocialCarouselBuildPresence then
		contextualInfoIcon = props.contextualInfoIcon
	end

	v4.contextualInfoIcon = contextualInfoIcon
	local contextualInfoStyle

	if FFlagSocialCarouselBuildPresence then
		if v2 then
			contextualInfoStyle = v2.label
		else
			contextualInfoStyle = v.Typography.LabelSmall
		end
	end

	v4.contextualInfoStyle = contextualInfoStyle

	v4.userPresenceType = userPresenceType
	v4.onActivated = props.onActivated
	v4.titleIcon = props.titleIcon
	local overlayIcon

	if FFlagShowRequestsInCarouselForAllUsers then
		overlayIcon = props.overlayIcon
	end

	v4.overlayIcon = overlayIcon
	v4.includeProfileFrame = FFlagFriendsCarouselProfileFrameEnabled
	local isRobloxSubscriber

	if FFlagSocialCarouselShowPlusBadge then
		isRobloxSubscriber = props.isRobloxSubscriber
	end

	v4.isRobloxSubscriber = isRobloxSubscriber
	v4.buttonRef = ref
	local v5 = {
		MarqueeListener = marqueeListener,
		Content = createElement2(userTile, v4),
		TextTapTarget = 0,
		AvatarTapTarget = 0,
		PlayIconOverlay = 0
	}
	local textTapTarget

	if FFlagSocialCarouselInGamePlayIcon and props.onTextActivated then
		textTapTarget = React.createElement(View, {
			tag = "size-full-full",
			ZIndex = 2,
			onActivated = props.onTextActivated,
			testId = `--social-social-carousel-view-tile-text-{props.item.id}`,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			selection = { Selectable = false }
		})
	end

	v5.TextTapTarget = textTapTarget
	local avatarTapTarget

	if FFlagSocialCarouselInGamePlayIcon and props.onTextActivated then
		avatarTapTarget = React.createElement(View, {
			tag = "size-full-full aspect-1-1",
			ZIndex = 3,
			onActivated = props.onActivated,
			testId = `--social-social-carousel-view-tile-avatar-{props.item.id}`,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			selection = { Selectable = false }
		})
	end

	v5.AvatarTapTarget = avatarTapTarget
	local playIconOverlay

	if FFlagSocialCarouselInGamePlayIcon and props.showPlayIcon then
		playIconOverlay = React.createElement(View, {
			tag = "size-full-full aspect-1-1",
			ZIndex = 4
		}, {
			PlayIconBackplate = React.createElement(View, {
				tag = "anchor-center-center size-800-800 radius-circle bg-surface-0",
				Position = UDim2.new(0.5, 0, 1, -v.Gap.Small)
			}, {
				PlayIcon = React.createElement(IconButton, {
					icon = "play-large",
					variant = ButtonVariant.Standard,
					size = InputSize.XSmall,
					isCircular = true,
					onActivated = props.onPlayIconActivated or props.onActivated,
					testId = `--social-social-carousel-iconbutton-play-{props.item.id}`,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Selectable = false
				})
			})
		})
	end

	v5.PlayIconOverlay = playIconOverlay
	return createElement(View, v3, v5)
end

return UserTile3
