local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local GetFFlagMomentsRenderPostAssets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/GetFFlagMomentsRenderPostAssets")

local createMomentStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/createMomentStore")

local mediaPreloadProvider = MomentsCommon.Media.MediaPreloadProvider

local v5 = { duration = 0.08, easingStyle = Enum.EasingStyle.Quad }

local context = React.createContext(nil)

local function MomentProvider(props)
	local data = props.data

	local function fn()
		return createMomentStore(data)
	end

	local v8 = React.useMemo(fn, { if GetFFlagMomentsRenderPostAssets() then props.dataVersion or false else nil })

	local v9 = mediaPreloadProvider.useMediaControllerProvider()
	local state, setState = React.useState(nil)

	React.useEffect(function()
		return (Signals.createEffect(function(p2)
			if v9 == nil then
				return
			end

			local v10 = v9.getControllerMap(p2)[data.momentId]

			if v10 == nil then
				return
			end

			setState(v10)
		end))
	end, { data.momentId, v9 })

	local v10, v11 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function()
		return (Signals.createEffect(function(p2)
			local isScrubbing = v8.getIsScrubbing(p2)
			v11(ReactOtter.ease(isScrubbing and 1 or 0, v5))
		end))
	end, { v8 })

	local v12 = React.useMemo(function()
		return {
			momentId = data.momentId,
			controller = state,
			store = v8,
			animationRatio = v10
		}
	end, { data.momentId, state, v8, v10 })

	return React.createElement(context.Provider, { value = v12 }, props.children)
end

return table.freeze({
	Context = context,
	Provider = MomentProvider,
	useMoment = function()
		local v6 = React.useContext(context)

		if v6 == nil then
			error("useMoment must be used within a MomentProvider")
		end

		return v6
	end,
	SCRUB_FADE_SECONDS = v5.duration
})
