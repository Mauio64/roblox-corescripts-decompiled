local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local Otter = dependencies.Otter
local t = dependencies.t
local Cryo = dependencies.Cryo
local withStyle = UIBlox.Style.withStyle
local getIconSize = UIBlox.App.ImageSet.getIconSize
local ExternalEventConnection = require(script.Parent.ExternalEventConnection)
local Spinner = require(script.Parent.Spinner)
local v14 = getIconSize(UIBlox.App.ImageSet.Enum.IconSize.Medium)
local _ = {
	Start = -240,
	End = 0
}
local _ = {
	Start = 1,
	End = 0
}
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}

local function lerp(p1, p2, p3) -- line: 37
	local v23 = math.min(1, (math.max(0, p3)))

	return p1 * (1 - v23) + p2 * v23
end

local v19 = Roact.PureComponent:extend("RefreshScrollingFrameNew")

v19.defaultProps = {
	ScrollingElement = "ScrollingFrame",
	refreshThreshold = 52,
	scrollingElementProps = {}
}
v19.validateProps = t.interface({
	ScrollingElement = t.union(t.string, t.callback, t.table),
	scrollingElementProps = t.optional(t.table),
	refreshThreshold = t.number,
	forwardRef = t.optional(t.table),
	onCanvasPositionChangedCallback = t.optional(t.callback),
	onStatusBarTapped = t.optional(t.callback),
	refresh = t.optional(t.callback),
	usesBuilderIcon = t.optional(t.boolean),
	[Roact.Children] = t.optional(t.any)
})

function v19.init(p4) -- line: 67
	-- upvalues: v19 (copy), Roact (copy), Otter (copy), t1 (copy), UserGameSettings (copy)
	p4.state = {
		isRefreshing = false
	}
	p4.startHeight = 0
	p4.isUserInteracting = false

	local forwardRef = p4.props.forwardRef

	assert(type(forwardRef) ~= "function", ("%s does not support function ref forwarding"):format((tostring(v19))))
	p4.scrollingFrameRef = forwardRef or Roact.createRef()
	p4.spinnerFrameRef = Roact.createRef()
	p4.spinnerRef = Roact.createRef()

	function p4.updateSpinner(p5) -- line: 88
		-- upvalues: p4 (copy)
		if p4.spinnerFrameRef.current then
			p4.spinnerFrameRef.current.Size = UDim2.new(1, 0, 0, p5)

			local v34 = p5 / p4.props.refreshThreshold

			if p4.props.usesBuilderIcon then
				local current = p4.spinnerRef.current
				local v36 = math.min(1, (math.max(0, v34)))

				current.TextTransparency = 1 * (1 - v36) + 0 * v36
			else
				local current = p4.spinnerRef.current
				local v38 = math.min(1, (math.max(0, v34)))

				current.ImageTransparency = 1 * (1 - v38) + 0 * v38
			end

			if not p4.state.isRefreshing then
				local current = p4.spinnerRef.current
				local v40 = math.min(1, (math.max(0, v34)))

				current.Rotation = -240 * (1 - v40) + 0 * v40
			end
		end
	end

	p4.motor = Otter.createSingleMotor(0)
	p4.motor:onStep(p4.updateSpinner)

	function p4.resetSpinner() -- line: 119
		-- upvalues: p4 (copy), Otter (copy), t1 (copy)
		p4.motor:setGoal(Otter.spring(0, t1))
	end
	function p4.scrollBack() -- line: 123
		-- upvalues: p4 (copy), UserGameSettings (copy)
		if p4.scrollingFrameRef.current then
			if UserGameSettings.ReducedMotion then
				p4.scrollingFrameRef.current.CanvasPosition = Vector2.new(0, 0)

				return
			end

			p4.scrollingFrameRef.current:ScrollToTop()
		end
	end
	function p4.dispatchRefresh() -- line: 133
		-- upvalues: p4 (copy), Otter (copy), t1 (copy)
		local refresh = p4.props.refresh
		local refreshThreshold = p4.props.refreshThreshold
		local isRefreshing = p4.state.isRefreshing

		if refresh == nil then
			return
		end

		if not isRefreshing then
			p4:setState({
				isRefreshing = true
			})
			p4.motor:setGoal(Otter.spring(refreshThreshold, t1))

			local function onRefreshComplete() -- line: 149
				-- upvalues: p4 (copy)
				if p4.isMounted then
					p4:setState({
						isRefreshing = false
					})
					p4.resetSpinner()
				end
			end

			refresh():andThen(onRefreshComplete, onRefreshComplete)
		end
	end
	function p4.onInputBegan(_) -- line: 162
		-- upvalues: p4 (copy)
		if not p4.isUserInteracting then
			p4.startHeight = p4.scrollingFrameRef.current.CanvasPosition.Y
		end

		p4.isUserInteracting = true
	end
	function p4.onInputEnded(_) -- line: 171
		-- upvalues: p4 (copy)
		p4.isUserInteracting = false

		local startHeight = p4.startHeight

		p4.startHeight = 0

		if p4.props.refresh ~= nil and p4.scrollingFrameRef.current then
			local v48 = -p4.scrollingFrameRef.current.CanvasPosition.Y

			if v48 > p4.props.refreshThreshold and startHeight < v48 then
				p4.dispatchRefresh()

				return
			end

			if v48 > 0 then
				p4.resetSpinner()
			end
		end
	end
	function p4.statusBarTapCallback() -- line: 191
		-- upvalues: p4 (copy)
		if p4.props.onStatusBarTapped then
			p4.props.onStatusBarTapped()
		end

		p4.scrollBack()
	end
	function p4.onCanvasPositionChanged(p8) -- line: 198
		-- upvalues: p4 (copy), Otter (copy)
		if p4.props.onCanvasPositionChangedCallback ~= nil then
			p4.props.onCanvasPositionChangedCallback(p8)
		end

		if p4.props.refresh ~= nil and p4.isUserInteracting and not p4.state.isRefreshing then
			local v50 = -p8.CanvasPosition.Y
			local refreshThreshold = p4.props.refreshThreshold

			if v50 >= 0 and v50 <= refreshThreshold then
				p4.motor:setGoal(Otter.instant(v50))
			end
		end
	end
	function p4.onCanvasSizeChanged(p9) -- line: 213
		-- upvalues: p4 (copy)
		if p4.props.onCanvasSizeChangedCallback ~= nil then
			p4.props.onCanvasSizeChangedCallback(p9)
		end
	end
