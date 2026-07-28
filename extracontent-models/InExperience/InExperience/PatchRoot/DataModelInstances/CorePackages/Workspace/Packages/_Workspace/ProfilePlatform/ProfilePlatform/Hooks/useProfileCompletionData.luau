local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local SignalsReact = require(ProfilePlatformParent.SignalsReact)
local SduiSharedUtilities = require(ProfilePlatformParent.SduiSharedUtilities)

require(ProfilePlatformParent.SduiCoreSystem)

local Enums = require(ProfilePlatform.Common.Enums)
local createProfileCompletionPromptsConfig = require(ProfilePlatformParent.ProfilePlatformCommon).Utils.createProfileCompletionPromptsConfig
local ServerTriggeredModals = require(ProfilePlatformParent.ServerTriggeredModals)
local v9 = game:DefineFastFlag("ProfileCompletionResolveLatestSduiEntry", false)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local fetchPrompts = ServerTriggeredModals.fetchPrompts

local function useProfileCompletionData() -- line: 29
	-- upvalues: React (copy), createProfileCompletionPromptsConfig (copy), fetchPrompts (copy), v9 (copy), getSduiApiStore (copy), Enums (copy), SignalsReact (copy)
	local v13 = React.useMemo(function() -- line: 30
		-- upvalues: createProfileCompletionPromptsConfig (copy)
		return createProfileCompletionPromptsConfig()
	end, {})

	React.useEffect(function() -- line: 34
		-- upvalues: fetchPrompts (copy), v13 (copy)
		fetchPrompts(v13, true)
	end, { v13 })

	local v14 = React.useCallback(function() -- line: 38
		-- upvalues: fetchPrompts (copy), createProfileCompletionPromptsConfig (copy)
		fetchPrompts(createProfileCompletionPromptsConfig(), true)
	end, {})
	local v15 = React.useCallback(function(p1) -- line: 42
		-- upvalues: v9 (copy), getSduiApiStore (copy), Enums (copy)
		if v9 then
			local v17 = getSduiApiStore().getData(Enums.Components.ProfileCompletion).data(p1)

			if not v17 then
				return nil
			end

			local config = nil
			local n1 = 0

			for _, v21 in v17 do
				if v21 and v21.config then
					local v22 = v21.dataUpdatedTimestamp or 0

					if not config or n1 < v22 then
						config = v21.config
						n1 = v22
					end
				end
			end

			return config
		end

		return (getSduiApiStore().getRootConfig(Enums.Components.ProfileCompletion, p1))
	end, {})

	return SignalsReact.useSignalState(v15), v14
end

return useProfileCompletionData
