local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SduiSharedUtilities")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SduiCoreSystem")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local createProfileCompletionPromptsConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatformCommon").Utils.createProfileCompletionPromptsConfig

local ServerTriggeredModals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ServerTriggeredModals")

local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local fetchPrompts = ServerTriggeredModals.fetchPrompts

local function useProfileCompletionData()
	local v5 = React.useMemo(function()
		return createProfileCompletionPromptsConfig()
	end, {})

	React.useEffect(function()
		fetchPrompts(v5, true)
	end, { v5 })

	local v6 = React.useCallback(function()
		fetchPrompts(createProfileCompletionPromptsConfig(), true)
	end, {})

	local v7 = React.useCallback(function(p2)
		local data = getSduiApiStore().getData(Enums.Components.ProfileCompletion).data(p2)

		if not data then
			return nil
		end

		local config = nil
		local v8 = 0

		for k, v9 in data do
			if not (v9 and v9.config) then
				continue
			end

			local dataUpdatedTimestamp = v9.dataUpdatedTimestamp or 0

			if not (not config or v8 < dataUpdatedTimestamp) then
				continue
			end

			config = v9.config
			v8 = dataUpdatedTimestamp
		end

		return config
	end, {})

	return SignalsReact.useSignalState(v7), v6
end

return useProfileCompletionData