end
function v19.didMount(p10) -- line: 220
	p10.isMounted = true
	p10.resetSpinner()
end
function v19.willUnmount(p11) -- line: 225
	p11.isMounted = false
	p11.motor:destroy()
	p11.motor = nil
end
function v19.render(p12) -- line: 232
	-- upvalues: Roact (copy), withStyle (copy), Cryo (copy), Spinner (copy), v14 (copy), ExternalEventConnection (copy), UserInputService (copy)
	local v29 = p12.props[Roact.Children]
	local isRefreshing = p12.state.isRefreshing

	return withStyle(function(_) -- line: 236
		-- upvalues: Roact (copy), p12 (copy), Cryo (copy), Spinner (copy), v14 (copy), isRefreshing (copy), v29 (copy), ExternalEventConnection (copy), UserInputService (copy)
		return Roact.createElement(p12.props.ScrollingElement, Cryo.Dictionary.join({
			[Roact.Change.CanvasPosition] = p12.onCanvasPositionChanged,
			[Roact.Change.CanvasSize] = p12.onCanvasSizeChanged,
			[Roact.Ref] = p12.scrollingFrameRef
		}, p12.props.scrollingElementProps), {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			SpinnerFrame = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				ClipsDescendants = false,
				[Roact.Ref] = p12.spinnerFrameRef
			}, {
				Spinner = Roact.createElement(Spinner, {
					Size = UDim2.new(0, v14, 0, v14),
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.new(0.5, 0, 1, 0),
					isSpinning = isRefreshing,
					[Roact.Ref] = p12.spinnerRef
				})
			}),
			Content = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 1, 0)
			}, v29),
			inputBegan = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputBegan,
				callback = p12.onInputBegan
			}),
			inputEnded = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputEnded,
				callback = p12.onInputEnded
			}),
			statusBarTapped = Roact.createElement(ExternalEventConnection, {
				event = UserInputService.StatusBarTapped,
				callback = p12.statusBarTapCallback
			})
		})
	end)
end

return Roact.forwardRef(function(p14, p15) -- line: 289
	-- upvalues: Roact (copy), v19 (copy), Cryo (copy)
	return Roact.createElement(v19, Cryo.Dictionary.join(p14, {
		forwardRef = p15
	}))
end)
