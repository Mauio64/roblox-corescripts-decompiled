local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local scriptParent = script.Parent
local CreateTemporaryOverlay = require(scriptParent.CreateTemporaryOverlay)
local DisplayName = nil
local u7 = nil
local n1 = 0
local t1 = {}
local n2 = 1
local u11 = nil
local n3 = 50
local vector3 = Vector3.new(0, 0, 0)
local u14 = nil

return {
	createSpectatorCamera = function(p1) -- line: 41
		-- upvalues: n3 (ref), t1 (ref), n2 (ref), UserInputService (copy), u7 (ref), vector3 (ref), u14 (ref), Workspace (copy), RunService (copy), DisplayName (ref), CreateTemporaryOverlay (copy), u11 (ref), n1 (ref)
		local Frame = Instance.new("Frame")

		Frame.Name = "InputFrame"
		Frame.Size = UDim2.new(0.4, 0, 0.15, 0)
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
		Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		Frame.BackgroundTransparency = 0.4
		Frame.BorderSizePixel = 0
		Frame.Visible = false
		Frame.Parent = p1.screenGui

		local UIListLayout = Instance.new("UIListLayout")

		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout.Parent = Frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = "SpeedLabel"
		TextLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.TextScaled = true
		TextLabel.Text = "Free Cam Speed (Current: " .. math.floor(n3) .. ") Between 10 And 20000"
		TextLabel.Parent = Frame

		local TextBox = Instance.new("TextBox")

		TextBox.Name = "SpeedTextBox"
		TextBox.Size = UDim2.new(0.9, 0, 0.25, 0)
		TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		TextBox.BackgroundTransparency = 0
		TextBox.Text = tostring((math.floor(n3)))
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextScaled = true
		TextBox.Font = Enum.Font.SourceSans
		TextBox.ClearTextOnFocus = true
		TextBox.TextXAlignment = Enum.TextXAlignment.Center
		TextBox.Parent = Frame

		local TextButton = Instance.new("TextButton")

		TextButton.Name = "ApplyButton"
		TextButton.Size = UDim2.new(0.9, 0, 0.25, 0)
		TextButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
		TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton.Text = "Apply Speed"
		TextButton.Font = Enum.Font.SourceSansBold
		TextButton.TextScaled = true
		TextButton.Parent = Frame
		TextButton.MouseButton1Click:Connect(function() -- line: 106
			-- upvalues: TextBox (copy), n3 (ref), TextLabel (copy)
			local ok, result = pcall(tonumber, TextBox.Text)

			if ok and (type(result) == "number" and result >= 10 and result <= 20000) then
				n3 = result
				TextLabel.Text = "Free Cam Speed (Current: " .. math.floor(n3) .. ") Between 10 And 20000"

				return
			end

			warn("Invalid speed input: " .. TextBox.Text .. ". Please enter a number between 10 and 20000.")
			TextBox.Text = tostring((math.floor(n3)))
		end)

		local u21 = false

		local function updateHumanoidList() -- line: 126
			-- upvalues: t1 (ref)
			t1 = {}

			for _, descendant in ipairs(workspace:GetDescendants()) do
				if descendant:IsA("Humanoid") then
					table.insert(t1, descendant)
				end
			end
		end
		local function getCurrentHumanoid() -- line: 138
			-- upvalues: updateHumanoidList (copy), t1 (ref), n2 (ref)
			updateHumanoidList()

			if #t1 == 0 then
				return nil
			end

			return t1[n2]
		end
		local function getNextHumanoid() -- line: 147
			-- upvalues: updateHumanoidList (copy), t1 (ref), n2 (ref)
			updateHumanoidList()

			if #t1 == 0 then
				return nil
			end

			n2 = n2 % #t1 + 1

			return t1[n2]
		end
		local function getHumanoidWithName(p2) -- line: 159
			-- upvalues: updateHumanoidList (copy), t1 (ref)
			updateHumanoidList()

			if #t1 == 0 then
				return nil
			end

			for _, v in ipairs(t1) do
				if p2 == v.DisplayName then
					return v
				end
			end

			return nil
		end
		local function StepFreecam(p3) -- line: 177
			-- upvalues: n3 (ref), UserInputService (copy), u7 (ref), vector3 (ref), u14 (ref), Workspace (copy)
			local v38 = n3

			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				v38 = n3 * 3
			end

			local vector3_2 = Vector3.new(0, 0, 0)

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				vector3_2 += u7.LookVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				vector3_2 -= u7.LookVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				vector3_2 += u7.RightVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				vector3_2 -= u7.RightVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.E) then
				vector3_2 += Vector3.new(0, 1, 0)
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
				vector3_2 -= Vector3.new(0, 1, 0)
			end

			if vector3_2.Magnitude > 0 then
				vector3_2 = vector3_2.Unit
			end

			local v40 = vector3_2 * v38
			local v41 = 1 - math.exp(-10 * p3)

			vector3 = vector3:Lerp(v40, v41)

			if v40.Magnitude == 0 and vector3.Magnitude < 0.1 then
				vector3 = Vector3.new(0, 0, 0)
			end

			u7 += vector3 * p3

			if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

				local MouseDelta = UserInputService:GetMouseDelta()
				local v43 = u14 == nil and (MouseDelta.X > 700 or MouseDelta.Y > 300)
				local v44 = u14 ~= nil and (math.abs(MouseDelta.X - u14.X) > 300 or math.abs(MouseDelta.Y - u14.Y) > 150)

				u14 = MouseDelta

				if not v43 and not v44 then
					local cFrame = CFrame.Angles(0, math.rad(-MouseDelta.X * 0.4), 0)
					local cFrame2 = CFrame.Angles(math.rad(-MouseDelta.Y * 0.4), 0, 0)
					local Position = u7.Position
					local v48 = cFrame * u7.Rotation * cFrame2

					u7 = CFrame.new(Position) * v48
				end
			else
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			end

			Workspace.CurrentCamera.CFrame = u7
		end
		local function setCameraMode(p4) -- line: 270
			-- upvalues: RunService (copy), UserInputService (copy), Frame (copy), DisplayName (ref), Workspace (copy), updateHumanoidList (copy), t1 (ref), setCameraMode (copy), CreateTemporaryOverlay (copy), p1 (copy), u7 (ref), StepFreecam (copy), u21 (ref), TextBox (copy), n3 (ref), TextLabel (copy), u11 (ref), n2 (ref), n1 (ref)
			RunService:UnbindFromRenderStep("Freecam")
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			Frame.Visible = false

			local g54 = nil
			local v51 = nil

			if DisplayName == nil then
				if Workspace.CurrentCamera.CameraSubject ~= nil then
					DisplayName = Workspace.CurrentCamera.CameraSubject.DisplayName
				else
					p4 = math.max(1, p4)
				end
			end

			if p4 == 0 then
				Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

				local v50 = DisplayName

				updateHumanoidList()

				if #t1 == 0 then
					v51 = nil
				else
					for _, v in ipairs(t1) do
						if v50 == v.DisplayName then
							v51 = v
							g54 = true
						end

						if g54 then
							break
						end
					end

					if not g54 then
						v51 = nil
					end
				end

				g54 = false

				if v51 == nil then
					warn("Default humanoid not found: " .. tostring(DisplayName))
					setCameraMode(1)

					return
				end

				Workspace.CurrentCamera.CameraSubject = v51
				CreateTemporaryOverlay.showOverlay("Default Camera", 2, p1.screenGui)

				return
			end

			if p4 == 1 then
				Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
				Workspace.CurrentCamera.CameraSubject = nil
				u7 = Workspace.CurrentCamera.CFrame
				RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
				Frame.Visible = u21
				TextBox.Text = tostring((math.floor(n3)))
				TextLabel.Text = "Free Cam Speed (Current: " .. math.floor(n3) .. ") Between 10 And 20000"
				CreateTemporaryOverlay.showOverlay("Free Camera", 2, p1.screenGui)

				return
			end

			if p4 == 2 then
				updateHumanoidList()
				u11 = if #t1 ~= 0 then t1[n2] else nil

				if u11 then
					Workspace.CurrentCamera.CameraType = Enum.CameraType.Follow
					Workspace.CurrentCamera.CameraSubject = u11
					CreateTemporaryOverlay.showOverlay("Follow " .. u11.DisplayName, 2, p1.screenGui)

					return
				end

				n1 = 0
				setCameraMode(0)
			end
		end
		local function cycleCameraMode() -- line: 342
			-- upvalues: n1 (ref), setCameraMode (copy)
			n1 = (n1 + 1) % 3
			setCameraMode(n1)
		end
		local function onInputBegan(p5, p6) -- line: 348
			-- upvalues: n1 (ref), setCameraMode (copy), updateHumanoidList (copy), t1 (ref), n2 (ref), u21 (ref), Frame (copy), TextBox (copy)
			if p6 then
				return
			end

			if p5.KeyCode == Enum.KeyCode.C then
				n1 = (n1 + 1) % 3
				setCameraMode(n1)
			end

			if p5.KeyCode == Enum.KeyCode.N and n1 == 2 then
				updateHumanoidList()

				if #t1 ~= 0 then
					n2 = n2 % #t1 + 1

					local _ = t1[n2]
				end

				setCameraMode(2)
			end

			if p5.KeyCode == Enum.KeyCode.V and n1 == 1 then
				u21 = not u21
				Frame.Visible = u21

				if u21 then
					TextBox:CaptureFocus()

					return
				end

				TextBox:ReleaseFocus()
			end
		end

		updateHumanoidList()
		UserInputService.InputBegan:Connect(onInputBegan)
	end
}
