local parent = script:FindFirstAncestor("AppBlox").Parent

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)

local InputUi = require(parent.InputUi)
local getSafeAreaSize = InputUi.getSafeAreaSize
local AppCommonLib = require(parent.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local AppSystemBar = require(parent.AppSystemBar)
local Constants = AppSystemBar.Constants

local extended = Roact.PureComponent:extend("FullscreenPageWithSafeArea")
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Display = require(parent.Display)
local Cryo = require(parent.Cryo)

local SharedFlags = require(parent.SharedFlags)
local FFlagExtendScrollingFramesBySafeInsets = SharedFlags.FFlagExtendScrollingFramesBySafeInsets

function extended.render(p)
	local statusBarHeight = p.props.statusBarHeight
	local screenSize = p.props.screenSize
	local globalGuiInset = p.props.globalGuiInset

	local backgroundColor3 = p.props.BackgroundColor3
	local backgroundTransparency = p.props.BackgroundTransparency
	local includeStatusBar = p.props.includeStatusBar
	local includeBottomBar = p.props.includeBottomBar
	local renderFullscreenBackground = p.props.renderFullscreenBackground
	local v = p.props[Roact.Children]
	local buttonRef = p.props.buttonRef
	local deviceSafePadding

	if FFlagExtendScrollingFramesBySafeInsets then
		deviceSafePadding = p.props.deviceSafePadding
	end

	if screenSize.X == 0 or screenSize.Y == 0 then
		return nil
	end

	local size = getSafeAreaSize(screenSize, globalGuiInset)
	local v2 = globalGuiInset.top + (FFlagExtendScrollingFramesBySafeInsets and deviceSafePadding.top or 0)

	local useFullScalePage = p.props.useFullScalePage or IsVRAppBuild()

	if includeStatusBar then
		size = UDim2.new(0, size.X.Offset, 0, size.Y.Offset - statusBarHeight)
		v2 += statusBarHeight
	end

	if includeBottomBar then
		size = UDim2.new(0, size.X.Offset, 0, size.Y.Offset - Constants.BOTTOM_BAR_SIZE)
	end

	local createElement = Roact.createElement
	local position

	if useFullScalePage then
		position = UDim2.new(0, 0, 0, 0)
	else
		position = UDim2.new(
			0,
			-globalGuiInset.left - (FFlagExtendScrollingFramesBySafeInsets and deviceSafePadding.left or 0),
			0,
			-globalGuiInset.top - (FFlagExtendScrollingFramesBySafeInsets and deviceSafePadding.top or 0)
		)
	end

	local size2

	if useFullScalePage then
		size2 = UDim2.new(1, 0, 1, 0)
	else
		size2 = UDim2.new(0, screenSize.X, 0, screenSize.Y)
	end

	local buttonRefsByRef = {
		Position = position,
		Size = size2,
		BackgroundColor3 = backgroundColor3,
		BackgroundTransparency = backgroundTransparency,
		Active = true,
		BorderSizePixel = 0,
		ClipsDescendants = not FFlagExtendScrollingFramesBySafeInsets,
		[Roact.Ref] = buttonRef
	}
	local v3 = {
		Background = renderFullscreenBackground and renderFullscreenBackground(v2),
		SafeAreaFrame = 0
	}
	local createElement2 = Roact.createElement
	local position2

	if useFullScalePage then
		position2 = UDim2.new(0, 0, 0, 0)
	else
		position2 = UDim2.new(
			0,
			globalGuiInset.left + (FFlagExtendScrollingFramesBySafeInsets and deviceSafePadding.left or 0),
			0,
			v2
		)
	end

	if useFullScalePage then
		size = UDim2.new(1, 0, 1, 0)
	end

	v3.SafeAreaFrame = createElement2("Frame", {
		Position = position2,
		Size = size,
		BackgroundTransparency = 1,
		ZIndex = renderFullscreenBackground and 2 or 1
	}, v)
	return createElement("Frame", buttonRefsByRef, v3)
end

local v = RoactRodux.connect(function(data, _)
	return {
		statusBarHeight = data.TopBar.statusBarHeight,
		screenSize = data.ScreenSize,
		globalGuiInset = data.GlobalGuiInset
	}
end)(extended)

if not FFlagExtendScrollingFramesBySafeInsets then
	return v
end

local function FullscreenPageWithSafeAreaFunctional(p)
	local deviceSafePadding = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local joined = Cryo.Dictionary.join(p, { deviceSafePadding = deviceSafePadding })

	return Roact.createElement(v, joined)
end

return FullscreenPageWithSafeAreaFunctional
