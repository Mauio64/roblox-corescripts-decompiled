local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local SquadPromptReducer = require(script.Parent.SquadPromptReducer)
local RoduxNetworking = require(SquadsCore.Http.RoduxNetworking)
local RoduxPresence = require(SquadsCore.Http.RoduxPresence)
local RoduxSquads = require(SquadsCore.RoduxSquads)
local SquadLocation = require(SquadsCore.Enums.SquadLocation)
local UserBlockingRodux = require(SquadsCore.Http.UserBlockingRodux)
local CrossExperience = require(SquadsCoreParent.CrossExperience)
local CrossExperienceVoice = require(SquadsCoreParent.CrossExperienceVoice)
local Rodux = require(SquadsCoreParent.Rodux)
local SharedFlags = require(SquadsCoreParent.SharedFlags)
local createPersistenceMiddleware = CrossExperience.Middlewares.createPersistenceMiddleware
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local t1 = {
	NetworkStatus = RoduxNetworking.installReducer(),
	Presence = RoduxPresence.installReducer(),
	Squad = RoduxSquads.installReducer(),
	SquadPrompt = SquadPromptReducer,
	UserBlocking = UserBlockingRodux.installReducer()
}

if GetFFlagEnableCrossExpVoice() then
	local CrossExperienceVoice2 = nil
	local v17 = createPersistenceMiddleware({
		storeKey = CrossExperience.Constants.STORAGE_CEV_STORE_KEY
	}).restore()

	if v17 and v17.Squad and v17.Squad.CrossExperienceVoice then
		CrossExperienceVoice2 = v17.Squad.CrossExperienceVoice
	end

	t1.CrossExperienceVoice = CrossExperienceVoice.installReducer(CrossExperienceVoice2)
end

return function(p1) -- line: 41
	-- upvalues: t1 (copy), SquadLocation (copy), SquadPromptReducer (copy), Rodux (copy)
	t1.SquadPrompt = if p1 ~= SquadLocation.InExperience then nil else SquadPromptReducer

	return Rodux.combineReducers(t1)
end
