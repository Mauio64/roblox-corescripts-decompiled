local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local useRoactService = require(ParentParentParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(ParentParentParent.RoactServiceTags).RoactNetworking
local React = require(ParentParentParent.React)
local ReactUtils = require(ParentParentParent.ReactUtils)
local useContext = React.useContext
local useEventConnection = ReactUtils.useEventConnection
local fetchEventDetails = require(ParentParent.Common.fetchEventDetails)
local ServiceOverrideContext = require(ParentParent.Components.CoreUI.ServiceOverrideContext)

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useRoactService (copy), RoactNetworking (copy), useContext (copy), ServiceOverrideContext (copy), React (copy), fetchEventDetails (copy), useEventConnection (copy)
	local v12 = useRoactService(RoactNetworking)
	local socialService = useContext(ServiceOverrideContext).socialService
	local v14 = React.useCallback(function(s1: string) -- line: 33
		-- upvalues: fetchEventDetails (copy), v12 (copy), t1 (copy), socialService (copy)
		fetchEventDetails(v12, s1):andThen(function(p1) -- line: 34
			-- upvalues: t1 (copy), s1 (copy)
			t1.openRsvpPrompt(s1, p1)
		end, function(p2) -- line: 36
			-- upvalues: socialService (copy), s1 (copy), t1 (copy)
			socialService:PromptRsvpToEventCompleted(s1, false, Enum.RsvpStatus.None)
			warn("Error fetching event details: ", p2)
			t1.closePrompt()
		end)
	end, {
		t1.openRsvpPrompt,
		v12
	})

	useEventConnection(socialService.ShowPromptRsvpToEvent, v14)

	return React.createElement(React.Fragment, {}, {})
end
