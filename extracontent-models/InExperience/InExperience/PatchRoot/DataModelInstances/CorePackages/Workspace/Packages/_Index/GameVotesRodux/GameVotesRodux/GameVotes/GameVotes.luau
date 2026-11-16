local GameVotesRodux = script:FindFirstAncestor("GameVotesRodux")
local parent = GameVotesRodux.Parent
local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local SetGameVotes = require(GameVotesRodux.GameVotes.SetGameVotes)

return function(options, data)
	options = options or {}
	assert(options, "")

	if data.type == SetGameVotes.name then
		local v = { upVotes = data.upVotes, downVotes = data.downVotes }

		options = Immutable.Set(options, data.universeId, v)
	end

	return options
end
