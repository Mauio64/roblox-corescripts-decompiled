return {
	createLoadingOverlay = function(state)
		state.LoadingOverlay = Instance.new("Frame")
		state.LoadingOverlay.Name = "LoadingOverlay"
		state.LoadingOverlay.BackgroundColor3 = state.defaultBackgroundColor3
		state.LoadingOverlay.BackgroundTransparency = state.defaultBackgroundTransparency
		state.LoadingOverlay.AnchorPoint = Vector2.new(0.5, 0.5)
		state.LoadingOverlay.Position = UDim2.new(0.5, 0, 0.5, 0)
		state.LoadingOverlay.BorderSizePixel = 0
		state.LoadingOverlay.Size = UDim2.new(0.5, 0, 0.5, 0)
		state.LoadingOverlay.Visible = false
		state.LoadingOverlay.Parent = state.screenGui

		state.LoadingLabel = Instance.new("TextLabel")
		state.LoadingLabel.Name = "LoadingLabel"
		state.LoadingLabel.Font = Enum.Font.SourceSans
		state.LoadingLabel.TextXAlignment = Enum.TextXAlignment.Center
		state.LoadingLabel.TextYAlignment = Enum.TextYAlignment.Center
		state.LoadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		state.LoadingLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		state.LoadingLabel.Size = UDim2.new(1, 0, 1, 0)
		state.LoadingLabel.SizeConstraint = Enum.SizeConstraint.RelativeXY
		state.LoadingLabel.BackgroundTransparency = 1
		state.LoadingLabel.Text = "Loading"
		state.LoadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		state.LoadingLabel.TextScaled = true
		state.LoadingLabel.Parent = state.LoadingOverlay
	end
}
