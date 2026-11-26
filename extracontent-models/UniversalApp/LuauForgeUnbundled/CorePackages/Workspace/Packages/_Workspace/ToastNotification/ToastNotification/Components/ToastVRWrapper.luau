local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/UIBlox")

local vrConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/VrCompatibility").VRConstants
local panel3D = UIBlox.Core.VR.Panel3D
local constants = UIBlox.Core.VR.Constants

local defineFastFlag = game:DefineFastFlag("RepositionInExperienceVRToasts", false)

return function(props)
	local isConfirmModalOpen = props.isConfirmModalOpen
	local isToastOpen = props.isToastOpen
	local isCoreScript = props.isCoreScript

	local toastComponent = props.ToastComponent
	local confirmationModalComponent = props.ConfirmationModalComponent

	local ref = React.useRef(nil)

	local v5 = GuiService.CoreGuiFolder
		and GuiService.CoreGuiFolder:FindFirstChild(vrConstants.PositionLockedPanelName)

	if v5 then
		ref.current = v5
	else
		v5 = ref.current
	end

	local v6 = not v5 and 2.45 or v5.Size.Y

	local v7 = {
		partSize = vrConstants.ToastSize,
		offset = CFrame.lookAt(vrConstants.ToastPosition, vrConstants.DefaultCameraPosition),
		virtualScreenSize = vrConstants.ToastResolution,
		curvature = vrConstants.ToastCurvature,
		panelName = "ToastNotifications",
		hidden = not isToastOpen
	}

	if isCoreScript then
		local v8 = React.useCallback(function(p2)
			if not v5 then
				return p2.panelCFrame
			end

			if defineFastFlag then
				return v5.CFrame * CFrame.new(0, v6 * -0.53, v6 * -0.15) * CFrame.Angles(0.25, 0, 0)
			end

			return v5.CFrame * CFrame.new(0, v6 * -0.45, v6 * -0.15) * CFrame.Angles(0.2, 0, 0)
		end, { v5, v6 })

		v7 = {
			panelName = "ToastNotifications",
			partSize = defineFastFlag and Vector3.new(1, 0.5, 0) or Vector3.new(1.2, 0.6, 0),
			virtualScreenSize = Vector2.new(300, 150),
			lerp = false,
			tilt = 0,
			anchoring = constants.AnchoringTypes.Head,
			faceCamera = true,
			curvature = 0,
			alwaysOnTop = true,
			parent = GuiService.CoreGuiFolder,
			hidden = not isToastOpen,
			tiltCallback = v8
		}
	end

	local v8 = React.useCallback(function(p2)
		if v5 then
			return v5.CFrame * CFrame.new(0, 0, -0.1)
		end

		return p2.panelCFrame
	end, { v5 })

	return React.createElement(React.Fragment, nil, {
		React.createElement(panel3D, v7, { Toast = toastComponent }),
		React.createElement(panel3D, {
			panelName = "ConfirmationModal",
			partSize = Vector3.new(3, 3, 0),
			virtualScreenSize = Vector2.new(600, 600),
			lerp = false,
			tilt = 0,
			anchoring = constants.AnchoringTypes.Head,
			faceCamera = true,
			curvature = 0,
			alwaysOnTop = true,
			parent = GuiService.CoreGuiFolder,
			hidden = not isConfirmModalOpen,
			tiltCallback = v8
		}, { DeeplinkConfirmationModal = confirmationModalComponent })
	})
end
