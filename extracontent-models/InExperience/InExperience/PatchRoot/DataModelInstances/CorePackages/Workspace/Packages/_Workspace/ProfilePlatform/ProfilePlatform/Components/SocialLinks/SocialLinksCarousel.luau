local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local TelemetryService = game:GetService("TelemetryService")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local CollectionViews = require(ProfilePlatformParent.CollectionViews)
local useRoactService = require(ProfilePlatformParent.RobloxAppHooks).useRoactService
local AppLinking = require(ProfilePlatformParent.RoactServiceTags).AppLinking
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local SocialLinkTile = require(ProfilePlatform.Components.SocialLinks.SocialLinkTile)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local sendSocialLinkClickEvent = require(ProfilePlatformParent.DiscoveryAnalytics).Events.sendSocialLinkClickEvent
local CollectionCarousel = CollectionViews.CollectionCarousel
local CollectionViewTypes = CollectionViews.CollectionViewTypes
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local CollectionItemSize = CollectionViewTypes.CollectionItemSize
local FFlagLuaAppAddSocialLinkClickTelemetryToEdp = require(ProfilePlatformParent.SharedFlags).FFlagLuaAppAddSocialLinkClickTelemetryToEdp
local v19 = if not FFlagLuaAppAddSocialLinkClickTelemetryToEdp then game:DefineFastInt("SocialLinkClickTelemetryThrottlePermyriad", 0) else nil

return function(t1: {[any]: any}) -- line: 42
	-- upvalues: useProfileWrapperContext (copy), useRoactService (copy), AppLinking (copy), React (copy), useLocalization (copy), TextKeys (copy), useDynamicSizeMargin (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendSocialLinkClickEvent (copy), v19 (copy), TelemetryService (copy), SocialLinkTile (copy), CollectionCarousel (copy)
	local v21 = useProfileWrapperContext()
	local openLeaveRobloxAlertUIBlox = v21.navigateTo.openLeaveRobloxAlertUIBlox
	local closeLeaveRobloxAlert = v21.navigateTo.closeLeaveRobloxAlert
	local v24 = useRoactService(AppLinking)
	local v25, v26 = React.useState(nil)
	local v27 = React.useRef(nil)
	local v28 = useLocalization({
		title = TextKeys.SocialMedia
	})
	local v29, v30 = useDynamicSizeMargin()
	local t2 = {
		sideMargin = v29
	}
	local v32 = useCollectionLayoutParams(CollectionItemSize.XSmall, v25, true, t2)
	local v33 = React.useCallback(function(n1: number) -- line: 58
		return n1 + 36
	end, {})
	local v34 = React.useCallback(function(p1) -- line: 106
		-- upvalues: openLeaveRobloxAlertUIBlox (copy), v24 (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendSocialLinkClickEvent (copy), v21 (copy), v19 (copy), TelemetryService (copy), closeLeaveRobloxAlert (copy)
		return function() -- line: 107
			-- upvalues: openLeaveRobloxAlertUIBlox (copy), v24 (copy), p1 (copy), FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendSocialLinkClickEvent (copy), v21 (copy), v19 (copy), TelemetryService (copy), closeLeaveRobloxAlert (copy)
			if openLeaveRobloxAlertUIBlox and (v24 and p1.url) then
				local key = p1.key
				local url = p1.url

				openLeaveRobloxAlertUIBlox(function() -- line: 63
					-- upvalues: FFlagLuaAppAddSocialLinkClickTelemetryToEdp (copy), sendSocialLinkClickEvent (copy), v21 (copy), key (copy), url (copy), v19 (copy), TelemetryService (copy), v24 (copy), closeLeaveRobloxAlert (copy)
					if FFlagLuaAppAddSocialLinkClickTelemetryToEdp then
						sendSocialLinkClickEvent({
							assignment_type = "group",
							social_link_display_type = "badge",
							assignment_id = v21.profileId,
							social_link_type = key,
							social_link_url = url
						})
					else
						local t3 = {
							eventName = "socialLinkClickEvent",
							description = "Event fired from the client every time a social link is clicked",
							links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/usercommunities/social_link_click_event.proto",
							backends = { "EventIngest" },
							throttlingPercentage = v19,
							lastUpdated = {
								25,
								5,
								20
							}
						}
						local t4 = {
							assignment_type = "group",
							social_link_display_type = "badge",
							assignment_id = v21.profileId,
							social_link_type = key,
							social_link_url = url
						}

						TelemetryService:LogEvent(t3, {
							customFields = t4
						})
					end

					if v24 then
						v24:openURL(url):andThen(function(p2) -- line: 93
							-- upvalues: v24 (copy), url (copy)
							if p2 == false then
								v24:openURL(url)
							end
						end)
					end

					if closeLeaveRobloxAlert then
						closeLeaveRobloxAlert()
					end
				end)
			end
		end
	end, {
		openLeaveRobloxAlertUIBlox,
		v24
	})
	local v35 = React.useCallback(function(p3, p4, _) -- line: 115
		-- upvalues: React (copy), SocialLinkTile (copy), v34 (copy)
		return React.createElement(SocialLinkTile, {
			tileSize = 80,
			name = p3.name,
			icon = p3.logo,
			onActivated = v34(p3),
			layoutOrder = p4
		}), p3.key
	end, { v34 })

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		[React.Change.AbsoluteSize] = v30
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}),
		CollectionCarousel = React.createElement(CollectionCarousel, {
			LayoutOrder = 1,
			containerRef = v26,
			scrollingFrameRef = v27,
			title = v28.title,
			items = t1.items,
			renderItem = v35,
			getItemHeight = v33,
			numColumns = v32.numColumns,
			fractionalItemAmount = v32.fractionalItemAmount,
			columnGap = v32.columnGap,
			sideMargin = v32.sideMargin,
			maxItemsToShow = v32.maxTilesToShow,
			thresholdFromEnd = v32.loadMoreThreshold
		})
	})
end
