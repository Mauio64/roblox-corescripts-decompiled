local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/cBc")
local omniFeedTypes = module.OmniFeedTypes
local omniFeedConstants = module.OmniFeedConstants
require("@game/CorePackages/Workspace/Packages/AppCommonLib")
require("@luauforge/bundled/dDZ")
local Cryo = require(CorePackages.Packages.Cryo)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local appPage = RobloxAppEnums.AppPage
local uiMode = RobloxAppEnums.UiMode
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
require("@luauforge/bundled/gDL")

local module3 = require("@luauforge/bundled/hQb")
local module4 = require("@luauforge/bundled/hQc")

local modules = require("@luauforge/bundled/dtb").Modules
local feedItemModel = modules.Personalization.OmniFeed.DataStore.FeedItemModel
local omniFeedProps = modules.Personalization.OmniFeed.OmniFeedProps

local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local fFlagLuaAppRemoveOmniFeedDividersAndExtraPadding = SharedFlags.FFlagLuaAppRemoveOmniFeedDividersAndExtraPadding
local fFlagHomepagePromptsPaddingFix = SharedFlags.FFlagHomepagePromptsPaddingFix
local fFlagLuaAppUseSortsWithDividersFString = SharedFlags.FFlagLuaAppUseSortsWithDividersFString
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local fStringLuaAppSortsWithDividers = SharedFlags.FStringLuaAppSortsWithDividers
local fFlagUseOmniFeedDividerOverrides = SharedFlags.FFlagUseOmniFeedDividerOverrides
local fIntOmniFeedDividerHeightOverride = SharedFlags.FIntOmniFeedDividerHeightOverride
local fIntOmniFeedDividerPaddingOverride = SharedFlags.FIntOmniFeedDividerPaddingOverride
local fFlagLuaAppEnableRelativeGuiHomeForAll = SharedFlags.FFlagLuaAppEnableRelativeGuiHomeForAll
local fFlagLuaAppEnableRelativeGuiHomeWithIxp = SharedFlags.FFlagLuaAppEnableRelativeGuiHomeWithIxp

local set = {}

if fFlagLuaAppUseSortsWithDividersFString then
	for k in fStringLuaAppSortsWithDividers:gmatch("(%w+)") do
		set[k] = true
	end
end

local SORT_INDEX_SELECTION_ORDER_MULTIPLIER = module.Constants.SORT_INDEX_SELECTION_ORDER_MULTIPLIER
local SORT_SELECTION_ORDER_BASE = module.Constants.SORT_SELECTION_ORDER_BASE

local function scaleSizeForPlatform(p2, p3)
	return p2 * p3.Stroke.Standard
end

local function isGridTile(p2): boolean
	local v5 = p2.treatmentProps.topicLayoutData
		and p2.treatmentProps.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]

	return v5 == omniFeedConstants.ComponentTypeDataKeys.GridTile
		or v5 == omniFeedConstants.ComponentTypeDataKeys.EventTile
end

