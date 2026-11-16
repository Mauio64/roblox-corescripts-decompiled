local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local ApolloClient = require(VirtualEvents.Parent.ApolloClient)
require(VirtualEvents.Parent.GraphQLServer)
local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local FocusNavigationUtils = require(VirtualEvents.Parent.FocusNavigationUtils)
local RobloxAppHooks = require(VirtualEvents.Parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(VirtualEvents.Parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local FormFactor = require(VirtualEvents.Parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor
local RoactUtils = require(VirtualEvents.Parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local getEventTimerStatus = require(VirtualEvents.Common.getEventTimerStatus)
local findFirstImageInMedia = require(VirtualEvents.Common.findFirstImageInMedia)
local fetchEventThumbnail = require(VirtualEvents.Common.fetchEventThumbnail)
local EventDetailsContainer = require(VirtualEvents.Components.EventDetailsContainer)
local useCTAProps = require(VirtualEvents.Hooks.useCTAProps)
local useAnimation = require(VirtualEvents.Hooks.useAnimation)

local requests = require(VirtualEvents.requests)
require(VirtualEvents.Parent.VirtualEventsState)
local constants = require(VirtualEvents.constants)

local useMutation = ApolloClient.useMutation

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local LoadableImage = UIBlox.App.Loading.LoadableImage
local withStyle = UIBlox.Core.Style.withStyle

local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local iconsnavigationclose_small = Images["icons/navigation/close_small"]

local function fn() end

local v = { onClose = fn, onJoinEvent = fn, onShare = fn }

local function EventDetailsVerticalPage(data)
	local joined = Cryo.Dictionary.join(v, data)

	local v2 = useRoactService(RoactNetworking)

	local isWideMode = useSelector(function(p)
		return p.FormFactor
	end) == formFactor.WIDE

	local media = data.virtualEvent.media

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(nil)
	local v3

	if media then
		v3 = findFirstImageInMedia(media)
	else
		v3 = nil
	end

	React.useEffect(function()
		local flag = true
		fetchEventThumbnail(v2, data.virtualEvent.id, v3):andThen(function(p)
			if flag then
				setState3(p)
			end
		end)
		return function()
			flag = false
		end
	end, { data.virtualEvent.id, v3 })

	local v4 = React.useCallback(function(p)
		local v4 = math.min(constants.HORIZONTAL_ASPECT_RATIO * p.AbsoluteSize.X, p.AbsoluteSize.Y)

		if v4 ~= state then
			setState(v4)
		end

		local v5 = p.AbsoluteSize.Y - v4 + 40

		if v5 ~= state2 then
			setState2(v5)
		end
	end, { state, state2 })

	local v5 = useMutation(requests.UPDATE_RSVP_STATUS, {
		variables = { virtualEventId = data.virtualEvent.id },
		update = function(_, object, p)
			local virtualEvent = p.data.virtualEventRsvp.virtualEvent

			object:modify({
				id = object:identify(virtualEvent),
				fields = {
					rsvpCounters = function(_, p2)
						local v5 = virtualEvent.userRsvpStatus == "going" and 1 or -1
						return Cryo.Dictionary.join(p2, {
							going = p2.going + v5
						})
					end
				}
			})
		end
	})

	local eventStatus = React.useMemo(function()
		return getEventTimerStatus(joined.virtualEvent, joined.currentTime)
	end, { joined.virtualEvent, joined.currentTime })

	local onRsvpChanged = React.useCallback(function()
		local rsvpStatus = joined.virtualEvent.userRsvpStatus == "going" and "notGoing" or "going"

		v5[1]({
			variables = { rsvpStatus = rsvpStatus }
		}):andThen(function(p)
			if joined.onRsvpChanged then
				joined.onRsvpChanged(
					p.data.virtualEventRsvp.virtualEvent.userRsvpStatus,
					p.data.virtualEventRsvp.shouldSeeNotificationsUpsellModal
				)
			end
		end)
	end, { joined.virtualEvent })

	local ctaProps = useCTAProps(joined.virtualEvent, eventStatus, data.notifyMeUseEmphasisVariant, {
		onClose = joined.onClose,
		onJoinEvent = joined.onJoinEvent,
		onRsvpChanged = onRsvpChanged,
		onShare = joined.onShare
	})

	local state4, setState4 = React.useState(constants.CONTAINER_WIDTH)
	useAnimation({
		startOffset = state4,
		endOffset = 0,
		duration = 0.1,
		easingStyle = "linear",
		setAnimationOffset = setState4
	})

	return withStyle(function(p)
		local createElement = React.createElement
		local v6 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

		local createElement2 = React.createElement
		local v7 = {
			ZIndex = 3,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(48, 48),
			Position = 0
		}
		local position

		if isWideMode then
			position = UDim2.new(1, -64, 0, 16)
		else
			position = UDim2.fromOffset(16, 16)
		end

		v7.Position = position
		local element = createElement("Frame", v6, {
			CloseButtonContainer = createElement2("Frame", v7, {
				CloseButton = React.createElement(UtilityActionIcon, {
					ZIndex = 1,
					onActivated = data.onClose,
					onMedia = true
				}),
				CloseIcon = React.createElement(ImageSetLabel, {
					ZIndex = 2,
					Size = UDim2.fromOffset(24, 24),
					Image = iconsnavigationclose_small,
					ImageColor3 = p.Theme.IconEmphasis.Color,
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(12, 12)
				})
			}),
			MediaContainer = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					[React.Change.AbsoluteSize] = v4,
					ZIndex = 1
				},
				{
					Thumbnail = React.createElement(LoadableImage, {
						Position = UDim2.fromScale(0, 0),
						Size = UDim2.new(1, 0, 0, state),
						BackgroundTransparency = 1,
						ScaleType = Enum.ScaleType.Crop,
						Image = state3,
						useShimmerAnimationWhileLoading = true,
						showFailedStateWhenLoadingFailed = true
					})
				}
			),
			EventContainer = React.createElement(
				"Frame",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2 },
				{
					EventDetailsContainer = React.createElement(EventDetailsContainer, {
						virtualEvent = data.virtualEvent,
						eventStatus = eventStatus,
						isWideMode = isWideMode,
						ctaProps = ctaProps,
						bottomHeight = state2,
						onExperienceTileActivated = data.onExperienceTileActivated
					})
				}
			)
		})

		local createElement3 = React.createElement
		local onClosesByActivated = {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Active = true,
			AutoButtonColor = false,
			[React.Event.Activated] = data.onClose
		}

		local createElement4 = React.createElement
		local v8 = {
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			isIsolated = true,
			frameProps = 0
		}

		local frameProps = {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, state4, 0, 0),
			Size = 0,
			BackgroundTransparency = 0,
			BackgroundColor3 = 0,
			BorderSizePixel = 0
		}
		local size

		if isWideMode then
			size = UDim2.new(0, constants.CONTAINER_WIDTH, 1, 0)
		else
			size = UDim2.fromScale(1, 1)
		end

		frameProps.Size = size
		frameProps.BackgroundTransparency = p.Theme.BackgroundDefault.Transparency
		frameProps.BackgroundColor3 = p.Theme.BackgroundDefault.Color
		v8.frameProps = frameProps
		return createElement3("ImageButton", onClosesByActivated, {
			EventDetailsWindow = createElement4(FocusNavigableSurfaceWrapper, v8, {
				EventDetailsWrapper = React.createElement("ScrollingFrame", {
					ScrollingDirection = Enum.ScrollingDirection.Y,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0, 0),
					ScrollBarThickness = 0,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					Selectable = false
				}, { EventDetailsVerticalPage = element })
			})
		})
	end)
end

return EventDetailsVerticalPage
