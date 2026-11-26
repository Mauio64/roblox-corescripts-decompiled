local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local Foundation = require(CorePackages.Packages.Foundation)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local module2 = require("@luauforge/deferred/gPt")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
require("@luauforge/deferred/hkx")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local module5 = require("@luauforge/bundled/gJS")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local module6 = require("@luauforge/bundled/gTf")
local module7 = require("@luauforge/bundled/fvR")
local module8 = require("@luauforge/deferred/gTt")
local grid = module2.GridComponents.Grid
local module9 = require("@luauforge/deferred/haY")
local module10 = require("@luauforge/deferred/haZ")
local module11 = require("@luauforge/deferred/hbl")
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags

local module12 = require("@luauforge/deferred/hbo")
local module13 = require("@luauforge/deferred/hbu")
local module14 = require("@luauforge/deferred/hbv")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local function AvatarSwitcherPage(props)
	local v5 = useNavigation()
	local v6 = Foundation.Hooks.useTokens()

	local v7 = RoactGamepad.useRefCache()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v8 = useLocalization({ title = "Feature.Avatar.Label.Title.AvatarSwitcher" })

	local v9 = useSelector(module5, getUseSelectorDeepEquals())

	local v10 = React.useCallback(function(props2)
		local item = props2.item

		if props.shouldRenderSettingsTile(item) then
			return React.createElement(module11, {
				itemWidth = props.gridMetrics.itemWidth,
				index = props2.index,
				ref = v7[props2.index]
			})
		end

		return React.createElement(module10, {
			itemWidth = props.gridMetrics.itemWidth,
			itemId = item,
			index = props2.index,
			ref = v7[props2.index],
			isSelected = props.itemIdsToIsWearing[item],
			hasItemFromCurrentPageEquipped = props.hasItemFromCurrentPageEquipped,
			impressionsTag = props.impressionsTag,
			impressionsSchema = "defaultItem",
			gridInformation = props2.gridInformation
		})
	end, { props.gridMetrics, props.itemIdsToIsWearing, props.shouldRenderSettingsTile })

	local v11 = React.useCallback(function()
		return React.createElement(Foundation.IconButton, {
			size = Foundation.Enums.IconSize.Medium,
			icon = "icons/common/settings",
			onActivated = function()
				v5.navigate(avatarScreen.ManageOutfitPage)
			end
		})
	end, {})

	local createElement = React.createElement
	local frame = focusable.Frame
	local v12 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

	local v13 = {
		AvatarSwitcherPageSceneInteractionFrame = React.createElement(module6),
		AvatarSwitcherExperienceView = 0
	}
	local createElement2 = React.createElement
	local v15 = {
		allowAdaptiveScrolling = true,
		showRobuxBalance = false,
		showUndoRedo = true,
		showSaveButton = false,
		isSceneFullView = props.isSceneFullView,
		isUIFullView = props.isUIFullView,
		topBar = React.createElement(module7.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = v8.title,
			transparentBackground = v9,
			leftItem = module7.makeBackButton(props.onBackButtonPressed),
			rightItems = { v11 },
			ref = ref,
			NextSelectionDown = v7[1],
			ZIndex = 3
		})
	}

	local createElement3 = React.createElement
	local view = Foundation.View
	local v17 = {
		tag = "bg-surface-0 size-full-full",
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
	}

	local createElement4 = React.createElement
	local v20 = {
		onThresholdReached = props.onScrollingFrameThresholdReached,
		onCanvasPositionChanged = props.onCanvasPositionChanged
	}
	local v21 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v6.Gap.Medium)
		}),
		AvatarSwitcherGridContainer = React.createElement(Foundation.View, {
			tag = "auto-xy size-full-0",
			padding = {
				left = UDim.new(0, v6.Size.Size_400),
				right = UDim.new(0, v6.Size.Size_400),
				bottom = UDim.new(0, v6.Size.Size_1000)
			},
			LayoutOrder = 1
		}, {
			AvatarSwitcherGrid = React.createElement(grid, {
				itemsPerRow = props.gridMetrics.itemsPerRow,
				renderItem = v10,
				items = props.itemIds,
				gapVertical = v6.Size.Size_400,
				gapHorizontal = v6.Size.Size_300,
				getItemId = function(p2)
					return p2
				end,
				ref = ref2
			})
		}),
		ImpressionsReporter = React.createElement(module12, {
			parentRef = ref2,
			pageFilter = props.impressionsPageFilter,
			onRequestImpressionsSignal = props.requestImpressionsSignal,
			eventContext = module13(),
			eventName = "marketplaceOrganicFELog",
			impressionsTag = props.impressionsTag,
			impressionsSchema = "defaultItem",
			requestId = "",
			surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
			analyticsMetadata = props.analyticsMetadata,
			searchUuid = props.searchUuid
		}),
		LoadMoreButton = 0
	}

	local v22 = if props.showLoadMoreButton then React.createElement(module14, {
		onActivated = props.fetchMoreOutfits,
		LayoutOrder = 2
	}) else nil
	v21.LoadMoreButton = v22
	v13.AvatarSwitcherExperienceView = createElement2(module8, v15, {
		AvatarSwitcherContent = createElement3(view, v17, {
			AvatarSwitcherScrollingContent = createElement4(module9, v20, v21)
		})
	})
	return createElement(frame, v12, v13)
end

return AvatarSwitcherPage
