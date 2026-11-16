local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local parent = VrSpatialUi.Parent
local React = require(parent.React)
local UIManager = require(VrSpatialUi.UIManager)
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition.InExperienceUIVRIXP

local function checkAndScalePart(p, vector2: Vector2) -- 2 equivalent calls inferred from this helper
	local additionalCameraScaleIfNeeded = UIManager.getInstance():getAdditionalCameraScaleIfNeeded()

	if p and p.current then
		p.current.Size = Vector3.new(
			vector2.X * additionalCameraScaleIfNeeded,
			vector2.Y * additionalCameraScaleIfNeeded,
			p.current.Size.Z
		)
	end
end

local function useHeadScale(p, vector2: Vector2)
	local state, setState = React.useState(function()
		return UIManager.getInstance():getAdditionalCameraScaleIfNeeded()
	end)

	React.useEffect(function()
		if InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
			checkAndScalePart(p, vector2) -- inferred equivalent call
		else
			setState(UIManager.getInstance():getAdditionalCameraScaleIfNeeded())
		end

		local headScaleChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function()
			if InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
				checkAndScalePart(p, vector2) -- inferred equivalent call
			else
				setState(UIManager.getInstance():getAdditionalCameraScaleIfNeeded())
			end
		end)
		return function()
			headScaleChangedConnection:Disconnect()
		end
	end, InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() and { p, vector2 } or {})
	return state, setState
end

return useHeadScale
