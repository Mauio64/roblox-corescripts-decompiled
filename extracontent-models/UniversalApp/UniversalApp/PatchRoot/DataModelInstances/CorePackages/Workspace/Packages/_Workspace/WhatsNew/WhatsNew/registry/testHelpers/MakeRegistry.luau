local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Constants = require(WhatsNew.Constants)

require(WhatsNew.Types)

local function makeEntry(t1: {[any]: any}?) -- line: 32
	local v5 = t1 or {}

	return {
		id = v5.id or "entryA",
		scopeId = v5.scopeId or "InExperience",
		anchorId = v5.anchorId or "anchorA",
		title = v5.title or "Title",
		text = v5.text or "Text",
		icon = v5.icon or "",
		enabled = v5.enabled == nil or v5.enabled,
		publishedTime = v5.publishedTime or "2026-05-01T00:00:00Z",
		disableTime = v5.disableTime
	}
end

return {
	makeEntry = makeEntry,
	makeRegistry = function(t2: {[any]: any}?) -- line: 47
		-- upvalues: Constants (copy)
		local v7 = t2 or {}

		return {
			constants = v7.constants or Constants.DEFAULT,
			scopeTours = v7.scopeTours or {
				InExperience = {
					id = "InExperience",
					parentScopeId = nil
				}
			},
			whatsNew = v7.whatsNew or {},
			onboarding = v7.onboarding or {}
		}
	end,
	inExperienceNested = function() -- line: 62
		-- upvalues: Constants (copy), makeEntry (copy)
		return {
			constants = Constants.DEFAULT,
			scopeTours = {
				InExperience = {
					id = "InExperience",
					parentScopeId = nil
				},
				ExperienceMenu = {
					id = "ExperienceMenu",
					parentScopeId = "InExperience",
					anchorId = "gameMenuTilt",
					openActionKey = "OpenExperienceMenu",
					closeActionKey = "CloseExperienceMenu",
					onboardingTitle = "The menu lives here",
					onboardingText = "The game menu contains in-game actions along with game-specific controls.",
					updatesTitle = "Menu updates",
					updatesText = "Open the menu to see updates to the side sheet."
				}
			},
			whatsNew = {
				makeEntry({
					id = "settings",
					scopeId = "ExperienceMenu",
					anchorId = "inGameSideSheetA",
					title = "Settings",
					text = "View people in the game, edit game settings, and more."
				}),
				makeEntry({
					id = "inGame",
					scopeId = "ExperienceMenu",
					anchorId = "inGameSideSheetB",
					title = "In game settings",
					text = "Create a party, view the leaderboard, and more."
				}),
				(makeEntry({
					id = "leaveRespawn",
					scopeId = "ExperienceMenu",
					anchorId = "LeaveRespawn",
					title = "Leave and Respawn moved",
					text = "Leave the experience or respawn your avatar here."
				}))
			},
			onboarding = {}
		}
	end,
	inExperienceDoubleNested = function() -- line: 169
		-- upvalues: Constants (copy), makeEntry (copy)
		return {
			constants = Constants.DEFAULT,
			scopeTours = {
				InExperience = {
					id = "InExperience",
					parentScopeId = nil
				},
				ExperienceMenu = {
					id = "ExperienceMenu",
					parentScopeId = "InExperience",
					anchorId = "gameMenuTilt",
					openActionKey = "OpenExperienceMenu",
					closeActionKey = "CloseExperienceMenu",
					onboardingTitle = "The menu lives here",
					onboardingText = "Open the menu to continue.",
					updatesTitle = "Menu updates",
					updatesText = "Open the menu to see updates."
				},
				SettingsPanel = {
					id = "SettingsPanel",
					parentScopeId = "ExperienceMenu",
					anchorId = "settingsGatewayAnchor",
					openActionKey = "OpenSettings",
					closeActionKey = "CloseSettings",
					onboardingTitle = "Settings live here",
					onboardingText = "Open settings to continue.",
					updatesTitle = "Settings updates",
					updatesText = "Open settings to see updates."
				}
			},
			whatsNew = { (makeEntry({
				id = "audioSetting",
				scopeId = "SettingsPanel",
				anchorId = "settingsTipAnchor",
				title = "Audio settings",
				text = "Control volume and audio output here."
			})) },
			onboarding = {}
		}
	end,
	sameAnchorPair = function() -- line: 109
		-- upvalues: Constants (copy), makeEntry (copy)
		return {
			constants = Constants.DEFAULT,
			scopeTours = {
				InExperience = {
					id = "InExperience",
					parentScopeId = nil
				}
			},
			whatsNew = {
				makeEntry({
					id = "gameExperiences",
					scopeId = "InExperience",
					anchorId = "gameMenuTilt",
					title = "Game experiences",
					text = "Discover new game experiences."
				}),
				(makeEntry({
					id = "music",
					scopeId = "InExperience",
					anchorId = "gameMenuTilt",
					title = "Music",
					text = "Control music in the experience."
				}))
			},
			onboarding = {}
		}
	end,
	emptyNestedScopeTours = function() -- line: 138
		return {
			InExperience = {
				id = "InExperience",
				parentScopeId = nil
			},
			ExperienceMenu = {
				id = "ExperienceMenu",
				parentScopeId = "InExperience",
				anchorId = "gameMenuTilt",
				openActionKey = "OpenExperienceMenu",
				closeActionKey = "CloseExperienceMenu",
				onboardingTitle = "The menu lives here",
				onboardingText = "Open the menu to continue.",
				updatesTitle = "Menu updates",
				updatesText = "Open the menu to see updates."
			},
			SettingsPanel = {
				id = "SettingsPanel",
				parentScopeId = "InExperience",
				anchorId = "settingsAnchor",
				openActionKey = "OpenSettings",
				closeActionKey = "CloseSettings",
				onboardingTitle = "Settings live here",
				onboardingText = "Open settings to continue.",
				updatesTitle = "Settings updates",
				updatesText = "Open settings to see updates."
			}
		}
	end
}
