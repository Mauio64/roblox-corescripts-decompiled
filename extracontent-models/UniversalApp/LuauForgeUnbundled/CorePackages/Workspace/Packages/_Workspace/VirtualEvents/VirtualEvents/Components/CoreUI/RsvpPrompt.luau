local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/CoreScriptsRoactCommon").useScreenSize
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactServiceTags").RoactNetworking
local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/NotificationModalsManager")
local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GameTile")
local mouseIconOverrideService = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/CoreScriptsCommon").MouseIconOverrideService

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Style").useDesignTokens

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/constants")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/logger")

local postRsvpStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/postRsvpStatus")
local formatDateLocalized = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/formatDateLocalized")

local ServiceOverrideContext = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/ServiceOverrideContext")

local useContext = React.useContext

local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local loadableImage = UIBlox.App.Loading.LoadableImage
local useLocalization = Localization.Hooks.useLocalization

local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local getTextBoundsAsync = Foundation.Utility.getTextBoundsAsync
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local gameTileThumbnailBadges = GameTile.GameTileThumbnailBadges

local scrollView = Foundation.ScrollView
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local defineFastFlag = game:DefineFastFlag("LuaAppFixRsvpPromptDescriptionScrolling", false)
local fFlagInGameRsvpPushUpsellEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagInGameRsvpPushUpsellEnabled

