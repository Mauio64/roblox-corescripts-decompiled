local promptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/ServerTriggeredModals").PromptsEntryPoint

local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/SduiSharedUtilities").SduiLoadTimer
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/RobloxAppEnums").AppPage

local fFlagSduiAllowNoConfigsBuilt = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/SharedFlags").FFlagSduiAllowNoConfigsBuilt
local defineFastFlag = game:DefineFastFlag("ProfileCompletionUsePlatformSurfaceKey", false)
local defineFastFlag2 = game:DefineFastFlag("ProfileCompletionReplaceOnFetch", false)

return function()
	local loadTimer = sduiLoadTimer.createLoadTimer("ProfileCompletion")

	return {
		entryPoint = promptsEntryPoint.SelfUserProfileOpen,
		surfaceKey = not defineFastFlag and "ProfileCompletion" or appPage.ProfilePlatform,
		configKey = "ProfileCompletion",
		clearOnEmptyResponse = true,
		replaceOnFetch = defineFastFlag2 and true or nil,
		allowNoConfigsBuilt = fFlagSduiAllowNoConfigsBuilt and true or nil,
		loadTimer = loadTimer
	}
end
