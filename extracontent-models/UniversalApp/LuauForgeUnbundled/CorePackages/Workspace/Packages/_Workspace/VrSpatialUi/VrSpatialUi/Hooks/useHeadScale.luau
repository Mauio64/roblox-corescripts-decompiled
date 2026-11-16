local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/React")
local UIManager = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/UIManager")
local inExperienceUIVRIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/SharedExperimentDefinition").InExperienceUIVRIXP

local function checkAndScalePart(p2, p3)
	local additionalCameraScaleIfNeeded = UIManager.getInstance():getAdditionalCameraScaleIfNeeded()

	if p2 and p2.current then
		p2.current.Size = Vector3.new(
			p3.X * additionalCameraScaleIfNeeded,
			p3.Y * additionalCameraScaleIfNeeded,
			p2.current.Size.Z
		)
	end
end

local function useHeadScale(p2, p3)
	local state, setState = React.useState(function()
		return UIManager.getInstance():getAdditionalCameraScaleIfNeeded()
	end)

	React.useEffect(function()
		if inExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
			local v5 = p2
			local v6 = p3
			local additionalCameraScaleIfNeeded = UIManager.getInstance():getAdditionalCameraScaleIfNeeded()

			if v5 and v5.current then
				v5.current.Size = Vector3.new(
					v6.X * additionalCameraScaleIfNeeded,
					v6.Y * additionalCameraScaleIfNeeded,
					v5.current.Size.Z
				)
			end
		else
			setState(UIManager.getInstance():getAdditionalCameraScaleIfNeeded())
		end

		local headScaleChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function()
			if inExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
				local v5 = p2
				local v6 = p3
				local additionalCameraScaleIfNeeded = UIManager.getInstance():getAdditionalCameraScaleIfNeeded()

				if v5 and v5.current then
					v5.current.Size = Vector3.new(
						v6.X * additionalCameraScaleIfNeeded,
						v6.Y * additionalCameraScaleIfNeeded,
						v5.current.Size.Z
					)
				end
			else
				setState(UIManager.getInstance():getAdditionalCameraScaleIfNeeded())
			end
		end)
		return function()
			headScaleChangedConnection:Disconnect()
		end
	end, inExperienceUIVRIXP:isSpatialUIScalingFixEnabled() and { p2, p3 } or {})
	return state, setState
end

return useHeadScale
