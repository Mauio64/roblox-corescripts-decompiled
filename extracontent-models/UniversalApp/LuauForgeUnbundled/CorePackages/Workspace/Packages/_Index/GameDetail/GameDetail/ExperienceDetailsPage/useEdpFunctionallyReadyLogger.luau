local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RoactUtils").Hooks.RoactRodux.useSelector

local fetchGamePlayButtonData = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GamePlayButton").FetchGamePlayButtonData

require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities")
local milestone = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/TimeToInteractiveTracker").TimeToInteractiveTracker.Milestone

local PageGate = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/PageGate")

local fFlagEDPTTIParityDefinitions = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags").FFlagEDPTTIParityDefinitions

local function useEdpFunctionallyReadyLogger(p2, p3)
	local v5 = useSelector(function(p4)
		if p3 then
			return fetchGamePlayButtonData.IsLoading(p4, p3)
		end

		return true
	end)

	local ref = if PageGate.FFlagEnablePLTPrefetchCallbacks then React.useRef(false) else nil

	React.useEffect(function()
		if not v5 and p3 and p2.trackOnce then
			p2.trackOnce(milestone.FunctionallyReady)

			local markPlayButtonReady = fFlagEDPTTIParityDefinitions and p2.markPlayButtonReady

			if markPlayButtonReady then
				markPlayButtonReady()
			end

			if PageGate.FFlagEnablePLTPrefetchCallbacks and ref and not ref.current then
				ref.current = true
				PageGate.signal(PageGate.Page.ExperienceDetail, PageGate.Milestone.FunctionallyReady)
			end
		end
	end, { v5, p3, p2 })
end

return useEdpFunctionallyReadyLogger
