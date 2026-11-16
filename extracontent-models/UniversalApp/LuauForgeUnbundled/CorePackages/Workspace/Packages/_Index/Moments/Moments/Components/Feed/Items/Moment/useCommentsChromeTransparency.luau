local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local getCommentsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore")
local v5 = {
	duration = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext").SCRUB_FADE_SECONDS,
	easingStyle = Enum.EasingStyle.Quad
}

local function useCommentsChromeTransparency(p2)
	local v6 = React.useMemo(function()
		local v7 = getCommentsSheetStore(false)
		return Signals.createComputed(function(p3)
			return p2 ~= nil and v7.getIsOpen(p3) and v7.getFeedItemId(p3) == p2
		end)
	end, { p2 or false })
	local v7 = SignalsReact.useSignalState(v6)

	local state, setState = React.useState(v7)
	local v8 = React.useCallback(function(p3)
		if p3 <= 0 then
			setState(false)
		end
	end, {})
	local v9, v10 = ReactOtter.useAnimatedBinding(v7 and 1 or 0, v8)

	React.useEffect(function()
		if v7 then
			setState(true)
		end

		v10(ReactOtter.ease(v7 and 1 or 0, v5))
	end, { v7 })

	if v7 or state then
		return v9
	end

	return nil
end

return useCommentsChromeTransparency
