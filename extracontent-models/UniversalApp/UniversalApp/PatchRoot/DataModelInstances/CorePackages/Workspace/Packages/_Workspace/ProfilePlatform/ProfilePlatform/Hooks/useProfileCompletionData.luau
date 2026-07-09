local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local SignalsReact = require(ProfilePlatformParent.SignalsReact)
local SduiSharedUtilities = require(ProfilePlatformParent.SduiSharedUtilities)

require(ProfilePlatformParent.SduiCoreSystem)

local Enums = require(ProfilePlatform.Common.Enums)
local createProfileCompletionPromptsConfig = require(ProfilePlatformParent.ProfilePlatformCommon).Utils.createProfileCompletionPromptsConfig
local ServerTriggeredModals = require(ProfilePlatformParent.ServerTriggeredModals)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local fetchPrompts = ServerTriggeredModals.fetchPrompts

local function useProfileCompletionData() -- line: 26
	-- upvalues: React (copy), createProfileCompletionPromptsConfig (copy), fetchPrompts (copy), getSduiApiStore (copy), Enums (copy), SignalsReact (copy)
	local v12 = React.useMemo(function() -- line: 27
		-- upvalues: createProfileCompletionPromptsConfig (copy)
		return createProfileCompletionPromptsConfig()
	end, {})

	React.useEffect(function() -- line: 31
		-- upvalues: fetchPrompts (copy), v12 (copy)
		fetchPrompts(v12, true)
	end, { v12 })

	local v13 = React.useCallback(function() -- line: 35
		-- upvalues: fetchPrompts (copy), createProfileCompletionPromptsConfig (copy)
		fetchPrompts(createProfileCompletionPromptsConfig(), true)
	end, {})
	local v14 = React.useCallback(function(p1) -- line: 39
		-- upvalues: getSduiApiStore (copy), Enums (copy)
		return (getSduiApiStore().getRootConfig(Enums.Components.ProfileCompletion, p1))
	end, {})

	return SignalsReact.useSignalState(v14), v13
end

return useProfileCompletionData
