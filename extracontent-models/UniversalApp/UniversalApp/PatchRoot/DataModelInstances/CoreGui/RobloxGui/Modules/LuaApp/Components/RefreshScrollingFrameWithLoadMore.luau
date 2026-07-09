local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Signal = require(Modules.Common.Signal)
local ScrollMovementDirection = require(Modules.LuaApp.Enum.ScrollMovementDirection)
local LoadingBarWithTheme = require(Modules.LuaApp.Components.LoadingBarWithTheme)
local RefreshScrollingFrame = require(Modules.LuaApp.Components.RefreshScrollingFrame)
local Foundation = require(CorePackages.Packages.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local v13 = Roact.PureComponent:extend("RefreshScrollingFrameWithLoadMore")

v13.defaultProps = {
	preloadDistance = 2000
}

function v13.init(p1) -- line: 32
	-- upvalues: Roact (copy), Signal (copy), ScrollMovementDirection (copy), View (copy), Button (copy), InputSize (copy), LoadingBarWithTheme (copy)
	p1._isMounted = false

	if type(p1.props.forwardRef) == "table" then
		p1.scrollingFrameRef = p1.props.forwardRef
	else
		p1.scrollingFrameRef = Roact.createRef()
	end

	function p1.setScrollingFrameRef(p2) -- line: 40
		-- upvalues: p1 (copy)
		p1.scrollingFrameRef.current = p2

		if p1.props.forwardRef and type(p1.props.forwardRef) == "function" then
			p1.props.forwardRef(p2)
		end
	end

	p1.scrollToTopSignal = Signal.new()

	function p1.scrollToTop() -- line: 49
		-- upvalues: p1 (copy)
		p1.scrollToTopSignal:fire()
	end

	p1.state = {
		isLoadingMore = false,
		isScrollable = false
	}
	p1.lastLoadMoreThreshold = 0
	p1.lastCanvasHeight = 0

	function p1.loadMore() -- line: 61
		-- upvalues: p1 (copy)
		local onLoadMore = p1.props.onLoadMore

		p1:setState({
			isLoadingMore = true
		})
		onLoadMore():andThen(function() -- line: 68
			-- upvalues: p1 (copy)
			if p1._isMounted then
				p1:setState({
					isLoadingMore = false
				})
			end
		end, function() -- line: 74
			-- upvalues: p1 (copy)
			if p1._isMounted then
				p1:setState({
					isLoadingMore = false
				})
			end

			p1.lastLoadMoreThreshold = 0
		end)
	end

	p1.lastScrollPosition = 0
	p1.scrollMovementDirection = ScrollMovementDirection.Backward

	function p1.checkScrollDirectionChanged(p3) -- line: 89
		-- upvalues: p1 (copy), ScrollMovementDirection (copy)
		local CanvasPositionY = p3.CanvasPosition.Y

		if CanvasPositionY < 0 or CanvasPositionY == p1.lastScrollPosition then
			return
		end

		local v26 = if not (CanvasPositionY > p1.lastScrollPosition) then ScrollMovementDirection.Backward else ScrollMovementDirection.Forward

		if v26 ~= p1.scrollMovementDirection then
			if p1.props.onScrollDirectionChanged ~= nil then
				p1.props.onScrollDirectionChanged(v26)
			end

			p1.scrollMovementDirection = v26
		end

		p1.lastScrollPosition = CanvasPositionY
	end
	function p1.onCanvasPositionChanged(p4) -- line: 110
		-- upvalues: p1 (copy)
		local preloadDistance = p1.props.preloadDistance
		local onLoadMore = p1.props.onLoadMore
		local isLoadingMore = p1.state.isLoadingMore
		local CanvasPositionY = p4.CanvasPosition.Y

		if onLoadMore and (not isLoadingMore and (CanvasPositionY > 0 and not p1.props.loadMoreButtonText)) then
			if p4.CanvasSize.Y.Scale ~= 0 then
				warn("RefreshScrollingFrame: Scrollingframe.CanvasSize.Y.Scale is not 0!\n\t\t\t\tContent loading would not work properly.")

				return
			end

			local v32 = p1._absoluteWindowSize or p4.AbsoluteWindowSize
			local v33 = p4.CanvasSize.Y.Offset - v32.Y - preloadDistance

			if v33 < CanvasPositionY and (v33 ~= p1.lastLoadMoreThreshold and v33 ~= p1.lastLoadMoreThreshold + 56) then
				p1.lastLoadMoreThreshold = v33
				p1.loadMore()
			end
		end

		if p1.props.onCanvasPositionChangedCallback then
			p1.props.onCanvasPositionChangedCallback(CanvasPositionY)
		end

		if p1.props.onScrollDirectionChanged ~= nil then
			p1.checkScrollDirectionChanged(p4)
		end
	end
	function p1.onAbsoluteWindowSizeChanged(p5) -- line: 154
		-- upvalues: p1 (copy)
		p1._absoluteWindowSize = p5.AbsoluteWindowSize
		p1.onCanvasSizeChanged(p5)
	end
	function p1.onCanvasSizeChanged(p6) -- line: 159
		-- upvalues: p1 (copy)
		local YOffset = p6.CanvasSize.Y.Offset
		local Y = (p1._absoluteWindowSize or p6.AbsoluteWindowSize).Y

		if YOffset < p1.lastCanvasHeight and YOffset ~= p1.lastCanvasHeight - 56 then
			p1.lastLoadMoreThreshold = 0
		end

		p1.lastCanvasHeight = YOffset

		if Y == 0 then
			return
		end

		if not p1._isMounted then
			return
		end

		local v38 = Y < YOffset

		if v38 ~= p1.state.isScrollable then
			p1:setState({
				isScrollable = v38
			})
		end

		if p1.props.onLoadMore and (not p1.state.isLoadingMore and (not v38 and (p6.CanvasPosition.Y > 0 and not p1.props.loadMoreButtonText))) and not p1.props.initializing then
			p1.loadMore()
		end
	end
	function p1.createFooter() -- line: 204
		-- upvalues: p1 (copy), Roact (copy), View (copy), Button (copy), InputSize (copy), LoadingBarWithTheme (copy)
		local isLoadingMore = p1.state.isLoadingMore

		if not isLoadingMore and (p1.props.onLoadMore and p1.props.loadMoreButtonText) then
			return Roact.createElement(View, {
				tag = "size-full-1200 row align-x-center align-y-center padding-x-xlarge padding-bottom-xxlarge"
			}, { Roact.createElement(Button, {
				fillBehavior = "Fill",
				size = InputSize.Large,
				onActivated = p1.loadMore,
				text = p1.props.loadMoreButtonText
			}) })
		end

		return isLoadingMore and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 56)
		}, {
			LoadingBar = Roact.createElement(LoadingBarWithTheme)
		})
	end
