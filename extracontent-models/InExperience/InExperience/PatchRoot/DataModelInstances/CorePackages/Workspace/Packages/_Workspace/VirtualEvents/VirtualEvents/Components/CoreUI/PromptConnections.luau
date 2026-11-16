local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local RobloxAppHooks = require(parent2.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent2.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking

local React = require(parent2.React)
local ReactUtils = require(parent2.ReactUtils)

local useContext = React.useContext
local useEventConnection = ReactUtils.useEventConnection

local fetchEventDetails = require(parent.Common.fetchEventDetails)

local ServiceOverrideContext = require(parent.Components.CoreUI.ServiceOverrideContext)

return function(p)
	local v = useRoactService(RoactNetworking)

	local socialService = useContext(ServiceOverrideContext).socialService

	local v2 = React.useCallback(function(p2: string)
		fetchEventDetails(v, p2):andThen(function(p3)
			p.openRsvpPrompt(p2, p3)
		end, function(p3)
			socialService:PromptRsvpToEventCompleted(p2, false, Enum.RsvpStatus.None)
			warn("Error fetching event details: ", p3)
			p.closePrompt()
		end)
	end, { p.openRsvpPrompt, v })

	useEventConnection(socialService.ShowPromptRsvpToEvent, v2)

	return React.createElement(React.Fragment, {}, {})
end
