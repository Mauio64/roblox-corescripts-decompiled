local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local DataHydration = require(InExperienceSideSheetParent.DataHydration)
local React = require(InExperienceSideSheetParent.React)
local Signals = require(InExperienceSideSheetParent.Signals)
local SignalsReact = require(InExperienceSideSheetParent.SignalsReact)
local getUniverseId = require(InExperienceSideSheet.Utils.getUniverseId)

local function useExperienceName() -- line: 11
	-- upvalues: getUniverseId (copy), React (copy), Signals (copy), DataHydration (copy), SignalsReact (copy)
	local v9 = getUniverseId()
	local v10 = React.useMemo(function() -- line: 14
		-- upvalues: Signals (copy), v9 (copy), DataHydration (copy)
		return Signals.createComputed(function(p1) -- line: 15
			-- upvalues: v9 (copy), DataHydration (copy)
			if v9 then
				return DataHydration.Game.getGameInfoStore(p1).getAndFetchGameInfo(v9).data(p1)
			end

			return nil
		end)
	end, { v9 })
	local v11 = SignalsReact.useSignalState(v10)

	if v11 then
		return v11.name
	end

	return nil
end

return useExperienceName
