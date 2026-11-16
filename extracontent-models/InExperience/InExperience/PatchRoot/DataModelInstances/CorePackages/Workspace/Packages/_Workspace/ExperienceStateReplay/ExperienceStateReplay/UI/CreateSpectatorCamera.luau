local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local parent = script.Parent
local CreateTemporaryOverlay = require(parent.CreateTemporaryOverlay)

local displayName = nil

local cframe3 = nil

local v = 0
local humanoids = {}
local v2 = 1
local cameraSubject = nil

local v3 = 50

local v4 = Vector3.new(0, 0, 0)
local v5 = nil

return {
	createSpectatorCamera = function(p)
		local inputFrame = Instance.new("Frame")
		inputFrame.Name = "InputFrame"

		inputFrame.Size = UDim2.new(0.4, 0, 0.15, 0)
		inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		inputFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		inputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		inputFrame.BackgroundTransparency = 0.4
		inputFrame.BorderSizePixel = 0
		inputFrame.Visible = false
		inputFrame.Parent = p.screenGui

		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Padding = UDim.new(0, 5)
		uiListLayout.Parent = inputFrame

		local speedLabel = Instance.new("TextLabel")
		speedLabel.Name = "SpeedLabel"

		speedLabel.Size = UDim2.new(0.9, 0, 0.3, 0)

		speedLabel.BackgroundTransparency = 1
		speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		speedLabel.Font = Enum.Font.SourceSans
		speedLabel.TextScaled = true

		speedLabel.Text = "Free Cam Speed (Current: " .. math.floor(v3) .. ") Between 10 And 20000"
		speedLabel.Parent = inputFrame

		local speedTextBox = Instance.new("TextBox")
		speedTextBox.Name = "SpeedTextBox"

		speedTextBox.Size = UDim2.new(0.9, 0, 0.25, 0)

		speedTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		speedTextBox.BackgroundTransparency = 0
		speedTextBox.Text = tostring((math.floor(v3)))
		speedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		speedTextBox.TextScaled = true

		speedTextBox.Font = Enum.Font.SourceSans
		speedTextBox.ClearTextOnFocus = true
		speedTextBox.TextXAlignment = Enum.TextXAlignment.Center
		speedTextBox.Parent = inputFrame

		local applyButton = Instance.new("TextButton")
		applyButton.Name = "ApplyButton"

		applyButton.Size = UDim2.new(0.9, 0, 0.25, 0)

		applyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
		applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		applyButton.Text = "Apply Speed"
		applyButton.Font = Enum.Font.SourceSansBold
		applyButton.TextScaled = true

		applyButton.Parent = inputFrame

		applyButton.MouseButton1Click:Connect(function()
			local success, result = pcall(tonumber, speedTextBox.Text)

			if success and type(result) == "number" and result >= 10 and result <= 20000 then
				v3 = result
				speedLabel.Text = "Free Cam Speed (Current: " .. math.floor(v3) .. ") Between 10 And 20000"
			else
				warn("Invalid speed input: " .. speedTextBox.Text .. ". Please enter a number between 10 and 20000.")
				speedTextBox.Text = tostring((math.floor(v3)))
			end
		end)

		local visible = false

		local function updateHumanoidList()
			humanoids = {}

			for _, humanoid in ipairs(workspace:GetDescendants()) do
				if humanoid:IsA("Humanoid") then
					table.insert(humanoids, humanoid)
				end
			end
		end

		local function getCurrentHumanoid() -- 1 equivalent call inferred from this helper
			updateHumanoidList()

			if #humanoids == 0 then
				return nil
			end

			return humanoids[v2]
		end

		local function getNextHumanoid()
			updateHumanoidList()

			if #humanoids == 0 then
				return nil
			end

			v2 = v2 % #humanoids + 1
			return humanoids[v2]
		end

		local function getHumanoidWithName(displayName2) -- 1 equivalent call inferred from this helper
			updateHumanoidList()

			if #humanoids == 0 then
				return nil
			end

			for _, v6 in ipairs(humanoids) do
				if v6.DisplayName == displayName2 then
					return v6
				end
			end

			return nil
		end

		local function StepFreecam(p2)
			local v6 = v3

			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				v6 = v3 * 3
			end

			local v7 = Vector3.new(0, 0, 0)

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				v7 += cframe3.LookVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				v7 -= cframe3.LookVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				v7 += cframe3.RightVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				v7 -= cframe3.RightVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.E) then
				v7 += Vector3.new(0, 1, 0)
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
				v7 -= Vector3.new(0, 1, 0)
			end

			if v7.Magnitude > 0 then
				v7 = v7.Unit
			end

			local v8 = v7 * v6

			local v9 = 1 - math.exp(-10 * p2)
			v4 = v4:Lerp(v8, v9)

			if v8.Magnitude == 0 and v4.Magnitude < 0.1 then
				v4 = Vector3.new(0, 0, 0)
			end

			cframe3 += v4 * p2

			if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

				local mouseDelta = UserInputService:GetMouseDelta()
				local v10

				if v5 == nil then
					v10 = mouseDelta.X > 700 or mouseDelta.Y > 300
				else
					v10 = false
				end

				local v11

				if v5 == nil then
					v11 = false
				else
					v11 = math.abs(mouseDelta.X - v5.X) > 300 or math.abs(mouseDelta.Y - v5.Y) > 150
				end

				v5 = mouseDelta

				if not (v10 or v11) then
					local cframe = CFrame.Angles(0, math.rad(-mouseDelta.X * 0.4), 0)
					local cframe2 = CFrame.Angles(math.rad(-mouseDelta.Y * 0.4), 0, 0)

					local position = cframe3.Position

					local v12 = cframe * cframe3.Rotation * cframe2

					cframe3 = CFrame.new(position) * v12
				end
			else
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			end

			Workspace.CurrentCamera.CFrame = cframe3
		end

		local function setCameraMode(p2)
			RunService:UnbindFromRenderStep("Freecam")

			UserInputService.MouseBehavior = Enum.MouseBehavior.Default

			inputFrame.Visible = false

			if displayName == nil then
				if Workspace.CurrentCamera.CameraSubject == nil then
					p2 = math.max(1, p2)
				else
					displayName = Workspace.CurrentCamera.CameraSubject.DisplayName
				end
			end

			if p2 == 0 then
				Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
				local cameraSubject2
				cameraSubject2 = getHumanoidWithName(displayName) -- inferred equivalent call

				if cameraSubject2 == nil then
					warn("Default humanoid not found: " .. tostring(displayName))
					setCameraMode(1)
				else
					Workspace.CurrentCamera.CameraSubject = cameraSubject2
					CreateTemporaryOverlay.showOverlay("Default Camera", 2, p.screenGui)
				end
			elseif p2 == 1 then
				Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
				Workspace.CurrentCamera.CameraSubject = nil
				cframe3 = Workspace.CurrentCamera.CFrame

				RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)

				inputFrame.Visible = visible
				speedTextBox.Text = tostring((math.floor(v3)))
				speedLabel.Text = "Free Cam Speed (Current: " .. math.floor(v3) .. ") Between 10 And 20000"
				CreateTemporaryOverlay.showOverlay("Free Camera", 2, p.screenGui)
			elseif p2 == 2 then
				cameraSubject = getCurrentHumanoid() -- inferred equivalent call

				if cameraSubject then
					Workspace.CurrentCamera.CameraType = Enum.CameraType.Follow
					Workspace.CurrentCamera.CameraSubject = cameraSubject
					CreateTemporaryOverlay.showOverlay("Follow " .. cameraSubject.DisplayName, 2, p.screenGui)
				else
					v = 0
					setCameraMode(0)
				end
			end
		end

		local function cycleCameraMode() -- 1 equivalent call inferred from this helper
			v = (v + 1) % 3
			setCameraMode(v)
		end

		local function onInputBegan(p2, p3)
			if p3 then
				return
			end

			if p2.KeyCode == Enum.KeyCode.C then
				cycleCameraMode() -- inferred equivalent call
			end

			if p2.KeyCode == Enum.KeyCode.N and v == 2 then
				updateHumanoidList()

				if #humanoids ~= 0 then
					v2 = v2 % #humanoids + 1
					local _ = humanoids[v2]
				end

				setCameraMode(2)
			end

			if p2.KeyCode == Enum.KeyCode.V and v == 1 then
				visible = not visible
				inputFrame.Visible = visible

				if visible then
					speedTextBox:CaptureFocus()
				else
					speedTextBox:ReleaseFocus()
				end
			end
		end

		updateHumanoidList()

		UserInputService.InputBegan:Connect(onInputBegan)
	end
}
