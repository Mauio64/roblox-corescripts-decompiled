local fetchBadgeDetailsPage = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgeDetailsPage/fetchBadgeDetailsPage")
local getBadgeDetailsPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgeDetailsPage/getBadgeDetailsPageKey")
local BadgeDetailsSheetState = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgeDetailsPage/BadgeDetailsSheetState")
require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Navigation")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Foundation")
local useTokens = Foundation.Hooks.useTokens
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Navigation").useNavigation
local useRouteName = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Navigation").useRouteName
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Navigation").useNavigationFocus
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Responsive")
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SduiSharedUtilities")
local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/AppComposition").CompositionTags

local setIsBadgeDetailsSheetOpen = BadgeDetailsSheetState.setIsBadgeDetailsSheetOpen
local fFlagSduiPageEntryUseSharedHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/SharedFlags").FFlagSduiPageEntryUseSharedHooks

local function getFromPropsOrNavigationParams(p2, p3)
	local v5 = p2.navigation and p2.navigation.getParam("extraProps")
	return p2[p3] or v5 and v5[p3]
end

local function BadgeDetailsPage(p2)
	local v5 = useTokens()
	local v6 = p2.navigation and p2.navigation.getParam("extraProps")
	local badgeId = p2.badgeId or v6 and v6.badgeId

	local v7 = getBadgeDetailsPageKey(badgeId)

	local v8 = React.useMemo(function()
		local v9 = p2
		local v10 = v9.navigation and v9.navigation.getParam("extraProps")
		return v9.pageTimer or v10 and v10.pageTimer or sduiLoadTimer.createLoadTimer("BadgeDetails")
	end, {})

	local v9 = useNavigation()
	local v10 = useRouteName()
	local v11 = useNavigationFocus()
	local v12 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	local v13 = React.useCallback(function()
		if v10 == "BadgeDetails" and v11 then
			v9.goBack()
		end
	end, { v9, v10, v11 })

	React.useEffect(function()
		if badgeId then
			fetchBadgeDetailsPage(badgeId, v8)
		end
	end, { badgeId, v8 })

	React.useEffect(function()
		setIsBadgeDetailsSheetOpen(not v12 and v11)

		return function()
			setIsBadgeDetailsSheetOpen(false)
		end
	end, { v12, v11 })

	local ref = React.useRef(nil)

	local v14 = React.useCallback(function()
		return React.createElement(sduiFeatureEntryPoint, {
			appPage = "BadgeDetails",
			configKey = v7,
			identifier = "badge_details_context_menu",
			AutomaticSize = Enum.AutomaticSize.XY,
			pageTimer = v8,
			shouldDisplayError = false,
			shouldDisplayLoading = false
		})
	end, { v7, v8 })

	if badgeId == nil then
		return nil
	end

	if v12 then
		return React.createElement(sduiPageEntryPoint, {
			appPage = "BadgeDetails",
			configKey = v7,
			identifier = fFlagSduiPageEntryUseSharedHooks and "badge_details_feed" or v7 .. "_badge_details_feed",
			pageTimer = v8,
			renderUtilities = v14,
			includeNavigationHeaderBar = true,
			contentTag = compositionTags.ContentRegion.Body
		})
	end

	return React.createElement(Foundation.Sheet.Root, {
		snapPoints = { 1 },
		isOpen = v11,
		displaySize = Foundation.Enums.DialogSize.Large,
		onClose = v13
	}, {
		Header = React.createElement(Foundation.Sheet.Header, {
			hasCloseAffordance = true
		}, {
			ContextMenu = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				},
				{
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					ContextMenuEntryPoint = React.createElement(
						"Frame",
						{
							LayoutOrder = 1,
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1,
							BorderSizePixel = 0
						},
						{ EntryPoint = v14() }
					)
				}
			)
		}),
		Content = React.createElement(
			Foundation.Sheet.Content,
			{ scrollingFrameRef = ref },
			React.createElement(sduiPageEntryPoint, {
				appPage = "BadgeDetails",
				configKey = v7,
				identifier = fFlagSduiPageEntryUseSharedHooks and "badge_details_feed" or v7 .. "_badge_details_feed",
				pageTimer = v8,
				includeNavigationHeaderBar = false,
				backgroundStyle = v5.Color.None,
				disableRootPadding = true,
				scrollingFrameRef = ref,
				snackbarPortalLayoutOrder = 2147483647
			})
		)
	})
end

return React.memo(BadgeDetailsPage)
