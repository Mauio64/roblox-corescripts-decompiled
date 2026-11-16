local PlayWithRewardComponent = script:FindFirstAncestor("PlayWithRewardComponent")
local parent = PlayWithRewardComponent.Parent

local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)

local PlayWithRewardCoachmarkStorage = require(PlayWithRewardComponent.PlayWithRewardCoachmarkStorage)
local PlayWithRewardTelemetry = require(PlayWithRewardComponent.PlayWithRewardTelemetry)

local useEarlyIsFocused = Navigation.useEarlyIsFocused
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Coachmark = Foundation.Coachmark
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local FFlagPlayWithRewardCoachmarkOverlayFix = SharedFlags.FFlagPlayWithRewardCoachmarkOverlayFix

local function PlayWithRewardCoachmark(props)
	local state, setState = React.useState(false)
	local v, v2

	if FFlagPlayWithRewardCoachmarkOverlayFix then
		v = useEarlyIsFocused()
		v2 = useSelector(function(p): boolean
			return p.CentralOverlay.OverlayType ~= nil
		end)
	else
		v = nil
		v2 = nil
	end

	React.useEffect(function()
		setState(false)

		if props.localUserId <= 0 then
			return
		end

		if PlayWithRewardCoachmarkStorage.consumeImpressionIfEligible(props.localUserId) then
			setState(true)
			PlayWithRewardTelemetry.logPlayWithRewardCoachmark("shown", props.flowId, props.universeId, props.productId)
		end
	end, { props.flowId, props.localUserId, props.productId, props.universeId })

	if FFlagPlayWithRewardCoachmarkOverlayFix then
		React.useEffect(function()
			if not v or v2 then
				setState(false)
			end
		end, { v, v2 })
	end

	local onClose = React.useCallback(function()
		PlayWithRewardCoachmarkStorage.dismissCurrentWindow(props.localUserId)
		PlayWithRewardTelemetry.logPlayWithRewardCoachmark("dismissed", props.flowId, props.universeId, props.productId)
		setState(false)
	end, { props.flowId, props.universeId, props.productId, props.localUserId })

	return React.createElement(Coachmark, {
		title = props.title,
		text = props.text,
		isOpen = state,
		side = PopoverSide.Bottom,
		align = PopoverAlign.Center,
		anchorRef = props.anchorRef,
		onClose = onClose
	})
end

return React.memo(PlayWithRewardCoachmark)
