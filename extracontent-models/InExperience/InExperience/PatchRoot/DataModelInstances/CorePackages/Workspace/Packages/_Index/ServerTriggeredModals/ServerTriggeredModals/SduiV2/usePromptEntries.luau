local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)

require(script.Parent.PromptStyle)
require(script.Parent.Types.PromptEntry)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

local function usePromptEntries(p: string, p2)
	local v = SignalsReact.useSignalState(getSduiApiStore().getData(p).data)

	return React.useMemo(function()
		local result = {}

		if not v then
			return result
		end

		for _, v2 in v do
			local category = v2.category

			if p2 == nil or category == p2 then
				table.insert(result, {
					identifier = v2.identifier,
					robloxComponentType = v2.robloxComponentType,
					title = v2.title,
					promptStyle = category,
					config = v2.config
				})
			end
		end

		return result
	end, { v, p2 })
end

return usePromptEntries
