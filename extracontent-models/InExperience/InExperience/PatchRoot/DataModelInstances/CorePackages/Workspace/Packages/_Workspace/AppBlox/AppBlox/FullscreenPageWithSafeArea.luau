local Parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(Parent.Roact)
local RoactRodux = require(Parent.RoactRodux)
local getSafeAreaSize = require(Parent.InputUi).getSafeAreaSize
local IsVRAppBuild = require(Parent.AppCommonLib).IsVRAppBuild
local Constants = require(Parent.AppSystemBar).Constants
local v7 = Roact.PureComponent:extend("FullscreenPageWithSafeArea")
local useSignalState = require(Parent.SignalsReact).useSignalState
local Display = require(Parent.Display)
local Cryo = require(Parent.Cryo)
local FFlagExtendScrollingFramesBySafeInsets = require(Parent.SharedFlags).FFlagExtendScrollingFramesBySafeInsets

function v7.render(p1) -- line: 18
	-- upvalues: Roact (copy), FFlagExtendScrollingFramesBySafeInsets (copy), getSafeAreaSize (copy), IsVRAppBuild (copy), Constants (copy)
	local statusBarHeight = p1.props.statusBarHeight
	local screenSize = p1.props.screenSize
	local globalGuiInset = p1.props.globalGuiInset
	local propsBackgroundColor3 = p1.props.BackgroundColor3
	local propsBackgroundTransparency = p1.props.BackgroundTransparency
	local includeStatusBar = p1.props.includeStatusBar
	local includeBottomBar = p1.props.includeBottomBar
	local renderFullscreenBackground = p1.props.renderFullscreenBackground
	local v23 = p1.props[Roact.Children]
	local buttonRef = p1.props.buttonRef
	local v25 = if not FFlagExtendScrollingFramesBySafeInsets then nil else p1.props.deviceSafePadding

	if screenSize.X == 0 or screenSize.Y == 0 then
		return nil
	end

	local v26 = getSafeAreaSize(screenSize, globalGuiInset)
	local v27 = globalGuiInset.top + (FFlagExtendScrollingFramesBySafeInsets and v25.top or 0)
	local v28 = p1.props.useFullScalePage or IsVRAppBuild()

	if includeStatusBar then
		v26 = UDim2.new(0, v26.X.Offset, 0, v26.Y.Offset - statusBarHeight)
		v27 += statusBarHeight
	end

	if includeBottomBar then
		v26 = UDim2.new(0, v26.X.Offset, 0, v26.Y.Offset - Constants.BOTTOM_BAR_SIZE)
	end

	return Roact.createElement("Frame", {
		Position = if not v28 then UDim2.new(0, -globalGuiInset.left - (FFlagExtendScrollingFramesBySafeInsets and v25.left or 0), 0, -globalGuiInset.top - (FFlagExtendScrollingFramesBySafeInsets and v25.top or 0)) else UDim2.new(0, 0, 0, 0),
		Size = if not v28 then UDim2.new(0, screenSize.X, 0, screenSize.Y) else UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = propsBackgroundColor3,
		BackgroundTransparency = propsBackgroundTransparency,
		Active = true,
		BorderSizePixel = 0,
		ClipsDescendants = not FFlagExtendScrollingFramesBySafeInsets,
		[Roact.Ref] = buttonRef
	}, {
		Background = renderFullscreenBackground and renderFullscreenBackground(v27),
		SafeAreaFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = if not v28 then UDim2.new(0, globalGuiInset.left + (FFlagExtendScrollingFramesBySafeInsets and v25.left or 0), 0, v27) else UDim2.new(0, 0, 0, 0),
			Size = if not v28 then v26 else UDim2.new(1, 0, 1, 0),
			ZIndex = not renderFullscreenBackground and 1 or 2
		}, v23)
	})
end

local v12 = RoactRodux.connect(function(p2, _) -- line: 87
	return {
		statusBarHeight = p2.TopBar.statusBarHeight,
		screenSize = p2.ScreenSize,
		globalGuiInset = p2.GlobalGuiInset
	}
end)(v7)

if FFlagExtendScrollingFramesBySafeInsets then
	local function FullscreenPageWithSafeAreaFunctional(p4) -- line: 96
		-- upvalues: useSignalState (copy), Display (copy), Cryo (copy), Roact (copy), v12 (copy)
		local v32 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
		local v33 = Cryo.Dictionary.join(p4, {
			deviceSafePadding = v32
		})

		return Roact.createElement(v12, v33)
	end

	return FullscreenPageWithSafeAreaFunctional
end

return v12
