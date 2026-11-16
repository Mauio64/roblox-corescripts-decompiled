local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local TweenService = game:GetService("TweenService")

local v = {
	linear = Enum.EasingStyle.Linear,
	quadratic = Enum.EasingStyle.Quad,
	cubic = Enum.EasingStyle.Cubic
}

local function stopTween(ref) -- 2 equivalent calls inferred from this helper
	if ref.current then
		ref.current:Cancel()
		ref.current = nil
	end
end

local function isApproximatelyEqual(p: number, p2: number): boolean -- 2 equivalent calls inferred from this helper
	return math.abs(p - p2) < 0.001
end

local function useAnimation(data)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		local startOffset = data.startOffset
		local endOffset = data.endOffset or 0
		local duration = data.duration or 0.2
		local easingStyle = data.easingStyle or "quadratic"

		if isApproximatelyEqual(startOffset, endOffset) then -- inferred equivalent call
			return
		end

		local numberValue = Instance.new("NumberValue")
		numberValue.Value = startOffset
		ref2.current = startOffset

		local v2 = v[easingStyle] or v.quadratic
		local tweenInfo = TweenInfo.new(duration, v2, Enum.EasingDirection.Out)
		stopTween(ref) -- inferred equivalent call
		ref.current = TweenService:Create(numberValue, tweenInfo, { Value = endOffset })

		local valueChangedConnection = numberValue:GetPropertyChangedSignal("Value"):Connect(function()
			local current = numberValue.Value

			if ref2.current == nil or not isApproximatelyEqual(current, ref2.current) then -- inferred equivalent call
				ref2.current = current
				data.setAnimationOffset(current)
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
			stopTween(ref) -- inferred equivalent call
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