return function(props)
	local v5 = useScreenSize()

	local v6 = props.enableInputDelayed == nil or props.enableInputDelayed

	local v7 = useLocalization({
		joinEvent = "Feature.VirtualEvents.JoinEvent",
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		notNowButton = "Feature.VirtualEvents.NotNowButton",
		dateAtTime = "Feature.VirtualEvents.Label.DateAtTime",
		toastText = "Feature.VirtualEvents.Label.ReminderSetForEventTime"
	})

	React.useEffect(function()
		mouseIconOverrideService.push("RSVPPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)

		return function()
			mouseIconOverrideService.pop("RSVPPromptOverride")
		end
	end, {})

	local eventDetails = props.promptData.eventDetails

	local displayTitle = eventDetails.displayTitle
	local displayDescription = eventDetails.displayDescription

	local thumbnails = eventDetails.thumbnails

	local v8 = constants.DEFAULT_EVENT_MEDIA_ID

	if thumbnails and thumbnails[1] and thumbnails[1].mediaId then
		v8 = thumbnails[1].mediaId
	end

	local v9 = useRoactService(roactNetworking)

	local v10 = eventDetails.userRsvpStatus == "going"

	local v11 = Enum.RsvpStatus.None

	if eventDetails.userRsvpStatus == "going" then
		v11 = Enum.RsvpStatus.Going
	elseif eventDetails.userRsvpStatus == "notGoing" then
		v11 = Enum.RsvpStatus.NotGoing
	end

	local v12 = v7.notifyMe

	if v10 then
		v12 = v7.unfollowEvent
	end

	local v13 = nil
	local dateTime

	if eventDetails.eventTime and eventDetails.eventTime.startUtc then
		dateTime = DateTime.fromIsoDate(eventDetails.eventTime.startUtc)

		if dateTime then
			v13 = formatDateLocalized(v7.dateAtTime, dateTime)
		end
	else
		dateTime = nil
	end

	local v14 = v7.joinEvent

	if v10 then
		v14 = v7.unfollowEvent
	end

	local socialService = useContext(ServiceOverrideContext).socialService

	local v15 = React.useCallback(function()
		if v10 then
			postRsvpStatus(v9, props.promptData.eventId, "notGoing"):andThen(function()
				socialService:PromptRsvpToEventCompleted(
					props.promptData.eventId,
					true,
					Enum.RsvpStatus.NotGoing,
					v11
				)
			end, function(p2)
				socialService:PromptRsvpToEventCompleted(
					props.promptData.eventId,
					false,
					Enum.RsvpStatus.None,
					v11
				)

				warn("Error updating rsvp status: ", p2)
			end)
		else
			postRsvpStatus(v9, props.promptData.eventId, "going"):andThen(function()
				socialService:PromptRsvpToEventCompleted(
					props.promptData.eventId,
					true,
					Enum.RsvpStatus.Going,
					v11
				)

				local v16 = v7.toastText:gsub("{(.-)}", {
					eventName = displayTitle,
					eventTime = v13
				})

				NotificationModalsManager.SetUIBloxToast({
					toastTitle = v16,
					sequenceNumber = DateTime.now().UnixTimestamp
				})

				if fFlagInGameRsvpPushUpsellEnabled and props.onRsvpGoingSucceeded then
					xpcall(props.onRsvpGoingSucceeded, function(p2)
						logger:warning("Error starting the push upsell: {}", (tostring(p2)))
					end, props.promptData.eventId)
				end
			end, function(p2)
				socialService:PromptRsvpToEventCompleted(
					props.promptData.eventId,
					false,
					Enum.RsvpStatus.None,
					v11
				)

				warn("Error updating rsvp status: ", p2)
			end)
		end

		props.closePrompt()
	end, { socialService, props.closePrompt, v10, props.onRsvpGoingSucceeded })

	local v16 = React.useCallback(function()
		local v17 = Enum.RsvpStatus.None

		if eventDetails.userRsvpStatus == "notGoing" then
			v17 = Enum.RsvpStatus.NotGoing
		elseif eventDetails.userRsvpStatus == "going" then
			v17 = Enum.RsvpStatus.Going
		end

		socialService:PromptRsvpToEventCompleted(props.promptData.eventId, true, v17, v11)
		props.closePrompt()
	end, { socialService, props.closePrompt, eventDetails.userRsvpStatus })

	local v17 = React.useMemo(function()
		return {
			buttons = {
				{
					buttonType = buttonType.PrimaryContextual,
					props = {
						delayInputSeconds = 2,
						enableInputDelayed = v6,
						isDelayedInput = v6,
						onActivated = v15,
						text = v12
					}
				}
			}
		}
	end, { v7, v15, v6, v12 })

	local state, setState = React.useState(Vector2.new(0, 0))

	local v18 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, { setState })

	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(0)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v19 = React.useCallback(function(p2)
		local y = math.ceil(p2.TextBounds.Y)

		if y > 0 then
			setState2(function(p3)
				if y == p3 then
					return p3
				end

				return y
			end)
		end
	end, { setState2 })

	local size_300 = useDesignTokens().Size.Size_300

	local v20 = useTokens()
	local bodyLarge = v20.Typography.BodyLarge

	local v21 = props.overrideUseWideMode

	if not v21 then
		v21 = v5.Y < 600 and v5.X > v5.Y
	end

	React.useEffect(function()
		if defineFastFlag then
			setState2(0)
		end
	end, { v21, displayDescription })

	React.useEffect(function()
		if defineFastFlag then
			if ref2.current then
				setState3(ref2.current.AbsoluteSize.Y)
			end
		else
			local current = ref.current

			if not current then
				return
			end

			local v22 = false
			task.spawn(function()
				local textBoundsAsync = getTextBoundsAsync(
					displayDescription,
					current.FontFace,
					current.TextSize,
					current.AbsoluteSize.X
				)

				if v22 or not textBoundsAsync then
					return
				end

				setState2(textBoundsAsync.Y * current.LineHeight)

				if ref2.current then
					setState3(ref2.current.AbsoluteSize.Y)
				end
			end)

			return function()
				v22 = true
			end
		end
	end, { ref, state.X, displayDescription, v21 })

	local v22 = React.useCallback(function()
		local v23 = v5.Y - 80 - 200
		local v24 = v23 < 80 and 80 or v23

		if v21 then
			local v25 = state.X * 0.6

			if v25 * 1 / constants.THUMBNAIL_ASPECT_RATIO < v24 then
				v24 = v25 * 1 / constants.THUMBNAIL_ASPECT_RATIO
			end

			if defineFastFlag then
				v24 = math.max(v24 - state3 - size_300, 80)
			end
		end

		local v25 = defineFastFlag and state2 == 0 and 80 or state2

		local v26 = math.min(v25, v24)

		if not v21 then
			if defineFastFlag then
				v24 = math.max(v24 - state3 - size_300 * 2, 80)
			end

			v26 = if defineFastFlag then math.min(v25, v24 * 0.4) else math.min(state2, v24 * 0.4)
			v24 -= v26
		end

		local udim = UDim2.new(1, 0, 0, v24)

		if v21 then
			udim = UDim2.new(0.6, 0, 0, v24)
		end

		local createElement = React.createElement
		local v29 = if v21 then Enum.AutomaticSize.X else Enum.AutomaticSize.Y

		local v30 = {
			Thumbnail = React.createElement(loadableImage, {
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = "rbxassetid://" .. v8,
				useShimmerAnimationWhileLoading = true,
				showFailedStateWhenLoadingFailed = true,
				cornerRadius = UDim.new(0, 8)
			}),
			AspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = constants.THUMBNAIL_ASPECT_RATIO,
				DominantAxis = Enum.DominantAxis.Width,
				AspectType = Enum.AspectType.FitWithinMaxSize
			}),
			Overlay = 0
		}

		local v31 = if dateTime then React.createElement(
			"Frame",
			{ ZIndex = 2, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
			{
				Badge = React.createElement(gameTileThumbnailBadges, {
					tileBadgesByPosition = {
						ImageTopLeft = {
							{ tileBadgeType = "Text", text = v13 }
						}
					}
				})
			}
		) else nil
		v30.Overlay = v31
		local element = createElement(
			"Frame",
			{
				AutomaticSize = v29,
				Size = udim,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			v30
		)

		local udim2 = UDim2.new(1, 0, 0, v26)

		if v21 then
			udim2 = if defineFastFlag then UDim2.new(0.4, -size_300, 0, v26) else UDim2.new(0.4, 0, 0, v26)
		end

		local v32

		if defineFastFlag then
			local v33 = not (state2 > 0) and 10000 or state2
			v32 = React.createElement("ScrollingFrame", {
				LayoutOrder = 3,
				Size = udim2,
				CanvasSize = UDim2.new(0, 0, 0, v33 + 2),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollBarThickness = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true
			}, {
				Body = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, v33),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = displayDescription,
					TextTruncate = Enum.TextTruncate.None,
					TextWrapped = true,
					FontFace = normalizeFontFace(bodyLarge.Font),
					TextSize = bodyLarge.FontSize,
					LineHeight = bodyLarge.LineHeight,
					TextColor3 = v20.Color.Content.Emphasis.Color3,
					TextTransparency = v20.Color.Content.Emphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.TextBounds] = v19,
					ref = ref
				})
			})
		else
			v32 = React.createElement(scrollView, {
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(1, 0),
					scrollBarVisibility = scrollBarVisibility.Auto,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
				},
				tag = "col align-y-top",
				LayoutOrder = 3,
				Size = udim2
			}, {
				Body = React.createElement(text, {
					tag = "size-full-0 text-body-large text-align-y-top text-align-x-left",
					Text = displayDescription,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, state2),
					padding = Vector2.new(0, 0),
					ref = ref
				})
			})
		end

		if v21 then
			return React.createElement(
				view,
				{
					Size = UDim2.new(1, 0, 0, 0),
					tag = "col align-x-center size-full-0 auto-y gap-medium",
					onAbsoluteSizeChanged = v18
				},
				{
					Title = React.createElement(text, {
						tag = "size-full-0 auto-y text-title-large text-align-x-left",
						Text = displayTitle,
						LayoutOrder = 1,
						ref = ref2
					}),
					Contents = React.createElement(view, {
						LayoutOrder = 2,
						tag = {
							["row align-y-top gap-medium size-full-0"] = defineFastFlag,
							["row align-y-center gap-medium size-full-0"] = not defineFastFlag
						},
						Size = UDim2.new(1, 0, 0, v24)
					}, { ThumbnailFrame = element, BodyScrollView = v32 })
				}
			)
		end

		return React.createElement(
			view,
			{
				Size = UDim2.new(1, 0, 0, 0),
				tag = "col align-x-center size-full-0 auto-y gap-medium",
				onAbsoluteSizeChanged = v18
			},
			{
				ThumbnailFrame = element,
				Title = React.createElement(text, {
					tag = "size-full-0 auto-y text-title-large text-align-x-left",
					Text = displayTitle,
					LayoutOrder = 2,
					ref = ref2
				}),
				BodyScrollView = v32
			}
		)
	end, {
		v8,
		displayTitle,
		displayDescription,
		dateTime,
		v13,
		state,
		state2,
		v18,
		v5,
		size_300,
		state3,
		v20,
		bodyLarge,
		v19,
		v21,
		props.overrideUseWideMode
	})

	return React.createElement(interactiveAlert, {
		onCloseClicked = v16,
		buttonStackInfo = v17,
		isMiddleContentFocusable = false,
		middleContent = v22,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = v5,
		title = v14
	})
end
