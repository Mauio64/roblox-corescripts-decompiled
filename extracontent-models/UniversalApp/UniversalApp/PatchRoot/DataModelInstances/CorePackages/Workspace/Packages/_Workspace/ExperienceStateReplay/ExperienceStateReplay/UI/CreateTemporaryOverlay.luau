local t1 = {}
local u2 = nil

function t1.hideOverlay() -- line: 12
	-- upvalues: u2 (ref)
	if u2 then
		u2:Destroy()
		u2 = nil
	end
end
function t1.showOverlay(p1, p2, p3) -- line: 25
	-- upvalues: t1 (copy), u2 (ref)
	t1.hideOverlay()

	local Frame = Instance.new("Frame")

	Frame.Name = "TextOverlay"
	Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	Frame.BackgroundTransparency = 0.5
	Frame.Size = UDim2.new(0.7, 0, 0.1, 0)
	Frame.Position = UDim2.new(0.5, 0, 0.8, 0)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.ZIndex = 100

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "OverlayLabel"
	TextLabel.Text = p1
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextScaled = true
	TextLabel.TextWrapped = true
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
	TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.Parent = Frame
	TextLabel.ZIndex = 200
	Frame.Parent = p3
	u2 = Frame
	task.spawn(function() -- line: 66
		-- upvalues: p2 (copy), u2 (ref), Frame (copy), t1 (copy)
		task.wait(p2)

		if u2 == Frame then
			t1.hideOverlay()
		end
	end)
end

return t1
