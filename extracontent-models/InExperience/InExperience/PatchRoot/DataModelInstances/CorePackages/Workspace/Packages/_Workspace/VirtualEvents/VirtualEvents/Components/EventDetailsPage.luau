local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local ApolloClient = require(VirtualEvents.Parent.ApolloClient)
require(VirtualEvents.Parent.GraphQLServer)
local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local RobloxAppHooks = require(VirtualEvents.Parent.RobloxAppHooks)
local useDeviceType = RobloxAppHooks.useDeviceType
require(VirtualEvents.Parent.RobloxAppEnums)
local RobloxAppHooks2 = require(VirtualEvents.Parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks2.useRoactService
local RoactServiceTags = require(VirtualEvents.Parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local Responsive = require(VirtualEvents.Parent.Responsive)
local ReactFocusNavigation = require(VirtualEvents.Parent.ReactFocusNavigation)
local AppBlox = require(VirtualEvents.Parent.AppBlox)
local useCloseWithBackButton = AppBlox.useCloseWithBackButton

local getEventTimerStatus = require(VirtualEvents.Common.getEventTimerStatus)
local getGalleryItems = require(VirtualEvents.Common.getGalleryItems)
local fetchEventThumbnailList = require(VirtualEvents.Common.fetchEventThumbnailList)
local fetchEventThumbnail = require(VirtualEvents.Common.fetchEventThumbnail)
local useActionBarProps = require(VirtualEvents.Hooks.useActionBarProps)
local EventTimer = require(VirtualEvents.Components.EventTimer)
local EventDescription = require(VirtualEvents.Components.EventDescription)
local EventHostedBy = require(VirtualEvents.Components.EventHostedBy)
local Attendance = require(VirtualEvents.Components.Attendance)
local requests = require(VirtualEvents.requests)
require(VirtualEvents.Parent.VirtualEventsState)

local FFlagLuaAppLimitEventThumbnailToOne = require(VirtualEvents.Flags.FFlagLuaAppLimitEventThumbnailToOne)

local useMutation = ApolloClient.useMutation

local AppBlox2 = require(VirtualEvents.Parent.AppBlox)
local DetailsPageTemplate = AppBlox2.DetailsPageTemplate
local ContentPosition = AppBlox2.ContentPosition
local MediaGalleryPreview = AppBlox2.MediaGalleryPreview
local calcMediaGallerySizesFromWidth = AppBlox2.calcMediaGallerySizesFromWidth
local ListTable = UIBlox.App.Table.ListTable
local function fn() end

local v = { onClose = fn, onJoinEvent = fn, onShare = fn }

local function EventDetailsPage(p)
	local joined = Cryo.Dictionary.join(v, p)

	local media = p.virtualEvent.media
	local experienceDetails = p.virtualEvent.experienceDetails

	local state, setState = React.useState(0)

	local deviceType = useDeviceType()

	local state2, setState2 = React.useState({})
	local imageId

	if state2[1] then
		imageId = state2[1].imageId
	end

	local v2 = useRoactService(RoactNetworking)

	React.useEffect(function()
		if FFlagLuaAppLimitEventThumbnailToOne then
			fetchEventThumbnail(v2, p.virtualEvent.id):andThen(function(imageId2)
				local v3 = {}

				if imageId2 then
					table.insert(v3, { imageId = imageId2, isYouTubeVideo = false })
				end

				if #v3 > 0 then
					setState2(v3)
				else
					setState2(getGalleryItems(media))
				end
			end, function()
				setState2(getGalleryItems(media))
			end)
		else
			fetchEventThumbnailList(v2, p.virtualEvent.id):andThen(function(items)
				local v3 = {}

				if items then
					for _, item in items do
						if item.mediaId then
							table.insert(v3, {
								imageId = "rbxassetid://" .. item.mediaId,
								isYouTubeVideo = false
							})
						end
					end
				end

				if #v3 > 0 then
					setState2(v3)
				else
					setState2(getGalleryItems(media))
				end
			end, function()
				setState2(getGalleryItems(media))
			end)
		end
	end, { p.virtualEvent.id, media })

	local v3 = useMutation(requests.UPDATE_RSVP_STATUS, {
		variables = { virtualEventId = p.virtualEvent.id },
		update = function(_, object, p2)
			local virtualEvent = p2.data.virtualEventRsvp.virtualEvent

			object:modify({
				id = object:identify(virtualEvent),
				fields = {
					rsvpCounters = function(_, p3)
						local v3 = virtualEvent.userRsvpStatus == "going" and 1 or -1
						return Cryo.Dictionary.join(p3, {
							going = p3.going + v3
						})
					end
				}
			})
		end
	})

	local v4 = React.useMemo(function()
		return getEventTimerStatus(joined.virtualEvent, joined.currentTime)
	end, { joined.virtualEvent, joined.currentTime })

	local v5 = React.useCallback(function(p2)
		local offset = calcMediaGallerySizesFromWidth(p2.AbsoluteSize.X, 5).contentSize.Y.Offset

		if offset ~= state then
			setState(offset)
		end
	end, { state })

	local onRsvpChanged = React.useCallback(function()
		local rsvpStatus = joined.virtualEvent.userRsvpStatus == "going" and "notGoing" or "going"

		v3[1]({
			variables = { rsvpStatus = rsvpStatus }
		}):andThen(function(p2)
			if joined.onRsvpChanged then
				joined.onRsvpChanged(
					p2.data.virtualEventRsvp.virtualEvent.userRsvpStatus,
					p2.data.virtualEventRsvp.shouldSeeNotificationsUpsellModal
				)
			end
		end)
	end, { joined.virtualEvent })

	local ref = React.useRef(nil)
	ref.current = Responsive.usePreferredInput()

	local disableStickyActionBar = ref.current == Responsive.Input.Directional

	local v6, v7 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
	local containerRef = useCloseWithBackButton(v7, p.onClose)

	local v8 = ReactFocusNavigation.useFocusGuiObject()

	local state3, setState3 = React.useState(nil)

	local v9 = React.useCallback(function(p2)
		setState3(p2)

		if typeof(v6) == "function" then
			v6(p2)
		end
	end, { v6 })

	React.useEffect(function()
		if state3 and ref.current == Responsive.Input.Directional then
			v8(state3)
		end
	end, { state3, v8 })

	local v10 = useActionBarProps(
		joined.virtualEvent,
		v4,
		{
			onClose = joined.onClose,
			onJoinEvent = joined.onJoinEvent,
			onShare = joined.onShare,
			onRsvpChanged = onRsvpChanged
		},
		v9
	)

	local v11 = React.useMemo(function()
		return v10.button or #v10.icons > 0
	end, { v10 })

	local v12 = {
		Attendance = v4 ~= "Elapsed" and {
			portraitLayoutOrder = 1,
			landscapePosition = ContentPosition.Left,
			landscapeLayoutOrder = 1,
			renderComponent = function()
				return React.createElement(Attendance, {
					virtualEvent = joined.virtualEvent,
					eventStatus = v4
				})
			end
		} or nil,
		MediaGallery = {
			portraitLayoutOrder = 2,
			landscapePosition = ContentPosition.Right,
			landscapeLayoutOrder = 1,
			renderComponent = function()
				return React.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, state),
						BackgroundTransparency = 1,
						[React.Change.AbsoluteSize] = v5
					},
					{
						Gallery = React.createElement(MediaGalleryPreview, {
							items = state2,
							numberOfThumbnails = 5
						})
					}
				)
			end
		},
		Description = {
			portraitLayoutOrder = 3,
			landscapePosition = ContentPosition.Left,
			landscapeLayoutOrder = 2,
			renderComponent = function()
				local createElement = React.createElement
				local v12 = {
					description = joined.virtualEvent.description,
					experienceName = 0,
					experienceThumbnail = 0,
					onExperienceTileActivated = 0
				}
				local experienceName

				if experienceDetails then
					experienceName = experienceDetails.name
				end

				v12.experienceName = experienceName
				v12.experienceThumbnail = ("rbxthumb://type=GameIcon&id=%s&w=150&h=150"):format(joined.virtualEvent.universeId)
				v12.onExperienceTileActivated = joined.onExperienceTileActivated
				return createElement(EventDescription, v12)
			end
		},
		EventInfo = joined.virtualEvent.host and {
			portraitLayoutOrder = 4,
			landscapePosition = ContentPosition.Right,
			landscapeLayoutOrder = 2,
			renderComponent = function()
				return React.createElement(ListTable, {
					cells = { React.createElement(EventHostedBy, {
							host = joined.virtualEvent.host,
							onActivated = joined.onHostActivated
						}) }
				})
			end
		} or nil
	}

	local createElement = React.createElement
	local v13 = {
		deviceType = deviceType,
		titleText = p.virtualEvent.eventStatus == "moderated" and "[CONTENT MODERATED]" or joined.virtualEvent.title,
		thumbnailImageUrl = imageId,
		thumbnailAspectRatio = Vector2.new(16, 9),
		renderInfoContent = function()
			return React.createElement(EventTimer, {
				virtualEvent = joined.virtualEvent,
				status = v4,
				currentTime = joined.currentTime
			})
		end,
		actionBarProps = 0,
		componentList = 0,
		onClose = 0,
		disableStickyActionBar = 0,
		containerRef = 0
	}
	local actionBarProps

	if v11 then
		actionBarProps = v10
	end

	v13.actionBarProps = actionBarProps
	v13.componentList = (p.virtualEvent.eventStatus == "cancelled" or p.virtualEvent.eventStatus == "moderated")
		and {}
		or v12
	v13.onClose = joined.onClose
	v13.disableStickyActionBar = disableStickyActionBar
	v13.containerRef = containerRef
	return createElement(DetailsPageTemplate, v13)
end

return EventDetailsPage
