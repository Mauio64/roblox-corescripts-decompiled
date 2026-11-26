local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactOtter")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useTokens = Foundation.Hooks.useTokens

local v5 = {
	heightRange = NumberRange.new(0.3, 1),
	width = UDim.new(1, 0),
	isMoving = true,
	staticHeight = 0.5
}

local random = Random.new()

local function AnimatedBar(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useTokens()

	local v7 = useCallback(function()
		return random:NextNumber(joined.heightRange.Min, joined.heightRange.Max)
	end, { joined.heightRange })

	local v8, v9 = ReactOtter.useAnimatedBinding(v7())

	useEffect(function()
		local flag = true

		task.spawn(function()
			while flag do
				local v10 = if joined.isMoving then v7() else joined.staticHeight

				v9(ReactOtter.ease(v10, {
					easingStyle = Enum.EasingStyle.Linear,
					duration = 0.25
				}))

				task.wait(0.25)
			end
		end)

		return function()
			flag = false
		end
	end, { v9, joined.isMoving, joined.staticHeight })

	return React.createElement("Frame", {
		LayoutOrder = joined.layoutOrder,
		Size = v8:map(function(p3)
			return UDim2.new(joined.width, UDim.new(p3, 0))
		end),
		BorderSizePixel = 0,
		BackgroundColor3 = v6.Color.ActionSubEmphasis.Background.Color3
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
	})
end

return AnimatedBar
