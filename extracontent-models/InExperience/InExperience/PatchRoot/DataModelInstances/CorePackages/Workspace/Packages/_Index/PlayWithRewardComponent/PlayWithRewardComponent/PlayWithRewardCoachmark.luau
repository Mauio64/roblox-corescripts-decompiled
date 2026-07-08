local PlayWithRewardComponent = script:FindFirstAncestor("PlayWithRewardComponent")
local PlayWithRewardComponentParent = PlayWithRewardComponent.Parent
local Foundation = require(PlayWithRewardComponentParent.Foundation)
local Navigation = require(PlayWithRewardComponentParent.Navigation)
local React = require(PlayWithRewardComponentParent.React)
local RoactUtils = require(PlayWithRewardComponentParent.RoactUtils)
local SharedFlags = require(PlayWithRewardComponentParent.SharedFlags)
local PlayWithRewardCoachmarkStorage = require(PlayWithRewardComponent.PlayWithRewardCoachmarkStorage)
local PlayWithRewardTelemetry = require(PlayWithRewardComponent.PlayWithRewardTelemetry)
local useEarlyIsFocused = Navigation.useEarlyIsFocused
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Coachmark = Foundation.Coachmark
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local FFlagPlayWithRewardCoachmarkOverlayFix = SharedFlags.FFlagPlayWithRewardCoachmarkOverlayFix

local function PlayWithRewardCoachmark(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), FFlagPlayWithRewardCoachmarkOverlayFix (copy), useEarlyIsFocused (copy), useSelector (copy), PlayWithRewardCoachmarkStorage (copy), PlayWithRewardTelemetry (copy), Coachmark (copy), PopoverSide (copy), PopoverAlign (copy)
	local v18, v19 = React.useState(false)
	local u20 = nil
	local u21 = nil

	if FFlagPlayWithRewardCoachmarkOverlayFix then
		u20 = useEarlyIsFocused()
		u21 = useSelector(function(p1) -- line: 47
			return p1.CentralOverlay.OverlayType ~= nil
		end)
	end

	React.useEffect(function() -- line: 52
		-- upvalues: v19 (copy), t1 (copy), PlayWithRewardCoachmarkStorage (copy), PlayWithRewardTelemetry (copy)
		v19(false)

		if t1.localUserId <= 0 then
			return
		end

		if PlayWithRewardCoachmarkStorage.consumeImpressionIfEligible(t1.localUserId) then
			v19(true)
			PlayWithRewardTelemetry.logPlayWithRewardCoachmark("shown", t1.flowId, t1.universeId, t1.productId)
		end
	end, {
		t1.flowId,
		t1.localUserId,
		t1.productId,
		t1.universeId
	})

	if FFlagPlayWithRewardCoachmarkOverlayFix then
		React.useEffect(function() -- line: 66
			-- upvalues: u20 (ref), u21 (ref), v19 (copy)
			if not u20 or u21 then
				v19(false)
			end
		end, {
			u20,
			u21
		})
	end

	local v22 = React.useCallback(function() -- line: 73
		-- upvalues: PlayWithRewardCoachmarkStorage (copy), t1 (copy), PlayWithRewardTelemetry (copy), v19 (copy)
		PlayWithRewardCoachmarkStorage.dismissCurrentWindow(t1.localUserId)
		PlayWithRewardTelemetry.logPlayWithRewardCoachmark("dismissed", t1.flowId, t1.universeId, t1.productId)
		v19(false)
	end, {
		t1.flowId,
		t1.universeId,
		t1.productId,
		t1.localUserId
	})

	return React.createElement(Coachmark, {
		title = t1.title,
		text = t1.text,
		isOpen = v18,
		side = PopoverSide.Bottom,
		align = PopoverAlign.Center,
		anchorRef = t1.anchorRef,
		onClose = v22
	})
end

return React.memo(PlayWithRewardCoachmark)
