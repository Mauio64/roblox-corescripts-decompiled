local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local SquadPromptReducer = require(script.Parent.SquadPromptReducer)

local RoduxNetworking = require(SquadsCore.Http.RoduxNetworking)
local RoduxPresence = require(SquadsCore.Http.RoduxPresence)
local RoduxSquads = require(SquadsCore.RoduxSquads)
local SquadLocation = require(SquadsCore.Enums.SquadLocation)
local UserBlockingRodux = require(SquadsCore.Http.UserBlockingRodux)

local FFlagSquadsPresenceStoreMigration = require(SquadsCore.Flags.FFlagSquadsPresenceStoreMigration)

local CrossExperience = require(parent.CrossExperience)
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local Rodux = require(parent.Rodux)
local SharedFlags = require(parent.SharedFlags)

local createPersistenceMiddleware = CrossExperience.Middlewares.createPersistenceMiddleware

local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice

local v = {
	NetworkStatus = RoduxNetworking.installReducer(),
	Presence = 0,
	Squad = 0,
	SquadPrompt = 0,
	UserBlocking = 0
}
local presence

if not FFlagSquadsPresenceStoreMigration then
	presence = RoduxPresence.installReducer()
end

v.Presence = presence
v.Squad = RoduxSquads.installReducer()
v.SquadPrompt = SquadPromptReducer
v.UserBlocking = UserBlockingRodux.installReducer()

if GetFFlagEnableCrossExpVoice() then
	local v2 = createPersistenceMiddleware({
		storeKey = CrossExperience.Constants.STORAGE_CEV_STORE_KEY
	}).restore()
	local v3

	if v2 and v2.Squad and v2.Squad.CrossExperienceVoice then
		v3 = v2.Squad.CrossExperienceVoice
	end

	v.CrossExperienceVoice = CrossExperienceVoice.installReducer(v3)
end

return function(p)
	local v2 = v
	local squadPrompt

	if p == SquadLocation.InExperience then
		squadPrompt = SquadPromptReducer
	end

	v2.SquadPrompt = squadPrompt
	return Rodux.combineReducers(v)
end
