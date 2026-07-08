local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local CharacterUtility = require(ParentParent.Thumbnailing).CharacterUtility
local CameraUtility = require(ParentParent.Thumbnailing).CameraUtility
local CFrameUtility = require(ParentParent.Thumbnailing).CFrameUtility
local EmoteUtility = require(ParentParent.Thumbnailing).EmoteUtility
local v8 = game:DefineFastFlag("PurchasePromptPreviewMakeupHead", false)

local function ModelViewport(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), EmoteUtility (copy), RunService (copy), CFrameUtility (copy), CharacterUtility (copy), CameraUtility (copy), v8 (copy)
	local v11 = React.useRef(nil)
	local v12, v13 = React.useBinding(nil)
	local v14 = React.useRef(false)

	React.useEffect(function() -- line: 32
		-- upvalues: v14 (copy)
		v14.current = true

		return function() -- line: 34
			-- upvalues: v14 (copy)
			v14.current = false
		end
	end, {})
	React.useEffect(function() -- line: 39
		-- upvalues: t1 (copy), v11 (copy), EmoteUtility (copy), RunService (copy), v14 (copy), CFrameUtility (copy), CharacterUtility (copy), CameraUtility (copy), v13 (copy), v8 (copy)
		task.spawn(function() -- line: 41
			-- upvalues: t1 (copy), v11 (copy), EmoteUtility (copy), RunService (copy), v14 (copy), CFrameUtility (copy), CharacterUtility (copy), CameraUtility (copy), v13 (copy), v8 (copy)
			local clone = t1.model:Clone()
			local Camera = Instance.new("Camera")

			Camera.CameraType = Enum.CameraType.Scriptable
			Camera.Parent = v11.current
			Camera.HeadLocked = true
			Camera.VRTiltAndRollEnabled = true
			clone.Parent = v11.current

			if clone:IsA("Model") and clone.PrimaryPart then
				clone:MoveTo((Vector3.new(0, 0, 0)))
				EmoteUtility.SetPlayerCharacterPoseWithMoodFallback(clone)
				RunService.PostSimulation:Wait()

				if not v14.current then
					return
				end

				local v17 = CFrameUtility.CalculateTargetCFrame(clone.Head.CFrame)
				local v18 = v17 - v17.Position + clone.PrimaryPart.CFrame.Position
				local v19, v20 = CharacterUtility.CalculateModelExtents(clone, v18)
				local t2 = {
					optFieldOfView = 30,
					extentScale = 1,
					targetCFrame = v18,
					minExtent = v19,
					maxExtent = v20,
					optCameraXRot = CameraUtility.XRotForFullBody,
					optCameraDistanceScale = CameraUtility.DistanceScaleForFullBody,
					extentScale = CameraUtility.DefaultBodyMarginScale
				}

				CameraUtility.SetupCamera(Camera, t2)
				v13(Camera)

				return
			end

			if not v14.current then
				return
			end

			local v22 = clone

			if not clone:IsA("Model") then
				v22 = Instance.new("Model")
				clone.Parent = v22
				v22.Parent = v11.current
			end

			if v8 then
				local Head = v22:FindFirstChild("Head")

				if Head and Head:IsA("MeshPart") then
					Head.CFrame = CFrame.new()

					local HeadCFrame = Head.CFrame
					local v25, v26 = CharacterUtility.CalculateModelExtents(v22, HeadCFrame)
					local t3 = {
						optFieldOfView = 30,
						extentScale = 1.2,
						optCameraXRot = 5,
						optCameraYRot = 20,
						targetCFrame = HeadCFrame,
						minExtent = v25,
						maxExtent = v26
					}

					CameraUtility.SetupCamera(Camera, t3)
					v13(Camera)

					return
				end

				CameraUtility.SetupAccessoryCamera(v22, Camera)
				v13(Camera)

				return
			end

			CameraUtility.SetupAccessoryCamera(v22, Camera)
			v13(Camera)
		end)
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t1.Size,
		Position = t1.Position,
		LayoutOrder = t1.LayoutOrder
	}, {
		ViewportFrame = React.createElement("ViewportFrame", {
			BackgroundTransparency = 1,
			LightDirection = Vector3.new(9.5, -12, 7.5),
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			LightColor = Color3.fromRGB(240, 240, 240),
			Ambient = Color3.fromRGB(160, 160, 160),
			CurrentCamera = v12
		}, {
			WorldModel = React.createElement("WorldModel", {
				ref = v11
			})
		})
	})
end

return ModelViewport
