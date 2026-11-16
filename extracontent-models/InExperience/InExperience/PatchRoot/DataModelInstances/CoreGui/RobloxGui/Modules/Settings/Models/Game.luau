local Game = {}

function Game.new()
	return {}
end

function Game.fromGameCache(data)
	local v = Game.new()
	v.universeId = data.UniverseId
	v.placeId = data.PlaceId
	v.name = data.Name
	v.playerCount = data.PlayerCount
	v.imageToken = data.ImageToken
	v.totalUpVotes = data.VoteData.UpVotes
	v.totalDownVotes = data.VoteData.DownVotes
	return v
end

function Game.fromJsonData(data)
	local v = Game.new()
	v.universeId = data.universeId
	v.placeId = data.placeId
	v.name = data.name
	v.playerCount = data.playerCount
	v.imageToken = data.imageToken
	v.totalUpVotes = data.totalUpVotes
	v.totalDownVotes = data.totalDownVotes
	return v
end

return Game
