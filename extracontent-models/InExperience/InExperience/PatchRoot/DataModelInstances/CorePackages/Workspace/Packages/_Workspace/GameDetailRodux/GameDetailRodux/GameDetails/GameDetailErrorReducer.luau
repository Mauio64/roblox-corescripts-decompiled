local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GameDetailRoduxParent = GameDetailRodux.Parent
local Immutable = require(GameDetailRoduxParent.AppCommonLib).Immutable
local AddGameDetails = require(GameDetailRodux.GameDetails.AddGameDetails)
local SetGameDetailError = require(GameDetailRodux.GameDetails.SetGameDetailError)

return function(p1, p2) -- line: 8
	-- upvalues: SetGameDetailError (copy), Immutable (copy), AddGameDetails (copy)
	local v8 = p1 or {}

	if p2.type == SetGameDetailError.name then
		return (Immutable.Set(v8, p2.universeId, {
			errorType = p2.errorType
		}))
	end

	if p2.type == AddGameDetails.name then
		if not next(v8) then
			return v8
		end

		for k, _ in pairs(p2.gameDetails) do
			if v8[k] then
				v8 = Immutable.RemoveFromDictionary(v8, k)
			end
		end
	end

	return v8
end
