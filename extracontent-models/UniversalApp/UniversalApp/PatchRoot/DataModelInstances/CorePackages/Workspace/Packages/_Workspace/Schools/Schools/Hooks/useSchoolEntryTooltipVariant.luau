local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local useSignalState = require(SchoolsParent.SignalsReact).useSignalState
local Constants = require(Schools.Common.Constants)
local Enums = require(Schools.Common.Enums)
local SchoolEntryStatus = require(Schools.Store.SchoolEntryStatus)
local SchoolEntryTooltipStorage = require(Schools.Common.SchoolEntryTooltipStorage)
local SchoolEntryTooltipVariant = Enums.SchoolEntryTooltipVariant
local isShown = SchoolEntryTooltipStorage.isShown
local markShown = SchoolEntryTooltipStorage.markShown

local function useSchoolEntryTooltipVariant() -- line: 18
	-- upvalues: useSignalState (copy), SchoolEntryStatus (copy), React (copy), isShown (copy), Constants (copy), SchoolEntryTooltipVariant (copy), markShown (copy)
	local v13 = useSignalState(SchoolEntryStatus.getVerifiedSignal())
	local v14 = useSignalState(SchoolEntryStatus.getIsLiveSignal())
	local v15, v16 = React.useState(function() -- line: 22
		-- upvalues: isShown (copy), Constants (copy)
		return isShown(Constants.FeatureAvailable.APP_STORAGE_KEY)
	end)
	local v17, v18 = React.useState(function() -- line: 25
		-- upvalues: isShown (copy), Constants (copy)
		return isShown(Constants.SchoolIsLive.APP_STORAGE_KEY)
	end)
	local v19 = if not v13 or (not v14 or v17) then if v13 or v15 then nil else SchoolEntryTooltipVariant.FeatureAvailable else SchoolEntryTooltipVariant.SchoolIsLive
	local v20 = React.useRef(v19)

	React.useLayoutEffect(function() -- line: 37
		-- upvalues: v20 (copy), v19 (copy)
		v20.current = v19
	end, { v19 })

	return v19, (React.useCallback(function() -- line: 41
		-- upvalues: v20 (copy), SchoolEntryTooltipVariant (copy), v16 (copy), markShown (copy), Constants (copy), v18 (copy)
		local current = v20.current

		if current == SchoolEntryTooltipVariant.FeatureAvailable then
			v16(true)
			markShown(Constants.FeatureAvailable.APP_STORAGE_KEY)

			return
		end

		if current == SchoolEntryTooltipVariant.SchoolIsLive then
			v18(true)
			markShown(Constants.SchoolIsLive.APP_STORAGE_KEY)
		end
	end, {}))
end

return useSchoolEntryTooltipVariant
