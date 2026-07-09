local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants

require(CorePackages.Workspace.Packages.AppCommonLib)
require(CorePackages.Workspace.Packages.ServerDrivenUi)

local Cryo = require(CorePackages.Packages.Cryo)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UiMode = RobloxAppEnums.UiMode
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo

require(CorePackages.Workspace.Packages.VideoUtils)

local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OmniFeedItem = require(Modules.Personalization.OmniFeed.OmniFeedItem)
local FFlagUpdateDividerStartBounds = require(Modules.Personalization.Flags.FFlagUpdateDividerStartBounds)
local Modules2 = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local FeedItemModel = Modules2.Personalization.OmniFeed.DataStore.FeedItemModel
local OmniFeedProps = Modules2.Personalization.OmniFeed.OmniFeedProps
local CompositionTags = require(CorePackages.Workspace.Packages.AppComposition).CompositionTags
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagLuaAppRemoveOmniFeedDividersAndExtraPadding = SharedFlags.FFlagLuaAppRemoveOmniFeedDividersAndExtraPadding
local FFlagHomepagePromptsPaddingFix = SharedFlags.FFlagHomepagePromptsPaddingFix
local FFlagLuaAppUseSortsWithDividersFString = SharedFlags.FFlagLuaAppUseSortsWithDividersFString
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local FStringLuaAppSortsWithDividers = SharedFlags.FStringLuaAppSortsWithDividers
local FFlagUseOmniFeedDividerOverrides = SharedFlags.FFlagUseOmniFeedDividerOverrides
local FIntOmniFeedDividerHeightOverride = SharedFlags.FIntOmniFeedDividerHeightOverride
local FIntOmniFeedDividerPaddingOverride = SharedFlags.FIntOmniFeedDividerPaddingOverride
local FFlagLuaAppEnableRelativeGuiHomeForAll = SharedFlags.FFlagLuaAppEnableRelativeGuiHomeForAll
local FFlagLuaAppEnableRelativeGuiHomeWithIxp = SharedFlags.FFlagLuaAppEnableRelativeGuiHomeWithIxp
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = SharedFlags.FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppHomeTouchAutoplay = SharedFlags.FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppGameCarouselAmpUpsellAction = SharedFlags.FFlagLuaAppGameCarouselAmpUpsellAction
local FFlagLuaAppsDefaultSelection = SharedFlags.FFlagLuaAppsDefaultSelection
local t1 = {}

if FFlagLuaAppUseSortsWithDividersFString then
	for match in FStringLuaAppSortsWithDividers:gmatch("(%w+)") do
		t1[match] = true
	end
end

local SORT_INDEX_SELECTION_ORDER_MULTIPLIER = DiscoveryTypes.Constants.SORT_INDEX_SELECTION_ORDER_MULTIPLIER
local SORT_SELECTION_ORDER_BASE = DiscoveryTypes.Constants.SORT_SELECTION_ORDER_BASE

local function scaleSizeForPlatform(n1: number, p1) -- line: 87
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return n1 * if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Stroke_100 else p1.Stroke.Standard
end
local function isGridTile(p2) -- line: 92
	-- upvalues: OmniFeedConstants (copy)
	local v47 = p2.treatmentProps.topicLayoutData and p2.treatmentProps.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]

	return v47 == OmniFeedConstants.ComponentTypeDataKeys.GridTile or v47 == OmniFeedConstants.ComponentTypeDataKeys.EventTile
