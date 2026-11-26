local SquadPromptReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/installReducer/SquadPromptReducer")

local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/RoduxNetworking")
local RoduxPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/RoduxPresence")
local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads")
local SquadLocation = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocation")
local UserBlockingRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/UserBlockingRodux")

local FFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Flags/FFlagSquadsPresenceStoreMigration")

local CrossExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/CrossExperience")
local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/CrossExperienceVoice")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Rodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags")

local createPersistenceMiddleware = CrossExperience.Middlewares.createPersistenceMiddleware

local getFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice

local v5 = {
	NetworkStatus = RoduxNetworking.installReducer(),
	Presence = 0,
	Squad = 0,
	SquadPrompt = 0,
	UserBlocking = 0
}
local v6 = if not FFlagSquadsPresenceStoreMigration then RoduxPresence.installReducer() else nil
v5.Presence = v6
v5.Squad = RoduxSquads.installReducer()
v5.SquadPrompt = SquadPromptReducer
v5.UserBlocking = UserBlockingRodux.installReducer()

if getFFlagEnableCrossExpVoice() then
	local v7 = createPersistenceMiddleware({
		storeKey = CrossExperience.Constants.STORAGE_CEV_STORE_KEY
	}).restore()
	local v8

	if v7 and v7.Squad and v7.Squad.CrossExperienceVoice then
		v8 = v7.Squad.CrossExperienceVoice
	end

	v5.CrossExperienceVoice = CrossExperienceVoice.installReducer(v8)
end

return function(p2)
	local v7 = v5
	local v8 = if p2 == SquadLocation.InExperience then SquadPromptReducer else nil
	v7.SquadPrompt = v8
	return Rodux.combineReducers(v5)
end
