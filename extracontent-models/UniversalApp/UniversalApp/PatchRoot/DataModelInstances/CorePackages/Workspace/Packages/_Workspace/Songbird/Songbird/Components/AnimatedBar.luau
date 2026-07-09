local Songbird = script:FindFirstAncestor("Songbird")
local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local ReactOtter = require(Songbird.Parent.ReactOtter)
local Foundation = require(Songbird.Parent.Foundation)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	isMoving = true,
	staticHeight = 0.5,
	heightRange = NumberRange.new(0.3, 1),
	width = UDim.new(1, 0)
}
local random = Random.new()

local function AnimatedBar(t2: {[any]: any}) -- line: 34
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), useCallback (copy), random (copy), ReactOtter (copy), useEffect (copy), React (copy)
	local v13 = Cryo.Dictionary.join(t1, t2)
	local v14 = useTokens()
	local v15 = useCallback(function() -- line: 38
		-- upvalues: random (copy), v13 (copy)
		return random:NextNumber(v13.heightRange.Min, v13.heightRange.Max)
	end, { v13.heightRange })
	local v16, v17 = ReactOtter.useAnimatedBinding(v15())

	useEffect(function() -- line: 44
		-- upvalues: v13 (copy), v15 (copy), v17 (copy), ReactOtter (copy)
		local u18 = true

		task.spawn(function() -- line: 47
			-- upvalues: u18 (ref), v13 (copy), v15 (copy), v17 (copy), ReactOtter (copy)
			while u18 do
				local v20 = if not v13.isMoving then v13.staticHeight else v15()

				v17(ReactOtter.ease(v20, {
					duration = 0.25,
					easingStyle = Enum.EasingStyle.Linear
				}))
				task.wait(0.25)
			end
		end)

		return function() -- line: 60
			-- upvalues: u18 (ref)
			u18 = false
		end
	end, {
		v17,
		v13.isMoving,
		v13.staticHeight
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		LayoutOrder = v13.layoutOrder,
		Size = v16:map(function(n1: number) -- line: 67
			-- upvalues: v13 (copy)
			return UDim2.new(v13.width, UDim.new(n1, 0))
		end),
		BackgroundColor3 = v14.Color.ActionSubEmphasis.Background.Color3
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		})
	})
end

return AnimatedBar
