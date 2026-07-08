local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local VrSpatialUiParent = VrSpatialUi.Parent
local React = require(VrSpatialUiParent.React)
local UIManager = require(VrSpatialUi.UIManager)
local InExperienceUIVRIXP = require(VrSpatialUiParent.SharedExperimentDefinition).InExperienceUIVRIXP

local function checkAndScalePart(p1, vector2: Vector2) -- line: 7
	-- upvalues: UIManager (copy)
	local v10 = UIManager.getInstance():getAdditionalCameraScaleIfNeeded()

	if p1 and p1.current then
		p1.current.Size = Vector3.new(vector2.X * v10, vector2.Y * v10, p1.current.Size.Z)
	end
end
local function useHeadScale(p2, vector2: Vector2) -- line: 15
	-- upvalues: React (copy), UIManager (copy), InExperienceUIVRIXP (copy)
	local v13, v14 = React.useState(function() -- line: 16
		-- upvalues: UIManager (copy)
		return UIManager.getInstance():getAdditionalCameraScaleIfNeeded()
	end)

	React.useEffect(function() -- line: 19
		-- upvalues: InExperienceUIVRIXP (copy), p2 (copy), vector2 (copy), UIManager (copy), v14 (copy)
		if InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
			local v15 = p2
			local v16 = vector2
			local v17 = UIManager.getInstance():getAdditionalCameraScaleIfNeeded()

			if v15 and v15.current then
				v15.current.Size = Vector3.new(v16.X * v17, v16.Y * v17, v15.current.Size.Z)
			end
		else
			v14(UIManager.getInstance():getAdditionalCameraScaleIfNeeded())
		end

		local connection = workspace.CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function() -- line: 26
			-- upvalues: InExperienceUIVRIXP (copy), p2 (copy), vector2 (copy), UIManager (copy), v14 (copy)
			if InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then
				local v19 = p2
				local v20 = vector2
				local v21 = UIManager.getInstance():getAdditionalCameraScaleIfNeeded()

				if v19 and v19.current then
					v19.current.Size = Vector3.new(v20.X * v21, v20.Y * v21, v19.current.Size.Z)

					return
				end
			else
				v14(UIManager.getInstance():getAdditionalCameraScaleIfNeeded())
			end
		end)

		return function() -- line: 33
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, if not InExperienceUIVRIXP:isSpatialUIScalingFixEnabled() then {} else {
		p2,
		vector2
	})

	return v13, v14
end

return useHeadScale
