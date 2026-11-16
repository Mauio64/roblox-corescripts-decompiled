local TextService = game:GetService("TextService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local React = require(parent2.React)
local UIBlox = require(parent2.UIBlox)
local CoreScriptsRoactCommon = require(parent2.CoreScriptsRoactCommon)
local useScreenSize = CoreScriptsRoactCommon.useScreenSize
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent2.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local NotificationModalsManager = require(parent2.NotificationModalsManager)
local GameTile = require(parent2.GameTile)
local CoreScriptsCommon = require(parent2.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService

local Style = require(parent2.Style)
local useDesignTokens = Style.useDesignTokens

local constants = require(parent.constants)

local postRsvpStatus = require(parent.Common.postRsvpStatus)
local formatDateLocalized = require(parent.Common.formatDateLocalized)

local ServiceOverrideContext = require(parent.Components.CoreUI.ServiceOverrideContext)

local useContext = React.useContext

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local LoadableImage = UIBlox.App.Loading.LoadableImage
local useLocalization = Localization.Hooks.useLocalization

local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local getTextBoundsAsync = Foundation.Utility.getTextBoundsAsync
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local GameTileThumbnailBadges = GameTile.GameTileThumbnailBadges

local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local defineFastFlag = game:DefineFastFlag("LuaAppFixRsvpPromptDescriptionScrolling", false)

return function(props)
	local screenSize = useScreenSize()

	local v = props.enableInputDelayed == nil or props.enableInputDelayed

	local v2 = useLocalization({
		joinEvent = "Feature.VirtualEvents.JoinEvent",
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		notNowButton = "Feature.VirtualEvents.NotNowButton",
		dateAtTime = "Feature.VirtualEvents.Label.DateAtTime",
		toastText = "Feature.VirtualEvents.Label.ReminderSetForEventTime"
	})

	React.useEffect(function()
		MouseIconOverrideService.push("RSVPPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)

		return function()
			MouseIconOverrideService.pop("RSVPPromptOverride")
		end
	end, {})

	local eventDetails = props.promptData.eventDetails

	local displayTitle = eventDetails.displayTitle
	local displayDescription = eventDetails.displayDescription

	local thumbnails = eventDetails.thumbnails

	local v3 = constants.DEFAULT_EVENT_MEDIA_ID

	if thumbnails and thumbnails[1] and thumbnails[1].mediaId then
		v3 = thumbnails[1].mediaId
	end

	local v4 = useRoactService(RoactNetworking)

	local v5 = eventDetails.userRsvpStatus == "going"

	local v6 = Enum.RsvpStatus.None

	if eventDetails.userRsvpStatus == "going" then
		v6 = Enum.RsvpStatus.Going
	elseif eventDetails.userRsvpStatus == "notGoing" then
		v6 = Enum.RsvpStatus.NotGoing
	end

	local text = v2.notifyMe

	if v5 then
		text = v2.unfollowEvent
	end

	local v7 = nil
	local dateTime

	if eventDetails.eventTime and eventDetails.eventTime.startUtc then
		dateTime = DateTime.fromIsoDate(eventDetails.eventTime.startUtc)

		if dateTime then
			v7 = formatDateLocalized(v2.dateAtTime, dateTime)
		end
	else
		dateTime = nil
	end

	local title = v2.joinEvent

	if v5 then
		title = v2.unfollowEvent
	end

	local socialService = useContext(ServiceOverrideContext).socialService

	local onActivated = React.useCallback(function()
		if v5 then
			postRsvpStatus(v4, props.promptData.eventId, "notGoing"):andThen(function()
				socialService:PromptRsvpToEventCompleted(props.promptData.eventId, true, Enum.RsvpStatus.NotGoing, v6)
			end, function(p)
				socialService:PromptRsvpToEventCompleted(props.promptData.eventId, false, Enum.RsvpStatus.None, v6)

				warn("Error updating rsvp status: ", p)
			end)
		else
			postRsvpStatus(v4, props.promptData.eventId, "going"):andThen(function()
				socialService:PromptRsvpToEventCompleted(props.promptData.eventId, true, Enum.RsvpStatus.Going, v6)

				local toastTitle = v2.toastText:gsub("{(.-)}", {
					eventName = displayTitle,
					eventTime = v7
				})

				NotificationModalsManager.SetUIBloxToast({
					toastTitle = toastTitle,
					sequenceNumber = DateTime.now().UnixTimestamp
				})
			end, function(p)
				socialService:PromptRsvpToEventCompleted(props.promptData.eventId, false, Enum.RsvpStatus.None, v6)

				warn("Error updating rsvp status: ", p)
			end)
		end

		props.closePrompt()
	end, { socialService, props.closePrompt, v5 })

	local onCloseClicked = React.useCallback(function()
		local v8 = Enum.RsvpStatus.None

		if eventDetails.userRsvpStatus == "notGoing" then
			v8 = Enum.RsvpStatus.NotGoing
		elseif eventDetails.userRsvpStatus == "going" then
			v8 = Enum.RsvpStatus.Going
		end

		socialService:PromptRsvpToEventCompleted(props.promptData.eventId, true, v8, v6)
		props.closePrompt()
	end, { socialService, props.closePrompt, eventDetails.userRsvpStatus })

	local buttonStackInfo = React.useMemo(function()
		return {
			buttons = {
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						delayInputSeconds = 2,
						enableInputDelayed = v,
						isDelayedInput = v,
						onActivated = onActivated,
						text = text
					}
				}
			}
		}
	end, { v2, onActivated, v, text })

	local state, setState = React.useState(Vector2.new(0, 0))

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize)
	end, { setState })

	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(0)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v8 = React.useCallback(function(p)
		local y = math.ceil(p.TextBounds.Y)

		if y > 0 then
			setState2(function(p2)
				return if y == p2 then p2 else y
			end)
		end
	end, { setState2 })

	local size_300 = useDesignTokens().Size.Size_300

	local v9 = useTokens()
	local bodyLarge = v9.Typography.BodyLarge

	local v10 = props.overrideUseWideMode

	if not v10 then
		if screenSize.Y < 600 then
			v10 = screenSize.X > screenSize.Y
		else
			v10 = false
		end
	end

	React.useEffect(function()
		if defineFastFlag then
			setState2(0)
		end
	end, { v10, displayDescription })

	React.useEffect(function()
		if defineFastFlag then
			if ref2.current then
				setState3(ref2.current.AbsoluteSize.Y)
			end
		elseif FoundationFontFaceMigration then
			local current = ref.current

			if not current then
				return
			end

			local v11 = false
			task.spawn(function()
				local textBoundsAsync = getTextBoundsAsync(
					displayDescription,
					current.FontFace,
					current.TextSize,
					current.AbsoluteSize.X
				)

				if v11 or not textBoundsAsync then
					return
				end

				setState2(textBoundsAsync.Y * current.LineHeight)

				if ref2.current then
					setState3(ref2.current.AbsoluteSize.Y)
				end
			end)

			return function()
				v11 = true
			end
		else
			if not ref.current then
				return
			end

			local getTextBoundsParams = Instance.new("GetTextBoundsParams")
			getTextBoundsParams.Text = displayDescription
			getTextBoundsParams.Font = ref.current.FontFace
			getTextBoundsParams.Size = ref.current.TextSize
			getTextBoundsParams.Width = ref.current.AbsoluteSize.X
			setState2(TextService:GetTextBoundsAsync(getTextBoundsParams).Y * ref.current.LineHeight)

			if ref2.current then
				setState3(ref2.current.AbsoluteSize.Y)
			end
		end
	end, { ref, state.X, displayDescription, v10 })

	local middleContent = React.useCallback(function()
		local v11 = screenSize.Y - 80 - 200
		local v12 = v11 < 80 and 80 or v11

		if v10 then
			local v13 = state.X * 0.6

			if v13 * 1 / constants.THUMBNAIL_ASPECT_RATIO < v12 then
				v12 = v13 * 1 / constants.THUMBNAIL_ASPECT_RATIO
			end

			if defineFastFlag then
				v12 = math.max(v12 - state3 - size_300, 80)
			end
		end

		local v13 = defineFastFlag and state2 == 0 and 80 or state2

		local v14 = math.min(v13, v12)

		if not v10 then
			if defineFastFlag then
				v12 = math.max(v12 - state3 - size_300 * 2, 80)
			end

			if defineFastFlag then
				v14 = math.min(v13, v12 * 0.4)
			else
				v14 = math.min(state2, v12 * 0.4)
			end

			v12 -= v14
		end

		local udim = UDim2.new(1, 0, 0, v12)

		if v10 then
			udim = UDim2.new(0.6, 0, 0, v12)
		end

		local createElement = React.createElement
		local automaticSize

		if v10 then
			automaticSize = Enum.AutomaticSize.X
		else
			automaticSize = Enum.AutomaticSize.Y
		end

		local v15 = {
			Thumbnail = React.createElement(LoadableImage, {
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = "rbxassetid://" .. v3,
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
		local overlay

		if dateTime then
			overlay = React.createElement(
				"Frame",
				{ ZIndex = 2, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
				{
					Badge = React.createElement(GameTileThumbnailBadges, {
						tileBadgesByPosition = {
							ImageTopLeft = {
								{ tileBadgeType = "Text", text = v7 }
							}
						}
					})
				}
			)
		end

		v15.Overlay = overlay
		local element = createElement(
			"Frame",
			{
				AutomaticSize = automaticSize,
				Size = udim,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			v15
		)

		local udim2 = UDim2.new(1, 0, 0, v14)

		if v10 then
			if defineFastFlag then
				udim2 = UDim2.new(0.4, -size_300, 0, v14)
			else
				udim2 = UDim2.new(0.4, 0, 0, v14)
			end
		end

		local bodyScrollView

		if defineFastFlag then
			local v16 = not (state2 > 0) and 10000 or state2
			local createElement2 = React.createElement
			local v17 = {
				LayoutOrder = 3,
				Size = udim2,
				CanvasSize = UDim2.new(0, 0, 0, v16 + 2),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollBarThickness = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true
			}

			local createElement3 = React.createElement
			local v18 = {}
			v18.Size = UDim2.new(1, 0, 0, v16)
			v18.BackgroundTransparency = 1
			v18.BorderSizePixel = 0
			v18.Text = displayDescription
			v18.TextTruncate = Enum.TextTruncate.None
			v18.TextWrapped = true
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(bodyLarge.Font)
			else
				fontFace = Font.fromEnum(bodyLarge.Font)
			end

			v18.FontFace = fontFace

			v18.TextSize = bodyLarge.FontSize
			v18.LineHeight = bodyLarge.LineHeight
			v18.TextColor3 = v9.Color.Content.Emphasis.Color3
			v18.TextTransparency = v9.Color.Content.Emphasis.Transparency
			v18.TextXAlignment = Enum.TextXAlignment.Left
			v18.TextYAlignment = Enum.TextYAlignment.Top
			v18[React.Change.TextBounds] = v8
			v18.ref = ref
			bodyScrollView = createElement2("ScrollingFrame", v17, {
				Body = createElement3("TextLabel", v18)
			})
		else
			bodyScrollView = React.createElement(ScrollView, {
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(1, 0),
					scrollBarVisibility = ScrollBarVisibility.Auto,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
				},
				tag = "col align-y-top",
				LayoutOrder = 3,
				Size = udim2
			}, {
				Body = React.createElement(Text, {
					tag = "size-full-0 text-body-large text-align-y-top text-align-x-left",
					Text = displayDescription,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, state2),
					padding = Vector2.new(0, 0),
					ref = ref
				})
			})
		end

		if v10 then
			return React.createElement(
				View,
				{
					Size = UDim2.new(1, 0, 0, 0),
					tag = "col align-x-center size-full-0 auto-y gap-medium",
					onAbsoluteSizeChanged = onAbsoluteSizeChanged
				},
				{
					Title = React.createElement(Text, {
						tag = "size-full-0 auto-y text-title-large text-align-x-left",
						Text = displayTitle,
						LayoutOrder = 1,
						ref = ref2
					}),
					Contents = React.createElement(View, {
						LayoutOrder = 2,
						tag = {
							["row align-y-top gap-medium size-full-0"] = defineFastFlag,
							["row align-y-center gap-medium size-full-0"] = not defineFastFlag
						},
						Size = UDim2.new(1, 0, 0, v12)
					}, { ThumbnailFrame = element, BodyScrollView = bodyScrollView })
				}
			)
		end

		return React.createElement(
			View,
			{
				Size = UDim2.new(1, 0, 0, 0),
				tag = "col align-x-center size-full-0 auto-y gap-medium",
				onAbsoluteSizeChanged = onAbsoluteSizeChanged
			},
			{
				ThumbnailFrame = element,
				Title = React.createElement(Text, {
					tag = "size-full-0 auto-y text-title-large text-align-x-left",
					Text = displayTitle,
					LayoutOrder = 2,
					ref = ref2
				}),
				BodyScrollView = bodyScrollView
			}
		)
	end, {
		v3,
		displayTitle,
		displayDescription,
		dateTime,
		v7,
		state,
		state2,
		onAbsoluteSizeChanged,
		screenSize,
		size_300,
		state3,
		v9,
		bodyLarge,
		v8,
		v10,
		props.overrideUseWideMode
	})

	return React.createElement(InteractiveAlert, {
		onCloseClicked = onCloseClicked,
		buttonStackInfo = buttonStackInfo,
		isMiddleContentFocusable = false,
		middleContent = middleContent,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = screenSize,
		title = title
	})
end
