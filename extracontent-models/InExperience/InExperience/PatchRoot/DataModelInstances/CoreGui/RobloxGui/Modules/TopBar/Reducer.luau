local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local createPersistenceMiddleware = CrossExperience.Middlewares.createPersistenceMiddleware
local FFlagTopBarSignalizeHealthBar = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeHealthBar
local GetFFlagEnableCrossExpVoice = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableCrossExpVoice
local scriptParent = script.Parent
local FFlagTopBarDeprecateCoreGuiRodux = require(scriptParent.Flags.FFlagTopBarDeprecateCoreGuiRodux)
local FFlagTopBarDeprecateChatRodux = require(scriptParent.Flags.FFlagTopBarDeprecateChatRodux)
local DisplayOptions = require(script.DisplayOptions)
local CoreGuiEnabled = require(script.CoreGuiEnabled)
local Health = require(script.Health)
local MoreMenu = require(script.MoreMenu)
local Chat = require(script.Chat)
local Respawn = require(script.Respawn)
local GameInfo = require(script.GameInfo)
local t1 = {
	displayOptions = DisplayOptions,
	coreGuiEnabled = if not FFlagTopBarDeprecateCoreGuiRodux then CoreGuiEnabled else nil,
	health = if not FFlagTopBarSignalizeHealthBar then Health else nil,
	moreMenu = MoreMenu,
	chat = if not FFlagTopBarDeprecateChatRodux then Chat else nil,
	respawn = Respawn,
	gameInfo = GameInfo
}

if GetFFlagEnableCrossExpVoice() then
	local CrossExperienceVoice2 = nil
	local v20 = createPersistenceMiddleware({
		storeKey = CrossExperience.Constants.STORAGE_CEV_STORE_KEY
	}).restore()

	if v20 and v20.Squad and v20.Squad.CrossExperienceVoice then
		CrossExperienceVoice2 = v20.Squad.CrossExperienceVoice
	end

	t1.Squad = Rodux.combineReducers({
		CrossExperienceVoice = CrossExperienceVoice.installReducer(CrossExperienceVoice2)
	})
end

return (Rodux.combineReducers(t1))
