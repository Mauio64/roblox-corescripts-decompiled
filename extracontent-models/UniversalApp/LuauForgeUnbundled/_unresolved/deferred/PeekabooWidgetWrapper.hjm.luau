local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize

local module = require("@luauforge/bundled/dWE")
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local InteractionFrame = require("@game/CoreGui/RobloxGui/Modules/PublishAssetPrompt/Components/Common/InteractionFrame")

local module3 = require("@luauforge/deferred/hjn")

local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("PeekabooWidget")

local strictInterface = t.strictInterface
local v5 = {
	viewportYScale = t.number,
	viewportXScale = t.number,
	topMarginYScale = t.number,
	renderBottomContents = t.callback,
	renderMiddleContents = t.callback,
	panByPixels = t.optional(t.callback),
	rotateByPixels = t.optional(t.callback),
	setAngularVelocityByPixels = t.optional(t.callback),
	zoomToPoint = t.optional(t.callback),
	globalGuiInset = 0,
	screenSize = 0,
	containerSize = 0,
	setPeekabooLayoutDetails = 0,
	navigation = 0
}

local v6 = if not module3 then t.strictInterface({
	left = t.integer,
	top = t.integer,
	right = t.integer,
	bottom = t.integer
}) else nil
v5.globalGuiInset = v6

local v7 = if not module3 then t.Vector2 else nil
v5.screenSize = v7
local v8 = if module3 then t.Vector2 else nil
v5.containerSize = v8

v5.setPeekabooLayoutDetails = t.callback

v5.navigation = t.table
extended.validateProps = strictInterface(v5)

function extended:init()
	self:deriveDetailsFromProps(self.props)

	function self.panByPixels(p2)
		if self.props.panByPixels then
			self.props.panByPixels(p2)
		end
	end
	function self.rotateByPixels(p2)
		if self.props.rotateByPixels then
			self.props.rotateByPixels(p2)
		end
	end
	function self.setAngularVelocityByPixels(p2)
		if self.props.setAngularVelocityByPixels then
			self.props.setAngularVelocityByPixels(p2)
		end
	end
	function self.zoomToPoint(p2, p3)
		if self.props.zoomToPoint then
			self.props.zoomToPoint(p2, p3)
		end
	end
end

function extended:postToRodux()
	local routeName = self.props.navigation.state.routeName
	self.props.setPeekabooLayoutDetails(
		routeName,
		self.safeAreaSize.Y.Offset,
		self.topYPix,
		self.viewportSizePix
	)
end

function extended:getFrameDetails(data)
	local v9 = self.safeAreaSize.X.Offset * data.viewportXScale
	local v10 = self.safeAreaSize.Y.Offset * data.viewportYScale

	if v9 < v10 then
		self.viewportSizePix = math.floor(v9 + 0.5)
	else
		self.viewportSizePix = math.floor(v10 + 0.5)
	end

	self.topYPix = math.floor(self.safeAreaSize.Y.Offset * data.topMarginYScale + 0.5)
	self.sideXPix = math.floor((self.safeAreaSize.X.Offset - self.viewportSizePix) / 2 + 0.5)
end

function extended:deriveDetailsFromProps(data)
	local screenSize = data.screenSize
	local globalGuiInset = data.globalGuiInset
	local containerSize = data.containerSize

	local v9 = if module3 then UDim2.fromOffset(containerSize.X, containerSize.Y) else getSafeAreaSize(screenSize, globalGuiInset)
	self.safeAreaSize = v9

	self:getFrameDetails(data)
	self:postToRodux()
end

function extended:willUpdate(p2, p3)
	self:deriveDetailsFromProps(p2)
end

function extended:renderWithProviders(p2)
	local theme = p2.Theme

	return Roact.createFragment({
		TopFrame = Roact.createElement("Frame", {
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = 0,
			Size = UDim2.new(1, 0, 0, self.topYPix),
			Position = UDim2.fromOffset(0, 0)
		}),
		LeftMiddleFrame = Roact.createElement("Frame", {
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = 0,
			Size = UDim2.new(0, self.sideXPix, 0, self.viewportSizePix),
			Position = UDim2.fromOffset(0, self.topYPix)
		}),
		MiddleFrame = Roact.createElement(InteractionFrame, {
			ZIndex = -1,
			Size = UDim2.new(0, self.viewportSizePix, 0, self.viewportSizePix),
			Position = UDim2.fromOffset(self.sideXPix, self.topYPix),
			panByPixels = self.panByPixels,
			rotateByPixels = self.rotateByPixels,
			setAngularVelocityByPixels = self.setAngularVelocityByPixels,
			zoomToPoint = self.zoomToPoint
		}, {
			Contents = self.props.renderMiddleContents()
		}),
		RightMiddleFrame = Roact.createElement("Frame", {
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = 0,
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(
				0,
				self.safeAreaSize.X.Offset - self.sideXPix - self.viewportSizePix,
				0,
				self.viewportSizePix
			),
			Position = UDim2.new(1, 0, 0, self.topYPix)
		}),
		BottomFrame = Roact.createElement("Frame", {
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 0, self.safeAreaSize.Y.Offset - self.topYPix - self.viewportSizePix),
			Position = UDim2.fromScale(0, 1)
		}, {
			Contents = self.props.renderBottomContents()
		})
	})
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithProviders(p2)
	end)
end

local v9 = withNavigation(RoactRodux.connect(not module3 and function(p2, p3)
	return { globalGuiInset = p2.GlobalGuiInset, screenSize = p2.ScreenSize }
end or nil, function(callback)
	return {
		setPeekabooLayoutDetails = function(p2, p3, p4, p5)
			callback(module(p2, p3, p4, p5))
		end
	}
end)(extended), nil)

local function PeekabooWidgetWrapper(p2)
	local state, setState = React.useState(Vector2.zero)
	local ref = React.useRef(nil)

	local v10 = React.useCallback(function(p3)
		setState(p3.AbsoluteSize)
	end, {})

	React.useLayoutEffect(function()
		v10(ref.current)
	end, { v10 })

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ref = ref,
			[React.Change.AbsoluteSize] = v10
		},
		{
			PeekabooWidget = React.createElement(v9, Cryo.Dictionary.join(p2, {
				containerSize = state
			}))
		}
	)
end

if not module3 then
	PeekabooWidgetWrapper = v9
end

return PeekabooWidgetWrapper