local function shouldAddDividerOrExtraPadding(p2, p3, k, omniFeedItem, omniFeedItems, pageContext, p4)
	local v5 = false
	local v6 = false

	if not ((module4 and 0 or p4 and 0 or 1) + p2 - 1 < k and k < p3) then
		return pageContext == appPage.SearchPage and k < p3 or v6, v5
	end

	local v7 = omniFeedItems[k - 1]
	local v8 = omniFeedItems[k]
	local v9 = omniFeedItems[k + 1]

	if v7 and v7.pageSection ~= v8.pageSection then
		v7 = nil
	end

	if v9 and v9.pageSection ~= v8.pageSection then
		v9 = nil
	end

	if fFlagLuaAppUseSortsWithDividersFString then
		v6 = v8.itemId and v8.itemId.topicId and set[v8.itemId.topicId] and true
			or v9 and v9.itemId and v9.itemId.topicId and set[v9.itemId.topicId] and true
			or false
	end

	if
		omniFeedItem.treatmentType == omniFeedTypes.HomeGameGrid
		and v9
		and v9.treatmentType ~= omniFeedTypes.HomeGameGrid
		or omniFeedItem.treatmentType ~= omniFeedTypes.HomeGameGrid
		and v7
		and v7.treatmentType == omniFeedTypes.HomeGameGrid
		and v9
		and v9.treatmentType == omniFeedTypes.HomeGameGrid
	then
		v6 = true
	elseif p4 then
		v5 = true
	elseif isSubjectToDesktopPolicies() then
		if
			omniFeedItem.treatmentType == omniFeedTypes.Carousel
			and v9 ~= nil
			and v9.treatmentType == omniFeedTypes.HomeGameGrid
		then
			local v10 = omniFeedItem.treatmentProps.topicLayoutData
				and omniFeedItem.treatmentProps.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]

			v5 = v10 == omniFeedConstants.ComponentTypeDataKeys.GridTile
				or v10 == omniFeedConstants.ComponentTypeDataKeys.EventTile

			if v5 then
				local v11 = v9.treatmentProps.topicLayoutData
					and v9.treatmentProps.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]

				v5 = v11 == omniFeedConstants.ComponentTypeDataKeys.GridTile
					or v11 == omniFeedConstants.ComponentTypeDataKeys.EventTile
			end
		else
			v5 = false
		end
	end

	return pageContext == appPage.SearchPage and k < p3 or v6, v5
end

