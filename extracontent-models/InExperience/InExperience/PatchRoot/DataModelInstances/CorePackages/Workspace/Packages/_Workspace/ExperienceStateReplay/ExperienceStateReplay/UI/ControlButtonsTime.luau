local ExperienceStateRecordingService = game:GetService("ExperienceStateRecordingService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local scriptParent = script.Parent
local ButtonAssets = require(scriptParent.ButtonAssets)
local CreateButtonsTime = require(scriptParent.CreateButtonsTime)

return {
	setupControl = function(p1) -- line: 12
		-- upvalues: ButtonAssets (copy), ExperienceStateRecordingService (copy), CreateButtonsTime (copy), ReplicatedStorage (copy), UserInputService (copy)
		p1.connections = {}

		function p1.SetPlaying() -- line: 15
			-- upvalues: p1 (copy), ButtonAssets (copy), ExperienceStateRecordingService (copy)
			p1.state.Playing = true
			p1.PlayButton.Image = ButtonAssets.PauseButton
			ExperienceStateRecordingService:SetPlaybackMode(Enum.ExperienceStateRecordingPlaybackMode.Playing)
		end
		function p1.SetPaused() -- line: 22
			-- upvalues: p1 (copy), ButtonAssets (copy), ExperienceStateRecordingService (copy)
			p1.state.Playing = false
			p1.PlayButton.Image = ButtonAssets.PlayButton
			ExperienceStateRecordingService:SetPlaybackMode(Enum.ExperienceStateRecordingPlaybackMode.Stopped)
		end
		function p1.ControlButtons(p2) -- line: 29
			-- upvalues: p1 (copy), CreateButtonsTime (copy), ReplicatedStorage (copy), ExperienceStateRecordingService (copy)
			p1.StopButton.ImageColor3 = CreateButtonsTime.regularColor
			p1.StopButton:SetAttribute("useHoverColor", true)
			p1.ReverseButton.ImageColor3 = CreateButtonsTime.regularColor
			p1.ReverseButton:SetAttribute("useHoverColor", true)
			p1.state.Reversing = false

			if p2 ~= p1.PlayButton then
				p1.PlayButton.ImageColor3 = CreateButtonsTime.regularColor
			end

			if p2 == p1.PlayButton then
				if p1.state.Playing then
					p1.SetPaused()

					return
				end

				p1.SetPlaying()

				return
			end

			if p2 == p1.StopButton then
				p1.StopButton:SetAttribute("useHoverColor", false)
				p1.StopButton.ImageColor3 = CreateButtonsTime.clickColor
				p1.LoadingOverlay.Visible = true
				p1.LoadingLabel.Text = "Returning To Replay Browser"
				p1.state.Loading = true
				ReplicatedStorage:WaitForChild("TeleportRequest"):FireServer()

				return
			end

			if p2 == p1.ReverseButton then
				p1.state.Reversing = true
				p1.SetPaused()
				p1.ReverseButton:SetAttribute("useHoverColor", false)
				p1.ReverseButton.ImageColor3 = CreateButtonsTime.clickColor
				ExperienceStateRecordingService:SetPlaybackMode(Enum.ExperienceStateRecordingPlaybackMode.Rewinding)
			end
		end

		p1.connections.PlayListener = p1.PlayButton.MouseButton1Click:Connect(function() -- line: 64
			-- upvalues: p1 (copy)
			p1.ControlButtons(p1.PlayButton)
		end)
		p1.connections.StopListener = p1.StopButton.MouseButton1Click:Connect(function() -- line: 69
			-- upvalues: p1 (copy)
			p1.ControlButtons(p1.StopButton)
		end)
		p1.connections.ReverseListener = p1.ReverseButton.MouseButton1Click:Connect(function() -- line: 74
			-- upvalues: p1 (copy)
			p1.ControlButtons(p1.ReverseButton)
		end)
		UserInputService.InputBegan:Connect(function(input, _) -- line: 79
			-- upvalues: p1 (copy)
			if input.KeyCode == Enum.KeyCode.Space then
				p1.ControlButtons(p1.PlayButton)

				return
			end

			if input.KeyCode == Enum.KeyCode.R then
				p1.ControlButtons(p1.ReverseButton)

				return
			end

			if input.KeyCode == Enum.KeyCode.X then
				p1.ControlButtons(p1.StopButton)
			end
		end)
	end
}
