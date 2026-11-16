local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
require(parent.SduiCoreSystem)
local Enums = require(ProfilePlatform.Common.Enums)

local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local createProfileCompletionPromptsConfig = ProfilePlatformCommon.Utils.createProfileCompletionPromptsConfig

local ServerTriggeredModals = require(parent.ServerTriggeredModals)

local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local fetchPrompts = ServerTriggeredModals.fetchPrompts

local function useProfileCompletionData()
	local v = React.useMemo(function()
		return createProfileCompletionPromptsConfig()
	end, {})

	React.useEffect(function()
		fetchPrompts(v, true)
	end, { v })

	local v2 = React.useCallback(function()
		fetchPrompts(createProfileCompletionPromptsConfig(), true)
	end, {})

	local v3 = React.useCallback(function(p)
		local data = getSduiApiStore().getData(Enums.Components.ProfileCompletion).data(p)

		if not data then
			return nil
		end

		local config = nil
		local v3 = 0

		for _, v4 in data do
			if not (v4 and v4.config) then
				continue
			end

			local dataUpdatedTimestamp = v4.dataUpdatedTimestamp or 0

			if not (not config or v3 < dataUpdatedTimestamp) then
				continue
			end

			config = v4.config
			v3 = dataUpdatedTimestamp
		end

		return config
	end, {})

	return SignalsReact.useSignalState(v3), v2
end

return useProfileCompletionData
