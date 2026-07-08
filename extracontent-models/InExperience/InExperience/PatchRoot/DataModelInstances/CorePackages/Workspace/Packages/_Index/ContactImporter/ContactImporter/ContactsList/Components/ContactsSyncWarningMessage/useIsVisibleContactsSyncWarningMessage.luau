local Parent = script:FindFirstAncestor("ContactImporter").Parent
local React = require(Parent.React)
local ContactsSyncWarningCache = require(script.Parent.ContactsSyncWarningCache)
local v4 = game:DefineFastInt("ContactsSyncWarningImpressionsCountCap", 1)

local function isMessageHiddenInitState() -- line: 9
	-- upvalues: ContactsSyncWarningCache (copy), v4 (copy)
	local v7 = ContactsSyncWarningCache.getValue() or 0

	return v7 < 0 or v7 >= v4
end
local function useIsVisibleContactsSyncWarningMessage() -- line: 14
	-- upvalues: React (copy), isMessageHiddenInitState (copy), ContactsSyncWarningCache (copy)
	local v8 = React.useState(isMessageHiddenInitState)

	React.useEffect(function() -- line: 18
		-- upvalues: v8 (copy), ContactsSyncWarningCache (copy)
		if not v8 then
			ContactsSyncWarningCache.incrementValue()
		end
	end, { v8 })

	return not v8
end

return useIsVisibleContactsSyncWarningMessage
