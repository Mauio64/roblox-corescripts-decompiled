local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactServiceTags").RoactNetworking

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ReactUtils")

local useContext = React.useContext
local useEventConnection = ReactUtils.useEventConnection

local fetchEventDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/fetchEventDetails")

local ServiceOverrideContext = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/ServiceOverrideContext")

return function(p2)
	local v5 = useRoactService(roactNetworking)

	local socialService = useContext(ServiceOverrideContext).socialService

	local v6 = React.useCallback(function(p3)
		fetchEventDetails(v5, p3):andThen(function(p4)
			p2.openRsvpPrompt(p3, p4)
		end, function(p4)
			socialService:PromptRsvpToEventCompleted(p3, false, Enum.RsvpStatus.None)
			warn("Error fetching event details: ", p4)
			p2.closePrompt()
		end)
	end, { p2.openRsvpPrompt, v5 })

	useEventConnection(socialService.ShowPromptRsvpToEvent, v6)

	return React.createElement(React.Fragment, {}, {})
end
