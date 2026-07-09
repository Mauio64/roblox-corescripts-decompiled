local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)

require(Modules.AvatarExperience.AvatarEditor.Components.useAvatarSwitcherFrameProps)

local Grid = AvatarExperienceUIKit.GridComponents.Grid
local AvatarSwitcherScrollingContent = require(Modules.AvatarExperience.AvatarSwitcher.AvatarSwitcherScrollingContent)
local AvatarTileContainer = require(Modules.AvatarExperience.AvatarSwitcher.AvatarTile.AvatarTileContainer)
local SettingsTileContainer = require(Modules.AvatarExperience.AvatarSwitcher.SettingsTile.SettingsTileContainer)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local OrganicEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.OrganicEventImpressionsReporter)
local FStringAXImpressionsEventName = require(Modules.AvatarExperience.Flags.FStringAXImpressionsEventName)
local LoadMoreButton = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventoryItemsList.LoadMoreButton)
local RecommendedItems = require(Modules.AvatarExperience.Common.Components.RecommendedItems)
local useCategoryInfo = require(Modules.AvatarExperience.Common.Hooks.useCategoryInfo)

local function AvatarSwitcherFrame(p1) -- line: 32
	-- upvalues: Foundation (copy), RoactGamepad (copy), React (copy), useCategoryInfo (copy), Responsive (copy), SettingsTileContainer (copy), AvatarTileContainer (copy), AvatarSwitcherScrollingContent (copy), Grid (copy), RecommendedItems (copy), OrganicEventImpressionsReporter (copy), FStringAXImpressionsEventName (copy), ImpressionEnums (copy), LoadMoreButton (copy)
	local v20 = Foundation.Hooks.useTokens()
	local v21 = RoactGamepad.useRefCache()
	local v22 = React.useRef(nil)
	local v23 = React.useRef(nil)
	local v24 = useCategoryInfo()
	local v25 = Responsive.useOrientation() == Responsive.Keys.Portrait
	local v26 = React.useCallback(function(p2) -- line: 43
		-- upvalues: p1 (copy), React (copy), SettingsTileContainer (copy), v21 (copy), AvatarTileContainer (copy)
		local item = p2.item

		if p1.shouldRenderSettingsTile(item) then
			return (React.createElement(SettingsTileContainer, {
				squareAspectRatio = true,
				itemWidth = p1.gridMetrics.itemWidth,
				index = p2.index,
				ref = v21[p2.index]
			}))
		end

		return React.createElement(AvatarTileContainer, {
			impressionsSchema = "defaultItem",
			squareAspectRatio = true,
			itemWidth = p1.gridMetrics.itemWidth,
			itemId = item,
			index = p2.index,
			ref = v21[p2.index],
			isSelected = p1.itemIdsToIsWearing[item],
			hasItemFromCurrentPageEquipped = p1.hasItemFromCurrentPageEquipped,
			impressionsTag = p1.impressionsTag,
			gridInformation = p2.gridInformation
		})
	end, {
		v21,
		p1.gridMetrics,
		p1.itemIdsToIsWearing,
		p1.shouldRenderSettingsTile,
		p1.hasItemFromCurrentPageEquipped,
		p1.impressionsTag
	})

	return React.createElement(AvatarSwitcherScrollingContent, {
		onThresholdReached = p1.onScrollingFrameThresholdReached,
		onCanvasPositionChanged = p1.onCanvasPositionChanged,
		onAbsoluteWindowSizeChanged = p1.onAbsoluteSizeChanged
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v20.Gap.Medium)
		}),
		AvatarSwitcherGridContainer = React.createElement(Foundation.View, {
			tag = "auto-xy",
			LayoutOrder = 1,
			padding = {
				left = if not v25 then UDim.new(0, v20.Size.Size_250) else UDim.new(0, v20.Size.Size_400),
				right = UDim.new(0, v20.Size.Size_250),
				bottom = UDim.new(0, v20.Size.Size_250),
				top = UDim.new(0, v20.Size.Size_250)
			},
			Size = UDim2.fromScale(1, 0)
		}, {
			AvatarSwitcherGrid = React.createElement(Grid, {
				itemsPerRow = p1.gridMetrics.itemsPerRow,
				renderItem = v26,
				items = p1.itemIds,
				gapVertical = v20.Size.Size_300,
				gapHorizontal = v20.Size.Size_200,
				getItemId = function(p3) -- line: 106
					return p3
				end,
				ref = v22
			})
		}),
		RecommendedItemsContainer = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			padding = {
				left = UDim.new(0, v20.Size.Size_200),
				right = UDim.new(0, v20.Size.Size_200),
				bottom = UDim.new(0, v20.Size.Size_200)
			}
		}, {
			RecommendedItems = React.createElement(RecommendedItems, {
				categoryInfo = v24,
				itemDetailsPeekViewRefs = v21,
				baseRef = v23,
				listFrameRef = v22,
				sendShopForMoreAnalytics = function() -- line: 128
				end
			})
		}),
		ImpressionsReporter = React.createElement(OrganicEventImpressionsReporter, {
			eventName = "marketplaceOrganicFELog",
			impressionsSchema = "defaultItem",
			requestId = "",
			parentRef = v22,
			pageFilter = p1.impressionsPageFilter,
			onRequestImpressionsSignal = p1.requestImpressionsSignal,
			eventContext = FStringAXImpressionsEventName(),
			impressionsTag = p1.impressionsTag,
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
			analyticsMetadata = p1.analyticsMetadata,
			searchUuid = p1.searchUuid
		}),
		LoadMoreButton = if not p1.showLoadMoreButton then nil else React.createElement(LoadMoreButton, {
			LayoutOrder = 2,
			onActivated = p1.fetchMoreOutfits
		})
	})
end

return AvatarSwitcherFrame