end
local function shouldAddDividerOrExtraPadding(n2: number, n3: number, n4: number, p3, t2: {[any]: any}, s1: string, b1: boolean) -- line: 100
	-- upvalues: FFlagUpdateDividerStartBounds (copy), FFlagLuaAppUseSortsWithDividersFString (copy), t1 (copy), OmniFeedTypes (copy), isSubjectToDesktopPolicies (copy), OmniFeedConstants (copy), AppPage (copy)
	local v55 = false
	local v56 = false

	if n4 > ((if not FFlagUpdateDividerStartBounds then not b1 and 1 or 0 else 0)) + n2 - 1 and n4 < n3 then
		local v57 = t2[n4 - 1]
		local v58 = t2[n4]
		local v59 = t2[n4 + 1]

		if v57 and v57.pageSection ~= v58.pageSection then
			v57 = nil
		end

		if v59 and v59.pageSection ~= v58.pageSection then
			v59 = nil
		end

		if FFlagLuaAppUseSortsWithDividersFString and (v58.itemId and v58.itemId.topicId and t1[v58.itemId.topicId] or v59 and v59.itemId and v59.itemId.topicId and t1[v59.itemId.topicId]) then
			v56 = true
		end

		if p3.treatmentType == OmniFeedTypes.HomeGameGrid and v59 and v59.treatmentType ~= OmniFeedTypes.HomeGameGrid or p3.treatmentType ~= OmniFeedTypes.HomeGameGrid and v57 and v57.treatmentType == OmniFeedTypes.HomeGameGrid and v59 and v59.treatmentType == OmniFeedTypes.HomeGameGrid then
			v56 = true
		elseif b1 then
			v55 = true
		elseif isSubjectToDesktopPolicies() then
			v55 = false

			if p3.treatmentType == OmniFeedTypes.Carousel then
				v55 = false

				if v59 ~= nil then
					v55 = false

					if v59.treatmentType == OmniFeedTypes.HomeGameGrid then
						local v60 = p3.treatmentProps.topicLayoutData and p3.treatmentProps.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]

						v55 = v60 == OmniFeedConstants.ComponentTypeDataKeys.GridTile or v60 == OmniFeedConstants.ComponentTypeDataKeys.EventTile

						if v55 then
							local v61 = v59.treatmentProps.topicLayoutData and v59.treatmentProps.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]

							v55 = v61 == OmniFeedConstants.ComponentTypeDataKeys.GridTile or v61 == OmniFeedConstants.ComponentTypeDataKeys.EventTile
						end
					end
				end
			end
		end
	end

	if s1 == AppPage.SearchPage and n4 < n3 then
		v56 = true
	end

	return v56, v55
end

