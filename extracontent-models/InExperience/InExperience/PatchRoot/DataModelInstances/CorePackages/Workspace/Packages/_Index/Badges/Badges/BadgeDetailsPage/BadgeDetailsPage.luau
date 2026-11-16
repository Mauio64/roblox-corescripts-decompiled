local parent = script:FindFirstAncestor("Badges").Parent

local fetchBadgeDetailsPage = require(script.Parent.fetchBadgeDetailsPage)
local getBadgeDetailsPageKey = require(script.Parent.getBadgeDetailsPageKey)
local BadgeDetailsSheetState = require(script.Parent.BadgeDetailsSheetState)
require(parent.Navigation)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Navigation2 = require(parent.Navigation)
local useRouteName = Navigation2.useRouteName
local Navigation3 = require(parent.Navigation)
local useNavigationFocus = Navigation3.useNavigationFocus
local Responsive = require(parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local setIsBadgeDetailsSheetOpen = BadgeDetailsSheetState.setIsBadgeDetailsSheetOpen
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiPageEntryUseSharedHooks = SharedFlags.FFlagSduiPageEntryUseSharedHooks

local function getFromPropsOrNavigationParams(p, p2: string) -- 2 equivalent calls inferred from this helper
	local v = p.navigation and p.navigation.getParam("extraProps")
	return p[p2] or v and v[p2]
end

local function BadgeDetailsPage(p)
	local v = useTokens()
	local v2 = getFromPropsOrNavigationParams(p, "badgeId") -- inferred equivalent call
	local badgeDetailsPageKey = getBadgeDetailsPageKey(v2)

	local pageTimer = React.useMemo(function()
		return getFromPropsOrNavigationParams(p, "pageTimer") or SduiLoadTimer.createLoadTimer("BadgeDetails") -- inferred equivalent call
	end, {})

	local v3 = useNavigation()
	local v4 = useRouteName()
	local isOpen = useNavigationFocus()
	local v5 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	local onClose = React.useCallback(function()
		if v4 == "BadgeDetails" and isOpen then
			v3.goBack()
		end
	end, { v3, v4, isOpen })

	React.useEffect(function()
		if v2 then
			fetchBadgeDetailsPage(v2, pageTimer)
		end
	end, { v2, pageTimer })

	React.useEffect(function()
		setIsBadgeDetailsSheetOpen(not v5 and isOpen)

		return function()
			setIsBadgeDetailsSheetOpen(false)
		end
	end, { v5, isOpen })

	local ref = React.useRef(nil)

	local renderUtilities = React.useCallback(function()
		return React.createElement(SduiFeatureEntryPoint, {
			appPage = "BadgeDetails",
			configKey = badgeDetailsPageKey,
			identifier = "badge_details_context_menu",
			AutomaticSize = Enum.AutomaticSize.XY,
			pageTimer = pageTimer,
			shouldDisplayError = false,
			shouldDisplayLoading = false
		})
	end, { badgeDetailsPageKey, pageTimer })

	if v2 == nil then
		return nil
	end

	if v5 then
		return React.createElement(SduiPageEntryPoint, {
			appPage = "BadgeDetails",
			configKey = badgeDetailsPageKey,
			identifier = FFlagSduiPageEntryUseSharedHooks and "badge_details_feed" or badgeDetailsPageKey .. "_badge_details_feed",
			pageTimer = pageTimer,
			renderUtilities = renderUtilities,
			includeNavigationHeaderBar = true,
			contentTag = CompositionTags.ContentRegion.Body
		})
	end

	return React.createElement(Foundation.Sheet.Root, {
		snapPoints = { 1 },
		isOpen = isOpen,
		displaySize = Foundation.Enums.DialogSize.Large,
		onClose = onClose
	}, {
		Header = React.createElement(Foundation.Sheet.Header, { hasCloseAffordance = true }, {
			ContextMenu = React.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0 },
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
						{ EntryPoint = renderUtilities() }
					)
				}
			)
		}),
		Content = React.createElement(
			Foundation.Sheet.Content,
			{ scrollingFrameRef = ref },
			React.createElement(SduiPageEntryPoint, {
				appPage = "BadgeDetails",
				configKey = badgeDetailsPageKey,
				identifier = FFlagSduiPageEntryUseSharedHooks and "badge_details_feed" or badgeDetailsPageKey .. "_badge_details_feed",
				pageTimer = pageTimer,
				includeNavigationHeaderBar = false,
				backgroundStyle = v.Color.None,
				disableRootPadding = true,
				scrollingFrameRef = ref,
				snackbarPortalLayoutOrder = 2147483647
			})
		)
	})
end

return React.memo(BadgeDetailsPage)
