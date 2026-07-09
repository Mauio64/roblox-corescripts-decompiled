local TextService = game:GetService("TextService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local useScreenSize = require(ParentParentParent.CoreScriptsRoactCommon).useScreenSize
local useRoactService = require(ParentParentParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(ParentParentParent.RoactServiceTags).RoactNetworking
local NotificationModalsManager = require(ParentParentParent.NotificationModalsManager)
local GameTile = require(ParentParentParent.GameTile)
local MouseIconOverrideService = require(ParentParentParent.CoreScriptsCommon).MouseIconOverrideService
local useDesignTokens = require(ParentParentParent.Style).useDesignTokens
local constants = require(ParentParent.constants)
local postRsvpStatus = require(ParentParent.Common.postRsvpStatus)
local formatDateLocalized = require(ParentParent.Common.formatDateLocalized)
local ServiceOverrideContext = require(ParentParent.Components.CoreUI.ServiceOverrideContext)
local useContext = React.useContext
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local LoadableImage = UIBlox.App.Loading.LoadableImage
local useLocalization = Localization.Hooks.useLocalization
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local GameTileThumbnailBadges = GameTile.GameTileThumbnailBadges
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local v30 = game:DefineFastFlag("LuaAppFixRsvpPromptDescriptionScrolling", false)

return function(t1: {[any]: any}) -- line: 74
	-- upvalues: useScreenSize (copy), useLocalization (copy), React (copy), MouseIconOverrideService (copy), constants (copy), useRoactService (copy), RoactNetworking (copy), formatDateLocalized (copy), useContext (copy), ServiceOverrideContext (copy), postRsvpStatus (copy), NotificationModalsManager (copy), ButtonType (copy), useDesignTokens (copy), useTokens (copy), v30 (copy), TextService (copy), LoadableImage (copy), GameTileThumbnailBadges (copy), ScrollView (copy), ScrollBarVisibility (copy), FoundationText (copy), View (copy), InteractiveAlert (copy)
	local v32 = useScreenSize()
	local v33 = t1.enableInputDelayed == nil or t1.enableInputDelayed
	local v34 = useLocalization({
		joinEvent = "Feature.VirtualEvents.JoinEvent",
		notifyMe = "Feature.VirtualEvents.NotifyMe",
		unfollowEvent = "Feature.VirtualEvents.UnfollowEvent",
		notNowButton = "Feature.VirtualEvents.NotNowButton",
		dateAtTime = "Feature.VirtualEvents.Label.DateAtTime",
		toastText = "Feature.VirtualEvents.Label.ReminderSetForEventTime"
	})

	React.useEffect(function() -- line: 88
		-- upvalues: MouseIconOverrideService (copy)
		MouseIconOverrideService.push("RSVPPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)

		return function() -- line: 91
			-- upvalues: MouseIconOverrideService (copy)
			MouseIconOverrideService.pop("RSVPPromptOverride")
		end
	end, {})

	local eventDetails = t1.promptData.eventDetails
	local displayTitle = eventDetails.displayTitle
	local displayDescription = eventDetails.displayDescription
	local thumbnails = eventDetails.thumbnails
	local DEFAULT_EVENT_MEDIA_ID = constants.DEFAULT_EVENT_MEDIA_ID

	if thumbnails and (thumbnails[1] and thumbnails[1].mediaId) then
		DEFAULT_EVENT_MEDIA_ID = thumbnails[1].mediaId
	end

	local v40 = useRoactService(RoactNetworking)
	local v41 = eventDetails.userRsvpStatus == "going"
	local None = Enum.RsvpStatus.None

	if eventDetails.userRsvpStatus == "going" then
		None = Enum.RsvpStatus.Going
	elseif eventDetails.userRsvpStatus == "notGoing" then
		None = Enum.RsvpStatus.NotGoing
	end

	local notifyMe = v34.notifyMe

	if v41 then
		notifyMe = v34.unfollowEvent
	end

	local dateTime = nil
	local u45 = nil

	if eventDetails.eventTime and eventDetails.eventTime.startUtc then
		dateTime = DateTime.fromIsoDate(eventDetails.eventTime.startUtc)

		if dateTime then
			u45 = formatDateLocalized(v34.dateAtTime, dateTime)
		end
	end

	local joinEvent = v34.joinEvent

	if v41 then
		joinEvent = v34.unfollowEvent
	end

	local socialService = useContext(ServiceOverrideContext).socialService
	local v48 = React.useCallback(function() -- line: 142
		-- upvalues: v41 (copy), postRsvpStatus (copy), v40 (copy), t1 (copy), socialService (copy), None (ref), v34 (copy), displayTitle (copy), u45 (ref), NotificationModalsManager (copy)
		if v41 then
			postRsvpStatus(v40, t1.promptData.eventId, "notGoing"):andThen(function() -- line: 144
				-- upvalues: socialService (copy), t1 (copy), None (ref)
				socialService:PromptRsvpToEventCompleted(t1.promptData.eventId, true, Enum.RsvpStatus.NotGoing, None)
			end, function(p1) -- line: 151
				-- upvalues: socialService (copy), t1 (copy), None (ref)
				socialService:PromptRsvpToEventCompleted(t1.promptData.eventId, false, Enum.RsvpStatus.None, None)
				warn("Error updating rsvp status: ", p1)
			end)
		else
			postRsvpStatus(v40, t1.promptData.eventId, "going"):andThen(function() -- line: 161
				-- upvalues: socialService (copy), t1 (copy), None (ref), v34 (copy), displayTitle (copy), u45 (ref), NotificationModalsManager (copy)
				socialService:PromptRsvpToEventCompleted(t1.promptData.eventId, true, Enum.RsvpStatus.Going, None)

				local v82 = v34.toastText:gsub("{(.-)}", {
					eventName = displayTitle,
					eventTime = u45
				})

				NotificationModalsManager.SetUIBloxToast({
					toastTitle = v82,
					sequenceNumber = DateTime.now().UnixTimestamp
				})
			end, function(p2) -- line: 178
				-- upvalues: socialService (copy), t1 (copy), None (ref)
				socialService:PromptRsvpToEventCompleted(t1.promptData.eventId, false, Enum.RsvpStatus.None, None)
				warn("Error updating rsvp status: ", p2)
			end)
		end

		t1.closePrompt()
	end, {
		socialService,
		t1.closePrompt,
		v41
	})
	local v49 = React.useCallback(function() -- line: 191
		-- upvalues: eventDetails (copy), socialService (copy), t1 (copy), None (ref)
		local None2 = Enum.RsvpStatus.None

		if eventDetails.userRsvpStatus == "notGoing" then
			None2 = Enum.RsvpStatus.NotGoing
		elseif eventDetails.userRsvpStatus == "going" then
			None2 = Enum.RsvpStatus.Going
		end

		socialService:PromptRsvpToEventCompleted(t1.promptData.eventId, true, None2, None)
		t1.closePrompt()
	end, {
		socialService,
		t1.closePrompt,
		eventDetails.userRsvpStatus
	})
	local v50 = React.useMemo(function() -- line: 203
		-- upvalues: ButtonType (copy), v33 (copy), v48 (copy), notifyMe (ref)
		return {
			buttons = {{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					delayInputSeconds = 2,
					enableInputDelayed = v33,
					isDelayedInput = v33,
					onActivated = v48,
					text = notifyMe
				}
			}}
		}
	end, {
		v34,
		v48,
		v33,
		notifyMe
	})
	local v51, v52 = React.useState(Vector2.new(0, 0))
	local v53 = React.useCallback(function(p3) -- line: 222
		-- upvalues: v52 (copy)
		v52(p3.AbsoluteSize)
	end, { v52 })
	local v54, v55 = React.useState(0)
	local v56, v57 = React.useState(0)
	local v58 = React.useRef(nil)
	local v59 = React.useRef(nil)
	local v60 = React.useCallback(function(p4) -- line: 232
		-- upvalues: v55 (copy)
		local v69 = math.ceil(p4.TextBounds.Y)

		if v69 > 0 then
			v55(function(p5) -- line: 235
				-- upvalues: v69 (copy)
				if p5 ~= v69 then
					return v69
				end

				return p5
			end)
		end
	end, { v55 })
	local Size_300 = useDesignTokens().Size.Size_300
	local v62 = useTokens()
	local BodyLarge = v62.Typography.BodyLarge
	local v64 = t1.overrideUseWideMode or v32.Y < 600 and v32.X > v32.Y

	React.useEffect(function() -- line: 255
		-- upvalues: v30 (copy), v55 (copy)
		if v30 then
			v55(0)
		end
	end, {
		v64,
		displayDescription
	})
	React.useEffect(function() -- line: 261
		-- upvalues: v30 (copy), v59 (copy), v57 (copy), v58 (copy), displayDescription (copy), TextService (copy), v55 (copy)
		if v30 then
			if v59.current then
				v57(v59.current.AbsoluteSize.Y)
			end

			return
		end

		if not v58.current then
			return
		end

		local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

		GetTextBoundsParams.Text = displayDescription
		GetTextBoundsParams.Font = v58.current.FontFace
		GetTextBoundsParams.Size = v58.current.TextSize
		GetTextBoundsParams.Width = v58.current.AbsoluteSize.X

		local TextBoundsAsync = TextService:GetTextBoundsAsync(GetTextBoundsParams)

		v55(TextBoundsAsync.Y * v58.current.LineHeight)

		if v59.current then
			v57(v59.current.AbsoluteSize.Y)
		end
	end, {
		v58,
		v51.X,
		displayDescription,
		v64
	})

	local v65 = React.useCallback(function() -- line: 288
		-- upvalues: v32 (copy), v64 (copy), v51 (copy), constants (copy), v30 (copy), v56 (copy), Size_300 (copy), v54 (copy), React (copy), LoadableImage (copy), DEFAULT_EVENT_MEDIA_ID (ref), dateTime (ref), GameTileThumbnailBadges (copy), u45 (ref), displayDescription (copy), BodyLarge (copy), v62 (copy), v60 (copy), v58 (copy), ScrollView (copy), ScrollBarVisibility (copy), FoundationText (copy), View (copy), v53 (copy), displayTitle (copy), v59 (copy)
		local v72 = v32.Y - 80 - 200

		if v72 < 80 then
			v72 = 80
		end

		if v64 then
			local v73 = v51.X * 0.6

			if v72 > v73 * 1 / constants.THUMBNAIL_ASPECT_RATIO then
				v72 = v73 * 1 / constants.THUMBNAIL_ASPECT_RATIO
			end

			if v30 then
				v72 = math.max(v72 - v56 - Size_300, 80)
			end
		end

		local v74 = if not v30 or v54 ~= 0 then v54 else 80
		local v75 = math.min(v74, v72)

		if not v64 then
			if v30 then
				v72 = math.max(v72 - v56 - Size_300 * 2, 80)
			end

			v75 = if not v30 then math.min(v54, v72 * 0.4) else math.min(v74, v72 * 0.4)
			v72 -= v75
		end

		local uDim2 = UDim2.new(1, 0, 0, v72)

		if v64 then
			uDim2 = UDim2.new(0.6, 0, 0, v72)
		end

		local v77 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = if not v64 then Enum.AutomaticSize.Y else Enum.AutomaticSize.X,
			Size = uDim2
		}, {
			Thumbnail = React.createElement(LoadableImage, {
				BackgroundTransparency = 1,
				useShimmerAnimationWhileLoading = true,
				showFailedStateWhenLoadingFailed = true,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				Image = "rbxassetid://" .. DEFAULT_EVENT_MEDIA_ID,
				cornerRadius = UDim.new(0, 8)
			}),
			AspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = constants.THUMBNAIL_ASPECT_RATIO,
				DominantAxis = Enum.DominantAxis.Width,
				AspectType = Enum.AspectType.FitWithinMaxSize
			}),
			Overlay = if not dateTime then nil else React.createElement("Frame", {
				ZIndex = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Badge = React.createElement(GameTileThumbnailBadges, {
					tileBadgesByPosition = {
						ImageTopLeft = {{
							tileBadgeType = "Text",
							text = u45
						}}
					}
				})
			})
		})
		local uDim2_2 = UDim2.new(1, 0, 0, v75)

		if v64 then
			uDim2_2 = if not v30 then UDim2.new(0.4, 0, 0, v75) else UDim2.new(0.4, -Size_300, 0, v75)
		end

		local v80

		if v30 then
			local v79 = not (v54 > 0) and 10000 or v54

			v80 = React.createElement("ScrollingFrame", {
				LayoutOrder = 3,
				ScrollBarThickness = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Size = uDim2_2,
				CanvasSize = UDim2.new(0, 0, 0, v79 + 2),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}, {
				Body = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, v79),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = displayDescription,
					TextTruncate = Enum.TextTruncate.None,
					TextWrapped = true,
					FontFace = Font.fromEnum(BodyLarge.Font),
					TextSize = BodyLarge.FontSize,
					LineHeight = BodyLarge.LineHeight,
					TextColor3 = v62.Color.Content.Emphasis.Color3,
					TextTransparency = v62.Color.Content.Emphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.TextBounds] = v60,
					ref = v58
				})
			})
		else
			v80 = React.createElement(ScrollView, {
				tag = "col align-y-top",
				LayoutOrder = 3,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(1, 0),
					scrollBarVisibility = ScrollBarVisibility.Auto,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
				},
				Size = uDim2_2
			}, {
				Body = React.createElement(FoundationText, {
					tag = "size-full-0 text-body-large text-align-y-top text-align-x-left",
					TextWrapped = true,
					Text = displayDescription,
					Size = UDim2.new(1, 0, 0, v54),
					padding = Vector2.new(0, 0),
					ref = v58
				})
			})
		end

		if v64 then
			return React.createElement(View, {
				tag = "col align-x-center size-full-0 auto-y gap-medium",
				Size = UDim2.new(1, 0, 0, 0),
				onAbsoluteSizeChanged = v53
			}, {
				Title = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-title-large text-align-x-left",
					LayoutOrder = 1,
					Text = displayTitle,
					ref = v59
				}),
				Contents = React.createElement(View, {
					LayoutOrder = 2,
					tag = {
						["row align-y-top gap-medium size-full-0"] = v30,
						["row align-y-center gap-medium size-full-0"] = not v30
					},
					Size = UDim2.new(1, 0, 0, v72)
				}, {
					ThumbnailFrame = v77,
					BodyScrollView = v80
				})
			})
		end

		return React.createElement(View, {
			tag = "col align-x-center size-full-0 auto-y gap-medium",
			Size = UDim2.new(1, 0, 0, 0),
			onAbsoluteSizeChanged = v53
		}, {
			ThumbnailFrame = v77,
			Title = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-title-large text-align-x-left",
				LayoutOrder = 2,
				Text = displayTitle,
				ref = v59
			}),
			BodyScrollView = v80
		})
	end, {
		DEFAULT_EVENT_MEDIA_ID,
		displayTitle,
		displayDescription,
		dateTime,
		u45,
		v51,
		v54,
		v53,
		v32,
		Size_300,
		v56,
		v62,
		BodyLarge,
		v60,
		v64,
		t1.overrideUseWideMode
	})

	return React.createElement(InteractiveAlert, {
		isMiddleContentFocusable = false,
		onCloseClicked = v49,
		buttonStackInfo = v50,
		middleContent = v65,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = v32,
		title = joinEvent
	})
end
