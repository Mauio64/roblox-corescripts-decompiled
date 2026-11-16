local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local CatalogSduiEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/CatalogSduiEntryPoint")
local getCatalogPageIdentifier = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Utils/getCatalogPageIdentifier")

local MarketplaceFeedSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/MarketplaceFeedSkeleton/MarketplaceFeedSkeleton")
local CATALOG_RESULTS_HORIZONTAL_MARGIN = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants").CATALOG_RESULTS_HORIZONTAL_MARGIN

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXMarketplaceLoadingSkeleton = AvatarExperienceFlags.FFlagAXMarketplaceLoadingSkeleton
local fFlagAXSduiFeedPublishesBreakpoint = AvatarExperienceFlags.FFlagAXSduiFeedPublishesBreakpoint
local fFlagAXMarketplaceBreakpointMismatchCounter = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointMismatchCounter
local fFlagAXSduiFeedMaintainScrollOnSeeAll = AvatarExperienceFlags.FFlagAXSduiFeedMaintainScrollOnSeeAll
local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags").FFlagAXScrollTelemetryIntegration2

local function CatalogSduiFeedEntryPoint(props, ref)
	local v5 = if fFlagAXMarketplaceLoadingSkeleton then React.createElement(MarketplaceFeedSkeleton) else nil

	local createElement = React.createElement
	local v7 = {
		context = props.context,
		identifier = getCatalogPageIdentifier(props.context),
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		Position = props.Position,
		loadingSlot = v5,
		onScroll = props.onScroll,
		requestImpressionsSignal = props.requestImpressionsSignal,
		breakpointOptions = 0,
		scrollPositionRef = 0,
		scrollRestoreRef = 0,
		scrollPerformanceIntervalName = 0,
		ref = 0
	}
	local v8

	if fFlagAXSduiFeedPublishesBreakpoint or fFlagAXMarketplaceBreakpointMismatchCounter then
		v8 = { horizontalInset = 0, publishToStore = 0, measurementSource = 0 }

		local v9 = if fFlagAXSduiFeedPublishesBreakpoint then CATALOG_RESULTS_HORIZONTAL_MARGIN * 2 else nil
		v8.horizontalInset = v9

		v8.publishToStore = fFlagAXSduiFeedPublishesBreakpoint and true or nil
		v8.measurementSource = fFlagAXMarketplaceBreakpointMismatchCounter and "SduiFeed" or nil
	end

	v7.breakpointOptions = v8

	local v9 = if fFlagAXSduiFeedMaintainScrollOnSeeAll then props.scrollPositionRef else nil
	v7.scrollPositionRef = v9
	local v10 = if fFlagAXSduiFeedMaintainScrollOnSeeAll then props.scrollRestoreRef else nil
	v7.scrollRestoreRef = v10

	local v11 = if fFlagAXScrollTelemetryIntegration2 then props.scrollPerformanceIntervalName else nil
	v7.scrollPerformanceIntervalName = v11

	v7.ref = ref
	return createElement(CatalogSduiEntryPoint, v7)
end

return React.forwardRef(CatalogSduiFeedEntryPoint)
