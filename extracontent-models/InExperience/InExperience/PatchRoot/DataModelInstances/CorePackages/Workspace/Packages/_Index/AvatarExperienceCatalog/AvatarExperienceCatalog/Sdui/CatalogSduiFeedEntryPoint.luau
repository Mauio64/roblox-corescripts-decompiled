local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local React = require(parent.React)
require(parent.Foundation)
local CatalogSduiEntryPoint = require(script.Parent.CatalogSduiEntryPoint)
local getCatalogPageIdentifier = require(script.Parent.Utils.getCatalogPageIdentifier)

local MarketplaceFeedSkeleton = require(AvatarExperienceCatalog.Components.MarketplaceFeedSkeleton.MarketplaceFeedSkeleton)
local Constants = require(AvatarExperienceCatalog.Constants)
local CATALOG_RESULTS_HORIZONTAL_MARGIN = Constants.CATALOG_RESULTS_HORIZONTAL_MARGIN

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMarketplaceLoadingSkeleton = AvatarExperienceFlags.FFlagAXMarketplaceLoadingSkeleton
local FFlagAXSduiFeedPublishesBreakpoint = AvatarExperienceFlags.FFlagAXSduiFeedPublishesBreakpoint
local FFlagAXMarketplaceBreakpointMismatchCounter = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointMismatchCounter
local FFlagAXSduiFeedMaintainScrollOnSeeAll = AvatarExperienceFlags.FFlagAXSduiFeedMaintainScrollOnSeeAll
local SharedFlags = require(parent.SharedFlags)
local FFlagAXScrollTelemetryIntegration2 = SharedFlags.FFlagAXScrollTelemetryIntegration2

local function CatalogSduiFeedEntryPoint(props, ref)
	local loadingSlot

	if FFlagAXMarketplaceLoadingSkeleton then
		loadingSlot = React.createElement(MarketplaceFeedSkeleton)
	end

	local createElement = React.createElement
	local v = {
		context = props.context,
		identifier = getCatalogPageIdentifier(props.context),
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		Position = props.Position,
		loadingSlot = loadingSlot,
		onScroll = props.onScroll,
		requestImpressionsSignal = props.requestImpressionsSignal,
		breakpointOptions = 0,
		scrollPositionRef = 0,
		scrollRestoreRef = 0,
		scrollPerformanceIntervalName = 0,
		ref = 0
	}
	local breakpointOptions

	if FFlagAXSduiFeedPublishesBreakpoint or FFlagAXMarketplaceBreakpointMismatchCounter then
		breakpointOptions = { horizontalInset = 0, publishToStore = 0, measurementSource = 0 }
		local horizontalInset

		if FFlagAXSduiFeedPublishesBreakpoint then
			horizontalInset = CATALOG_RESULTS_HORIZONTAL_MARGIN * 2
		end

		breakpointOptions.horizontalInset = horizontalInset

		breakpointOptions.publishToStore = FFlagAXSduiFeedPublishesBreakpoint and true or nil
		breakpointOptions.measurementSource = FFlagAXMarketplaceBreakpointMismatchCounter and "SduiFeed" or nil
	end

	v.breakpointOptions = breakpointOptions
	local scrollPositionRef

	if FFlagAXSduiFeedMaintainScrollOnSeeAll then
		scrollPositionRef = props.scrollPositionRef
	end

	v.scrollPositionRef = scrollPositionRef
	local scrollRestoreRef

	if FFlagAXSduiFeedMaintainScrollOnSeeAll then
		scrollRestoreRef = props.scrollRestoreRef
	end

	v.scrollRestoreRef = scrollRestoreRef
	local scrollPerformanceIntervalName

	if FFlagAXScrollTelemetryIntegration2 then
		scrollPerformanceIntervalName = props.scrollPerformanceIntervalName
	end

	v.scrollPerformanceIntervalName = scrollPerformanceIntervalName

	v.ref = ref
	return createElement(CatalogSduiEntryPoint, v)
end

return React.forwardRef(CatalogSduiFeedEntryPoint)
