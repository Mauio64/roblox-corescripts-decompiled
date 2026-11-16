local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/ExperienceService").ExperienceService

local AppSquadTopBannerEventReceiver = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/AppSquadEventReceiver/AppSquadTopBannerEventReceiver")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local react = dependencies.React
local roduxSquads = dependencies.RoduxSquads
local SquadEventReceiver = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadEventReceiver")
local getSquadExperienceInviteStore = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Stores").GetSquadExperienceInviteStore
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SignalsReact").useSignalState

local useDispatch = dependencies.Hooks.useDispatch
local useSelector = dependencies.Hooks.useSelector
local useCanAccessParty = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Hooks/useCanAccessParty")

local currentSquadUpdated = roduxSquads.Actions.CurrentSquadUpdated

local fFlagUseSignalsForSquadExperienceInvite = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInvite

return function(p2)
	local v5 = useDispatch()

	local v6 = react.useCallback(function(p3)
		if p3.Squad and p3.Squad.Squad then
			return p3.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})
	local v7

	if fFlagUseSignalsForSquadExperienceInvite then
		v7 = useSignalState(getSquadExperienceInviteStore(false).getCurrentExperienceInvite)
	else
		v7 = useSelector(v6)
	end

	local v9 = useSelector((react.useCallback(function(p3)
		if p3.Squad and p3.Squad.Squad and p3.Squad.Squad.currentSquadPersist then
			return p3.Squad.Squad.currentSquadPersist.isPaused
		end

		return false
	end, {})))

	react.useEffect(function()
		experienceService:RegisterForExperienceJoin(function()
			roduxSquads.PersistManagers.currentSquadPersistManager.pause(v5)
		end)
		experienceService:RegisterForExperienceLeave(function()
			roduxSquads.PersistManagers.currentSquadPersistManager.persistAndUpdateState(v5)
		end)
	end, { v5 })

	react.useEffect(function()
		if v7 and v9 then
			if fFlagUseSignalsForSquadExperienceInvite then
				getSquadExperienceInviteStore(false).currentExperienceInviteDismissed(v7.notification.notificationId)
			else
				v5(roduxSquads.Actions.CurrentExperienceInviteDismissed(v7.notification.notificationId))
			end
		end
	end, { v7, v9 })

	local v10 = useCanAccessParty()

	react.useEffect(function()
		if not v10 then
			v5(currentSquadUpdated(nil))
		end
	end, { v10 })

	local createElement = react.createElement
	local fragment = react.Fragment
	local v12 = {
		appSquadTopBannerEventReceiver = react.createElement(AppSquadTopBannerEventReceiver),
		squadEventReceiver = 0
	}

	local v13 = if v10 and not v9 then react.createElement(SquadEventReceiver) else nil
	v12.squadEventReceiver = v13
	return createElement(fragment, nil, v12)
end
