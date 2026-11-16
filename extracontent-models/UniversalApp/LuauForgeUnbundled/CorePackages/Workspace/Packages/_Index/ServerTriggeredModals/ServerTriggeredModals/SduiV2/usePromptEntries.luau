local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SignalsReact")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities")

require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptStyle")
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

local function usePromptEntries(p2, p3)
	local v5 = SignalsReact.useSignalState(getSduiApiStore().getData(p2).data)

	return React.useMemo(function()
		local result = {}

		if not v5 then
			return result
		end

		for k, v6 in v5 do
			local category = v6.category

			if p3 == nil or category == p3 then
				table.insert(result, {
					identifier = v6.identifier,
					robloxComponentType = v6.robloxComponentType,
					title = v6.title,
					promptStyle = category,
					config = v6.config
				})
			end
		end

		return result
	end, { v5, p3 })
end

return usePromptEntries
