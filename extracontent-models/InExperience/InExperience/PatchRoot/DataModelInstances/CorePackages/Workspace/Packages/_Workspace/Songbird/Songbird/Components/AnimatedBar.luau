local Songbird = script:FindFirstAncestor("Songbird")

local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local ReactOtter = require(Songbird.Parent.ReactOtter)
local Foundation = require(Songbird.Parent.Foundation)

local useCallback = React.useCallback
local useEffect = React.useEffect
local useTokens = Foundation.Hooks.useTokens

local v = {
	heightRange = NumberRange.new(0.3, 1),
	width = UDim.new(1, 0),
	isMoving = true,
	staticHeight = 0.5
}

local random = Random.new()

local function AnimatedBar(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useTokens()

	local v3 = useCallback(function()
		return random:NextNumber(joined.heightRange.Min, joined.heightRange.Max)
	end, { joined.heightRange })

	local v4, v5 = ReactOtter.useAnimatedBinding(v3())

	useEffect(function()
		local flag = true

		task.spawn(function()
			while flag do
				local v6

				if joined.isMoving then
					v6 = v3()
				else
					v6 = joined.staticHeight
				end

				v5(ReactOtter.ease(v6, { easingStyle = Enum.EasingStyle.Linear, duration = 0.25 }))

				task.wait(0.25)
			end
		end)

		return function()
			flag = false
		end
	end, { v5, joined.isMoving, joined.staticHeight })

	return React.createElement("Frame", {
		LayoutOrder = joined.layoutOrder,
		Size = v4:map(function(p2: number)
			return UDim2.new(joined.width, UDim.new(p2, 0))
		end),
		BorderSizePixel = 0,
		BackgroundColor3 = v2.Color.ActionSubEmphasis.Background.Color3
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
	})
end

return AnimatedBar
