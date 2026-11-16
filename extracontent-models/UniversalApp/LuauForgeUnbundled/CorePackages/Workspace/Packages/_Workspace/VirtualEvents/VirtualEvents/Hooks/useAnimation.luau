local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local TweenService = game:GetService("TweenService")

local v5 = {
	linear = Enum.EasingStyle.Linear,
	quadratic = Enum.EasingStyle.Quad,
	cubic = Enum.EasingStyle.Cubic
}

local function stopTween(p2)
	if p2.current then
		p2.current:Cancel()
		p2.current = nil
	end
end

local function isApproximatelyEqual(p2, p3): boolean
	return math.abs(p2 - p3) < 0.001
end

local function useAnimation(data)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		local startOffset = data.startOffset
		local endOffset = data.endOffset or 0
		local duration = data.duration or 0.2
		local easingStyle = data.easingStyle or "quadratic"

		if math.abs(startOffset - endOffset) < 0.001 then
			return
		end

		local numberValue = Instance.new("NumberValue")
		numberValue.Value = startOffset
		ref2.current = startOffset

		local v6 = v5[easingStyle] or v5.quadratic
		local tweenInfo = TweenInfo.new(duration, v6, Enum.EasingDirection.Out)

		local v7 = ref

		if v7.current then
			v7.current:Cancel()
			v7.current = nil
		end

		ref.current = TweenService:Create(numberValue, tweenInfo, { Value = endOffset })

		local valueChangedConnection = numberValue:GetPropertyChangedSignal("Value"):Connect(function()
			local value = numberValue.Value

			if ref2.current == nil or not (math.abs(value - ref2.current) < 0.001) then
				ref2.current = value
				data.setAnimationOffset(value)
			end
		end)

		if ref.current then
			ref.current.Completed:Connect(function()
				valueChangedConnection:Disconnect()
				numberValue:Destroy()
				ref.current = nil
				ref2.current = nil
			end)
			ref.current:Play()
		end

		return function()
			valueChangedConnection:Disconnect()
			local v8 = ref

			if v8.current then
				v8.current:Cancel()
				v8.current = nil
			end

			numberValue:Destroy()
			ref2.current = nil
		end
	end, {
		data.startOffset,
		data.endOffset,
		data.duration,
		data.easingStyle,
		data.setAnimationOffset
	})
end

return useAnimation
