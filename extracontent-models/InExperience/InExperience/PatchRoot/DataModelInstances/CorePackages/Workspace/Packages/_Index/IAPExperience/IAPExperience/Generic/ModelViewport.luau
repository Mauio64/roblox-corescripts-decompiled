local RunService = game:GetService("RunService")

local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local Thumbnailing = require(parent.Thumbnailing)
local CharacterUtility = Thumbnailing.CharacterUtility
local Thumbnailing2 = require(parent.Thumbnailing)
local CameraUtility = Thumbnailing2.CameraUtility
local Thumbnailing3 = require(parent.Thumbnailing)
local CFrameUtility = Thumbnailing3.CFrameUtility
local Thumbnailing4 = require(parent.Thumbnailing)
local EmoteUtility = Thumbnailing4.EmoteUtility

local defineFastFlag = game:DefineFastFlag("PurchasePromptPreviewMakeupHead2", false)

local function ModelViewport(props)
	local ref = React.useRef(nil)
	local currentCamera, v = React.useBinding(nil)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		ref2.current = true
		return function()
			ref2.current = false
		end
	end, {})

	React.useEffect(function()
		task.spawn(function()
			local clone = props.model:Clone()
			local camera = Instance.new("Camera")
			camera.CameraType = Enum.CameraType.Scriptable
			camera.Parent = ref.current
			camera.HeadLocked = true
			camera.VRTiltAndRollEnabled = true
			clone.Parent = ref.current

			if clone:IsA("Model") and clone.PrimaryPart then
				clone:MoveTo(Vector3.new(0, 0, 0))

				EmoteUtility.SetPlayerCharacterPoseWithMoodFallback(clone)

				RunService.PostSimulation:Wait()

				if not ref2.current then
					return
				end

				local targetCFrame = CFrameUtility.CalculateTargetCFrame(clone.Head.CFrame)
				local targetCFrame2 = targetCFrame - targetCFrame.Position + clone.PrimaryPart.CFrame.Position

				local modelExtents, maxExtent = CharacterUtility.CalculateModelExtents(clone, targetCFrame2)
				local v2 = {
					optFieldOfView = 30,
					targetCFrame = targetCFrame2,
					minExtent = modelExtents,
					maxExtent = maxExtent,
					extentScale = 1
				}

				v2.optCameraXRot = CameraUtility.XRotForFullBody
				v2.optCameraDistanceScale = CameraUtility.DistanceScaleForFullBody
				v2.extentScale = CameraUtility.DefaultBodyMarginScale
				CameraUtility.SetupCamera(camera, v2)
				v(camera)
			else
				if not ref2.current then
					return
				end

				local parent2

				if clone:IsA("Model") then
					parent2 = clone
				else
					parent2 = Instance.new("Model")
					clone.Parent = parent2
					parent2.Parent = ref.current
				end

				if defineFastFlag then
					local head = parent2:FindFirstChild("Head")

					if head and head:IsA("MeshPart") and not parent2:FindFirstChild("HumanoidRootPart") then
						local cframe = head.CFrame

						local bodyPartsExtents, maxExtent = CharacterUtility.CalculateBodyPartsExtents(cframe, { head })
						CameraUtility.SetupCamera(camera, {
							optFieldOfView = 30,
							targetCFrame = cframe,
							minExtent = bodyPartsExtents,
							maxExtent = maxExtent,
							extentScale = 1.2,
							optCameraXRot = 5,
							optCameraYRot = 20
						})
						v(camera)
						return
					end
				end

				CameraUtility.SetupAccessoryCamera(parent2, camera)
				v(camera)
			end
		end)
	end, {})

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = props.Size,
			Position = props.Position,
			LayoutOrder = props.LayoutOrder
		},
		{
			ViewportFrame = React.createElement("ViewportFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				LightColor = Color3.fromRGB(240, 240, 240),
				Ambient = Color3.fromRGB(160, 160, 160),
				LightDirection = Vector3.new(9.5, -12, 7.5),
				CurrentCamera = currentCamera
			}, {
				WorldModel = React.createElement("WorldModel", { ref = ref })
			})
		}
	)
end

return ModelViewport
