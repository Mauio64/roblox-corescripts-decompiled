local ApolloClient = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ApolloClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")
local useDeviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useDeviceType
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppEnums")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactServiceTags").RoactNetworking
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Responsive")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ReactFocusNavigation")
local useCloseWithBackButton = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/AppBlox").useCloseWithBackButton

local getEventTimerStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getEventTimerStatus")
local getGalleryItems = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getGalleryItems")
local fetchEventThumbnailList = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/fetchEventThumbnailList")
local fetchEventThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/fetchEventThumbnail")
local useActionBarProps = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Hooks/useActionBarProps")
local EventTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventTimer")
local EventDescription = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventDescription")
local EventHostedBy = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventHostedBy")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/Attendance")
local requests = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/requests")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")

local FFlagLuaAppLimitEventThumbnailToOne = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Flags/FFlagLuaAppLimitEventThumbnailToOne")

local useMutation = ApolloClient.useMutation

local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/AppBlox")
local detailsPageTemplate = AppBlox.DetailsPageTemplate
local contentPosition = AppBlox.ContentPosition
local mediaGalleryPreview = AppBlox.MediaGalleryPreview
local calcMediaGallerySizesFromWidth = AppBlox.calcMediaGallerySizesFromWidth
local listTable = UIBlox.App.Table.ListTable
local function fn() end

local v5 = { onClose = fn, onJoinEvent = fn, onShare = fn }

