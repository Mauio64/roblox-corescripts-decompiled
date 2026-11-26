local TelemetryService = game:GetService("TelemetryService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CollectionViews")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useRoactService
local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").AppLinking
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local SocialLinkTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/SocialLinks/SocialLinkTile")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")
local sendSocialLinkClickEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DiscoveryAnalytics").Events.sendSocialLinkClickEvent

local collectionCarousel = CollectionViews.CollectionCarousel
local collectionViewTypes = CollectionViews.CollectionViewTypes
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local collectionItemSize = collectionViewTypes.CollectionItemSize

local fFlagLuaAppAddSocialLinkClickTelemetryToEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagLuaAppAddSocialLinkClickTelemetryToEdp
local v5

if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then
	v5 = nil
else
	v5 = game:DefineFastInt("SocialLinkClickTelemetryThrottlePermyriad", 0)
end

return function(p2)
	local v6 = useProfileWrapperContext()
	local openLeaveRobloxAlertUIBlox = v6.navigateTo.openLeaveRobloxAlertUIBlox
	local closeLeaveRobloxAlert = v6.navigateTo.closeLeaveRobloxAlert
	local v7 = useRoactService(appLinking)
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local v8 = useLocalization({ title = TextKeys.SocialMedia })

	local v9, v10 = useDynamicSizeMargin()
	local v11 = useCollectionLayoutParams(collectionItemSize.XSmall, state, true, {
		sideMargin = v9
	})

	local v12 = React.useCallback(function(p3)
		return p3 + 36
	end, {})

	local v13 = React.useCallback(function(p3)
		return function()
			if openLeaveRobloxAlertUIBlox and v7 and p3.url then
				local key = p3.key
				local url = p3.url
				openLeaveRobloxAlertUIBlox(function()
					if fFlagLuaAppAddSocialLinkClickTelemetryToEdp then
						sendSocialLinkClickEvent({
							assignment_id = v6.profileId,
							assignment_type = "group",
							social_link_type = key,
							social_link_url = url,
							social_link_display_type = "badge"
						})
					else
						TelemetryService:LogEvent({
							eventName = "socialLinkClickEvent",
							backends = { "EventIngest" },
							throttlingPercentage = v5,
							lastUpdated = { 25, 5, 20 },
							description = "Event fired from the client every time a social link is clicked",
							links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/usercommunities/social_link_click_event.proto"
						}, {
							customFields = {
								assignment_id = v6.profileId,
								assignment_type = "group",
								social_link_type = key,
								social_link_url = url,
								social_link_display_type = "badge"
							}
						})
					end

					if v7 then
						v7:openURL(url):andThen(function(p4)
							if p4 == false then
								v7:openURL(url)
							end
						end)
					end

					if closeLeaveRobloxAlert then
						closeLeaveRobloxAlert()
					end
				end)
			end
		end
	end, { openLeaveRobloxAlertUIBlox, v7 })

	local v14 = React.useCallback(function(props, p3, p4)
		return React.createElement(SocialLinkTile, {
			name = props.name,
			icon = props.logo,
			tileSize = 80,
			onActivated = v13(props),
			layoutOrder = p3
		}), props.key
	end, { v13 })

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = p2.layoutOrder,
		[React.Change.AbsoluteSize] = v10
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}),
		CollectionCarousel = React.createElement(collectionCarousel, {
			containerRef = setState,
			scrollingFrameRef = ref,
			LayoutOrder = 1,
			title = v8.title,
			items = p2.items,
			renderItem = v14,
			getItemHeight = v12,
			numColumns = v11.numColumns,
			fractionalItemAmount = v11.fractionalItemAmount,
			columnGap = v11.columnGap,
			sideMargin = v11.sideMargin,
			maxItemsToShow = v11.maxTilesToShow,
			thresholdFromEnd = v11.loadMoreThreshold
		})
	})
end
