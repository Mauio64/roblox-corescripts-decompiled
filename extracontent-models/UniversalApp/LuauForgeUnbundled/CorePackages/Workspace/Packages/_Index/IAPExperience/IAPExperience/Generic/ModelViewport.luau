local RunService = game:GetService("RunService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local characterUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Thumbnailing").CharacterUtility
local cameraUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Thumbnailing").CameraUtility
local cframeUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Thumbnailing").CFrameUtility
local emoteUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Thumbnailing").EmoteUtility

local defineFastFlag = game:DefineFastFlag("PurchasePromptPreviewMakeupHead2", false)

local function ModelViewport(props)
	local ref = React.useRef(nil)
	local v5, v6 = React.useBinding(nil)
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

				emoteUtility.SetPlayerCharacterPoseWithMoodFallback(clone)

				RunService.PostSimulation:Wait()

				if not ref2.current then
					return
				end

				local targetCFrame = cframeUtility.CalculateTargetCFrame(clone.Head.CFrame)
				local v7 = targetCFrame - targetCFrame.Position + clone.PrimaryPart.CFrame.Position

				local modelExtents, v8 = characterUtility.CalculateModelExtents(clone, v7)
				local v9 = {
					optFieldOfView = 30,
					targetCFrame = v7,
					minExtent = modelExtents,
					maxExtent = v8,
					extentScale = 1
				}

				v9.optCameraXRot = cameraUtility.XRotForFullBody
				v9.optCameraDistanceScale = cameraUtility.DistanceScaleForFullBody
				v9.extentScale = cameraUtility.DefaultBodyMarginScale
				cameraUtility.SetupCamera(camera, v9)
				v6(camera)
			else
				if not ref2.current then
					return
				end

				local v7

				if clone:IsA("Model") then
					v7 = clone
				else
					v7 = Instance.new("Model")
					clone.Parent = v7
					v7.Parent = ref.current
				end

				if defineFastFlag then
					local head = v7:FindFirstChild("Head")

					if head and head:IsA("MeshPart") and not v7:FindFirstChild("HumanoidRootPart") then
						local cframe = head.CFrame

						local bodyPartsExtents, v8 = characterUtility.CalculateBodyPartsExtents(cframe, { head })
						cameraUtility.SetupCamera(camera, {
							optFieldOfView = 30,
							targetCFrame = cframe,
							minExtent = bodyPartsExtents,
							maxExtent = v8,
							extentScale = 1.2,
							optCameraXRot = 5,
							optCameraYRot = 20
						})
						v6(camera)
						return
					end
				end

				cameraUtility.SetupAccessoryCamera(v7, camera)
				v6(camera)
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
				CurrentCamera = v5
			}, {
				WorldModel = React.createElement("WorldModel", { ref = ref })
			})
		}
	)
end

return ModelViewport
