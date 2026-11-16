local parent = script:FindFirstAncestor("ContactImporter").Parent

local React = require(parent.React)

local ContactsSyncWarningCache = require(script.Parent.ContactsSyncWarningCache)
local defineFastInt = game:DefineFastInt("ContactsSyncWarningImpressionsCountCap", 1)

local function isMessageHiddenInitState(): boolean
	local v = ContactsSyncWarningCache.getValue() or 0
	return v < 0 or defineFastInt <= v
end

local function useIsVisibleContactsSyncWarningMessage(): boolean
	local v = React.useState(isMessageHiddenInitState)

	React.useEffect(function()
		if not v then
			ContactsSyncWarningCache.incrementValue()
		end
	end, { v })

	return not v
end

return useIsVisibleContactsSyncWarningMessage
