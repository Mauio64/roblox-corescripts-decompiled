local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local createPersistenceMiddleware = CrossExperience.Middlewares.createPersistenceMiddleware

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeHealthBar = CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice

local parent = script.Parent

local FFlagTopBarDeprecateCoreGuiRodux = require(parent.Flags.FFlagTopBarDeprecateCoreGuiRodux)
local FFlagTopBarDeprecateChatRodux = require(parent.Flags.FFlagTopBarDeprecateChatRodux)

local DisplayOptions = require(script.DisplayOptions)
local CoreGuiEnabled = require(script.CoreGuiEnabled)
local Health = require(script.Health)
local MoreMenu = require(script.MoreMenu)
local Chat = require(script.Chat)
local Respawn = require(script.Respawn)
local GameInfo = require(script.GameInfo)

if FFlagTopBarDeprecateCoreGuiRodux then
	CoreGuiEnabled = nil
end

if FFlagTopBarSignalizeHealthBar then
	Health = nil
end

if FFlagTopBarDeprecateChatRodux then
	Chat = nil
end

local v = {
	displayOptions = DisplayOptions,
	coreGuiEnabled = CoreGuiEnabled,
	health = Health,
	moreMenu = MoreMenu,
	chat = Chat,
	respawn = Respawn,
	gameInfo = GameInfo
}

if GetFFlagEnableCrossExpVoice() then
	local v2 = createPersistenceMiddleware({
		storeKey = CrossExperience.Constants.STORAGE_CEV_STORE_KEY
	}).restore()
	local v3

	if v2 and v2.Squad and v2.Squad.CrossExperienceVoice then
		v3 = v2.Squad.CrossExperienceVoice
	end

	v.Squad = Rodux.combineReducers({
		CrossExperienceVoice = CrossExperienceVoice.installReducer(v3)
	})
end

return (Rodux.combineReducers(v))
