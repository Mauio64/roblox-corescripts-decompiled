local ApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ApolloClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/FocusNavigationUtils")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactServiceTags").RoactNetworking
local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/FormFactor").Enums.FormFactor
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactUtils").Hooks.RoactRodux.useSelector

local getEventTimerStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getEventTimerStatus")
local findFirstImageInMedia = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/findFirstImageInMedia")
local fetchEventThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/fetchEventThumbnail")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventDetailsContainer")
local useCTAProps = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Hooks/useCTAProps")
local useAnimation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Hooks/useAnimation")

local requests = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/requests")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/constants")

local useMutation = ApolloClient.useMutation

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local utilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local loadableImage = UIBlox.App.Loading.LoadableImage
local withStyle = UIBlox.Core.Style.withStyle

local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local iconsnavigationclose_small = images["icons/navigation/close_small"]

local function fn() end

local v5 = { onClose = fn, onJoinEvent = fn, onShare = fn }

local function EventDetailsVerticalPage(data)
	local joined = Cryo.Dictionary.join(v5, data)

	local v6 = useRoactService(roactNetworking)

	local v7 = useSelector(function(p2)
		return p2.FormFactor
	end) == formFactor.WIDE

	local media = data.virtualEvent.media

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(nil)
	local v8 = if media then findFirstImageInMedia(media) else nil

	React.useEffect(function()
		local flag = true
		fetchEventThumbnail(v6, data.virtualEvent.id, v8):andThen(function(p2)
			if flag then
				setState3(p2)
			end
		end)
		return function()
			flag = false
		end
	end, { data.virtualEvent.id, v8 })

	local v9 = React.useCallback(function(p2)
		local v10 = math.min(constants.HORIZONTAL_ASPECT_RATIO * p2.AbsoluteSize.X, p2.AbsoluteSize.Y)

		if v10 ~= state then
			setState(v10)
		end

		local v11 = p2.AbsoluteSize.Y - v10 + 40

		if v11 ~= state2 then
			setState2(v11)
		end
	end, { state, state2 })

	local v10 = useMutation(requests.UPDATE_RSVP_STATUS, {
		variables = { virtualEventId = data.virtualEvent.id },
		update = function(p2, object, p3)
			local virtualEvent = p3.data.virtualEventRsvp.virtualEvent

			object:modify({
				id = object:identify(virtualEvent),
				fields = {
					rsvpCounters = function(p4, p5)
						local v11 = virtualEvent.userRsvpStatus == "going" and 1 or -1
						return Cryo.Dictionary.join(p5, {
							going = p5.going + v11
						})
					end
				}
			})
		end
	})

	local v11 = React.useMemo(function()
		return getEventTimerStatus(joined.virtualEvent, joined.currentTime)
	end, { joined.virtualEvent, joined.currentTime })

	local v12 = React.useCallback(function()
		local v13 = joined.virtualEvent.userRsvpStatus == "going" and "notGoing" or "going"

		v10[1]({
			variables = { rsvpStatus = v13 }
		}):andThen(function(p2)
			if joined.onRsvpChanged then
				joined.onRsvpChanged(
					p2.data.virtualEventRsvp.virtualEvent.userRsvpStatus,
					p2.data.virtualEventRsvp.shouldSeeNotificationsUpsellModal
				)
			end
		end)
	end, { joined.virtualEvent })

	local v13 = useCTAProps(joined.virtualEvent, v11, data.notifyMeUseEmphasisVariant, {
		onClose = joined.onClose,
		onJoinEvent = joined.onJoinEvent,
		onRsvpChanged = v12,
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

	return withStyle(function(p2)
		local createElement = React.createElement
		local v15 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

		local createElement2 = React.createElement
		local v17 = {
			ZIndex = 3,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(48, 48),
			Position = 0
		}

		local v18 = if v7 then UDim2.new(1, -64, 0, 16) else UDim2.fromOffset(16, 16)
		v17.Position = v18
		local element = createElement("Frame", v15, {
			CloseButtonContainer = createElement2("Frame", v17, {
				CloseButton = React.createElement(utilityActionIcon, {
					ZIndex = 1,
					onActivated = data.onClose,
					onMedia = true
				}),
				CloseIcon = React.createElement(imageSetLabel, {
					ZIndex = 2,
					Size = UDim2.fromOffset(24, 24),
					Image = iconsnavigationclose_small,
					ImageColor3 = p2.Theme.IconEmphasis.Color,
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(12, 12)
				})
			}),
			MediaContainer = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					[React.Change.AbsoluteSize] = v9,
					ZIndex = 1
				},
				{
					Thumbnail = React.createElement(loadableImage, {
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
					EventDetailsContainer = React.createElement(module9, {
						virtualEvent = data.virtualEvent,
						eventStatus = v11,
						isWideMode = v7,
						ctaProps = v13,
						bottomHeight = state2,
						onExperienceTileActivated = data.onExperienceTileActivated
					})
				}
			)
		})

		local createElement4 = React.createElement
		local onClosesByActivated = {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Active = true,
			AutoButtonColor = false,
			[React.Event.Activated] = data.onClose
		}

		local createElement5 = React.createElement
		local v23 = {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			isIsolated = true,
			frameProps = 0
		}

		local v24 = {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, state4, 0, 0),
			Size = 0,
			BackgroundTransparency = 0,
			BackgroundColor3 = 0,
			BorderSizePixel = 0
		}
		local v25 = if v7 then UDim2.new(0, constants.CONTAINER_WIDTH, 1, 0) else UDim2.fromScale(1, 1)
		v24.Size = v25
		v24.BackgroundTransparency = p2.Theme.BackgroundDefault.Transparency
		v24.BackgroundColor3 = p2.Theme.BackgroundDefault.Color
		v23.frameProps = v24
		return createElement4("ImageButton", onClosesByActivated, {
			EventDetailsWindow = createElement5(focusNavigableSurfaceWrapper, v23, {
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
