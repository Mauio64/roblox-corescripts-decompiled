local AdPlayer = script:FindFirstAncestor("AdPlayer")

if not require(AdPlayer.Flags).GetEnableLuaRewardTimerUI() then
	return nil
end

local AdPlayerParent = AdPlayer.Parent
local React = require(AdPlayerParent.React)

local function transparencyGradient(n1: number) -- line: 33
	return NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(n1 - 0.001, 0),
		NumberSequenceKeypoint.new(n1 + 0.001, 1),
		NumberSequenceKeypoint.new(1, 1)
	})
end
local function rightRotation(p1) -- line: 42
	return (math.clamp(p1 * 360, 0, 180))
end
local function leftRotation(p2) -- line: 46
	return (math.clamp(p2 * 360 - 180, 0, 180))
end

return function(t1: {[any]: any}) -- line: 50
	-- upvalues: React (copy), rightRotation (copy), transparencyGradient (copy)
	local v11 = t1.thickness or 3
	local v12 = if not t1.children then {} else table.clone(t1.children)

	v12.rightClipper = React.createElement("Frame", {
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		ZIndex = 0,
		Size = UDim2.fromScale(0.5, 1),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5)
	}, {
		arc = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -v11 * 2, 1, -v11 * 2),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0, 0.5)
		}, {
			corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			}),
			stroke = React.createElement("UIStroke", {
				Color = t1.ImageColor3,
				Transparency = t1.ImageTransparency,
				Thickness = v11,
				Enabled = t1.alpha:map(function(p3) -- line: 76
					return math.clamp(p3 * 360, 0, 180) > 0
				end)
			}, {
				gradient = React.createElement("UIGradient", {
					Rotation = t1.alpha:map(rightRotation),
					Transparency = transparencyGradient(0.5)
				})
			})
		})
	})
	v12.leftClipper = React.createElement("Frame", {
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		ZIndex = 0,
		Size = UDim2.fromScale(0.5, 1),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5)
	}, {
		arc = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -v11 * 2, 1, -v11 * 2),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(1, 0.5)
		}, {
			corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			}),
			stroke = React.createElement("UIStroke", {
				Color = t1.ImageColor3,
				Transparency = t1.ImageTransparency,
				Thickness = v11,
				Enabled = t1.alpha:map(function(p4) -- line: 110
					return math.clamp(p4 * 360 - 180, 0, 180) > 0
				end)
			}, {
				gradient = React.createElement("UIGradient", {
					Rotation = t1.alpha:map(function(p5) -- line: 115
						return math.clamp(p5 * 360 - 180, 0, 180) - 180
					end),
					Transparency = t1.alpha:map(function(p6) -- line: 118
						-- upvalues: transparencyGradient (copy)
						return transparencyGradient(math.clamp(math.clamp(p6 * 360 - 180, 0, 180) / 180, 0, 1) * 0.02 + 0.5)
					end)
				})
			})
		})
	})

	return React.createElement("Frame", {
		Position = t1.Position,
		AnchorPoint = t1.AnchorPoint,
		Size = t1.Size,
		SizeConstraint = t1.SizeConstraint,
		BackgroundTransparency = t1.BackgroundTransparency,
		BackgroundColor3 = t1.BackgroundColor3,
		Rotation = t1.Rotation,
		ZIndex = t1.ZIndex,
		LayoutOrder = t1.LayoutOrder,
		Visible = t1.Visible
	}, v12)
end
