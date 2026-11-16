local ExperienceStateRecordingService = game:GetService("ExperienceStateRecordingService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local parent = script.Parent
local ButtonAssets = require(parent.ButtonAssets)
local CreateButtonsTime = require(parent.CreateButtonsTime)

return {
	setupControl = function(state)
		state.connections = {}

		function state.SetPlaying()
			state.state.Playing = true
			state.PlayButton.Image = ButtonAssets.PauseButton

			ExperienceStateRecordingService:SetPlaybackMode(Enum.ExperienceStateRecordingPlaybackMode.Playing)
		end

		function state.SetPaused()
			state.state.Playing = false
			state.PlayButton.Image = ButtonAssets.PlayButton

			ExperienceStateRecordingService:SetPlaybackMode(Enum.ExperienceStateRecordingPlaybackMode.Stopped)
		end

		function state.ControlButtons(p)
			state.StopButton.ImageColor3 = CreateButtonsTime.regularColor
			state.StopButton:SetAttribute("useHoverColor", true)
			state.ReverseButton.ImageColor3 = CreateButtonsTime.regularColor
			state.ReverseButton:SetAttribute("useHoverColor", true)
			state.state.Reversing = false

			if p ~= state.PlayButton then
				state.PlayButton.ImageColor3 = CreateButtonsTime.regularColor
			end

			if p == state.PlayButton then
				if state.state.Playing then
					state.SetPaused()
				else
					state.SetPlaying()
				end
			elseif p == state.StopButton then
				state.StopButton:SetAttribute("useHoverColor", false)
				state.StopButton.ImageColor3 = CreateButtonsTime.clickColor
				state.LoadingOverlay.Visible = true
				state.LoadingLabel.Text = "Returning To Replay Browser"
				state.state.Loading = true
				ReplicatedStorage:WaitForChild("TeleportRequest"):FireServer()
			elseif p == state.ReverseButton then
				state.state.Reversing = true
				state.SetPaused()
				state.ReverseButton:SetAttribute("useHoverColor", false)
				state.ReverseButton.ImageColor3 = CreateButtonsTime.clickColor

				ExperienceStateRecordingService:SetPlaybackMode(Enum.ExperienceStateRecordingPlaybackMode.Rewinding)
			end
		end

		state.connections.PlayListener = state.PlayButton.MouseButton1Click:Connect(function()
			state.ControlButtons(state.PlayButton)
		end)

		state.connections.StopListener = state.StopButton.MouseButton1Click:Connect(function()
			state.ControlButtons(state.StopButton)
		end)

		state.connections.ReverseListener = state.ReverseButton.MouseButton1Click:Connect(function()
			state.ControlButtons(state.ReverseButton)
		end)

		UserInputService.InputBegan:Connect(function(input, _)
			if input.KeyCode == Enum.KeyCode.Space then
				state.ControlButtons(state.PlayButton)
			elseif input.KeyCode == Enum.KeyCode.R then
				state.ControlButtons(state.ReverseButton)
			elseif input.KeyCode == Enum.KeyCode.X then
				state.ControlButtons(state.StopButton)
			end
		end)
	end
}
