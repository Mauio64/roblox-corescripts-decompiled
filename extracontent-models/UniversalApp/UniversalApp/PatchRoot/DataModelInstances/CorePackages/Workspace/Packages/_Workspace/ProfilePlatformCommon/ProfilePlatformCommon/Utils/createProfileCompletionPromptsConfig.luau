local Parent = script:FindFirstAncestor("ProfilePlatformCommon").Parent
local PromptsEntryPoint = require(Parent.ServerTriggeredModals).PromptsEntryPoint
local SduiLoadTimer = require(Parent.SduiSharedUtilities).SduiLoadTimer
local AppPage = require(Parent.RobloxAppEnums).AppPage
local FFlagSduiAllowNoConfigsBuilt = require(Parent.SharedFlags).FFlagSduiAllowNoConfigsBuilt
local v6 = game:DefineFastFlag("ProfileCompletionUsePlatformSurfaceKey", false)

return function() -- line: 18
	-- upvalues: SduiLoadTimer (copy), PromptsEntryPoint (copy), v6 (copy), AppPage (copy), FFlagSduiAllowNoConfigsBuilt (copy)
	local v7 = SduiLoadTimer.createLoadTimer("ProfileCompletion")

	return {
		configKey = "ProfileCompletion",
		clearOnEmptyResponse = true,
		entryPoint = PromptsEntryPoint.SelfUserProfileOpen,
		surfaceKey = not v6 and "ProfileCompletion" or AppPage.ProfilePlatform,
		allowNoConfigsBuilt = not not FFlagSduiAllowNoConfigsBuilt or nil,
		loadTimer = v7
	}
end
