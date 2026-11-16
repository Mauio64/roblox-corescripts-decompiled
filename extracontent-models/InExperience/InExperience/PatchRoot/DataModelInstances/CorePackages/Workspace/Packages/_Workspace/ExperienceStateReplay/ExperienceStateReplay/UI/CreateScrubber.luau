local parent = script.Parent
local SecondsToTimeStr = require(parent.SecondsToTimeStr)

return {
	createScrubber = function(state)
		state.ScrubberLoadProgress = Instance.new("Frame")
		state.ScrubberLoadProgress.Name = "ScrubberLoadProgress"
		state.ScrubberLoadProgress.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		state.ScrubberLoadProgress.BackgroundTransparency = 0.5
		state.ScrubberLoadProgress.BorderSizePixel = 0
		state.ScrubberLoadProgress.AnchorPoint = Vector2.new(0, 0)
		state.ScrubberLoadProgress.Position = UDim2.new(0, 0, 0, 0)
		state.ScrubberLoadProgress.SizeConstraint = Enum.SizeConstraint.RelativeXY
		state.ScrubberLoadProgress.Size = UDim2.new(0, 0, 1, 0)
		state.ScrubberLoadProgress.Parent = state.ScrubberControlBar

		state.ScrubberPlayProgress = Instance.new("Frame")
		state.ScrubberPlayProgress.Name = "ScrubberPlayProgress"
		state.ScrubberPlayProgress.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		state.ScrubberPlayProgress.BorderSizePixel = 0
		state.ScrubberPlayProgress.AnchorPoint = Vector2.new(0, 0)
		state.ScrubberPlayProgress.Position = UDim2.new(0, 0, 0, 0)
		state.ScrubberPlayProgress.SizeConstraint = Enum.SizeConstraint.RelativeXY
		state.ScrubberPlayProgress.Size = UDim2.new(0, 0, 1, 0)
		state.ScrubberPlayProgress.Parent = state.ScrubberLoadProgress

		state.ScrubberButton = Instance.new("TextButton")
		state.ScrubberButton.Name = "ScrubberButton"
		state.ScrubberButton.Text = ""
		state.ScrubberButton.BackgroundTransparency = 1
		state.ScrubberButton.BorderSizePixel = 0
		state.ScrubberButton.AnchorPoint = Vector2.new(0, 0)
		state.ScrubberButton.Position = UDim2.new(0, 0, 0, 0)
		state.ScrubberButton.SizeConstraint = Enum.SizeConstraint.RelativeXY
		state.ScrubberButton.Size = UDim2.new(1, 0, 1, 0)
		state.ScrubberButton.Parent = state.ScrubberControlBar

		state.ScrubberTimeLabel = Instance.new("TextLabel")
		state.ScrubberTimeLabel.Name = "ScrubberTimeLabel"
		state.ScrubberTimeLabel.Font = Enum.Font.SourceSans
		state.ScrubberTimeLabel.TextXAlignment = Enum.TextXAlignment.Center
		state.ScrubberTimeLabel.TextYAlignment = Enum.TextYAlignment.Center
		state.ScrubberTimeLabel.Size = UDim2.new(0.15, 0, 1.3, 0)
		state.ScrubberTimeLabel.SizeConstraint = Enum.SizeConstraint.RelativeXY
		state.ScrubberTimeLabel.AnchorPoint = Vector2.new(0.5, 1)
		state.ScrubberTimeLabel.Position = UDim2.new(0, 0, 0, 0)
		state.ScrubberTimeLabel.BorderSizePixel = 0
		state.ScrubberTimeLabel.BackgroundColor3 = state.defaultBackgroundColor3
		state.ScrubberTimeLabel.BackgroundTransparency = state.defaultBackgroundTransparency
		state.ScrubberTimeLabel.Text = SecondsToTimeStr.convertSecondsToTimeStr(0)
		state.ScrubberTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		state.ScrubberTimeLabel.TextScaled = true
		state.ScrubberTimeLabel.Parent = state.ScrubberControlBar
		state.ScrubberTimeLabel.Visible = false

		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingBottom = UDim.new(0.05, 0)
		uiPadding.Parent = state.ScrubberTimeLabel

		local scrubberControlBar = state.ScrubberControlBar

		if not scrubberControlBar then
			warn("No ScrubberControlBar found")
			return
		end

		local function fn(p: number)
			local scrubberTimeLabel = state.ScrubberTimeLabel

			if not scrubberTimeLabel then
				warn("No ScrubberTimeLabel found")
				return
			end

			scrubberTimeLabel.Position = UDim2.new(0, p - scrubberControlBar.AbsolutePosition.X, 0, 0)
			local x = scrubberControlBar.AbsolutePosition.X
			local v = x + scrubberControlBar.AbsoluteSize.X
			local v2 = (p - x) / (v - x)
			local v3 = v2 * state.overallLengthSeconds

			state.ScrubberTimeLabel.Text = SecondsToTimeStr.convertSecondsToTimeStr(v3)

			if v2 > 0.75 then
				state.ScrubberTimeLabel.AnchorPoint = Vector2.new(1, 1)
			else
				state.ScrubberTimeLabel.AnchorPoint = Vector2.new(0.5, 1)
			end
		end

		scrubberControlBar.MouseEnter:Connect(function(p: number)
			state.ScrubberTimeLabel.Visible = true
			fn(p)
		end)
		scrubberControlBar.MouseMoved:Connect(function(p: number)
			fn(p)
		end)
		scrubberControlBar.MouseLeave:Connect(function()
			state.ScrubberTimeLabel.Visible = false
		end)
	end
}
