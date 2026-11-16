local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local TelemetryService = game:GetService("TelemetryService")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local CollectionViews = require(parent.CollectionViews)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SocialLinkTile = require(ProfilePlatform.Components.SocialLinks.SocialLinkTile)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sendSocialLinkClickEvent = DiscoveryAnalytics.Events.sendSocialLinkClickEvent

local CollectionCarousel = CollectionViews.CollectionCarousel
local CollectionViewTypes = CollectionViews.CollectionViewTypes
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local CollectionItemSize = CollectionViewTypes.CollectionItemSize

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddSocialLinkClickTelemetryToEdp = SharedFlags.FFlagLuaAppAddSocialLinkClickTelemetryToEdp
local throttlingPercentage

if FFlagLuaAppAddSocialLinkClickTelemetryToEdp then
	throttlingPercentage = nil
else
	throttlingPercentage = game:DefineFastInt("SocialLinkClickTelemetryThrottlePermyriad", 0)
end

return function(p)
	local v = useProfileWrapperContext()
	local openLeaveRobloxAlertUIBlox = v.navigateTo.openLeaveRobloxAlertUIBlox
	local closeLeaveRobloxAlert = v.navigateTo.closeLeaveRobloxAlert
	local v2 = useRoactService(AppLinking)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local v3 = useLocalization({ title = TextKeys.SocialMedia })

	local sideMargin, v4 = useDynamicSizeMargin()
	local v5 = useCollectionLayoutParams(CollectionItemSize.XSmall, state, true, {
		sideMargin = sideMargin
	})

	local getItemHeight = React.useCallback(function(p2: number)
		return p2 + 36
	end, {})

	local v6 = React.useCallback(function(p2)
		return function()
			if openLeaveRobloxAlertUIBlox and v2 and p2.url then
				local key = p2.key
				local url = p2.url
				openLeaveRobloxAlertUIBlox(function()
					if FFlagLuaAppAddSocialLinkClickTelemetryToEdp then
						sendSocialLinkClickEvent({
							assignment_id = v.profileId,
							assignment_type = "group",
							social_link_type = key,
							social_link_url = url,
							social_link_display_type = "badge"
						})
					else
						TelemetryService:LogEvent({
							eventName = "socialLinkClickEvent",
							backends = { "EventIngest" },
							throttlingPercentage = throttlingPercentage,
							lastUpdated = { 25, 5, 20 },
							description = "Event fired from the client every time a social link is clicked",
							links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/usercommunities/social_link_click_event.proto"
						}, {
							customFields = {
								assignment_id = v.profileId,
								assignment_type = "group",
								social_link_type = key,
								social_link_url = url,
								social_link_display_type = "badge"
							}
						})
					end

					if v2 then
						v2:openURL(url):andThen(function(p3)
							if p3 == false then
								v2:openURL(url)
							end
						end)
					end

					if closeLeaveRobloxAlert then
						closeLeaveRobloxAlert()
					end
				end)
			end
		end
	end, { openLeaveRobloxAlertUIBlox, v2 })

	local renderItem = React.useCallback(function(props, layoutOrder, _)
		return React.createElement(SocialLinkTile, {
			name = props.name,
			icon = props.logo,
			tileSize = 80,
			onActivated = v6(props),
			layoutOrder = layoutOrder
		}), props.key
	end, { v6 })

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = p.layoutOrder,
		[React.Change.AbsoluteSize] = v4
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}),
		CollectionCarousel = React.createElement(CollectionCarousel, {
			containerRef = setState,
			scrollingFrameRef = ref,
			LayoutOrder = 1,
			title = v3.title,
			items = p.items,
			renderItem = renderItem,
			getItemHeight = getItemHeight,
			numColumns = v5.numColumns,
			fractionalItemAmount = v5.fractionalItemAmount,
			columnGap = v5.columnGap,
			sideMargin = v5.sideMargin,
			maxItemsToShow = v5.maxTilesToShow,
			thresholdFromEnd = v5.loadMoreThreshold
		})
	})
end
