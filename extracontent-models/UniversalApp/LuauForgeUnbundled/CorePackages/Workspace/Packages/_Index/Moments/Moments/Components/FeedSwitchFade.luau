local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local useTokens = Foundation.Hooks.useTokens

local v5 = { duration = 0.2, easingStyle = Enum.EasingStyle.Sine }

local function FadeCover(p2)
	local v6 = useTokens()
	local onFaded = p2.onFaded
	local v7, v8 = ReactOtter.useAnimatedBinding(0, function(p3)
		if p3 >= 1 then
			onFaded()
		end
	end)

	React.useEffect(function()
		v8(ReactOtter.ease(1, v5))
	end, {})

	local surface_0 = v6.Color.Surface.Surface_0
	return React.createElement(Foundation.View, {
		tag = "size-full",
		backgroundStyle = v7:map(function(p3)
			return {
				Color3 = surface_0.Color3,
				Transparency = math.lerp(surface_0.Transparency, 1, p3)
			}
		end),
		testId = "--moments-feed-switch-fade"
	})
end

local function FeedSwitchFade(p2)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(p2.feedKey)

	if state3 ~= p2.feedKey then
		setState3(p2.feedKey)
		setState(state + 1)
	end

	local v6 = React.useCallback(function()
		setState2(state)
	end, { state })

	if state2 == state then
		return nil
	end

	local v7 = {
		[`Cover{state}`] = React.createElement(FadeCover, { onFaded = v6 })
	}

	return React.createElement(Foundation.View, {
		tag = "size-full",
		backgroundStyle = { Transparency = 1 },
		ZIndex = p2.ZIndex
	}, v7)
end

return FeedSwitchFade
