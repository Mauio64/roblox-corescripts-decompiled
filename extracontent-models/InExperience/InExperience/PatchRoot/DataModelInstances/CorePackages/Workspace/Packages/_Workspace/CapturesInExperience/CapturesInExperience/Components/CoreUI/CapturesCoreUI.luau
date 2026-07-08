local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ReactUtils = require(ParentParentParent.ReactUtils)
local CaptureService = game:GetService("CaptureService")
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local CaptureControlsView = require(ParentParent.Components.CoreUI.CaptureControlsView)
local Constants = require(ParentParent.Constants)
local makeVideoCaptureFailedHandler = require(ParentParent.Utils.makeVideoCaptureFailedHandler)
local makeVideoCaptureStartFailedHandler = require(ParentParent.Utils.makeVideoCaptureStartFailedHandler)
local ToastContainer = require(ParentParent.Components.Common.ToastContainer)
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEventConnection = ReactUtils.useEventConnection
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FFlagEnableUpdatedCaptureControls = require(ParentParent.Flags.FFlagEnableUpdatedCaptureControls)

return function(_: {[any]: any}) -- line: 25
	-- upvalues: useDispatch (copy), useSelector (copy), Constants (copy), useCallback (copy), makeVideoCaptureStartFailedHandler (copy), useEventConnection (copy), CaptureService (copy), makeVideoCaptureFailedHandler (copy), React (copy), FFlagEnableUpdatedCaptureControls (copy), CaptureControlsView (copy), ToastContainer (copy)
	local v18 = useDispatch()
	local v19 = useSelector(function(p1) -- line: 28
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].Carousel.IsOpen
	end)
	local v20 = useSelector(function(p2) -- line: 32
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].IsCapturesCoreGuiEnabled
	end)
	local v21 = useCallback(makeVideoCaptureStartFailedHandler(v18), {})

	useEventConnection(CaptureService.UserVideoCaptureStartFailed, v21)

	local v22 = useCallback(makeVideoCaptureFailedHandler(v18), {})

	useEventConnection(CaptureService.UserVideoCaptureFailed, v22)

	return React.createElement(React.Fragment, {}, {
		CaptureControlsView = if not FFlagEnableUpdatedCaptureControls or not v20 then nil else React.createElement(CaptureControlsView),
		ToastsFrame = if v19 then nil else React.createElement("Frame", {
			Active = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = Constants.ZIndex.Toasts
		}, {
			ToastContainer = React.createElement(ToastContainer)
		})
	})
end
