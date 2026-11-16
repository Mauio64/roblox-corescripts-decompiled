local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactAppExperiment")
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

return {
	isGreenFindFriendsButtonExperimentEnabled = fn,
	isRemoveCloseButtonExperimentEnabled = fn2,
	useIsGreenFindFriendsButtonExperimentEnabled = function(p2)
		return useUserExperiment({ defineFastString }, fn, p2.isExposureEnabled)
	end,
	useIsRemoveCloseButtonExperimentEnabled = function(p2)
		return useUserExperiment({ defineFastString }, fn2, p2.isExposureEnabled)
	end
}