return React.memo(function(props)
	local v5 = useDesignTokens()
	local color = useStyle().Theme.BackgroundContrast.Color
	local v6 = useUiModeInfo().uiMode == uiMode.TenFoot

	local children = {}

	children.Layout = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical
	})

	local v7 = 1
	local v8 = props.layoutPadding or 0

	local v9 = v8 / 2

	if fFlagUseOmniFeedDividerOverrides then
		if fIntOmniFeedDividerPaddingOverride >= 0 then
			v8 = fIntOmniFeedDividerPaddingOverride * v5.Stroke.Standard
		end

		if fIntOmniFeedDividerHeightOverride >= 0 then
			v9 = fIntOmniFeedDividerHeightOverride * v5.Stroke.Standard
		end
	end

	local omniFeedItems = props.omniFeedItems
	local v10 = nil
	local v11 = nil

	for i = 1, #omniFeedItems do
		if omniFeedItems[i].pageSection ~= props.omniFeedPageSection then
			continue
		end

		v11 = i
		v10 = v10 or i
	end

	local v12 = v10 or 1
	local v13 = v11 or #omniFeedItems

	local numberOfItemsToBeRendered = props.numberOfItemsToBeRendered or v13 - v12 + 1

	local pageContext = props.pageContext

	local topMargin = props.topMargin or 0
	local bottomMargin = props.bottomMargin or 0
	local v14 = 1
	local flag = true

	for k, omniFeedItem in omniFeedItems do
		if numberOfItemsToBeRendered < k - v12 + 1 then
			break
		end

		local treatmentProps = omniFeedItem.treatmentProps or {}
		local uniqueNameForAnalytics = feedItemModel.getUniqueNameForAnalytics(omniFeedItem)
		local v15 = SORT_SELECTION_ORDER_BASE + k * SORT_INDEX_SELECTION_ORDER_MULTIPLIER
		local v16 = omniFeedProps.new(
			k,
			v14,
			props.onItemsUpdatedSignalRef and props.onItemsUpdatedSignalRef.current,
			props.refreshSignalRef and props.refreshSignalRef.current,
			pageContext,
			props.scrollingFrameRef,
			props.sduiContext,
			v15,
			props.defaultContainerSize,
			props.appCompositionEnabled,
			props.videoPlaybackContext,
			props.refreshFeed
		)

		local joined = Cryo.Dictionary.join({ [omniFeedProps.key] = v16 }, treatmentProps)

		if fFlagHomepagePromptsPaddingFix and omniFeedItem.treatmentType == omniFeedTypes.Prompts then
			joined = Cryo.Dictionary.join(joined, {
				topPadding = v8,
				bottomPadding = v8
			})
		end

		if v14 then
			local numberOfRows = feedItemModel.getNumberOfRows(omniFeedItem)

			v14 = if numberOfRows then v14 + numberOfRows else nil
		end

		if props.omniFeedPageSection ~= omniFeedItem.pageSection then
			continue
		end

		local v18 = not flag
		local v19

		if fFlagHomepagePromptsPaddingFix then
			v19 = omniFeedItem.treatmentType == omniFeedTypes.Prompts
			local omniFeedItem2 = omniFeedItems[k - 1]
			local v20 = omniFeedItem2 ~= nil and omniFeedItem2.treatmentType == omniFeedTypes.Prompts
			v18 = v18 and not (v19 or v20)
		else
			v19 = false
		end

		local v20 = v18 and omniFeedItem.treatmentType == omniFeedTypes.UpsellCard
		local sortIndex = if omniFeedItem.itemId then omniFeedItem.itemId.sortIndex else nil
		local v21 = if sortIndex and props.sortsData then props.sortsData[sortIndex] else nil

		if v21 and (not v21.topic or v21.topic == "") then
			v18 = false
		end

		if v18 then
			local v22 = "feedPaddingTop_" .. tostring(k)
			local createElement = React.createElement

			local v25 = if v20 then UDim2.new(1, 0, 0, v5.Size.Size_300) else UDim2.new(1, 0, 0, v8)
			children[v22] = createElement("Frame", {
				Size = v25,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = v7
			})

			v7 += 1
		end

		local v22 = "feedItem_" .. tostring(k)
		local createElement = React.createElement
		local v24 = {
			omniFeedItemType = omniFeedItem.treatmentType,
			layoutOrder = v7,
			feedItemNameId = uniqueNameForAnalytics,
			itemProps = joined,
			itemIndex = k,
			impressionsTag = props.impressionsTag,
			zIndex = numberOfItemsToBeRendered - k,
			defaultFocusRef = 0
		}
		local v25 = if k == 1 then props.defaultFocusRef else nil
		v24.defaultFocusRef = v25
		children[v22] = createElement(module3, v24)

		v7 += 1

		if not (fFlagLuaAppRemoveOmniFeedDividersAndExtraPadding or fFlagHomepagePromptsPaddingFix and v19) then
			local v26, v27 = shouldAddDividerOrExtraPadding(
				v12,
				v13,
				k,
				omniFeedItem,
				omniFeedItems,
				pageContext,
				v6
			)

			if v26 or v27 then
				children["feedPaddingBottom_" .. tostring(k)] = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, v8),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = v7
				})

				v7 += 1
			end

			if v26 then
				children["feedDivider_" .. tostring(k)] = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, v9),
					BackgroundTransparency = 0,
					BackgroundColor3 = color,
					BorderSizePixel = 0,
					LayoutOrder = v7
				})

				v7 += 1
			end
		end

		if k - v12 + 1 == numberOfItemsToBeRendered and props.hasNextPage then
			children["loadingBlank_" .. tostring(k)] = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 10),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = v7
			})

			v7 += 1
		end

		if flag then
			flag = false
		end
	end

	children.Padding = React.createElement(React.Fragment, nil, {
		PaddingTop = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, topMargin),
			BackgroundTransparency = 1,
			LayoutOrder = 0
		}),
		PaddingBottom = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, bottomMargin),
			BackgroundTransparency = 1,
			LayoutOrder = v7
		})
	})

	local v15 = (fFlagLuaAppEnableRelativeGuiHomeForAll or fFlagLuaAppEnableRelativeGuiHomeWithIxp)
		and props.enableRelativeGui
		and "RelativeGui"
		or "Frame"

	local createElement = React.createElement
	local v16 = {
		["Size"] = nil,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local tag = React.Tag
	local v17 = if fFlagLuaAppCompositionAlways or props.appCompositionEnabled then props.contentTag or compositionTags.ContentRegion.Body else nil
	v16[tag] = v17
	return createElement(v15, v16, children)
end)
