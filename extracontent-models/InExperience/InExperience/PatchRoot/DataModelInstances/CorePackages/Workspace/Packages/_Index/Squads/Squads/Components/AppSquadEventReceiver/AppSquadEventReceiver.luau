local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService

local AppSquadTopBannerEventReceiver = require(script.Parent.AppSquadTopBannerEventReceiver)

local dependencies = require(Squads.dependencies)
local react = dependencies.React
local roduxSquads = dependencies.RoduxSquads
local SquadEventReceiver = require(parent.SquadsCore.SquadEventReceiver)
local Stores = require(parent.SquadsCore.Stores)
local GetSquadExperienceInviteStore = Stores.GetSquadExperienceInviteStore
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useDispatch = dependencies.Hooks.useDispatch
local useSelector = dependencies.Hooks.useSelector
local useCanAccessParty = require(Squads.Hooks.useCanAccessParty)

local currentSquadUpdated = roduxSquads.Actions.CurrentSquadUpdated

local fFlagUseSignalsForSquadExperienceInvite = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInvite

return function(_)
	local v = useDispatch()

	local v2 = react.useCallback(function(p)
		if p.Squad and p.Squad.Squad then
			return p.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})
	local v3

	if fFlagUseSignalsForSquadExperienceInvite then
		v3 = useSignalState(GetSquadExperienceInviteStore(false).getCurrentExperienceInvite)
	else
		v3 = useSelector(v2)
	end

	local v4 = useSelector((react.useCallback(function(p)
		if p.Squad and p.Squad.Squad and p.Squad.Squad.currentSquadPersist then
			return p.Squad.Squad.currentSquadPersist.isPaused
		end

		return false
	end, {})))

	react.useEffect(function()
		experienceService:RegisterForExperienceJoin(function()
			roduxSquads.PersistManagers.currentSquadPersistManager.pause(v)
		end)
		experienceService:RegisterForExperienceLeave(function()
			roduxSquads.PersistManagers.currentSquadPersistManager.persistAndUpdateState(v)
		end)
	end, { v })

	react.useEffect(function()
		if v3 and v4 then
			if fFlagUseSignalsForSquadExperienceInvite then
				GetSquadExperienceInviteStore(false).currentExperienceInviteDismissed(v3.notification.notificationId)
			else
				v(roduxSquads.Actions.CurrentExperienceInviteDismissed(v3.notification.notificationId))
			end
		end
	end, { v3, v4 })

	local v5 = useCanAccessParty()

	react.useEffect(function()
		if not v5 then
			v(currentSquadUpdated(nil))
		end
	end, { v5 })

	local createElement = react.createElement
	local fragment = react.Fragment
	local v6 = {
		appSquadTopBannerEventReceiver = react.createElement(AppSquadTopBannerEventReceiver),
		squadEventReceiver = 0
	}
	local squadEventReceiver

	if v5 and not v4 then
		squadEventReceiver = react.createElement(SquadEventReceiver)
	end

	v6.squadEventReceiver = squadEventReceiver
	return createElement(fragment, nil, v6)
end
