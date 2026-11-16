local parent = script:FindFirstAncestor("ProfilePlatformCommon").Parent

local ServerTriggeredModals = require(parent.ServerTriggeredModals)
local PromptsEntryPoint = ServerTriggeredModals.PromptsEntryPoint

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt
local defineFastFlag = game:DefineFastFlag("ProfileCompletionUsePlatformSurfaceKey", false)
local defineFastFlag2 = game:DefineFastFlag("ProfileCompletionReplaceOnFetch", false)

return function()
	local loadTimer = SduiLoadTimer.createLoadTimer("ProfileCompletion")

	return {
		entryPoint = PromptsEntryPoint.SelfUserProfileOpen,
		surfaceKey = not defineFastFlag and "ProfileCompletion" or AppPage.ProfilePlatform,
		configKey = "ProfileCompletion",
		clearOnEmptyResponse = true,
		replaceOnFetch = defineFastFlag2 and true or nil,
		allowNoConfigsBuilt = FFlagSduiAllowNoConfigsBuilt and true or nil,
		loadTimer = loadTimer
	}
end
