local GuiService = game:GetService("GuiService")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/UIBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/React")
local __subscribeToBinding = React.__subscribeToBinding
local constants = UIBlox.Core.VR.Constants
local panel3D = UIBlox.Core.VR.Panel3D

local UIManager = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/UIManager")
require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Constants")
local registerRoactPanel = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/registerRoactPanel")
local useHeadScale = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Hooks/useHeadScale")
local inExperienceUIVRIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/SharedExperimentDefinition").InExperienceUIVRIXP

local function Panel3DInSpatialUI(props)
	local scaledPartSizeInPixel = UIManager.getInstance():getScaledPartSizeInPixel(props.panelType)
	local panelSizeInPixel = UIManager.getInstance():getPanelSizeInPixel(props.panelType)
	local ref = if inExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then React.useRef(nil) else nil
	local v5, v6 = useHeadScale(ref, scaledPartSizeInPixel)

	local fn = nil
	local createElement = React.createElement
	local v8 = {
		panelName = props.panelType,
		partRef = ref,
		partSize = 0,
		virtualScreenSize = 0,
		offset = 0,
		lerp = true,
		tilt = 0,
		anchoring = 0,
		faceCamera = true,
		curvature = 0,
		parent = 0,
		connectPanelManagerFunction = 0,
		zOffset = 0
	}

	if not inExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
		scaledPartSizeInPixel *= v5
	end

	v8.partSize = scaledPartSizeInPixel
	local v9 = if inExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then panelSizeInPixel else panelSizeInPixel * v5
	v8.virtualScreenSize = v9
	v8.offset = CFrame.new(0, 0, 0)

	v8.anchoring = constants.AnchoringTypes.PanelManaged

	v8.parent = GuiService.CoreGuiFolder
	function v8.connectPanelManagerFunction(p2)
		if p2 then
			registerRoactPanel(p2, props.panelType, props.visibilityObservable, props.keepVisibleWhenTopBarHidden)

			if props.keepVisibleWhenTopBarHidden and props.controlsVisible and p2.current then
				local current = p2.current
				local adornee = current.Adornee
				local active = current.Active
				local canQuery = adornee.CanQuery
				local function updateInput(p3)
					current.Active = active and p3
					adornee.CanQuery = canQuery and p3
				end
				local v10 = __subscribeToBinding(props.controlsVisible, updateInput)
				local value = props.controlsVisible:getValue()
				current.Active = active and value
				adornee.CanQuery = canQuery and value

				fn = function()
					v10()
					local v11 = adornee
					current.Active = active
					v11.CanQuery = canQuery
				end
			end
		else
			if fn then
				fn()
				fn = nil
			end

			UIManager.getInstance():removeRoactPanel(props.panelType)
		end
	end
	v8.zOffset = props.zOffset or 1
	local v11

	if props.requireCanvasGroup then
		local createElement2 = React.createElement
		local v13 = {
			BackgroundTransparency = 1,
			Name = "AnimatablePanelManagedContent",
			BorderSizePixel = 0,
			GroupTransparency = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}

		local renderFunction = props.renderFunction

		if not inExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
			panelSizeInPixel *= v5
		end

		v11 = createElement2("CanvasGroup", v13, {
			Content = renderFunction(panelSizeInPixel)
		})
	else
		local renderFunction = props.renderFunction

		if not inExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
			panelSizeInPixel *= v5
		end

		v11 = renderFunction(panelSizeInPixel)
	end

	return createElement(panel3D, v8, { ContentContainer = v11 })
end

return React.memo(Panel3DInSpatialUI)
