local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)

require(script.Parent.PromptStyle)

local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

local function usePromptEntries(s1: string, p1) -- line: 27
	-- upvalues: SignalsReact (copy), getSduiApiStore (copy), React (copy)
	local v9 = SignalsReact.useSignalState(getSduiApiStore().getData(s1).data)

	return React.useMemo(function() -- line: 30
		-- upvalues: v9 (copy), p1 (copy)
		local t1 = {}

		if not v9 then
			return t1
		end

		for _, v12 in v9 do
			local category = v12.category

			if p1 == nil or category == p1 then
				table.insert(t1, {
					identifier = v12.identifier,
					robloxComponentType = v12.robloxComponentType,
					title = v12.title,
					promptStyle = category,
					config = v12.config
				})
			end
		end

		return t1
	end, {
		v9,
		p1
	})
end

return usePromptEntries