local function EventDetailsPage(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local media = p2.virtualEvent.media
	local experienceDetails = p2.virtualEvent.experienceDetails

	local state, setState = React.useState(0)

	local v6 = useDeviceType()

	local state2, setState2 = React.useState({})
	local imageId = if state2[1] then state2[1].imageId else nil

	local v7 = useRoactService(roactNetworking)

	React.useEffect(function()
		if FFlagLuaAppLimitEventThumbnailToOne then
			fetchEventThumbnail(v7, p2.virtualEvent.id):andThen(function(p3)
				local v8 = {}

				if p3 then
					table.insert(v8, { imageId = p3, isYouTubeVideo = false })
				end

				if #v8 > 0 then
					setState2(v8)
				else
					setState2(getGalleryItems(media))
				end
			end, function()
				setState2(getGalleryItems(media))
			end)
		else
			fetchEventThumbnailList(v7, p2.virtualEvent.id):andThen(function(items)
				local v8 = {}

				if items then
					for k, item in items do
						if item.mediaId then
							table.insert(v8, {
								imageId = "rbxassetid://" .. item.mediaId,
								isYouTubeVideo = false
							})
						end
					end
				end

				if #v8 > 0 then
					setState2(v8)
				else
					setState2(getGalleryItems(media))
				end
			end, function()
				setState2(getGalleryItems(media))
			end)
		end
	end, { p2.virtualEvent.id, media })

	local v8 = useMutation(requests.UPDATE_RSVP_STATUS, {
		variables = { virtualEventId = p2.virtualEvent.id },
		update = function(p3, object, p4)
			local virtualEvent = p4.data.virtualEventRsvp.virtualEvent

			object:modify({
				id = object:identify(virtualEvent),
				fields = {
					rsvpCounters = function(p5, p6)
						local v9 = virtualEvent.userRsvpStatus == "going" and 1 or -1
						return Cryo.Dictionary.join(p6, {
							going = p6.going + v9
						})
					end
				}
			})
		end
	})

	local v9 = React.useMemo(function()
		return getEventTimerStatus(joined.virtualEvent, joined.currentTime)
	end, { joined.virtualEvent, joined.currentTime })

	local v10 = React.useCallback(function(p3)
		local offset = calcMediaGallerySizesFromWidth(p3.AbsoluteSize.X, 5).contentSize.Y.Offset

		if offset ~= state then
			setState(offset)
		end
	end, { state })

	local v11 = React.useCallback(function()
		local v12 = joined.virtualEvent.userRsvpStatus == "going" and "notGoing" or "going"

		v8[1]({
			variables = { rsvpStatus = v12 }
		}):andThen(function(p3)
			if joined.onRsvpChanged then
				joined.onRsvpChanged(
					p3.data.virtualEventRsvp.virtualEvent.userRsvpStatus,
					p3.data.virtualEventRsvp.shouldSeeNotificationsUpsellModal
				)
			end
		end)
	end, { joined.virtualEvent })

	local ref = React.useRef(nil)
	ref.current = Responsive.usePreferredInput()

	local v12 = ref.current == Responsive.Input.Directional

	local v13, v14 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
	local v15 = useCloseWithBackButton(v14, p2.onClose)

	local v16 = ReactFocusNavigation.useFocusGuiObject()

	local state3, setState3 = React.useState(nil)

	local v17 = React.useCallback(function(p3)
		setState3(p3)

		if typeof(v13) == "function" then
			v13(p3)
		end
	end, { v13 })

	React.useEffect(function()
		if state3 and ref.current == Responsive.Input.Directional then
			v16(state3)
		end
	end, { state3, v16 })

	local v18 = useActionBarProps(
		joined.virtualEvent,
		v9,
		{
			onClose = joined.onClose,
			onJoinEvent = joined.onJoinEvent,
			onShare = joined.onShare,
			onRsvpChanged = v11
		},
		v17
	)

	local v19 = React.useMemo(function()
		return v18.button or #v18.icons > 0
	end, { v18 })

	local v20 = {
		Attendance = v9 ~= "Elapsed" and {
			portraitLayoutOrder = 1,
			landscapePosition = contentPosition.Left,
			landscapeLayoutOrder = 1,
			renderComponent = function()
				return React.createElement(module15, {
					virtualEvent = joined.virtualEvent,
					eventStatus = v9
				})
			end
		} or nil,
		MediaGallery = {
			portraitLayoutOrder = 2,
			landscapePosition = contentPosition.Right,
			landscapeLayoutOrder = 1,
			renderComponent = function()
				return React.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, state),
						BackgroundTransparency = 1,
						[React.Change.AbsoluteSize] = v10
					},
					{
						Gallery = React.createElement(mediaGalleryPreview, {
							items = state2,
							numberOfThumbnails = 5
						})
					}
				)
			end
		},
		Description = {
			portraitLayoutOrder = 3,
			landscapePosition = contentPosition.Left,
			landscapeLayoutOrder = 2,
			renderComponent = function()
				local createElement = React.createElement
				local v22 = {
					description = joined.virtualEvent.description,
					experienceName = 0,
					experienceThumbnail = 0,
					onExperienceTileActivated = 0
				}
				local v23 = if experienceDetails then experienceDetails.name else nil
				v22.experienceName = v23
				v22.experienceThumbnail = ("rbxthumb://type=GameIcon&id=%s&w=150&h=150"):format(joined.virtualEvent.universeId)
				v22.onExperienceTileActivated = joined.onExperienceTileActivated
				return createElement(EventDescription, v22)
			end
		},
		EventInfo = joined.virtualEvent.host and {
			portraitLayoutOrder = 4,
			landscapePosition = contentPosition.Right,
			landscapeLayoutOrder = 2,
			renderComponent = function()
				return React.createElement(listTable, {
					cells = { React.createElement(EventHostedBy, {
							host = joined.virtualEvent.host,
							onActivated = joined.onHostActivated
						}) }
				})
			end
		} or nil
	}

	return React.createElement(detailsPageTemplate, {
		deviceType = v6,
		titleText = p2.virtualEvent.eventStatus == "moderated" and "[CONTENT MODERATED]" or joined.virtualEvent.title,
		thumbnailImageUrl = imageId,
		thumbnailAspectRatio = Vector2.new(16, 9),
		renderInfoContent = function()
			return React.createElement(EventTimer, {
				virtualEvent = joined.virtualEvent,
				status = v9,
				currentTime = joined.currentTime
			})
		end,
		actionBarProps = if v19 then v18 else nil,
		componentList = (p2.virtualEvent.eventStatus == "cancelled" or p2.virtualEvent.eventStatus == "moderated") and {} or v20,
		onClose = joined.onClose,
		disableStickyActionBar = v12,
		containerRef = v15
	})
end

return EventDetailsPage
