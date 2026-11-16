local TweenService = game:GetService("TweenService")

local AvatarViewport = script:FindFirstAncestor("AvatarViewport")
local parent = AvatarViewport.Parent

local React = require(parent.React)

local computeOrbitHeadCFrame = require(AvatarViewport.Camera.computeOrbitHeadCFrame)
local Constants = require(AvatarViewport.Constants)
require(AvatarViewport.Types)

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

	local v = React.useCallback(function()
		local current = ref.current

		if current then
			current:Cancel()
			ref.current = nil
		end
	end, {})

	local frameCamera = React.useCallback(function(p)
		local current = data.cameraRef.current
		local model = data.model

		if not (current and model) then
			return
		end

		local current2 = ref2.current

		local current3 = ref3.current
		local cframe

		if current3 then
			cframe = current3({
				character = model,
				yRotDeg = yRotDegRef.current,
				distanceScale = distanceScaleRef.current,
				config = current2
			})
		else
			cframe = computeOrbitHeadCFrame({
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

		if not cframe then
			return
		end

		current.FieldOfView = current2.fieldOfViewDeg

		if p and p.tween then
			v()
			local tween = TweenService:Create(current, Constants.EmoteCameraTweenInfo, {
				CFrame = cframe
			})

			ref.current = tween
			tween.Completed:Connect(function()
				if ref.current == tween then
					ref.current = nil
				end
			end)
			tween:Play()
		else
			v()
			current.CFrame = cframe
		end
	end, { data.model, v, data.cameraRef })

	React.useEffect(function()
		frameCamera()
	end, {
		data.yRotDeg,
		data.distanceScale,
		data.model,
		data.config.fieldOfViewDeg,
		data.config.fieldOfViewForDistanceScaleDeg,
		data.config.layout.viewportHeight,
		data.config.layout.cutoutTopOffset,
		data.config.layout.cutoutDiameter,
		frameCamera
	})

	React.useEffect(function()
		return function()
			v()
		end
	end, { v })

	return { frameCamera = frameCamera }
end

return useOrbitHeadCamera
