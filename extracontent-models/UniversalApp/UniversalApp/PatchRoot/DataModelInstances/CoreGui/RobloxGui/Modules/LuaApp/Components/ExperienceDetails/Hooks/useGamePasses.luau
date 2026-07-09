local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local DataStatus = DataHydration.DataStatus

local function useGamePasses(s1: string) -- line: 11
	-- upvalues: DataHydration (copy), React (copy), DataStatus (copy), SignalsReact (copy)
	local v8 = DataHydration.Game.getGamePassStore(false)
	local v9 = React.useCallback(function(p1) -- line: 13
		-- upvalues: v8 (copy), s1 (copy), DataStatus (copy)
		local v11 = v8.getPassesForUniverse(s1)

		if v11.status(p1) == DataStatus.NotReady then
			return nil
		end

		local v12 = v11.data(p1)

		if v12 == nil then
			return nil
		end

		local t1 = {}

		for _, v15 in v12 do
			local v16 = v8.getGamePassInfo(v15).data(p1)

			if v16 then
				table.insert(t1, v16)
			end
		end

		return t1
	end, {
		v8,
		s1
	})

	return SignalsReact.useSignalState(v9)
end

return useGamePasses