return React.memo(function(t3: {[any]: any}) -- line: 185
	-- upvalues: useDesignTokens (copy), useStyle (copy), useUiModeInfo (copy), UiMode (copy), React (copy), FFlagUseOmniFeedDividerOverrides (copy), FIntOmniFeedDividerPaddingOverride (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FIntOmniFeedDividerHeightOverride (copy), FeedItemModel (copy), SORT_SELECTION_ORDER_BASE (copy), SORT_INDEX_SELECTION_ORDER_MULTIPLIER (copy), OmniFeedProps (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), FFlagLuaAppHomeTouchAutoplay (copy), FFlagLuaAppGameCarouselAmpUpsellAction (copy), Cryo (copy), FFlagHomepagePromptsPaddingFix (copy), OmniFeedTypes (copy), OmniFeedItem (copy), FFlagLuaAppsDefaultSelection (copy), FFlagLuaAppRemoveOmniFeedDividersAndExtraPadding (copy), shouldAddDividerOrExtraPadding (copy), FFlagLuaAppEnableRelativeGuiHomeForAll (copy), FFlagLuaAppEnableRelativeGuiHomeWithIxp (copy), FFlagLuaAppCompositionAlways (copy), CompositionTags (copy)
	local v63 = useDesignTokens()
	local BackgroundContrastColor = useStyle().Theme.BackgroundContrast.Color
	local v65 = useUiModeInfo().uiMode == UiMode.TenFoot
	local t4 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		})
	}
	local n5 = 1
	local v68 = t3.layoutPadding or 0
	local v69 = v68 / 2

	if FFlagUseOmniFeedDividerOverrides then
		if FIntOmniFeedDividerPaddingOverride >= 0 then
			v68 = FIntOmniFeedDividerPaddingOverride * if not FFlagRenameDeprecatedUIBloxTokens then v63.Global.Stroke_100 else v63.Stroke.Standard
		end

		if FIntOmniFeedDividerHeightOverride >= 0 then
			v69 = FIntOmniFeedDividerHeightOverride * if not FFlagRenameDeprecatedUIBloxTokens then v63.Global.Stroke_100 else v63.Stroke.Standard
		end
	end

	local omniFeedItems = t3.omniFeedItems
	local v71 = nil
	local v72 = nil

	for i = 1, #omniFeedItems do
		if omniFeedItems[i].pageSection == t3.omniFeedPageSection then
			if not v71 then
				v71 = i
			end

			v72 = i
		end
	end

	local v74 = v71 or 1
	local v75 = v72 or #omniFeedItems
	local v76 = t3.numberOfItemsToBeRendered or v75 - v74 + 1
	local n6 = 1
	local pageContext = t3.pageContext
	local v79 = t3.topMargin or 0
	local v80 = t3.bottomMargin or 0
	local v81 = true

	for v82, v83 in omniFeedItems do
		if v76 < v82 - v74 + 1 then
			break
		end

		local v84 = v83.treatmentProps or {}
		local v85 = FeedItemModel.getUniqueNameForAnalytics(v83)
		local v86 = SORT_SELECTION_ORDER_BASE + v82 * SORT_INDEX_SELECTION_ORDER_MULTIPLIER
		local v87 = OmniFeedProps.new(v82, n6, t3.onItemsUpdatedSignalRef and t3.onItemsUpdatedSignalRef.current, t3.refreshSignalRef and t3.refreshSignalRef.current, pageContext, t3.scrollingFrameRef, t3.sduiContext, v86, t3.defaultContainerSize, t3.appCompositionEnabled, if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t3.onTileImageLoaded, if not FFlagLuaAppHomeTouchAutoplay then nil else t3.videoPlaybackContext, if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else t3.refreshFeed)
		local v88 = Cryo.Dictionary.join({
			[OmniFeedProps.key] = v87
		}, v84)

		if FFlagHomepagePromptsPaddingFix and v83.treatmentType == OmniFeedTypes.Prompts then
			v88 = Cryo.Dictionary.join(v88, {
				topPadding = v68,
				bottomPadding = v68
			})
		end

		if n6 then
			local v89 = FeedItemModel.getNumberOfRows(v83)

			n6 = if v89 then n6 + v89 else nil
		end

		if t3.omniFeedPageSection == v83.pageSection then
			local v90 = not v81
			local v91 = false

			if FFlagHomepagePromptsPaddingFix then
				v91 = v83.treatmentType == OmniFeedTypes.Prompts

				local v92 = omniFeedItems[v82 - 1]
				local v93 = v92 ~= nil and v92.treatmentType == OmniFeedTypes.Prompts

				v90 = v90 and (not v91 and not v93)
			end

			local v94 = v90 and v83.treatmentType == OmniFeedTypes.UpsellCard
			local v95 = if not v83.itemId then nil else v83.itemId.sortIndex
			local v96 = if not v95 or not t3.sortsData then nil else t3.sortsData[v95]

			if v96 and (not v96.topic or v96.topic == "") then
				v90 = false
			end

			if v90 then
				t4["feedPaddingTop_" .. tostring(v82)] = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = if not v94 then UDim2.new(1, 0, 0, v68) else UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then v63.Global.Space_150 else v63.Size.Size_300),
					LayoutOrder = n5
				})
				n5 += 1
			end

			t4["feedItem_" .. tostring(v82)] = React.createElement(OmniFeedItem, {
				omniFeedItemType = v83.treatmentType,
				layoutOrder = n5,
				feedItemNameId = v85,
				itemProps = v88,
				itemIndex = v82,
				impressionsTag = t3.impressionsTag,
				zIndex = v76 - v82,
				defaultFocusRef = if not FFlagLuaAppsDefaultSelection or v82 ~= 1 then nil else t3.defaultFocusRef
			})
			n5 += 1

			if not FFlagLuaAppRemoveOmniFeedDividersAndExtraPadding and (not FFlagHomepagePromptsPaddingFix or not v91) then
				local v97, v98 = shouldAddDividerOrExtraPadding(v74, v75, v82, v83, omniFeedItems, pageContext, v65)

				if v97 or v98 then
					t4["feedPaddingBottom_" .. tostring(v82)] = React.createElement("Frame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, v68),
						LayoutOrder = n5
					})
					n5 += 1
				end

				if v97 then
					t4["feedDivider_" .. tostring(v82)] = React.createElement("Frame", {
						BackgroundTransparency = 0,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, v69),
						BackgroundColor3 = BackgroundContrastColor,
						LayoutOrder = n5
					})
					n5 += 1
				end
			end

			if v76 == v82 - v74 + 1 and t3.hasNextPage then
				t4["loadingBlank_" .. tostring(v82)] = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 10),
					LayoutOrder = n5
				})
				n5 += 1
			end

			if v81 then
				v81 = false
			end
		end
	end

	t4.Padding = React.createElement(React.Fragment, nil, {
		PaddingTop = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, v79)
		}),
		PaddingBottom = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v80),
			LayoutOrder = n5
		})
	})

	local v99 = not FFlagLuaAppEnableRelativeGuiHomeForAll and not FFlagLuaAppEnableRelativeGuiHomeWithIxp and "Frame" or (not t3.enableRelativeGui and "Frame" or "RelativeGui")

	return React.createElement(v99, {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Tag] = if not FFlagLuaAppCompositionAlways and not t3.appCompositionEnabled then nil else t3.contentTag or CompositionTags.ContentRegion.Body
	}, t4)
end)
