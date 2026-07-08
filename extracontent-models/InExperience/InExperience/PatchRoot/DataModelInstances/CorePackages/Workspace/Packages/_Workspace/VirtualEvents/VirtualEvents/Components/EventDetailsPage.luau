local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local ApolloClient = require(VirtualEvents.Parent.ApolloClient)

require(VirtualEvents.Parent.GraphQLServer)

local Cryo = require(VirtualEvents.Parent.Cryo)
local React = require(VirtualEvents.Parent.React)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local useDeviceType = require(VirtualEvents.Parent.RobloxAppHooks).useDeviceType

require(VirtualEvents.Parent.RobloxAppEnums)

local useRoactService = require(VirtualEvents.Parent.RobloxAppHooks).useRoactService
local RoactNetworking = require(VirtualEvents.Parent.RoactServiceTags).RoactNetworking
local Responsive = require(VirtualEvents.Parent.Responsive)
local ReactFocusNavigation = require(VirtualEvents.Parent.ReactFocusNavigation)
local useCloseWithBackButton = require(VirtualEvents.Parent.AppBlox).useCloseWithBackButton
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
local AppBlox = require(VirtualEvents.Parent.AppBlox)
local DetailsPageTemplate = AppBlox.DetailsPageTemplate
local ContentPosition = AppBlox.ContentPosition
local MediaGalleryPreview = AppBlox.MediaGalleryPreview
local calcMediaGallerySizesFromWidth = AppBlox.calcMediaGallerySizesFromWidth
local ListTable = UIBlox.App.Table.ListTable

local function v30() -- line: 40
end

local t1 = {
	onClose = v30,
	onJoinEvent = v30,
	onShare = v30
}

