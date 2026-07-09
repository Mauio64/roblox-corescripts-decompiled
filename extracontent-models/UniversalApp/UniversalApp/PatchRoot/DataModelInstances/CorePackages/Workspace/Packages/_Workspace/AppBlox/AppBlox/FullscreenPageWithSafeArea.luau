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
local v11 = game:DefineFastFlag("VRAlwaysIgnoreSafeMargins", false)
local FFlagExtendScrollingFramesBySafeInsets = require(Parent.SharedFlags).FFlagExtendScrollingFramesBySafeInsets

function v7.render(p1) -- line: 19
	-- upvalues: Roact (copy), FFlagExtendScrollingFramesBySafeInsets (copy), getSafeAreaSize (copy), v11 (copy), IsVRAppBuild (copy), Constants (copy)
	local statusBarHeight = p1.props.statusBarHeight
	local screenSize = p1.props.screenSize
	local globalGuiInset = p1.props.globalGuiInset
	local propsBackgroundColor3 = p1.props.BackgroundColor3
	local propsBackgroundTransparency = p1.props.BackgroundTransparency
	local includeStatusBar = p1.props.includeStatusBar
	local includeBottomBar = p1.props.includeBottomBar
	local renderFullscreenBackground = p1.props.renderFullscreenBackground
	local v24 = p1.props[Roact.Children]
	local buttonRef = p1.props.buttonRef
	local v26 = if not FFlagExtendScrollingFramesBySafeInsets then nil else p1.props.deviceSafePadding

	if screenSize.X == 0 or screenSize.Y == 0 then
		return nil
	end

	local v27 = getSafeAreaSize(screenSize, globalGuiInset)
	local v28 = globalGuiInset.top + (FFlagExtendScrollingFramesBySafeInsets and v26.top or 0)
	local v29 = if not v11 then if p1.props.useFullScalePage == nil then IsVRAppBuild() else p1.props.useFullScalePage else p1.props.useFullScalePage or IsVRAppBuild()

	if includeStatusBar then
		v27 = UDim2.new(0, v27.X.Offset, 0, v27.Y.Offset - statusBarHeight)
		v28 += statusBarHeight
	end

	if includeBottomBar then
		v27 = UDim2.new(0, v27.X.Offset, 0, v27.Y.Offset - Constants.BOTTOM_BAR_SIZE)
	end

	return Roact.createElement("Frame", {
		Position = if not v29 then UDim2.new(0, -globalGuiInset.left - (FFlagExtendScrollingFramesBySafeInsets and v26.left or 0), 0, -globalGuiInset.top - (FFlagExtendScrollingFramesBySafeInsets and v26.top or 0)) else UDim2.new(0, 0, 0, 0),
		Size = if not v29 then UDim2.new(0, screenSize.X, 0, screenSize.Y) else UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = propsBackgroundColor3,
		BackgroundTransparency = propsBackgroundTransparency,
		Active = true,
		BorderSizePixel = 0,
		ClipsDescendants = not FFlagExtendScrollingFramesBySafeInsets,
		[Roact.Ref] = buttonRef
	}, {
		Background = renderFullscreenBackground and renderFullscreenBackground(v28),
		SafeAreaFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = if not v29 then UDim2.new(0, globalGuiInset.left + (FFlagExtendScrollingFramesBySafeInsets and v26.left or 0), 0, v28) else UDim2.new(0, 0, 0, 0),
			Size = if not v29 then v27 else UDim2.new(1, 0, 1, 0),
			ZIndex = not renderFullscreenBackground and 1 or 2
		}, v24)
	})
end

local v13 = RoactRodux.connect(function(p2, _) -- line: 90
	return {
		statusBarHeight = p2.TopBar.statusBarHeight,
		screenSize = p2.ScreenSize,
		globalGuiInset = p2.GlobalGuiInset
	}
end)(v7)

if FFlagExtendScrollingFramesBySafeInsets then
	local function FullscreenPageWithSafeAreaFunctional(p4) -- line: 99
		-- upvalues: useSignalState (copy), Display (copy), Cryo (copy), Roact (copy), v13 (copy)
		local v33 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
		local v34 = Cryo.Dictionary.join(p4, {
			deviceSafePadding = v33
		})

		return Roact.createElement(v13, v34)
	end

	return FullscreenPageWithSafeAreaFunctional
end

return v13
