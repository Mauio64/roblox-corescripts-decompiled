local RunService = game:GetService("RunService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local ReactUtils = require(parent2.ReactUtils)
local EventConnection = ReactUtils.EventConnection

local useStyle = require(parent.Core.Style.useStyle)

local forwardRef = React.forwardRef(function(props, ref)
	local v = useStyle()
	local selection = v.Tokens.Color.Selection
	local reducedMotion = v.Settings.ReducedMotion
	local colorSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, selection.Start.Color3),
		ColorSequenceKeypoint.new(1, selection.End.Color3)
	})

	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, selection.Start.Transparency),
		NumberSequenceKeypoint.new(1, selection.End.Transparency)
	})

	local rotation, v2 = React.useBinding(0)
	local color, v3 = React.useBinding(colorSequence)
	local transparency, v4 = React.useBinding(numberSequence)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(-props.offset, -props.offset),
		Size = UDim2.new(1, props.offset * 2, 1, props.offset * 2),
		ref = ref
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = props.cornerRadius }),
		UIStroke = React.createElement(
			"UIStroke",
			{ Color = Color3.new(1, 1, 1), Transparency = 0, Thickness = props.borderWidth },
			{
				UIGradient = React.createElement("UIGradient", {
					Rotation = rotation,
					Color = color,
					Transparency = transparency
				})
			}
		),
		HeartbeatConnection = props.isVisible and React.createElement(EventConnection, {
			event = RunService.Heartbeat,
			callback = function(_)
				local v5 = rotation:getValue() + 2
				local v6 = colorSequence
				local v7 = numberSequence

				if reducedMotion then
					local midpoint = (math.sin((math.rad(v5))) + 1) / 2

					local value = v6.Keypoints[1].Value
					local value2 = v6.Keypoints[#v6.Keypoints].Value
					v6 = ColorSequence.new(value:Lerp(value2, midpoint))

					local value3 = v7.Keypoints[1].Value
					local value4 = v7.Keypoints[#v7.Keypoints].Value
					v7 = NumberSequence.new(value3 + (value4 - value3) * midpoint)
				end

				v2(v5)
				v3(v6)
				v4(v7)
			end
		})
	})
end)

return React.memo(forwardRef)
