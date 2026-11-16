local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local panel3D = UIBlox.Core.VR.Panel3D
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local object = LuauPolyfill.Object
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local vrConstants = require("@luauforge/bundled/fye").VRConstants
local overlayComponent = require("@luauforge/bundled/hLa").OverlayComponent
local module2 = require("@luauforge/bundled/fvl")

local module3 = require("@luauforge/bundled/hPD")
local getFFlagEnableVRChartsTab = SharedFlags.GetFFlagEnableVRChartsTab
local defineFastFlag = game:DefineFastFlag("EnableCentralFoundationOverlayProvider", false)

local v5 = { hideCentralOverlay = false }

local function fn(p2)
	return p2.CentralOverlay.OverlayType
end

local function fn2(p2)
	return p2.CentralOverlay.Arguments
end

local function fn3(p2)
	return p2.ScreenSize
end

return function(p2)
	local v6 = object.assign({}, v5, p2)

	local v7 = useSelector(fn)
	local v8 = overlayComponent[v7]
	local v9 = useSelector(fn2)
	local v10 = useSelector(fn3)

	local v11 = useDispatch()

	local v12 = React.useCallback(function()
		v11(module2())
	end)

	React.useEffect(function()
		if not v7 then
			v12()
		end
	end, { v7 or false })

	local openPosition = if v9 then v9.openPosition else nil

	if getFFlagEnableVRChartsTab() and openPosition then
		local v13 = v10.X / 2
		local v14 = v13 + (openPosition.X - v13) / 1.2
		v9 = object.assign({}, v9, {
			openPosition = Vector2.new(v14, openPosition.Y)
		})
	end

	local element = React.createElement(
		v8,
		object.assign({}, v9, {
			containerWidth = v10.X,
			closeCentralOverlayThunk = module2
		})
	)

	if v6.hideCentralOverlay or not v8 then
		return nil
	end

	local createElement = React.createElement
	local portal = Roact.Portal

	local createElement2 = React.createElement
	local v16 = {
		partSize = Vector2.new(vrConstants.MainScreenSize.X * 1.2, vrConstants.MainScreenSize.Y),
		offset = CFrame.new(vrConstants.CentralOverlayPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
		virtualScreenSize = Vector2.new(v10.X, v10.Y),
		panelName = "CentralOverlay",
		curvature = vrConstants.MainScreenCurvature
	}

	local createElement3 = React.createElement
	local v19 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Selectable = false
	}

	local v21 = if defineFastFlag then React.createElement(module3, nil, {
		OverlayComponent = element
	}) else nil

	if defineFastFlag then
		element = nil
	end

	return createElement(portal, { target = CoreGui }, {
		VRCentralOverlay = createElement2(panel3D, v16, {
			TextButtonWrapper = createElement3("TextButton", v19, {
				VRCentralFoundationOverlayProvider = v21,
				OverlayComponent = element
			})
		})
	})
end
