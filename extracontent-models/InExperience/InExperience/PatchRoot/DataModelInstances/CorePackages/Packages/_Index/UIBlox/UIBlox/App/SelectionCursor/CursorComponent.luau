local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local EventConnection = require(ParentParentParent.ReactUtils).EventConnection
local useStyle = require(ParentParent.Core.Style.useStyle)
local v7 = React.forwardRef(function(t1: {[any]: any}, p1) -- line: 22
	-- upvalues: useStyle (copy), React (copy), EventConnection (copy), RunService (copy)
	local v10 = useStyle()
	local SelectionCursor = v10.Tokens.Component.SelectionCursor
	local ReducedMotion = v10.Settings.ReducedMotion
	local colorSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, SelectionCursor.Gradient.Start.Color3),
		ColorSequenceKeypoint.new(1, SelectionCursor.Gradient.End.Color3)
	})
	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, SelectionCursor.Gradient.Start.Transparency),
		NumberSequenceKeypoint.new(1, SelectionCursor.Gradient.End.Transparency)
	})
	local v15, v16 = React.useBinding(0)
	local v17, v18 = React.useBinding(colorSequence)
	local v19, v20 = React.useBinding(numberSequence)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(-t1.offset, -t1.offset),
		Size = UDim2.new(1, t1.offset * 2, 1, t1.offset * 2),
		ref = p1
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = t1.cornerRadius
		}),
		UIStroke = React.createElement("UIStroke", {
			Transparency = 0,
			Color = Color3.new(1, 1, 1),
			Thickness = t1.borderWidth
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = v15,
				Color = v17,
				Transparency = v19
			})
		}),
		HeartbeatConnection = t1.isVisible and React.createElement(EventConnection, {
			event = RunService.Heartbeat,
			callback = function(_) -- line: 60
				-- upvalues: v15 (copy), colorSequence (copy), numberSequence (copy), ReducedMotion (copy), v16 (copy), v18 (copy), v20 (copy)
				local v22 = v15:getValue() + 2
				local v23 = colorSequence
				local v24 = numberSequence

				if ReducedMotion then
					local v25 = (math.sin((math.rad(v22))) + 1) / 2
					local Value = v23.Keypoints[1].Value
					local Value2 = v23.Keypoints[#v23.Keypoints].Value

					v23 = ColorSequence.new(Value:Lerp(Value2, v25))

					local Value3 = v24.Keypoints[1].Value
					local Value4 = v24.Keypoints[#v24.Keypoints].Value

					v24 = NumberSequence.new(Value3 + (Value4 - Value3) * v25)
				end

				v16(v22)
				v18(v23)
				v20(v24)
			end
		})
	})
end)

return React.memo(v7)
