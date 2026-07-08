local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local ExperienceService = require(SquadsParent.ExperienceService).ExperienceService
local AppSquadTopBannerEventReceiver = require(script.Parent.AppSquadTopBannerEventReceiver)
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local RoduxSquads = dependencies.RoduxSquads
local SquadEventReceiver = require(SquadsParent.SquadsCore.SquadEventReceiver)
local useDispatch = dependencies.Hooks.useDispatch
local useSelector = dependencies.Hooks.useSelector
local useCanAccessParty = require(Squads.Hooks.useCanAccessParty)
local CurrentSquadUpdated = RoduxSquads.Actions.CurrentSquadUpdated

return function(_) -- line: 18
	-- upvalues: useDispatch (copy), React (copy), useSelector (copy), ExperienceService (copy), RoduxSquads (copy), useCanAccessParty (copy), CurrentSquadUpdated (copy), AppSquadTopBannerEventReceiver (copy), SquadEventReceiver (copy)
	local v14 = useDispatch()
	local v15 = React.useCallback(function(p2) -- line: 21
		if p2.Squad and p2.Squad.Squad then
			return p2.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})
	local v16 = useSelector(v15)
	local v17 = React.useCallback(function(p3) -- line: 26
		if p3.Squad and (p3.Squad.Squad and p3.Squad.Squad.currentSquadPersist) then
			return p3.Squad.Squad.currentSquadPersist.isPaused
		end

		return false
	end, {})
	local v18 = useSelector(v17)

	React.useEffect(function() -- line: 36
		-- upvalues: ExperienceService (copy), RoduxSquads (copy), v14 (copy)
		ExperienceService:RegisterForExperienceJoin(function() -- line: 37
			-- upvalues: RoduxSquads (copy), v14 (copy)
			RoduxSquads.PersistManagers.currentSquadPersistManager.pause(v14)
		end)
		ExperienceService:RegisterForExperienceLeave(function() -- line: 42
			-- upvalues: RoduxSquads (copy), v14 (copy)
			RoduxSquads.PersistManagers.currentSquadPersistManager.persistAndUpdateState(v14)
		end)
	end, { v14 })
	React.useEffect(function() -- line: 48
		-- upvalues: v16 (copy), v18 (copy), v14 (copy), RoduxSquads (copy)
		if v16 and v18 then
			v14(RoduxSquads.Actions.CurrentExperienceInviteDismissed(v16.notification.notificationId))
		end
	end, {
		v16,
		v18
	})

	local v19 = useCanAccessParty()

	React.useEffect(function() -- line: 64
		-- upvalues: v19 (copy), v14 (copy), CurrentSquadUpdated (copy)
		if not v19 then
			v14(CurrentSquadUpdated(nil))
		end
	end, { v19 })

	return React.createElement(React.Fragment, nil, {
		appSquadTopBannerEventReceiver = React.createElement(AppSquadTopBannerEventReceiver),
		squadEventReceiver = if not v19 or v18 then nil else React.createElement(SquadEventReceiver)
	})
end
