local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local TweenService = game:GetService("TweenService")
local t1 = {
	linear = Enum.EasingStyle.Linear,
	quadratic = Enum.EasingStyle.Quad,
	cubic = Enum.EasingStyle.Cubic
}

local function stopTween(t2: {[any]: any}) -- line: 32
	if t2.current then
		t2.current:Cancel()
		t2.current = nil
	end
end
local function isApproximatelyEqual(n1: number, n2: number) -- line: 40
	return math.abs(n1 - n2) < 0.001
end
local function useAnimation(t3: {[any]: any}) -- line: 44
	-- upvalues: React (copy), t1 (copy), TweenService (copy)
	local v12 = React.useRef(nil)
	local v13 = React.useRef(nil)

	React.useEffect(function() -- line: 48
		-- upvalues: t3 (copy), v13 (copy), t1 (copy), v12 (copy), TweenService (copy)
		local startOffset = t3.startOffset
		local v15 = t3.endOffset or 0
		local v16 = t3.duration or 0.2
		local v17 = t3.easingStyle or "quadratic"

		if math.abs(startOffset - v15) < 0.001 then
			return
		end

		local NumberValue = Instance.new("NumberValue")

		NumberValue.Value = startOffset
		v13.current = startOffset

		local v19 = t1[v17] or t1.quadratic
		local tweenInfo = TweenInfo.new(v16, v19, Enum.EasingDirection.Out)
		local v21 = v12

		if v21.current then
			v21.current:Cancel()
			v21.current = nil
		end

		v12.current = TweenService:Create(NumberValue, tweenInfo, {
			Value = v15
		})

		local connection = NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 75
			-- upvalues: NumberValue (copy), v13 (copy), t3 (copy)
			local NumberValueValue = NumberValue.Value

			if v13.current == nil or not (math.abs(NumberValueValue - v13.current) < 0.001) then
				v13.current = NumberValueValue
				t3.setAnimationOffset(NumberValueValue)
			end
		end)

		if v12.current then
			v12.current.Completed:Connect(function() -- line: 84
				-- upvalues: connection (copy), NumberValue (copy), v12 (copy), v13 (copy)
				connection:Disconnect()
				NumberValue:Destroy()
				v12.current = nil
				v13.current = nil
			end)
			v12.current:Play()
		end

		return function() -- line: 93
			-- upvalues: connection (copy), v12 (copy), NumberValue (copy), v13 (copy)
			connection:Disconnect()

			local v24 = v12

			if v24.current then
				v24.current:Cancel()
				v24.current = nil
			end

			NumberValue:Destroy()
			v13.current = nil
		end
	end, {
		t3.startOffset,
		t3.endOffset,
		t3.duration,
		t3.easingStyle,
		t3.setAnimationOffset
	})
end

return useAnimation
