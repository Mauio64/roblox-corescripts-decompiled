local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local ReactUtils = require(parent2.ReactUtils)

local CaptureService = game:GetService("CaptureService")

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)

local CaptureControlsView = require(parent.Components.CoreUI.CaptureControlsView)
local Constants = require(parent.Constants)
local makeVideoCaptureFailedHandler = require(parent.Utils.makeVideoCaptureFailedHandler)
local makeVideoCaptureStartFailedHandler = require(parent.Utils.makeVideoCaptureStartFailedHandler)
local ToastContainer = require(parent.Components.Common.ToastContainer)

local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEventConnection = ReactUtils.useEventConnection
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function(_)
	local v = useDispatch()

	local v2 = useSelector(function(p)
		return p[Constants.RoduxKey].Carousel.IsOpen
	end)

	local v3 = useSelector(function(p)
		return p[Constants.RoduxKey].IsCapturesCoreGuiEnabled
	end)

	local v4 = useCallback(makeVideoCaptureStartFailedHandler(v), {})
	useEventConnection(CaptureService.UserVideoCaptureStartFailed, v4)

	local v5 = useCallback(makeVideoCaptureFailedHandler(v), {})
	useEventConnection(CaptureService.UserVideoCaptureFailed, v5)

	local createElement = React.createElement
	local fragment = React.Fragment
	local captureControlsView

	if v3 then
		captureControlsView = React.createElement(CaptureControlsView)
	end

	local toastsFrame

	if not v2 then
		toastsFrame = React.createElement(
			"Frame",
			{
				Active = false,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = Constants.ZIndex.Toasts
			},
			{
				ToastContainer = React.createElement(ToastContainer)
			}
		)
	end

	return createElement(fragment, {}, {
		CaptureControlsView = captureControlsView,
		ToastsFrame = toastsFrame
	})
end
