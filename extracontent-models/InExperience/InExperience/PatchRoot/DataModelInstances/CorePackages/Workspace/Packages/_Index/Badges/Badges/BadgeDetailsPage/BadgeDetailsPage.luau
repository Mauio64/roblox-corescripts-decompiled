local Parent = script:FindFirstAncestor("Badges").Parent
local fetchBadgeDetailsPage = require(script.Parent.fetchBadgeDetailsPage)
local getBadgeDetailsPageKey = require(script.Parent.getBadgeDetailsPageKey)
local BadgeDetailsSheetState = require(script.Parent.BadgeDetailsSheetState)

require(Parent.Navigation)

local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local React = require(Parent.React)
local useNavigation = require(Parent.Navigation).useNavigation
local useRouteName = require(Parent.Navigation).useRouteName
local useNavigationFocus = require(Parent.Navigation).useNavigationFocus
local Responsive = require(Parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local CompositionTags = require(Parent.AppComposition).CompositionTags
local setIsBadgeDetailsSheetOpen = BadgeDetailsSheetState.setIsBadgeDetailsSheetOpen
local FFlagSduiPageEntryUseSharedHooks = require(Parent.SharedFlags).FFlagSduiPageEntryUseSharedHooks
local v20 = game:DefineFastFlag("LuaAppBadgeDetailsLargeSideSheetSize2", false)

local function getFromPropsOrNavigationParams(t1: {[any]: any}, s1: string) -- line: 41
	local v25 = t1.navigation and t1.navigation.getParam("extraProps")

	return t1[s1] or v25 and v25[s1]
end
local function BadgeDetailsPage(t2: {[any]: any}) -- line: 57
	-- upvalues: useTokens (copy), getBadgeDetailsPageKey (copy), React (copy), SduiLoadTimer (copy), useNavigation (copy), useRouteName (copy), useNavigationFocus (copy), useBreakpointXOrSmaller (copy), Responsive (copy), fetchBadgeDetailsPage (copy), setIsBadgeDetailsSheetOpen (copy), SduiFeatureEntryPoint (copy), SduiPageEntryPoint (copy), FFlagSduiPageEntryUseSharedHooks (copy), CompositionTags (copy), Foundation (copy), v20 (copy)
	local v29 = useTokens()
	local v30 = t2.navigation and t2.navigation.getParam("extraProps")
	local v31 = t2.badgeId or v30 and v30.badgeId
	local v32 = getBadgeDetailsPageKey(v31)
	local v33 = React.useMemo(function() -- line: 63
		-- upvalues: t2 (copy), SduiLoadTimer (copy)
		local v41 = t2
		local v42 = v41.navigation and v41.navigation.getParam("extraProps")

		return v41.pageTimer or v42 and v42.pageTimer or SduiLoadTimer.createLoadTimer("BadgeDetails")
	end, {})
	local v34 = useNavigation()
	local v35 = useRouteName()
	local v36 = useNavigationFocus()
	local v37 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v38 = React.useCallback(function() -- line: 72
		-- upvalues: v35 (copy), v36 (copy), v34 (copy)
		if v35 == "BadgeDetails" and v36 then
			v34.goBack()
		end
	end, {
		v34,
		v35,
		v36
	})

	React.useEffect(function() -- line: 78
		-- upvalues: v31 (copy), fetchBadgeDetailsPage (copy), v33 (copy)
		if v31 then
			fetchBadgeDetailsPage(v31, v33)
		end
	end, {
		v31,
		v33
	})
	React.useEffect(function() -- line: 84
		-- upvalues: v37 (copy), v36 (copy), setIsBadgeDetailsSheetOpen (copy)
		local v43 = not v37 and v36

		setIsBadgeDetailsSheetOpen(v43)

		return function() -- line: 88
			-- upvalues: setIsBadgeDetailsSheetOpen (copy)
			setIsBadgeDetailsSheetOpen(false)
		end
	end, {
		v37,
		v36
	})

	local v39 = React.useRef(nil)
	local v40 = React.useCallback(function() -- line: 97
		-- upvalues: React (copy), SduiFeatureEntryPoint (copy), v32 (copy), v33 (copy)
		return React.createElement(SduiFeatureEntryPoint, {
			appPage = "BadgeDetails",
			identifier = "badge_details_context_menu",
			shouldDisplayError = false,
			shouldDisplayLoading = false,
			configKey = v32,
			AutomaticSize = Enum.AutomaticSize.XY,
			pageTimer = v33
		})
	end, {
		v32,
		v33
	})

	if v31 == nil then
		return nil
	end

	if v37 then
		return React.createElement(SduiPageEntryPoint, {
			appPage = "BadgeDetails",
			includeNavigationHeaderBar = true,
			configKey = v32,
			identifier = if not FFlagSduiPageEntryUseSharedHooks then v32 .. "_" .. "badge_details_feed" else "badge_details_feed",
			pageTimer = v33,
			renderUtilities = v40,
			contentTag = CompositionTags.ContentRegion.Body
		})
	end

	return React.createElement(Foundation.Sheet.Root, {
		snapPoints = { 1 },
		isOpen = v36,
		displaySize = if not v20 then nil else Foundation.Enums.DialogSize.Large,
		onClose = v38
	}, {
		Header = React.createElement(Foundation.Sheet.Header, {
			hasCloseAffordance = true
		}, {
			ContextMenu = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				ContextMenuEntryPoint = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					EntryPoint = v40()
				})
			})
		}),
		Content = React.createElement(Foundation.Sheet.Content, {
			scrollingFrameRef = v39
		}, React.createElement(SduiPageEntryPoint, {
			appPage = "BadgeDetails",
			includeNavigationHeaderBar = false,
			disableRootPadding = true,
			snackbarPortalLayoutOrder = 2147483647,
			configKey = v32,
			identifier = if not FFlagSduiPageEntryUseSharedHooks then v32 .. "_" .. "badge_details_feed" else "badge_details_feed",
			pageTimer = v33,
			backgroundStyle = v29.Color.None,
			scrollingFrameRef = v39
		}))
	})
end

return React.memo(BadgeDetailsPage)
