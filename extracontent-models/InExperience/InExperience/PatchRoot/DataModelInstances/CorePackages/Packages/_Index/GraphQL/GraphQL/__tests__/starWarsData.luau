local ParentParent = script.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)

local Array = require(ParentParent.LuauPolyfill).Array
local Promise = require(ParentParent.Promise)
local t1 = {
	type = "Human",
	id = "1000",
	name = "Luke Skywalker",
	homePlanet = "Tatooine",
	friends = {
		"1002",
		"1003",
		"2000",
		"2001"
	},
	appearsIn = {
		4,
		5,
		6
	}
}
local t2 = {
	type = "Human",
	id = "1001",
	name = "Darth Vader",
	homePlanet = "Tatooine",
	friends = { "1004" },
	appearsIn = {
		4,
		5,
		6
	}
}
local t3 = {
	type = "Human",
	id = "1002",
	name = "Han Solo",
	friends = {
		"1000",
		"1003",
		"2001"
	},
	appearsIn = {
		4,
		5,
		6
	}
}
local t4 = {
	type = "Human",
	id = "1003",
	name = "Leia Organa",
	homePlanet = "Alderaan",
	friends = {
		"1000",
		"1002",
		"2000",
		"2001"
	},
	appearsIn = {
		4,
		5,
		6
	}
}
local t5 = {
	type = "Human",
	id = "1004",
	name = "Wilhuff Tarkin",
	friends = { "1001" },
	appearsIn = { 4 }
}
local t6 = {
	[t1.id] = t1,
	[t2.id] = t2,
	[t3.id] = t3,
	[t4.id] = t4,
	[t5.id] = t5
}
local t7 = {
	type = "Droid",
	id = "2000",
	name = "C-3PO",
	primaryFunction = "Protocol",
	friends = {
		"1000",
		"1002",
		"1003",
		"2001"
	},
	appearsIn = {
		4,
		5,
		6
	}
}
local t8 = {
	type = "Droid",
	id = "2001",
	name = "R2-D2",
	primaryFunction = "Astromech",
	friends = {
		"1000",
		"1002",
		"1003"
	},
	appearsIn = {
		4,
		5,
		6
	}
}
local t9 = {
	[t7.id] = t7,
	[t8.id] = t8
}

local function getCharacter(s1: string) -- line: 135
	-- upvalues: Promise (copy), t6 (copy), t9 (copy)
	return Promise.resolve(t6[s1] or t9[s1])
end

return {
	getHuman = function(s2: string) -- line: 165
		-- upvalues: t6 (copy)
		return t6[s2]
	end,
	getCharacter = getCharacter,
	getDroid = function(s3: string) -- line: 172
		-- upvalues: t9 (copy)
		return t9[s3]
	end,
	getFriends = function(t10: {[any]: any}) -- line: 143
		-- upvalues: Array (copy), getCharacter (copy)
		return Array.map(t10.friends, function(p1) -- line: 145
			-- upvalues: getCharacter (copy)
			return getCharacter(p1)
		end)
	end,
	getHero = function(n1: number) -- line: 153
		-- upvalues: t1 (copy), t8 (copy)
		if n1 == 5 then
			return t1
		end

		return t8
	end
}
