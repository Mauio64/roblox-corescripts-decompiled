local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)

local selfViewVisibilityUpdatedSignal = require("@game/CoreGui/RobloxGui/Modules/SelfView/selfViewVisibilityUpdatedSignal")
local module2 = require("@luauforge/bundled/egD")

local module3 = require("@luauforge/bundled/egE")
local module4 = require("@luauforge/bundled/egI")

local Foundation = require(CorePackages.Packages.Foundation)
local button = Foundation.Button
local view = Foundation.View
local inputSize = Foundation.Enums.InputSize

local extended = Roact.PureComponent:extend("RefreshScrollingFrameWithLoadMore")

extended.defaultProps = { preloadDistance = 2000 }

function extended:init()
	self._isMounted = false

	if type(self.props.forwardRef) == "table" then
		self.scrollingFrameRef = self.props.forwardRef
	else
		self.scrollingFrameRef = Roact.createRef()
	end

	function self.setScrollingFrameRef(current)
		self.scrollingFrameRef.current = current

		if self.props.forwardRef and type(self.props.forwardRef) == "function" then
			self.props.forwardRef(current)
		end
	end

	self.scrollToTopSignal = selfViewVisibilityUpdatedSignal.new()

	function self.scrollToTop()
		self.scrollToTopSignal:fire()
	end

	self.state = { isLoadingMore = false, isScrollable = false }

	self.lastLoadMoreThreshold = 0
	self.lastCanvasHeight = 0

	function self.loadMore()
		local onLoadMore = self.props.onLoadMore

		self:setState({ isLoadingMore = true })

		onLoadMore():andThen(function()
			if self._isMounted then
				self:setState({ isLoadingMore = false })
			end
		end, function()
			if self._isMounted then
				self:setState({ isLoadingMore = false })
			end

			self.lastLoadMoreThreshold = 0
		end)
	end

	self.lastScrollPosition = 0
	self.scrollMovementDirection = module2.Backward
	function self.checkScrollDirectionChanged(p2)
		local y = p2.CanvasPosition.Y

		if y < 0 or y == self.lastScrollPosition then
			return
		end

		local v5 = if self.lastScrollPosition < y then module2.Forward else module2.Backward

		if v5 ~= self.scrollMovementDirection then
			if self.props.onScrollDirectionChanged ~= nil then
				self.props.onScrollDirectionChanged(v5)
			end

			self.scrollMovementDirection = v5
		end

		self.lastScrollPosition = y
	end

	function self.onCanvasPositionChanged(data)
		local preloadDistance = self.props.preloadDistance
		local onLoadMore = self.props.onLoadMore
		local isLoadingMore = self.state.isLoadingMore
		local y = data.CanvasPosition.Y

		local v5 = onLoadMore and not isLoadingMore

		if v5 then
			v5 = y > 0 and not self.props.loadMoreButtonText
		end

		if v5 then
			if data.CanvasSize.Y.Scale ~= 0 then
				warn("RefreshScrollingFrame: Scrollingframe.CanvasSize.Y.Scale is not 0!\n\t\t\t\t\tContent loading would not work properly.")

				return
			end

			local absoluteWindowSize = self._absoluteWindowSize or data.AbsoluteWindowSize
			local v6 = data.CanvasSize.Y.Offset - absoluteWindowSize.Y - preloadDistance

			local v7 = v6 < y and v6 ~= self.lastLoadMoreThreshold and v6 ~= self.lastLoadMoreThreshold + 56

			if v7 then
				self.lastLoadMoreThreshold = v6
				self.loadMore()
			end
		end

		if self.props.onCanvasPositionChangedCallback then
			self.props.onCanvasPositionChangedCallback(y)
		end

		if self.props.onScrollDirectionChanged ~= nil then
			self.checkScrollDirectionChanged(data)
		end
	end

	function self.onAbsoluteWindowSizeChanged(p2)
		self._absoluteWindowSize = p2.AbsoluteWindowSize
		self.onCanvasSizeChanged(p2)
	end

	function self.onCanvasSizeChanged(data)
		local offset = data.CanvasSize.Y.Offset
		local y = (self._absoluteWindowSize or data.AbsoluteWindowSize).Y

		if offset < self.lastCanvasHeight and offset ~= self.lastCanvasHeight - 56 then
			self.lastLoadMoreThreshold = 0
		end

		self.lastCanvasHeight = offset

		if not (y ~= 0 and self._isMounted) then
			return
		end

		local v5 = y < offset

		if v5 ~= self.state.isScrollable then
			self:setState({ isScrollable = v5 })
		end

		local v6 = self.props.onLoadMore and not (self.state.isLoadingMore or v5)

		if v6 then
			v6 = data.CanvasPosition.Y > 0 and not self.props.loadMoreButtonText
		end

		if v6 and not self.props.initializing then
			self.loadMore()
		end
	end

	function self.createFooter()
		local isLoadingMore = self.state.isLoadingMore

		if isLoadingMore or not (self.props.onLoadMore and self.props.loadMoreButtonText) then
			return isLoadingMore
				and Roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 56) },
					{ LoadingBar = Roact.createElement(module3) }
				)
		end

		return Roact.createElement(
			view,
			{
				tag = "size-full-1200 row align-x-center align-y-center padding-x-xlarge padding-bottom-xxlarge"
			},
			{ Roact.createElement(button, {
					size = inputSize.Large,
					fillBehavior = "Fill",
					onActivated = self.loadMore,
					text = self.props.loadMoreButtonText
				}) }
		)
	end
end

function extended:didMount()
	self._isMounted = true

	local current = self.scrollingFrameRef.current

	if current then
		self.onCanvasSizeChanged(current)
		self._absoluteWindowSize = current.AbsoluteWindowSize
	end
end

function extended:willUnmount()
	self._isMounted = false
end

function extended.render(props)
	local v6 = Cryo.Dictionary.join(props.props, {
		onCanvasPositionChangedCallback = props.onCanvasPositionChanged,
		onCanvasSizeChangedCallback = props.onCanvasSizeChanged,
		onAbsoluteWindowSizeChangedCallback = props.onAbsoluteWindowSizeChanged,
		createFooter = props.createFooter,
		onLoadMore = Cryo.None,
		bottomPadding = props.props.bottomPadding,
		[Roact.Children] = Cryo.None,
		[Roact.Ref] = props.setScrollingFrameRef
	})

	return Roact.createElement(module4, v6, props.props[Roact.Children])
end

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
