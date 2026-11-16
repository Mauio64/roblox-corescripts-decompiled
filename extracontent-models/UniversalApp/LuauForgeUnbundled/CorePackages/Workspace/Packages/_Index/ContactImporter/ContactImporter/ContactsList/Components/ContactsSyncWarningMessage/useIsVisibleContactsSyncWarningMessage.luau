local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/React")

local ContactsSyncWarningCache = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsSyncWarningMessage/ContactsSyncWarningCache")
local defineFastInt = game:DefineFastInt("ContactsSyncWarningImpressionsCountCap", 1)

local function isMessageHiddenInitState(): boolean
	local v5 = ContactsSyncWarningCache.getValue() or 0
	return v5 < 0 or defineFastInt <= v5
end

local function useIsVisibleContactsSyncWarningMessage(): boolean
	local v5 = React.useState(isMessageHiddenInitState)

	React.useEffect(function()
		if not v5 then
			ContactsSyncWarningCache.incrementValue()
		end
	end, { v5 })

	return not v5
end

return useIsVisibleContactsSyncWarningMessage