local function EventDetailsPage(p1) -- line: 71
	-- upvalues: Cryo (copy), t1 (copy), React (copy), useDeviceType (copy), useRoactService (copy), RoactNetworking (copy), FFlagLuaAppLimitEventThumbnailToOne (copy), fetchEventThumbnail (copy), getGalleryItems (copy), fetchEventThumbnailList (copy), useMutation (copy), requests (copy), getEventTimerStatus (copy), calcMediaGallerySizesFromWidth (copy), Responsive (copy), ReactFocusNavigation (copy), useCloseWithBackButton (copy), useActionBarProps (copy), ContentPosition (copy), Attendance (copy), MediaGalleryPreview (copy), EventDescription (copy), ListTable (copy), EventHostedBy (copy), DetailsPageTemplate (copy), EventTimer (copy)
	local v34 = Cryo.Dictionary.join(t1, p1)
	local media = p1.virtualEvent.media
	local experienceDetails = p1.virtualEvent.experienceDetails
	local v37, v38 = React.useState(0)
	local v39 = useDeviceType()
	local v40, v41 = React.useState({})
	local v42 = if not v40[1] then nil else v40[1].imageId
	local v43 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 86
		-- upvalues: FFlagLuaAppLimitEventThumbnailToOne (copy), fetchEventThumbnail (copy), v43 (copy), p1 (copy), v41 (copy), getGalleryItems (copy), media (copy), fetchEventThumbnailList (copy)
		if FFlagLuaAppLimitEventThumbnailToOne then
			fetchEventThumbnail(v43, p1.virtualEvent.id):andThen(function(p2) -- line: 88
				-- upvalues: v41 (copy), getGalleryItems (copy), media (copy)
				local t2 = {}

				if p2 then
					table.insert(t2, {
						isYouTubeVideo = false,
						imageId = p2
					})
				end

				if #t2 > 0 then
					v41(t2)

					return
				end

				v41(getGalleryItems(media))
			end, function() -- line: 105
				-- upvalues: v41 (copy), getGalleryItems (copy), media (copy)
				v41(getGalleryItems(media))
			end)

			return
		end

		fetchEventThumbnailList(v43, p1.virtualEvent.id):andThen(function(p3) -- line: 109
			-- upvalues: v41 (copy), getGalleryItems (copy), media (copy)
			local t3 = {}

			if p3 then
				for _, v74 in p3 do
					if v74.mediaId then
						table.insert(t3, {
							isYouTubeVideo = false,
							imageId = "rbxassetid://" .. v74.mediaId
						})
					end
				end
			end

			if #t3 > 0 then
				v41(t3)

				return
			end

			v41(getGalleryItems(media))
		end, function() -- line: 130
			-- upvalues: v41 (copy), getGalleryItems (copy), media (copy)
			v41(getGalleryItems(media))
		end)
	end, {
		p1.virtualEvent.id,
		media
	})

	local v44 = useMutation(requests.UPDATE_RSVP_STATUS, {
		variables = {
			virtualEventId = p1.virtualEvent.id
		},
		update = function(_, p5, p6) -- line: 140
			-- upvalues: Cryo (copy)
			local virtualEvent = p6.data.virtualEventRsvp.virtualEvent

			p5:modify({
				id = p5:identify(virtualEvent),
				fields = {
					rsvpCounters = function(_, t4: {[any]: any}) -- line: 146
						-- upvalues: virtualEvent (copy), Cryo (copy)
						local v77 = virtualEvent.userRsvpStatus ~= "going" and -1 or 1

						return Cryo.Dictionary.join(t4, {
							going = t4.going + v77
						})
					end
				}
			})
		end
	})
	local v45 = React.useMemo(function() -- line: 157
		-- upvalues: getEventTimerStatus (copy), v34 (copy)
		return getEventTimerStatus(v34.virtualEvent, v34.currentTime)
	end, {
		v34.virtualEvent,
		v34.currentTime
	})
	local v46 = React.useCallback(function(p8) -- line: 161
		-- upvalues: calcMediaGallerySizesFromWidth (copy), v37 (copy), v38 (copy)
		local AbsoluteSizeX = p8.AbsoluteSize.X
		local YOffset = calcMediaGallerySizesFromWidth(AbsoluteSizeX, 5).contentSize.Y.Offset

		if YOffset ~= v37 then
			v38(YOffset)
		end
	end, { v37 })
	local v47 = React.useCallback(function() -- line: 170
		-- upvalues: v34 (copy), v44 (copy)
		local v67 = v34.virtualEvent.userRsvpStatus == "going" and "notGoing" or "going"

		v44[1]({
			variables = {
				rsvpStatus = v67
			}
		}):andThen(function(p9) -- line: 184
			-- upvalues: v34 (copy)
			if v34.onRsvpChanged then
				v34.onRsvpChanged(p9.data.virtualEventRsvp.virtualEvent.userRsvpStatus, p9.data.virtualEventRsvp.shouldSeeNotificationsUpsellModal)
			end
		end)
	end, { v34.virtualEvent })
	local v48 = React.useRef(nil)

	v48.current = Responsive.usePreferredInput()

	local v49 = v48.current == Responsive.Input.Directional
	local v50, v51 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
	local v52 = useCloseWithBackButton(v51, p1.onClose)
	local v53 = ReactFocusNavigation.useFocusGuiObject()
	local v54, v55 = React.useState(nil)
	local v56 = React.useCallback(function(p10) -- line: 210
		-- upvalues: v55 (copy), v50 (copy)
		v55(p10)

		if typeof(v50) == "function" then
			v50(p10)
		end
	end, { v50 })

	React.useEffect(function() -- line: 219
		-- upvalues: v54 (copy), v48 (copy), Responsive (copy), v53 (copy)
		if v54 and v48.current == Responsive.Input.Directional then
			v53(v54)
		end
	end, {
		v54,
		v53
	})

	local v57 = useActionBarProps(v34.virtualEvent, v45, {
		onClose = v34.onClose,
		onJoinEvent = v34.onJoinEvent,
		onShare = v34.onShare,
		onRsvpChanged = v47
	}, v56)
	local v58 = React.useMemo(function() -- line: 232
		-- upvalues: v57 (copy)
		return v57.button or #v57.icons > 0
	end, { v57 })
	local t5 = {
		Attendance = if v45 == "Elapsed" then nil else {
			portraitLayoutOrder = 1,
			landscapeLayoutOrder = 1,
			landscapePosition = ContentPosition.Left,
			renderComponent = function() -- line: 242
				-- upvalues: React (copy), Attendance (copy), v34 (copy), v45 (copy)
				return React.createElement(Attendance, {
					virtualEvent = v34.virtualEvent,
					eventStatus = v45
				})
			end
		},
		MediaGallery = {
			portraitLayoutOrder = 2,
			landscapeLayoutOrder = 1,
			landscapePosition = ContentPosition.Right,
			renderComponent = function() -- line: 254
				-- upvalues: React (copy), v37 (copy), v46 (copy), MediaGalleryPreview (copy), v40 (copy)
				return React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, v37),
					BackgroundTransparency = 1,
					[React.Change.AbsoluteSize] = v46
				}, {
					Gallery = React.createElement(MediaGalleryPreview, {
						numberOfThumbnails = 5,
						items = v40
					})
				})
			end
		},
		Description = {
			portraitLayoutOrder = 3,
			landscapeLayoutOrder = 2,
			landscapePosition = ContentPosition.Left,
			renderComponent = function() -- line: 271
				-- upvalues: React (copy), EventDescription (copy), v34 (copy), experienceDetails (copy)
				return React.createElement(EventDescription, {
					description = v34.virtualEvent.description,
					experienceName = if not experienceDetails then nil else experienceDetails.name,
					experienceThumbnail = ("rbxthumb://type=GameIcon&id=%s&w=150&h=150"):format(v34.virtualEvent.universeId),
					onExperienceTileActivated = v34.onExperienceTileActivated
				})
			end
		},
		EventInfo = if not v34.virtualEvent.host then nil else {
			portraitLayoutOrder = 4,
			landscapeLayoutOrder = 2,
			landscapePosition = ContentPosition.Right,
			renderComponent = function() -- line: 285
				-- upvalues: React (copy), ListTable (copy), EventHostedBy (copy), v34 (copy)
				return React.createElement(ListTable, {
					cells = { React.createElement(EventHostedBy, {
						host = v34.virtualEvent.host,
						onActivated = v34.onHostActivated
					}) }
				})
			end
		}
	}

	return React.createElement(DetailsPageTemplate, {
		deviceType = v39,
		titleText = if p1.virtualEvent.eventStatus ~= "moderated" then v34.virtualEvent.title else "[CONTENT MODERATED]",
		thumbnailImageUrl = v42,
		thumbnailAspectRatio = Vector2.new(16, 9),
		renderInfoContent = function() -- line: 306
			-- upvalues: React (copy), EventTimer (copy), v34 (copy), v45 (copy)
			return React.createElement(EventTimer, {
				virtualEvent = v34.virtualEvent,
				status = v45,
				currentTime = v34.currentTime
			})
		end,
		actionBarProps = if not v58 then nil else v57,
		componentList = if p1.virtualEvent.eventStatus == "cancelled" or p1.virtualEvent.eventStatus == "moderated" then {} else t5,
		onClose = v34.onClose,
		disableStickyActionBar = v49,
		containerRef = v52
	})
end

return EventDetailsPage
