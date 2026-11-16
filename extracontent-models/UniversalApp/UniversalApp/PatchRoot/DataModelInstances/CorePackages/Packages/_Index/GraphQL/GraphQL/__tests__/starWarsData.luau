local parent = script.Parent.Parent.Parent

require(parent.LuauPolyfill)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local Promise = require(parent.Promise)

local v = {
	type = "Human",
	id = "1000",
	name = "Luke Skywalker",
	friends = { "1002", "1003", "2000", "2001" },
	appearsIn = { 4, 5, 6 },
	homePlanet = "Tatooine"
}

local v2 = {
	type = "Human",
	id = "1001",
	name = "Darth Vader",
	friends = { "1004" },
	appearsIn = { 4, 5, 6 },
	homePlanet = "Tatooine"
}

local v3 = {
	type = "Human",
	id = "1002",
	name = "Han Solo",
	friends = { "1000", "1003", "2001" },
	appearsIn = { 4, 5, 6 }
}

local v4 = {
	type = "Human",
	id = "1003",
	name = "Leia Organa",
	friends = { "1000", "1002", "2000", "2001" },
	appearsIn = { 4, 5, 6 },
	homePlanet = "Alderaan"
}

local v5 = {
	type = "Human",
	id = "1004",
	name = "Wilhuff Tarkin",
	friends = { "1001" },
	appearsIn = { 4 }
}

local v6 = {
	[v.id] = v,
	[v2.id] = v2,
	[v3.id] = v3,
	[v4.id] = v4,
	[v5.id] = v5
}

local v7 = {
	type = "Droid",
	id = "2000",
	name = "C-3PO",
	friends = { "1000", "1002", "1003", "2001" },
	appearsIn = { 4, 5, 6 },
	primaryFunction = "Protocol"
}

local v8 = {
	type = "Droid",
	id = "2001",
	name = "R2-D2",
	friends = { "1000", "1002", "1003" },
	appearsIn = { 4, 5, 6 },
	primaryFunction = "Astromech"
}

local v9 = { [v7.id] = v7, [v8.id] = v8 }

local function getCharacter(p: string)
	return Promise.resolve(v6[p] or v9[p])
end

local StarWarsData = {}

function StarWarsData.getHuman(p: string)
	return v6[p]
end

StarWarsData.getCharacter = getCharacter

function StarWarsData.getDroid(p: string)
	return v9[p]
end

function StarWarsData.getFriends(p)
	return Array.map(p.friends, function(p2)
		return getCharacter(p2)
	end)
end

function StarWarsData.getHero(p: number)
	return if p == 5 then v else v8
end

return StarWarsData
