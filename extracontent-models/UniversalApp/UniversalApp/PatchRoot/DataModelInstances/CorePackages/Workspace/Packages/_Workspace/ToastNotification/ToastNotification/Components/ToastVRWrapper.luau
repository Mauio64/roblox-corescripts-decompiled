local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local UIBlox = require(ParentParent.UIBlox)
local VRConstants = require(ParentParent.VrCompatibility).VRConstants
local Panel3D = UIBlox.Core.VR.Panel3D
local Constants = UIBlox.Core.VR.Constants
local v8 = game:DefineFastFlag("RepositionInExperienceVRToasts", false)

return function(p1) -- line: 28
	-- upvalues: React (copy), GuiService (copy), VRConstants (copy), v8 (copy), Constants (copy), Panel3D (copy)
	local isConfirmModalOpen = p1.isConfirmModalOpen
	local isToastOpen = p1.isToastOpen
	local isCoreScript = p1.isCoreScript
	local ToastComponent = p1.ToastComponent
	local ConfirmationModalComponent = p1.ConfirmationModalComponent
	local v15 = React.useRef(nil)
	local u16 = GuiService.CoreGuiFolder and GuiService.CoreGuiFolder:FindFirstChild(VRConstants.PositionLockedPanelName)

	if u16 then
		v15.current = u16
	else
		u16 = v15.current
	end

	local v17 = not u16 and 2.45 or u16.Size.Y
	local t1 = {
		panelName = "ToastNotifications",
		partSize = VRConstants.ToastSize,
		offset = CFrame.lookAt(VRConstants.ToastPosition, VRConstants.DefaultCameraPosition),
		virtualScreenSize = VRConstants.ToastResolution,
		curvature = VRConstants.ToastCurvature,
		hidden = not isToastOpen
	}

	if isCoreScript then
		local v19 = React.useCallback(function(p2) -- line: 62
			-- upvalues: u16 (ref), v8 (copy), v17 (copy)
			if u16 then
				if v8 then
					return u16.CFrame * CFrame.new(0, v17 * -0.53, v17 * -0.15) * CFrame.Angles(0.25, 0, 0)
				end

				return u16.CFrame * CFrame.new(0, v17 * -0.45, v17 * -0.15) * CFrame.Angles(0.2, 0, 0)
			end

			return p2.panelCFrame
		end, {
			u16,
			v17
		})

		t1 = {
			panelName = "ToastNotifications",
			lerp = false,
			tilt = 0,
			faceCamera = true,
			curvature = 0,
			alwaysOnTop = true,
			partSize = if not v8 then Vector3.new(1.2000000476837158, 0.6000000238418579, 0) else Vector3.new(1, 0.5, 0),
			virtualScreenSize = Vector2.new(300, 150),
			anchoring = Constants.AnchoringTypes.Head,
			parent = GuiService.CoreGuiFolder,
			hidden = not isToastOpen,
			tiltCallback = v19
		}
	end

	local v20 = React.useCallback(function(p3) -- line: 93
		-- upvalues: u16 (ref)
		if u16 then
			return u16.CFrame * CFrame.new(0, 0, -0.1)
		end

		return p3.panelCFrame
	end, { u16 })

	return React.createElement(React.Fragment, nil, {
		React.createElement(Panel3D, t1, {
			Toast = ToastComponent
		}),
		React.createElement(Panel3D, {
			panelName = "ConfirmationModal",
			partSize = Vector3.new(3, 3, 0),
			lerp = false,
			tilt = 0,
			faceCamera = true,
			curvature = 0,
			alwaysOnTop = true,
			virtualScreenSize = Vector2.new(600, 600),
			anchoring = Constants.AnchoringTypes.Head,
			parent = GuiService.CoreGuiFolder,
			hidden = not isConfirmModalOpen,
			tiltCallback = v20
		}, {
			DeeplinkConfirmationModal = ConfirmationModalComponent
		})
	})
end
