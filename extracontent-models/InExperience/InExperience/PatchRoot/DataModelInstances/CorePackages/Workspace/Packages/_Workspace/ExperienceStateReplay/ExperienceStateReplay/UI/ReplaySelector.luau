local ParentParent = script.Parent.Parent
local GetFStringPlaybackGuid = require(ParentParent.Flags.GetFStringPlaybackGuid)

return {
	create = function(p1, p2) -- line: 7
		-- upvalues: GetFStringPlaybackGuid (copy)
		local Frame = Instance.new("Frame")

		Frame.Name = "ReplaySelector"
		Frame.Size = UDim2.fromOffset(300, 250)
		Frame.Position = UDim2.fromScale(0.5, 0.5)
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Frame.BorderSizePixel = 0
		Frame.Parent = p1.screenGui

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 8)
		UICorner.Parent = Frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = "TitleLabel"
		TextLabel.Size = UDim2.new(1, 0, 0, 30)
		TextLabel.Position = UDim2.new(0, 0, 0, 10)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = "Enter Engine Context"
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.Font = Enum.Font.SourceSansBold
		TextLabel.TextSize = 16
		TextLabel.Parent = Frame

		local TextBox = Instance.new("TextBox")

		TextBox.Name = "GuidInput"
		TextBox.Size = UDim2.new(0.9, 0, 0, 40)
		TextBox.Position = UDim2.new(0.5, 0, 0, 50)
		TextBox.AnchorPoint = Vector2.new(0.5, 0)
		TextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.PlaceholderText = "Paste GUID here..."
		TextBox.Font = Enum.Font.SourceSans
		TextBox.TextSize = 14
		TextBox.Text = GetFStringPlaybackGuid()
		TextBox.Parent = Frame

		local UICorner2 = Instance.new("UICorner")

		UICorner2.CornerRadius = UDim.new(0, 4)
		UICorner2.Parent = TextBox

		local TextButton = Instance.new("TextButton")

		TextButton.Name = "CloseButton"
		TextButton.Size = UDim2.fromOffset(30, 30)
		TextButton.Position = UDim2.new(1, -4, 0, 4)
		TextButton.AnchorPoint = Vector2.new(1, 0)
		TextButton.BackgroundTransparency = 1
		TextButton.Text = "X"
		TextButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		TextButton.Font = Enum.Font.SourceSansBold
		TextButton.TextSize = 18
		TextButton.Parent = Frame

		local TextButton2 = Instance.new("TextButton")

		TextButton2.Name = "OpenReplaySelectorButton"
		TextButton2.Size = UDim2.fromOffset(100, 30)
		TextButton2.Position = UDim2.new(0, 10, 0, 10)
		TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton2.Text = "Replay Input"
		TextButton2.Font = Enum.Font.SourceSansBold
		TextButton2.TextSize = 14
		TextButton2.Visible = false
		TextButton2.Parent = p1.screenGui

		local UICorner3 = Instance.new("UICorner")

		UICorner3.CornerRadius = UDim.new(0, 4)
		UICorner3.Parent = TextButton2
		TextButton2.MouseButton1Click:Connect(function() -- line: 77
			-- upvalues: Frame (copy), TextButton2 (copy)
			Frame.Visible = true
			TextButton2.Visible = false
		end)
		TextButton.MouseButton1Click:Connect(function() -- line: 82
			-- upvalues: Frame (copy), TextButton2 (copy)
			Frame.Visible = false
			TextButton2.Visible = true
		end)

		local TextButton3 = Instance.new("TextButton")

		TextButton3.Name = "SubmitButton"
		TextButton3.Size = UDim2.new(0.5, 0, 0, 30)
		TextButton3.Position = UDim2.new(0.5, 0, 0, 200)
		TextButton3.AnchorPoint = Vector2.new(0.5, 0)
		TextButton3.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
		TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton3.Text = "Load Replay"
		TextButton3.Font = Enum.Font.SourceSansBold
		TextButton3.TextSize = 14
		TextButton3.Parent = Frame

		local UICorner4 = Instance.new("UICorner")

		UICorner4.CornerRadius = UDim.new(0, 4)
		UICorner4.Parent = TextButton3
		TextButton3.MouseButton1Click:Connect(function() -- line: 103
			-- upvalues: p2 (copy), TextBox (copy)
			if p2 then
				p2(TextBox.Text)
			end
		end)

		return {
			Container = Frame,
			SetVisible = function(_: {[any]: any}, b1: boolean) -- line: 113
				-- upvalues: Frame (copy), TextButton2 (copy)
				Frame.Visible = b1
				TextButton2.Visible = not b1
			end
		}
	end
}
