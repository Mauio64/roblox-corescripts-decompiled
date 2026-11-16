local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local MomentsCommon = require(parent.MomentsCommon)
local ReactOtter = require(parent.ReactOtter)
local Signals = require(parent.Signals)
local GetFFlagMomentsRenderPostAssets = require(parent.MomentsCommon.GetFFlagMomentsRenderPostAssets)

local createMomentStore = require(script.Parent.createMomentStore)

local MediaPreloadProvider = MomentsCommon.Media.MediaPreloadProvider

local v = { duration = 0.08, easingStyle = Enum.EasingStyle.Quad }

local context = React.createContext(nil)

local function MomentProvider(props)
	local data = props.data

	local useMemo = React.useMemo
	local function fn()
		return createMomentStore(data)
	end

	local v2

	if GetFFlagMomentsRenderPostAssets() then
		v2 = props.dataVersion or false
	end

	local store = useMemo(fn, { v2 })

	local v3 = MediaPreloadProvider.useMediaControllerProvider()
	local state, setState = React.useState(nil)

	React.useEffect(function()
		return (Signals.createEffect(function(p)
			if v3 == nil then
				return
			end

			local v4 = v3.getControllerMap(p)[data.momentId]

			if v4 == nil then
				return
			end

			setState(v4)
		end))
	end, { data.momentId, v3 })

	local animationRatio, v4 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function()
		return (Signals.createEffect(function(p)
			local isScrubbing = store.getIsScrubbing(p)
			v4(ReactOtter.ease(isScrubbing and 1 or 0, v))
		end))
	end, { store })

	local v5 = React.useMemo(function()
		return {
			momentId = data.momentId,
			controller = state,
			store = store,
			animationRatio = animationRatio
		}
	end, { data.momentId, state, store, animationRatio })

	return React.createElement(context.Provider, { value = v5 }, props.children)
end

return table.freeze({
	Context = context,
	Provider = MomentProvider,
	useMoment = function()
		local v2 = React.useContext(context)

		if v2 == nil then
			error("useMoment must be used within a MomentProvider")
		end

		return v2
	end,
	SCRUB_FADE_SECONDS = v.duration
})
