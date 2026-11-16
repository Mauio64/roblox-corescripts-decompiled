local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local useTokens = Foundation.Hooks.useTokens

local v = { duration = 0.2, easingStyle = Enum.EasingStyle.Sine }

local function FadeCover(p)
	local v2 = useTokens()
	local onFaded = p.onFaded
	local v3, v4 = ReactOtter.useAnimatedBinding(0, function(p2: number)
		if p2 >= 1 then
			onFaded()
		end
	end)

	React.useEffect(function()
		v4((ReactOtter.ease(1, v)))
	end, {})

	local surface_0 = v2.Color.Surface.Surface_0
	return React.createElement(Foundation.View, {
		tag = "size-full",
		backgroundStyle = v3:map(function(p2: number)
			return {
				Color3 = surface_0.Color3,
				Transparency = math.lerp(surface_0.Transparency, 1, p2)
			}
		end),
		testId = "--moments-feed-switch-fade"
	})
end

local function FeedSwitchFade(p)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(p.feedKey)

	if state3 ~= p.feedKey then
		setState3(p.feedKey)
		setState(state + 1)
	end

	local onFaded = React.useCallback(function()
		setState2(state)
	end, { state })

	if state2 == state then
		return nil
	end

	local v2 = {
		[`Cover{state}`] = React.createElement(FadeCover, { onFaded = onFaded })
	}

	return React.createElement(Foundation.View, {
		tag = "size-full",
		backgroundStyle = { Transparency = 1 },
		ZIndex = p.ZIndex
	}, v2)
end

return FeedSwitchFade
