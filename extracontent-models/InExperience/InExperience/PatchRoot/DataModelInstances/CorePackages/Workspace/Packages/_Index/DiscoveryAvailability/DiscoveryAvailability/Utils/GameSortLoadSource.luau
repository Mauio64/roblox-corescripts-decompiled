local v = {}
local GameSortLoadSource = {}
GameSortLoadSource.GameSortLoadSourceType = {
	API = "API",
	ClientFallbackCache = "ClientFallbackCache"
}

function GameSortLoadSource.setSortLoadSource(p: string, p2: string?)
	if p2 then
		v[p] = p2
	else
		v[p] = nil
	end
end

function GameSortLoadSource.getSortLoadSource(p: string)
	return v[p]
end

return GameSortLoadSource
