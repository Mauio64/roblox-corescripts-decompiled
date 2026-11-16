local parent = script:FindFirstAncestor("ContactImporter").Parent
local RoactAppExperiment = require(parent.RoactAppExperiment)
local defineFastString = game:DefineFastString("ContactImportLayer", "Social.ContactList")

local defineFastString2 = game:DefineFastString(
	"ContactImportGreenFindFriendsButtonExperimentVariable",
	"green_find_friends_button"
)

local defineFastString3 = game:DefineFastString(
	"ContactImportRemoveCloseButtonExperimentVariable",
	"remove_close_button"
)

local useUserExperiment = RoactAppExperiment.useUserExperiment

local function fn(options): boolean
	return ((options or {})[defineFastString] or {})[defineFastString2] == true
end

local function fn2(options): boolean
	return ((options or {})[defineFastString] or {})[defineFastString3] == true
end

local ContactImportButtonsIXP = {}
ContactImportButtonsIXP.isGreenFindFriendsButtonExperimentEnabled = fn
ContactImportButtonsIXP.isRemoveCloseButtonExperimentEnabled = fn2

function ContactImportButtonsIXP.useIsGreenFindFriendsButtonExperimentEnabled(p)
	return useUserExperiment({ defineFastString }, fn, p.isExposureEnabled)
end

function ContactImportButtonsIXP.useIsRemoveCloseButtonExperimentEnabled(p)
	return useUserExperiment({ defineFastString }, fn2, p.isExposureEnabled)
end

return ContactImportButtonsIXP
