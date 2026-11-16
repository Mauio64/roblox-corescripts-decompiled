local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RoactRodux")

local getSafeAreaSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/InputUi").getSafeAreaSize
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppCommonLib").IsVRAppBuild
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppSystemBar").Constants

local extended = Roact.PureComponent:extend("FullscreenPageWithSafeArea")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SignalsReact").useSignalState
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Display")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")

local fFlagExtendScrollingFramesBySafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagExtendScrollingFramesBySafeInsets

function extended.render(p2)
	local statusBarHeight = p2.props.statusBarHeight
	local screenSize = p2.props.screenSize
	local globalGuiInset = p2.props.globalGuiInset

	local backgroundColor3 = p2.props.BackgroundColor3
	local backgroundTransparency = p2.props.BackgroundTransparency
	local includeStatusBar = p2.props.includeStatusBar
	local includeBottomBar = p2.props.includeBottomBar
	local renderFullscreenBackground = p2.props.renderFullscreenBackground
	local v5 = p2.props[Roact.Children]
	local buttonRef = p2.props.buttonRef

	local deviceSafePadding = if fFlagExtendScrollingFramesBySafeInsets then p2.props.deviceSafePadding else nil

	if screenSize.X == 0 or screenSize.Y == 0 then
		return nil
	end

	local v6 = getSafeAreaSize(screenSize, globalGuiInset)
	local v7 = globalGuiInset.top + (fFlagExtendScrollingFramesBySafeInsets and deviceSafePadding.top or 0)

	local useFullScalePage = p2.props.useFullScalePage or isVRAppBuild()

	if includeStatusBar then
		v6 = UDim2.new(0, v6.X.Offset, 0, v6.Y.Offset - statusBarHeight)
		v7 += statusBarHeight
	end

	if includeBottomBar then
		v6 = UDim2.new(0, v6.X.Offset, 0, v6.Y.Offset - constants.BOTTOM_BAR_SIZE)
	end

	local createElement = Roact.createElement

	local v9 = if useFullScalePage then UDim2.new(0, 0, 0, 0) else UDim2.new(
		0,
		-globalGuiInset.left - (fFlagExtendScrollingFramesBySafeInsets and deviceSafePadding.left or 0),
		0,
		-globalGuiInset.top - (fFlagExtendScrollingFramesBySafeInsets and deviceSafePadding.top or 0)
	)

	local v10 = if useFullScalePage then UDim2.new(1, 0, 1, 0) else UDim2.new(0, screenSize.X, 0, screenSize.Y)
	local buttonRefsByRef = {
		Position = v9,
		Size = v10,
		BackgroundColor3 = backgroundColor3,
		BackgroundTransparency = backgroundTransparency,
		Active = true,
		BorderSizePixel = 0,
		ClipsDescendants = not fFlagExtendScrollingFramesBySafeInsets,
		[Roact.Ref] = buttonRef
	}
	local v11 = {
		Background = renderFullscreenBackground and renderFullscreenBackground(v7),
		SafeAreaFrame = 0
	}
	local createElement2 = Roact.createElement

	local v14 = if useFullScalePage then UDim2.new(0, 0, 0, 0) else UDim2.new(
		0,
		globalGuiInset.left + (fFlagExtendScrollingFramesBySafeInsets and deviceSafePadding.left or 0),
		0,
		v7
	)

	if useFullScalePage then
		v6 = UDim2.new(1, 0, 1, 0)
	end

	v11.SafeAreaFrame = createElement2("Frame", {
		Position = v14,
		Size = v6,
		BackgroundTransparency = 1,
		ZIndex = renderFullscreenBackground and 2 or 1
	}, v5)
	return createElement("Frame", buttonRefsByRef, v11)
end

local v5 = RoactRodux.connect(function(data, p2)
	return {
		statusBarHeight = data.TopBar.statusBarHeight,
		screenSize = data.ScreenSize,
		globalGuiInset = data.GlobalGuiInset
	}
end)(extended)

if not fFlagExtendScrollingFramesBySafeInsets then
	return v5
end

local function FullscreenPageWithSafeAreaFunctional(p2)
	local v6 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local joined = Cryo.Dictionary.join(p2, { deviceSafePadding = v6 })

	return Roact.createElement(v5, joined)
end

return FullscreenPageWithSafeAreaFunctional
