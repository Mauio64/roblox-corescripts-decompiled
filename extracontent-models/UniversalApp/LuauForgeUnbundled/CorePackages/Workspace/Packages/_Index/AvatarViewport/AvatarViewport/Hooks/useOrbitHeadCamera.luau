local TweenService = game:GetService("TweenService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarViewport/React")

local computeOrbitHeadCFrame = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Camera/computeOrbitHeadCFrame")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")

local function useOrbitHeadCamera(data)
	local ref = React.useRef(nil)

	local ref2 = React.useRef(data.config)
	ref2.current = data.config
	local ref3 = React.useRef(data.frameCloseupPreviewCamera)
	ref3.current = data.frameCloseupPreviewCamera

	local ref4 = React.useRef(data.yRotDeg)
	local ref5 = React.useRef(data.distanceScale)
	local yRotDegRef = data.yRotDegRef or ref4
	local distanceScaleRef = data.distanceScaleRef or ref5

	if not data.yRotDegRef then
		ref4.current = data.yRotDeg
	end

	if not data.distanceScaleRef then
		ref5.current = data.distanceScale
	end

	local v5 = React.useCallback(function()
		local current = ref.current

		if current then
			current:Cancel()
			ref.current = nil
		end
	end, {})

	local v6 = React.useCallback(function(p2)
		local current = data.cameraRef.current
		local model = data.model

		if not (current and model) then
			return
		end

		local current2 = ref2.current

		local current3 = ref3.current
		local v7

		if current3 then
			v7 = current3({
				character = model,
				yRotDeg = yRotDegRef.current,
				distanceScale = distanceScaleRef.current,
				config = current2
			})
		else
			v7 = computeOrbitHeadCFrame({
				character = model,
				yRotDeg = yRotDegRef.current,
				distanceScale = distanceScaleRef.current,
				baseDistance = current2.baseDistance,
				fieldOfViewDeg = current2.fieldOfViewDeg,
				fieldOfViewForDistanceScaleDeg = current2.fieldOfViewForDistanceScaleDeg,
				focusPartName = current2.focusPartName,
				layout = current2.layout
			})
		end

		if not v7 then
			return
		end

		current.FieldOfView = current2.fieldOfViewDeg

		if p2 and p2.tween then
			v5()
			local tween = TweenService:Create(current, Constants.EmoteCameraTweenInfo, {
				CFrame = v7
			})

			ref.current = tween
			tween.Completed:Connect(function()
				if ref.current == tween then
					ref.current = nil
				end
			end)
			tween:Play()
		else
			v5()
			current.CFrame = v7
		end
	end, { data.model, v5, data.cameraRef })

	React.useEffect(function()
		v6()
	end, {
		data.yRotDeg,
		data.distanceScale,
		data.model,
		data.config.fieldOfViewDeg,
		data.config.fieldOfViewForDistanceScaleDeg,
		data.config.layout.viewportHeight,
		data.config.layout.cutoutTopOffset,
		data.config.layout.cutoutDiameter,
		v6
	})

	React.useEffect(function()
		return function()
			v5()
		end
	end, { v5 })

	return { frameCamera = v6 }
end

return useOrbitHeadCamera
