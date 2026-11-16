local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local otter = dependencies.Otter
local t = dependencies.t
local cryo = dependencies.Cryo
local withStyle = uiBlox.Style.withStyle
local getIconSize = uiBlox.App.ImageSet.getIconSize

local ExternalEventConnection = require(script.Parent.ExternalEventConnection)
local Spinner = require(script.Parent.Spinner)

local iconSize = getIconSize(uiBlox.App.ImageSet.Enum.IconSize.Medium)

local _ = { Start = -240, End = 0 }

local _ = { Start = 1, End = 0 }

local v = { dampingRatio = 1, frequency = 3.5 }

local function lerp(p, p2, p3) -- 3 equivalent calls inferred from this helper
	local v2 = math.min(1, (math.max(0, p3)))

	return p * (1 - v2) + p2 * v2
end

local extended = roact.PureComponent:extend("RefreshScrollingFrameNew")

extended.defaultProps = {
	ScrollingElement = "ScrollingFrame",
	refreshThreshold = 52,
	scrollingElementProps = {}
}

extended.validateProps = t.interface({
	ScrollingElement = t.union(t.string, t.callback, t.table),
	scrollingElementProps = t.optional(t.table),
	refreshThreshold = t.number,
	forwardRef = t.optional(t.table),
	onCanvasPositionChangedCallback = t.optional(t.callback),
	onStatusBarTapped = t.optional(t.callback),
	refresh = t.optional(t.callback),
	usesBuilderIcon = t.optional(t.boolean),
	[roact.Children] = t.optional(t.any)
})

function extended:init()
	self.state = { isRefreshing = false }

	self.startHeight = 0

	self.isUserInteracting = false

	local forwardRef = self.props.forwardRef

	assert(type(forwardRef) ~= "function", ("%s does not support function ref forwarding"):format((tostring(extended))))

	self.scrollingFrameRef = forwardRef or roact.createRef()
	self.spinnerFrameRef = roact.createRef()
	self.spinnerRef = roact.createRef()

	function self.updateSpinner(p)
		if self.spinnerFrameRef.current then
			self.spinnerFrameRef.current.Size = UDim2.new(1, 0, 0, p)
			local v2 = p / self.props.refreshThreshold

			if self.props.usesBuilderIcon then
				local current = self.spinnerRef.current
				current.TextTransparency = lerp(1, 0, v2) -- inferred equivalent call
			else
				local current = self.spinnerRef.current
				current.ImageTransparency = lerp(1, 0, v2) -- inferred equivalent call
			end

			if not self.state.isRefreshing then
				local current = self.spinnerRef.current
				current.Rotation = lerp(-240, 0, v2) -- inferred equivalent call
			end
		end
	end

	self.motor = otter.createSingleMotor(0)
	self.motor:onStep(self.updateSpinner)

	function self.resetSpinner()
		self.motor:setGoal(otter.spring(0, v))
	end

	function self.scrollBack()
		if self.scrollingFrameRef.current then
			if UserGameSettings.ReducedMotion then
				self.scrollingFrameRef.current.CanvasPosition = Vector2.new(0, 0)
			else
				self.scrollingFrameRef.current:ScrollToTop()
			end
		end
	end

	function self.dispatchRefresh()
		local refresh = self.props.refresh
		local refreshThreshold = self.props.refreshThreshold
		local isRefreshing = self.state.isRefreshing

		if refresh == nil then
			return
		end

		if not isRefreshing then
			self:setState({ isRefreshing = true })

			self.motor:setGoal(otter.spring(refreshThreshold, v))

			local function onRefreshComplete()
				if self.isMounted then
					self:setState({ isRefreshing = false })

					self.resetSpinner()
				end
			end

			refresh():andThen(onRefreshComplete, onRefreshComplete)
		end
	end

	function self.onInputBegan(_)
		if not self.isUserInteracting then
			self.startHeight = self.scrollingFrameRef.current.CanvasPosition.Y
		end

		self.isUserInteracting = true
	end

	function self.onInputEnded(_)
		self.isUserInteracting = false

		local startHeight = self.startHeight
		self.startHeight = 0

		if self.props.refresh ~= nil and self.scrollingFrameRef.current then
			local v2 = -self.scrollingFrameRef.current.CanvasPosition.Y

			if self.props.refreshThreshold < v2 and startHeight < v2 then
				self.dispatchRefresh()
			elseif v2 > 0 then
				self.resetSpinner()
			end
		end
	end

	function self.statusBarTapCallback()
		if self.props.onStatusBarTapped then
			self.props.onStatusBarTapped()
		end

		self.scrollBack()
	end

	function self.onCanvasPositionChanged(p)
		if self.props.onCanvasPositionChangedCallback ~= nil then
			self.props.onCanvasPositionChangedCallback(p)
		end

		if self.props.refresh ~= nil and self.isUserInteracting and not self.state.isRefreshing then
			local v2 = -p.CanvasPosition.Y
			local refreshThreshold = self.props.refreshThreshold

			if v2 >= 0 and v2 <= refreshThreshold then
				self.motor:setGoal(otter.instant(v2))
			end
		end
	end

	function self.onCanvasSizeChanged(p)
		if self.props.onCanvasSizeChangedCallback ~= nil then
			self.props.onCanvasSizeChangedCallback(p)
		end
	end
end

function extended:didMount()
	self.isMounted = true
	self.resetSpinner()
end

function extended:willUnmount()
	self.isMounted = false

	self.motor:destroy()
	self.motor = nil
end

function extended.render(data)
	local v2 = data.props[roact.Children]
	local isRefreshing = data.state.isRefreshing

	return withStyle(function(_)
		return roact.createElement(
			data.props.ScrollingElement,
			cryo.Dictionary.join(
				{
					[roact.Change.CanvasPosition] = data.onCanvasPositionChanged,
					[roact.Change.CanvasSize] = data.onCanvasSizeChanged,
					[roact.Ref] = data.scrollingFrameRef
				},
				data.props.scrollingElementProps
			),
			{
				Layout = roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				SpinnerFrame = roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					ClipsDescendants = false,
					[roact.Ref] = data.spinnerFrameRef
				}, {
					Spinner = roact.createElement(Spinner, {
						Size = UDim2.new(0, iconSize, 0, iconSize),
						AnchorPoint = Vector2.new(0.5, 1),
						Position = UDim2.new(0.5, 0, 1, 0),
						isSpinning = isRefreshing,
						[roact.Ref] = data.spinnerRef
					})
				}),
				Content = roact.createElement(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 1, 0)
					},
					v2
				),
				inputBegan = roact.createElement(ExternalEventConnection, {
					event = UserInputService.InputBegan,
					callback = data.onInputBegan
				}),
				inputEnded = roact.createElement(ExternalEventConnection, {
					event = UserInputService.InputEnded,
					callback = data.onInputEnded
				}),
				statusBarTapped = roact.createElement(ExternalEventConnection, {
					event = UserInputService.StatusBarTapped,
					callback = data.statusBarTapCallback
				})
			}
		)
	end)
end

return roact.forwardRef(function(p, forwardRef)
	return roact.createElement(extended, cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
