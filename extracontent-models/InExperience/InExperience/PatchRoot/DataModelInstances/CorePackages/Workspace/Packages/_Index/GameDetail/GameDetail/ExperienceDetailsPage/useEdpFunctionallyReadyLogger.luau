local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local GamePlayButton = require(parent.GamePlayButton)
local FetchGamePlayButtonData = GamePlayButton.FetchGamePlayButtonData

require(parent.SduiSharedUtilities)
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local Milestone = TimeToInteractiveTracker.TimeToInteractiveTracker.Milestone

local PageGate = require(parent.PageGate)

local SharedFlags = require(parent.SharedFlags)
local FFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions

local function useEdpFunctionallyReadyLogger(p, p2: string?)
	local v = useSelector(function(p3)
		if p2 then
			return FetchGamePlayButtonData.IsLoading(p3, p2)
		end

		return true
	end)
	local ref

	if PageGate.FFlagEnablePLTPrefetchCallbacks then
		ref = React.useRef(false)
	else
		ref = nil
	end

	React.useEffect(function()
		if not v and p2 and p.trackOnce then
			p.trackOnce(Milestone.FunctionallyReady)

			local markPlayButtonReady = FFlagEDPTTIParityDefinitions and p.markPlayButtonReady

			if markPlayButtonReady then
				markPlayButtonReady()
			end

			if PageGate.FFlagEnablePLTPrefetchCallbacks and ref and not ref.current then
				ref.current = true
				PageGate.signal(PageGate.Page.ExperienceDetail, PageGate.Milestone.FunctionallyReady)
			end
		end
	end, { v, p2, p })
end

return useEdpFunctionallyReadyLogger
