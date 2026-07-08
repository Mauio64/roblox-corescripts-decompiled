local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local MomentsCommon = require(Parent.MomentsCommon)
local ReactOtter = require(Parent.ReactOtter)
local Signals = require(Parent.Signals)
local createMomentStore = require(script.Parent.createMomentStore)
local MediaPreloadProvider = MomentsCommon.Media.MediaPreloadProvider
local t1 = {
	duration = 0.08,
	easingStyle = Enum.EasingStyle.Quad
}
local v9 = React.createContext(nil)

local function MomentProvider(t2: {[any]: any}) -- line: 52
	-- upvalues: React (copy), createMomentStore (copy), MediaPreloadProvider (copy), Signals (copy), ReactOtter (copy), t1 (copy), v9 (copy)
	local data = t2.data
	local v13 = React.useMemo(function() -- line: 59
		-- upvalues: createMomentStore (copy), data (copy)
		return createMomentStore(data)
	end, {})
	local v14 = MediaPreloadProvider.useMediaControllerProvider()
	local v15, v16 = React.useState(nil)

	React.useEffect(function() -- line: 66
		-- upvalues: Signals (copy), v14 (copy), data (copy), v16 (copy)
		return (Signals.createEffect(function(p1) -- line: 67
			-- upvalues: v14 (copy), data (copy), v16 (copy)
			if v14 == nil then
				return
			end

			local v22 = v14.getControllerMap(p1)[data.momentId]

			if v22 == nil then
				return
			end

			v16(v22)
		end))
	end, {
		data.momentId,
		v14
	})

	local v17, v18 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 85
		-- upvalues: Signals (copy), v13 (copy), v18 (copy), ReactOtter (copy), t1 (copy)
		return (Signals.createEffect(function(p2) -- line: 86
			-- upvalues: v13 (copy), v18 (copy), ReactOtter (copy), t1 (copy)
			local v24 = v13.getIsScrubbing(p2)

			v18(ReactOtter.ease(not v24 and 0 or 1, t1))
		end))
	end, { v13 })

	local v19 = React.useMemo(function() -- line: 94
		-- upvalues: data (copy), v15 (copy), v13 (copy), v17 (copy)
		return {
			momentId = data.momentId,
			controller = v15,
			store = v13,
			animationRatio = v17
		}
	end, {
		data.momentId,
		v15,
		v13,
		v17
	})

	return React.createElement(v9.Provider, {
		value = v19
	}, t2.children)
end

return table.freeze({
	Context = v9,
	Provider = MomentProvider,
	useMoment = function() -- line: 113
		-- upvalues: React (copy), v9 (copy)
		local v20 = React.useContext(v9)

		if v20 == nil then
			error("useMoment must be used within a MomentProvider")
		end

		return v20
	end,
	SCRUB_FADE_SECONDS = t1.duration
})
