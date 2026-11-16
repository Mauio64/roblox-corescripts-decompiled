local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local GuiService = game:GetService("GuiService")
local parent = VrSpatialUi.Parent
local UIBlox = require(parent.UIBlox)
local React = require(parent.React)
local __subscribeToBinding = React.__subscribeToBinding
local Constants = UIBlox.Core.VR.Constants
local Panel3D = UIBlox.Core.VR.Panel3D

local UIManager = require(VrSpatialUi.UIManager)
require(VrSpatialUi.Constants)
local registerRoactPanel = require(VrSpatialUi.registerRoactPanel)
local useHeadScale = require(VrSpatialUi.Hooks.useHeadScale)
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition.InExperienceUIVRIXP

local function Panel3DInSpatialUI(props)
	local scaledPartSizeInPixel = UIManager.getInstance():getScaledPartSizeInPixel(props.panelType)
	local panelSizeInPixel = UIManager.getInstance():getPanelSizeInPixel(props.panelType)
	local ref

	if InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
		ref = React.useRef(nil)
	end

	local v, _ = useHeadScale(ref, scaledPartSizeInPixel)

	local fn = nil
	local createElement = React.createElement
	local v2 = {
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

	if not InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
		scaledPartSizeInPixel *= v
	end

	v2.partSize = scaledPartSizeInPixel
	local virtualScreenSize

	if InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
		virtualScreenSize = panelSizeInPixel
	else
		virtualScreenSize = panelSizeInPixel * v
	end

	v2.virtualScreenSize = virtualScreenSize
	v2.offset = CFrame.new(0, 0, 0)

	v2.anchoring = Constants.AnchoringTypes.PanelManaged

	v2.parent = GuiService.CoreGuiFolder
	function v2.connectPanelManagerFunction(p)
		if p then
			registerRoactPanel(p, props.panelType, props.visibilityObservable, props.keepVisibleWhenTopBarHidden)

			if props.keepVisibleWhenTopBarHidden and props.controlsVisible and p.current then
				local current = p.current
				local adornee = current.Adornee
				local active = current.Active
				local canQuery = adornee.CanQuery
				local function updateInput(flag: boolean) -- 1 equivalent call inferred from this helper
					current.Active = active and flag
					adornee.CanQuery = canQuery and flag
				end
				local v3 = __subscribeToBinding(props.controlsVisible, updateInput)
				updateInput(props.controlsVisible:getValue()) -- inferred equivalent call
				fn = function()
					v3()
					current.Active = active
					adornee.CanQuery = canQuery
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
	v2.zOffset = props.zOffset or 1
	local contentContainer

	if props.requireCanvasGroup then
		local createElement2 = React.createElement
		local v3 = {
			BackgroundTransparency = 1,
			Name = "AnimatablePanelManagedContent",
			BorderSizePixel = 0,
			GroupTransparency = 0,
			Size = UDim2.new(1, 0, 1, 0)
		}

		local renderFunction = props.renderFunction

		if not InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
			panelSizeInPixel *= v
		end

		contentContainer = createElement2("CanvasGroup", v3, {
			Content = renderFunction(panelSizeInPixel)
		})
	else
		local renderFunction = props.renderFunction

		if not InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
			panelSizeInPixel *= v
		end

		contentContainer = renderFunction(panelSizeInPixel)
	end

	return createElement(Panel3D, v2, { ContentContainer = contentContainer })
end

return React.memo(Panel3DInSpatialUI)
