local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local FreeFlowCarousel = UIBlox.App.Container.Carousel.FreeFlowCarousel
local GAME_CAROUSEL_PADDING = require(CorePackages.Workspace.Packages.DiscoveryTypes).Constants.GAME_CAROUSEL_PADDING
local v9 = Roact.PureComponent:extend("LoadableCarousel")

v9.validateProps = t.strictInterface({
	fetchingStatus = t.string,
	itemList = t.array(t.any),
	renderItem = t.callback,
	identifier = t.optional(t.callback),
	headerText = t.optional(t.string),
	onSeeAll = t.optional(t.callback),
	itemSize = t.optional(t.Vector2),
	itemPadding = t.optional(t.number),
	carouselMargin = t.optional(t.number),
	innerPadding = t.optional(t.number),
	layoutOrder = t.optional(t.integer),
	loadNext = t.optional(t.callback),
	onRetry = t.optional(t.callback)
})
v9.defaultProps = {
	carouselMargin = GAME_CAROUSEL_PADDING
}

function v9.init(p1) -- line: 65
	function p1.renderOnLoading() -- line: 66
		return nil
	end
end
function v9.render(p2) -- line: 71
	-- upvalues: Roact (copy), FreeFlowCarousel (copy), LoadingStateContainer (copy), RetrievalStatus (copy)
	local v12 = Roact.createElement(FreeFlowCarousel, {
		identifier = p2.props.identifier,
		headerText = p2.props.headerText,
		onSeeAll = p2.props.onSeeAll,
		itemList = p2.props.itemList,
		renderItem = p2.props.renderItem,
		itemSize = p2.props.itemSize,
		itemPadding = p2.props.itemPadding,
		carouselMargin = p2.props.carouselMargin,
		innerPadding = p2.props.innerPadding,
		layoutOrder = p2.props.layoutOrder,
		loadNext = p2.props.loadNext
	})

	return Roact.createElement(LoadingStateContainer, {
		dataStatus = RetrievalStatus.fromRawValue(p2.props.fetchingStatus),
		onRetry = p2.props.onRetry,
		renderOnLoading = p2.renderOnLoading,
		renderOnLoaded = function() -- line: 90
			-- upvalues: v12 (copy)
			return v12
		end
	})
end

return v9
