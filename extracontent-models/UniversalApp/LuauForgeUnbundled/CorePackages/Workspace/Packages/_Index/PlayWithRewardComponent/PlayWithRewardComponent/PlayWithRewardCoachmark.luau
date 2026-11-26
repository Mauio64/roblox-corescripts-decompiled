local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/Foundation")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/RoactUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/SharedFlags")

local PlayWithRewardCoachmarkStorage = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardComponent/PlayWithRewardComponent/PlayWithRewardCoachmarkStorage")
local PlayWithRewardTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/PlayWithRewardComponent/PlayWithRewardComponent/PlayWithRewardTelemetry")

local useEarlyIsFocused = Navigation.useEarlyIsFocused
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local coachmark = Foundation.Coachmark
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local fFlagPlayWithRewardCoachmarkOverlayFix = SharedFlags.FFlagPlayWithRewardCoachmarkOverlayFix

local function PlayWithRewardCoachmark(props)
	local state, setState = React.useState(false)
	local v5, v6

	if fFlagPlayWithRewardCoachmarkOverlayFix then
		v5 = useEarlyIsFocused()
		v6 = useSelector(function(p2): boolean
			return p2.CentralOverlay.OverlayType ~= nil
		end)
	else
		v5 = nil
		v6 = nil
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

	if fFlagPlayWithRewardCoachmarkOverlayFix then
		React.useEffect(function()
			if not v5 or v6 then
				setState(false)
			end
		end, { v5, v6 })
	end

	local v7 = React.useCallback(function()
		PlayWithRewardCoachmarkStorage.dismissCurrentWindow(props.localUserId)
		PlayWithRewardTelemetry.logPlayWithRewardCoachmark("dismissed", props.flowId, props.universeId, props.productId)
		setState(false)
	end, { props.flowId, props.universeId, props.productId, props.localUserId })

	return React.createElement(coachmark, {
		title = props.title,
		text = props.text,
		isOpen = state,
		side = popoverSide.Bottom,
		align = popoverAlign.Center,
		anchorRef = props.anchorRef,
		onClose = v7
	})
end

return React.memo(PlayWithRewardCoachmark)
