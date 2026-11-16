local CreateTemporaryOverlay = {}

local v = nil

function CreateTemporaryOverlay.hideOverlay()
	if v then
		v:Destroy()
		v = nil
	end
end

function CreateTemporaryOverlay.showOverlay(text, duration, parent)
	CreateTemporaryOverlay.hideOverlay()

	local textOverlay = Instance.new("Frame")
	textOverlay.Name = "TextOverlay"
	textOverlay.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	textOverlay.BackgroundTransparency = 0.5
	textOverlay.Size = UDim2.new(0.7, 0, 0.1, 0)
	textOverlay.Position = UDim2.new(0.5, 0, 0.8, 0)
	textOverlay.AnchorPoint = Vector2.new(0.5, 0.5)
	textOverlay.ZIndex = 100

	local overlayLabel = Instance.new("TextLabel")
	overlayLabel.Name = "OverlayLabel"
	overlayLabel.Text = text
	overlayLabel.TextColor3 = Color3.new(1, 1, 1)
	overlayLabel.TextScaled = true
	overlayLabel.TextWrapped = true
	overlayLabel.BackgroundTransparency = 1
	overlayLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
	overlayLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	overlayLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	overlayLabel.Font = Enum.Font.SourceSans
	overlayLabel.Parent = textOverlay
	overlayLabel.ZIndex = 200

	textOverlay.Parent = parent

	v = textOverlay

	task.spawn(function()
		task.wait(duration)

		if v == textOverlay then
			CreateTemporaryOverlay.hideOverlay()
		end
	end)
end

return CreateTemporaryOverlay