end
function v13.didMount(p7) -- line: 229
	p7._isMounted = true

	local current = p7.scrollingFrameRef.current

	if current then
		p7.onCanvasSizeChanged(current)
		p7._absoluteWindowSize = current.AbsoluteWindowSize
	end
end
function v13.willUnmount(p8) -- line: 241
	p8._isMounted = false
end
function v13.render(p9) -- line: 245
	-- upvalues: Cryo (copy), Roact (copy), RefreshScrollingFrame (copy)
	local v19 = Cryo.Dictionary.join(p9.props, {
		onCanvasPositionChangedCallback = p9.onCanvasPositionChanged,
		onCanvasSizeChangedCallback = p9.onCanvasSizeChanged,
		onAbsoluteWindowSizeChangedCallback = p9.onAbsoluteWindowSizeChanged,
		createFooter = p9.createFooter,
		onLoadMore = Cryo.None,
		bottomPadding = p9.props.bottomPadding,
		[Roact.Children] = Cryo.None,
		[Roact.Ref] = p9.setScrollingFrameRef
	})

	return Roact.createElement(RefreshScrollingFrame, v19, p9.props[Roact.Children])
end

return Roact.forwardRef(function(p10, p11) -- line: 260
	-- upvalues: Roact (copy), v13 (copy), Cryo (copy)
	return Roact.createElement(v13, Cryo.Dictionary.join(p10, {
		forwardRef = p11
	}))
end)
