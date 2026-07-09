local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local SetPeekabooLayoutDetails = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetPeekabooLayoutDetails)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local SharedInteractionFrame = require(Modules.AvatarExperience.Common.Components.SharedInteractionFrame)
local FFlagAXF10ftFixPeekabooWidget = require(Modules.AvatarExperience.Flags.FFlagAXF10ftFixPeekabooWidget)
local withStyle = UIBlox.Style.withStyle
local v15 = Roact.PureComponent:extend("PeekabooWidget")

v15.validateProps = t.strictInterface({
	viewportYScale = t.number,
	viewportXScale = t.number,
	topMarginYScale = t.number,
	renderBottomContents = t.callback,
	renderMiddleContents = t.callback,
	panByPixels = t.optional(t.callback),
	rotateByPixels = t.optional(t.callback),
	setAngularVelocityByPixels = t.optional(t.callback),
	zoomToPoint = t.optional(t.callback),
	globalGuiInset = if not FFlagAXF10ftFixPeekabooWidget then t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	}) else nil,
	screenSize = if not FFlagAXF10ftFixPeekabooWidget then t.Vector2 else nil,
	containerSize = if not FFlagAXF10ftFixPeekabooWidget then nil else t.Vector2,
	setPeekabooLayoutDetails = t.callback,
	navigation = t.table
})

function v15.init(p1) -- line: 67
	p1:deriveDetailsFromProps(p1.props)

	function p1.panByPixels(p2) -- line: 70
		-- upvalues: p1 (copy)
		if p1.props.panByPixels then
			p1.props.panByPixels(p2)
		end
	end
	function p1.rotateByPixels(p3) -- line: 75
		-- upvalues: p1 (copy)
		if p1.props.rotateByPixels then
			p1.props.rotateByPixels(p3)
		end
	end
	function p1.setAngularVelocityByPixels(p4) -- line: 80
		-- upvalues: p1 (copy)
		if p1.props.setAngularVelocityByPixels then
			p1.props.setAngularVelocityByPixels(p4)
		end
	end
	function p1.zoomToPoint(p5, p6) -- line: 85
		-- upvalues: p1 (copy)
		if p1.props.zoomToPoint then
			p1.props.zoomToPoint(p5, p6)
		end
	end
end
function v15.postToRodux(p7) -- line: 92
	local routeName = p7.props.navigation.state.routeName

	p7.props.setPeekabooLayoutDetails(routeName, p7.safeAreaSize.Y.Offset, p7.topYPix, p7.viewportSizePix)
end
function v15.getFrameDetails(p8, p9) -- line: 98
	local v23 = p8.safeAreaSize.X.Offset * p9.viewportXScale
	local v24 = p8.safeAreaSize.Y.Offset * p9.viewportYScale

	if v23 < v24 then
		p8.viewportSizePix = math.floor(v23 + 0.5)
	else
		p8.viewportSizePix = math.floor(v24 + 0.5)
	end

	p8.topYPix = math.floor(p8.safeAreaSize.Y.Offset * p9.topMarginYScale + 0.5)
	p8.sideXPix = math.floor((p8.safeAreaSize.X.Offset - p8.viewportSizePix) / 2 + 0.5)
end
function v15.deriveDetailsFromProps(p10, p11) -- line: 111
	-- upvalues: FFlagAXF10ftFixPeekabooWidget (copy), getSafeAreaSize (copy)
	local screenSize = p11.screenSize
	local globalGuiInset = p11.globalGuiInset
	local containerSize = p11.containerSize

	p10.safeAreaSize = if not FFlagAXF10ftFixPeekabooWidget then getSafeAreaSize(screenSize, globalGuiInset) else UDim2.fromOffset(containerSize.X, containerSize.Y)
	p10:getFrameDetails(p11)
	p10:postToRodux()
end
function v15.willUpdate(p12, p13, _) -- line: 122
	p12:deriveDetailsFromProps(p13)
end
function v15.renderWithProviders(p15, p16) -- line: 126
	-- upvalues: Roact (copy), SharedInteractionFrame (copy)
	local Theme = p16.Theme

	return Roact.createFragment({
		TopFrame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 0,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			Size = UDim2.new(1, 0, 0, p15.topYPix),
			Position = UDim2.fromOffset(0, 0)
		}),
		LeftMiddleFrame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 0,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			Size = UDim2.new(0, p15.sideXPix, 0, p15.viewportSizePix),
			Position = UDim2.fromOffset(0, p15.topYPix)
		}),
		MiddleFrame = Roact.createElement(SharedInteractionFrame, {
			ZIndex = -1,
			Size = UDim2.new(0, p15.viewportSizePix, 0, p15.viewportSizePix),
			Position = UDim2.fromOffset(p15.sideXPix, p15.topYPix),
			panByPixels = p15.panByPixels,
			rotateByPixels = p15.rotateByPixels,
			setAngularVelocityByPixels = p15.setAngularVelocityByPixels,
			zoomToPoint = p15.zoomToPoint
		}, {
			Contents = p15.props.renderMiddleContents()
		}),
		RightMiddleFrame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 0,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0, p15.safeAreaSize.X.Offset - p15.sideXPix - p15.viewportSizePix, 0, p15.viewportSizePix),
			Position = UDim2.new(1, 0, 0, p15.topYPix)
		}),
		BottomFrame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 0, p15.safeAreaSize.Y.Offset - p15.topYPix - p15.viewportSizePix),
			Position = UDim2.fromScale(0, 1)
		}, {
			Contents = p15.props.renderBottomContents()
		})
	})
end
function v15.render(p17) -- line: 188
	-- upvalues: withStyle (copy)
	return withStyle(function(p18) -- line: 189
		-- upvalues: p17 (copy)
		return p17:renderWithProviders(p18)
	end)
end

local u16 = withNavigation(RoactRodux.connect(not FFlagAXF10ftFixPeekabooWidget and function(p19, _) -- line: 197
	return {
		globalGuiInset = p19.GlobalGuiInset,
		screenSize = p19.ScreenSize
	}
end or nil, function(p21) -- line: 203
	-- upvalues: SetPeekabooLayoutDetails (copy)
	return {
		setPeekabooLayoutDetails = function(p22, p23, p24, p25) -- line: 205
			-- upvalues: p21 (copy), SetPeekabooLayoutDetails (copy)
			p21(SetPeekabooLayoutDetails(p22, p23, p24, p25))
		end
	}
end)(v15), nil)

local function PeekabooWidgetWrapper(p26) -- line: 214
	-- upvalues: React (copy), u16 (ref), Cryo (copy)
	local v41, v42 = React.useState(Vector2.zero)
	local v43 = React.useRef(nil)
	local v44 = React.useCallback(function(p27) -- line: 218
		-- upvalues: v42 (copy)
		v42(p27.AbsoluteSize)
	end, {})

	React.useLayoutEffect(function() -- line: 222
		-- upvalues: v44 (copy), v43 (copy)
		v44(v43.current)
	end, { v44 })

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ref = v43,
		[React.Change.AbsoluteSize] = v44
	}, {
		PeekabooWidget = React.createElement(u16, Cryo.Dictionary.join(p26, {
			containerSize = v41
		}))
	})
end

return if not FFlagAXF10ftFixPeekabooWidget then u16 else PeekabooWidgetWrapper
