local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local getCommentsSheetStore = require(Moments.Components.Comments.Sheet.getCommentsSheetStore)
local MomentContext = require(script.Parent.MomentContext)

local v = { duration = MomentContext.SCRUB_FADE_SECONDS, easingStyle = Enum.EasingStyle.Quad }

local function useCommentsChromeTransparency(p: string?)
	local v2 = React.useMemo(function()
		local commentsSheetStore = getCommentsSheetStore(false)
		return Signals.createComputed(function(p2)
			return p ~= nil and commentsSheetStore.getIsOpen(p2) and commentsSheetStore.getFeedItemId(p2) == p
		end)
	end, { p or false })
	local v3 = SignalsReact.useSignalState(v2)

	local state, setState = React.useState(v3)
	local v4 = React.useCallback(function(p2: number)
		if p2 <= 0 then
			setState(false)
		end
	end, {})
	local v5, v6 = ReactOtter.useAnimatedBinding(v3 and 1 or 0, v4)

	React.useEffect(function()
		if v3 then
			setState(true)
		end

		v6(ReactOtter.ease(v3 and 1 or 0, v))
	end, { v3 })
	return if v3 or state then v5 else nil
end

return useCommentsChromeTransparency
