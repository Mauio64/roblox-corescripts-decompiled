local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local React = require(TenFootUiShellParent.React)
local SceneManagement = require(TenFootUiShellParent.SceneManagement)
local FocusNavigationUtils = require(TenFootUiShellParent.FocusNavigationUtils)
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useRootFocusNavigationBindings = require(TenFootUiShell.Hooks.useRootFocusNavigationBindings)
local Constants = require(TenFootUiShell.ReactNavigationExtend.Views.Constants)
local SurfaceGuiWithAdornee = SceneManagement.SurfaceGuiWithAdornee
local useCameraFacingGeometry = SceneManagement.useCameraFacingGeometry

local function getAdorneeSizeFromScreenSize(n1: number) -- line: 14
	-- upvalues: Constants (copy)
	return function(vector2: Vector2) -- line: 15
		-- upvalues: n1 (copy), Constants (copy)
		return (Vector3.new(vector2.X, vector2.Y * n1, Constants.ADORNEE_DEPTH))
	end
end

local n2 = 1

local function v14(vector2: Vector2) -- line: 15
	-- upvalues: n2 (copy), Constants (copy)
	return (Vector3.new(vector2.X, vector2.Y * n2, Constants.ADORNEE_DEPTH))
end

local TOP_BAR_HEIGHT_RATIO = Constants.TOP_BAR_HEIGHT_RATIO

local function v16(vector2: Vector2) -- line: 15
	-- upvalues: TOP_BAR_HEIGHT_RATIO (copy), Constants (copy)
	return (Vector3.new(vector2.X, vector2.Y * TOP_BAR_HEIGHT_RATIO, Constants.ADORNEE_DEPTH))
end

local CONTROLLER_BAR_HEIGHT_RATIO = Constants.CONTROLLER_BAR_HEIGHT_RATIO

local function v18(vector2: Vector2) -- line: 15
	-- upvalues: CONTROLLER_BAR_HEIGHT_RATIO (copy), Constants (copy)
	return (Vector3.new(vector2.X, vector2.Y * CONTROLLER_BAR_HEIGHT_RATIO, Constants.ADORNEE_DEPTH))
end
local function getGlobalNavCFrame(t1: {[any]: any}) -- line: 30
	-- upvalues: Constants (copy)
	local viewportFillDimensionsY = t1.viewportFillDimensions.Y
	local cFrame = t1.cFrame
	local v32 = viewportFillDimensionsY * Constants.TOP_BAR_HEIGHT_RATIO

	return cFrame * CFrame.new(0, viewportFillDimensionsY / 2 - v32 / 2, 0)
end
local function getControllerBarCFrame(t2: {[any]: any}) -- line: 38
	-- upvalues: Constants (copy)
	local viewportFillDimensionsY = t2.viewportFillDimensions.Y
	local cFrame = t2.cFrame
	local v36 = viewportFillDimensionsY * Constants.CONTROLLER_BAR_HEIGHT_RATIO

	return cFrame * CFrame.new(0, v36 / 2 - viewportFillDimensionsY / 2, 0)
end
local function RootViewSurface(t3: {[any]: any}) -- line: 52
	-- upvalues: useCameraFacingGeometry (copy), Constants (copy), React (copy), SurfaceGuiWithAdornee (copy), v14 (copy)
	local v38 = useCameraFacingGeometry(Constants.DEFAULT_SCREEN_DISTANCE_TO_CAMERA)

	return React.createElement(SurfaceGuiWithAdornee, {
		name = "RootViewSurface",
		isVisible = true,
		adorneeSize = v38.viewportFillDimensions:map(v14),
		adorneeCFrame = v38.cFrame,
		adorneeParent = t3.adorneeParent,
		canvasSize = Constants.FULLSCREEN_CANVAS_SIZE,
		surfaceGuiParent = t3.surfaceGuiParent
	}, t3.content)
end
local function GlobalNavBarSurface(t4: {[any]: any}) -- line: 66
	-- upvalues: React (copy), useRootFocusNavigationBindings (copy), useCameraFacingGeometry (copy), Constants (copy), v16 (copy), getGlobalNavCFrame (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), SurfaceGuiWithAdornee (copy)
	local v40, v41 = React.useState(nil)
	local v42 = useRootFocusNavigationBindings(v41)
	local v43 = useCameraFacingGeometry(Constants.DEFAULT_SCREEN_DISTANCE_TO_CAMERA)
	local v44 = v43.viewportFillDimensions:map(v16)
	local v45 = React.joinBindings({
		viewportFillDimensions = v43.viewportFillDimensions,
		cFrame = v43.cFrame
	}):map(getGlobalNavCFrame)

	useFocusNavigableSurfaceRegistryConnection(v40, FocusNavigableSurfaceIdentifierEnum.NavBar)

	local v46 = React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v42,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1)
	}, t4.content)

	return React.createElement(SurfaceGuiWithAdornee, {
		isVisible = true,
		name = "GlobalNavBarSurface",
		adorneeSize = v44,
		adorneeCFrame = v45,
		canvasSize = Constants.TOP_BAR_CANVAS_SIZE,
		adorneeParent = t4.adorneeParent,
		surfaceGuiParent = t4.surfaceGuiParent
	}, v46)
end
local function ControllerBarSurface(t5: {[any]: any}) -- line: 96
	-- upvalues: useCameraFacingGeometry (copy), Constants (copy), v18 (copy), React (copy), getControllerBarCFrame (copy), SurfaceGuiWithAdornee (copy)
	local v48 = useCameraFacingGeometry(Constants.DEFAULT_SCREEN_DISTANCE_TO_CAMERA - 1)
	local v49 = v48.viewportFillDimensions:map(v18)
	local v50 = React.joinBindings({
		viewportFillDimensions = v48.viewportFillDimensions,
		cFrame = v48.cFrame
	}):map(getControllerBarCFrame)

	return React.createElement(SurfaceGuiWithAdornee, {
		isVisible = true,
		name = "ControllerBarSurface",
		adorneeSize = v49,
		adorneeCFrame = v50,
		canvasSize = Constants.CONTROLLER_BAR_CANVAS_SIZE,
		adorneeParent = t5.adorneeParent,
		surfaceGuiParent = t5.surfaceGuiParent
	}, t5.content)
end
local function TenFootUiLayout(t6: {[any]: any}) -- line: 123
	-- upvalues: React (copy), RootViewSurface (copy), GlobalNavBarSurface (copy), ControllerBarSurface (copy)
	return React.createElement(React.Fragment, nil, {
		RootViewSlot = if not t6.rootViewSlot then nil else React.createElement(RootViewSurface, {
			adorneeParent = t6.adorneeParent,
			surfaceGuiParent = t6.surfaceGuiParent,
			content = t6.rootViewSlot
		}),
		GlobalNavBarSlot = if not t6.globalNavSlot then nil else React.createElement(GlobalNavBarSurface, {
			adorneeParent = t6.adorneeParent,
			surfaceGuiParent = t6.surfaceGuiParent,
			content = t6.globalNavSlot
		}),
		ControllerBarSlot = if not t6.controllerBarSlot then nil else React.createElement(ControllerBarSurface, {
			adorneeParent = t6.adorneeParent,
			surfaceGuiParent = t6.surfaceGuiParent,
			content = t6.controllerBarSlot
		})
	})
end

return TenFootUiLayout
