local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local VrCompatibility = require(parent.VrCompatibility)
local VRConstants = VrCompatibility.VRConstants
local Panel3D = UIBlox.Core.VR.Panel3D
local Constants = UIBlox.Core.VR.Constants

local defineFastFlag = game:DefineFastFlag("RepositionInExperienceVRToasts", false)

return function(props)
	local isConfirmModalOpen = props.isConfirmModalOpen
	local isToastOpen = props.isToastOpen
	local isCoreScript = props.isCoreScript

	local toastComponent = props.ToastComponent
	local confirmationModalComponent = props.ConfirmationModalComponent

	local ref = React.useRef(nil)

	local current = GuiService.CoreGuiFolder
		and GuiService.CoreGuiFolder:FindFirstChild(VRConstants.PositionLockedPanelName)

	if current then
		ref.current = current
	else
		current = ref.current
	end

	local v = not current and 2.45 or current.Size.Y

	local v2 = {
		partSize = VRConstants.ToastSize,
		offset = CFrame.lookAt(VRConstants.ToastPosition, VRConstants.DefaultCameraPosition),
		virtualScreenSize = VRConstants.ToastResolution,
		curvature = VRConstants.ToastCurvature,
		panelName = "ToastNotifications",
		hidden = not isToastOpen
	}

	if isCoreScript then
		local tiltCallback = React.useCallback(function(p)
			if not current then
				return p.panelCFrame
			end

			if defineFastFlag then
				return current.CFrame * CFrame.new(0, v * -0.53, v * -0.15) * CFrame.Angles(0.25, 0, 0)
			end

			return current.CFrame * CFrame.new(0, v * -0.45, v * -0.15) * CFrame.Angles(0.2, 0, 0)
		end, { current, v })

		v2 = {
			panelName = "ToastNotifications",
			partSize = defineFastFlag and Vector3.new(1, 0.5, 0) or Vector3.new(1.2, 0.6, 0),
			virtualScreenSize = Vector2.new(300, 150),
			lerp = false,
			tilt = 0,
			anchoring = Constants.AnchoringTypes.Head,
			faceCamera = true,
			curvature = 0,
			alwaysOnTop = true,
			parent = GuiService.CoreGuiFolder,
			hidden = not isToastOpen,
			tiltCallback = tiltCallback
		}
	end

	local tiltCallback = React.useCallback(function(p)
		if current then
			return current.CFrame * CFrame.new(0, 0, -0.1)
		end

		return p.panelCFrame
	end, { current })

	return React.createElement(React.Fragment, nil, {
		React.createElement(Panel3D, v2, { Toast = toastComponent }),
		React.createElement(Panel3D, {
			panelName = "ConfirmationModal",
			partSize = Vector3.new(3, 3, 0),
			virtualScreenSize = Vector2.new(600, 600),
			lerp = false,
			tilt = 0,
			anchoring = Constants.AnchoringTypes.Head,
			faceCamera = true,
			curvature = 0,
			alwaysOnTop = true,
			parent = GuiService.CoreGuiFolder,
			hidden = not isConfirmModalOpen,
			tiltCallback = tiltCallback
		}, { DeeplinkConfirmationModal = confirmationModalComponent })
	})
end
