local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local GuiService = game:GetService("GuiService")
local VrSpatialUiParent = VrSpatialUi.Parent
local UIBlox = require(VrSpatialUiParent.UIBlox)
local React = require(VrSpatialUiParent.React)
local Constants = UIBlox.Core.VR.Constants
local Panel3D = UIBlox.Core.VR.Panel3D
local UIManager = require(VrSpatialUi.UIManager)

require(VrSpatialUi.Constants)

local registerRoactPanel = require(VrSpatialUi.registerRoactPanel)
local useHeadScale = require(VrSpatialUi.Hooks.useHeadScale)
local InExperienceUIVRIXP = require(VrSpatialUiParent.SharedExperimentDefinition).InExperienceUIVRIXP

local function Panel3DInSpatialUI(t1: {[any]: any}) -- line: 25
	-- upvalues: UIManager (copy), InExperienceUIVRIXP (copy), React (copy), useHeadScale (copy), Panel3D (copy), Constants (copy), GuiService (copy), registerRoactPanel (copy)
	local v14 = UIManager.getInstance():getScaledPartSizeInPixel(t1.panelType)
	local v15 = UIManager.getInstance():getPanelSizeInPixel(t1.panelType)
	local v16 = if not InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then nil else React.useRef(nil)
	local v17, _ = useHeadScale(v16, v14)

	return React.createElement(Panel3D, {
		lerp = true,
		tilt = 0,
		faceCamera = true,
		curvature = 0,
		panelName = t1.panelType,
		partRef = v16,
		partSize = if not InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then v14 * v17 else v14,
		virtualScreenSize = if not InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then v15 * v17 else v15,
		offset = CFrame.new(0, 0, 0),
		anchoring = Constants.AnchoringTypes.PanelManaged,
		parent = GuiService.CoreGuiFolder,
		connectPanelManagerFunction = function(p1) -- line: 43
			-- upvalues: registerRoactPanel (copy), t1 (copy), UIManager (copy)
			if p1 then
				registerRoactPanel(p1, t1.panelType, t1.visibilityObservable)

				return
			end

			UIManager.getInstance():removeRoactPanel(t1.panelType)
		end,
		zOffset = t1.zOffset or 1
	}, {
		ContentContainer = if not t1.requireCanvasGroup then t1.renderFunction(if not InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then v15 * v17 else v15) else React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			Name = "AnimatablePanelManagedContent",
			BorderSizePixel = 0,
			GroupTransparency = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Content = t1.renderFunction(if not InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then v15 * v17 else v15)
		})
	})
end

return React.memo(Panel3DInSpatialUI)
