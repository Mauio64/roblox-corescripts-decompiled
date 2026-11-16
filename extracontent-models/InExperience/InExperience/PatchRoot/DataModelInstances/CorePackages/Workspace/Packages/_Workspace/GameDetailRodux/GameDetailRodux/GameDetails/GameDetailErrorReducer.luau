local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local parent = GameDetailRodux.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local AddGameDetails = require(GameDetailRodux.GameDetails.AddGameDetails)
local SetGameDetailError = require(GameDetailRodux.GameDetails.SetGameDetailError)

return function(options, data)
	options = options or {}

	if data.type == SetGameDetailError.name then
		return (Immutable.Set(options, data.universeId, { errorType = data.errorType }))
	end

	if not (data.type == AddGameDetails.name and next(options)) then
		return options
	end

	for k, _ in pairs(data.gameDetails) do
		if options[k] then
			options = Immutable.RemoveFromDictionary(options, k)
		end
	end

	return options
end
