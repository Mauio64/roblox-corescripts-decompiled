local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local ApolloClient = require(VirtualEvents.Parent.ApolloClient)

require(VirtualEvents.Parent.GraphQLServer)

local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local FocusNavigationUtils = require(VirtualEvents.Parent.FocusNavigationUtils)
local useRoactService = require(VirtualEvents.Parent.RobloxAppHooks).useRoactService
local RoactNetworking = require(VirtualEvents.Parent.RoactServiceTags).RoactNetworking
local FormFactor = require(VirtualEvents.Parent.FormFactor).Enums.FormFactor
local useSelector = require(VirtualEvents.Parent.RoactUtils).Hooks.RoactRodux.useSelector
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
local v27 = Images["icons/navigation/close_small"]

local function v28() -- line: 45
end

local t1 = {
	onClose = v28,
	onJoinEvent = v28,
	onShare = v28
}

local function EventDetailsVerticalPage(p1) -- line: 71
	-- upvalues: Cryo (copy), t1 (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), FormFactor (copy), React (copy), findFirstImageInMedia (copy), fetchEventThumbnail (copy), constants (copy), useMutation (copy), requests (copy), getEventTimerStatus (copy), useCTAProps (copy), useAnimation (copy), withStyle (copy), UtilityActionIcon (copy), ImageSetLabel (copy), v27 (copy), LoadableImage (copy), EventDetailsContainer (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v32 = Cryo.Dictionary.join(t1, p1)
	local v33 = useRoactService(RoactNetworking)
	local v34 = useSelector(function(p2) -- line: 76
		return p2.FormFactor
	end) == FormFactor.WIDE
	local media = p1.virtualEvent.media
	local v36, v37 = React.useState(0)
	local v38, v39 = React.useState(0)
	local v40, v41 = React.useState(nil)
	local v42 = if not media then nil else findFirstImageInMedia(media)

	React.useEffect(function() -- line: 88
		-- upvalues: fetchEventThumbnail (copy), v33 (copy), p1 (copy), v42 (copy), v41 (copy)
		local u51 = true

		fetchEventThumbnail(v33, p1.virtualEvent.id, v42):andThen(function(p3) -- line: 90
			-- upvalues: u51 (ref), v41 (copy)
			if u51 then
				v41(p3)
			end
		end)

		return function() -- line: 95
			-- upvalues: u51 (ref)
			u51 = false
		end
	end, {
		p1.virtualEvent.id,
		v42
	})

	local v43 = React.useCallback(function(p4) -- line: 100
		-- upvalues: constants (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy)
		local v53 = math.min(constants.HORIZONTAL_ASPECT_RATIO * p4.AbsoluteSize.X, p4.AbsoluteSize.Y)

		if v53 ~= v36 then
			v37(v53)
		end

		local v54 = p4.AbsoluteSize.Y - v53 + 40

		if v54 ~= v38 then
			v39(v54)
		end
	end, {
		v36,
		v38
	})
	local v44 = useMutation(requests.UPDATE_RSVP_STATUS, {
		variables = {
			virtualEventId = p1.virtualEvent.id
		},
		update = function(_, p6, p7) -- line: 116
			-- upvalues: Cryo (copy)
			local virtualEvent = p7.data.virtualEventRsvp.virtualEvent

			p6:modify({
				id = p6:identify(virtualEvent),
				fields = {
					rsvpCounters = function(_, t2: {[any]: any}) -- line: 122
						-- upvalues: virtualEvent (copy), Cryo (copy)
						local v65 = virtualEvent.userRsvpStatus ~= "going" and -1 or 1

						return Cryo.Dictionary.join(t2, {
							going = t2.going + v65
						})
					end
				}
			})
		end
	})
	local v45 = React.useMemo(function() -- line: 133
		-- upvalues: getEventTimerStatus (copy), v32 (copy)
		return getEventTimerStatus(v32.virtualEvent, v32.currentTime)
	end, {
		v32.virtualEvent,
		v32.currentTime
	})
	local v46 = React.useCallback(function() -- line: 137
		-- upvalues: v32 (copy), v44 (copy)
		local v59 = v32.virtualEvent.userRsvpStatus == "going" and "notGoing" or "going"

		v44[1]({
			variables = {
				rsvpStatus = v59
			}
		}):andThen(function(p9) -- line: 151
			-- upvalues: v32 (copy)
			if v32.onRsvpChanged then
				v32.onRsvpChanged(p9.data.virtualEventRsvp.virtualEvent.userRsvpStatus, p9.data.virtualEventRsvp.shouldSeeNotificationsUpsellModal)
			end
		end)
	end, { v32.virtualEvent })
	local v47 = useCTAProps(v32.virtualEvent, v45, p1.notifyMeUseEmphasisVariant, {
		onClose = v32.onClose,
		onJoinEvent = v32.onJoinEvent,
		onRsvpChanged = v46,
		onShare = v32.onShare
	})
	local v48, v49 = React.useState(constants.CONTAINER_WIDTH)

	useAnimation({
		endOffset = 0,
		duration = 0.1,
		easingStyle = "linear",
		startOffset = v48,
		setAnimationOffset = v49
	})

	return withStyle(function(p10) -- line: 178
		-- upvalues: React (copy), v34 (copy), UtilityActionIcon (copy), p1 (copy), ImageSetLabel (copy), v27 (copy), v43 (copy), LoadableImage (copy), v36 (copy), v40 (copy), EventDetailsContainer (copy), v45 (copy), v47 (copy), v38 (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), v48 (copy), constants (copy)
		local v61 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			CloseButtonContainer = React.createElement("Frame", {
				ZIndex = 3,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(48, 48),
				Position = if not v34 then UDim2.fromOffset(16, 16) else UDim2.new(1, -64, 0, 16)
			}, {
				CloseButton = React.createElement(UtilityActionIcon, {
					ZIndex = 1,
					onMedia = true,
					onActivated = p1.onClose
				}),
				CloseIcon = React.createElement(ImageSetLabel, {
					ZIndex = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(24, 24),
					Image = v27,
					ImageColor3 = p10.Theme.IconEmphasis.Color,
					Position = UDim2.fromOffset(12, 12)
				})
			}),
			MediaContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				[React.Change.AbsoluteSize] = v43,
				ZIndex = 1
			}, {
				Thumbnail = React.createElement(LoadableImage, {
					BackgroundTransparency = 1,
					useShimmerAnimationWhileLoading = true,
					showFailedStateWhenLoadingFailed = true,
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.new(1, 0, 0, v36),
					ScaleType = Enum.ScaleType.Crop,
					Image = v40
				})
			}),
			EventContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				EventDetailsContainer = React.createElement(EventDetailsContainer, {
					virtualEvent = p1.virtualEvent,
					eventStatus = v45,
					isWideMode = v34,
					ctaProps = v47,
					bottomHeight = v38,
					onExperienceTileActivated = p1.onExperienceTileActivated
				})
			})
		})

		return React.createElement("ImageButton", {
			ZIndex = 4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Active = true,
			AutoButtonColor = false,
			[React.Event.Activated] = p1.onClose
		}, {
			EventDetailsWindow = React.createElement(FocusNavigableSurfaceWrapper, {
				isIsolated = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
				frameProps = {
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, v48, 0, 0),
					Size = if not v34 then UDim2.fromScale(1, 1) else UDim2.new(0, constants.CONTAINER_WIDTH, 1, 0),
					BackgroundTransparency = p10.Theme.BackgroundDefault.Transparency,
					BackgroundColor3 = p10.Theme.BackgroundDefault.Color
				}
			}, {
				EventDetailsWrapper = React.createElement("ScrollingFrame", {
					BackgroundTransparency = 1,
					ScrollBarThickness = 0,
					Selectable = false,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0, 0),
					CanvasSize = UDim2.new(1, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y
				}, {
					EventDetailsVerticalPage = v61
				})
			})
		})
	end)
end

return EventDetailsVerticalPage
