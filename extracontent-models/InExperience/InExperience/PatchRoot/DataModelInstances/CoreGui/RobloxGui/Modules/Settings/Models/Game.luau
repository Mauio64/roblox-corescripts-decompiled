local t1 = {
	new = function() -- line: 16
		return {}
	end
}

function t1.fromGameCache(p1) -- line: 21
	-- upvalues: t1 (copy)
	local v3 = t1.new()

	v3.universeId = p1.UniverseId
	v3.placeId = p1.PlaceId
	v3.name = p1.Name
	v3.playerCount = p1.PlayerCount
	v3.imageToken = p1.ImageToken
	v3.totalUpVotes = p1.VoteData.UpVotes
	v3.totalDownVotes = p1.VoteData.DownVotes

	return v3
end
function t1.fromJsonData(p2) -- line: 33
	-- upvalues: t1 (copy)
	local v5 = t1.new()

	v5.universeId = p2.universeId
	v5.placeId = p2.placeId
	v5.name = p2.name
	v5.playerCount = p2.playerCount
	v5.imageToken = p2.imageToken
	v5.totalUpVotes = p2.totalUpVotes
	v5.totalDownVotes = p2.totalDownVotes

	return v5
end

return t1
