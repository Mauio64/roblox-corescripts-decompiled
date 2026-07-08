local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local _ = require(ParentParent.jsutils.invariant).invariant
local GraphQLSchema = require(ParentParent.type.schema).GraphQLSchema
local GraphQLString = require(ParentParent.type.scalars).GraphQLString
local definition = require(ParentParent.type.definition)
local GraphQLList = definition.GraphQLList
local GraphQLNonNull = definition.GraphQLNonNull
local GraphQLEnumType = definition.GraphQLEnumType
local GraphQLInterfaceType = definition.GraphQLInterfaceType
local GraphQLObjectType = definition.GraphQLObjectType
local starWarsData = require(script.Parent.starWarsData)
local getFriends = starWarsData.getFriends
local getHero = starWarsData.getHero
local getHuman = starWarsData.getHuman
local getDroid = starWarsData.getDroid
local u20 = nil
local u21 = nil
local u22 = nil
local v23 = GraphQLEnumType.new({
	name = "Episode",
	description = "One of the films in the Star Wars Trilogy",
	values = Map.new({
		{
			"NEW_HOPE",
			{
				value = 4,
				description = "Released in 1977."
			}
		},
		{
			"EMPIRE",
			{
				value = 5,
				description = "Released in 1980."
			}
		},
		{
			"JEDI",
			{
				value = 6,
				description = "Released in 1983."
			}
		}
	})
})

u20 = GraphQLInterfaceType.new({
	name = "Character",
	description = "A character in the Star Wars Trilogy",
	fields = function() -- line: 127
		-- upvalues: Map (copy), GraphQLNonNull (copy), GraphQLString (copy), GraphQLList (copy), u20 (ref), v23 (copy)
		return Map.new({
			{
				"id",
				{
					description = "The id of the character.",
					type = GraphQLNonNull.new(GraphQLString)
				}
			},
			{
				"name",
				{
					description = "The name of the character.",
					type = GraphQLString
				}
			},
			{
				"friends",
				{
					description = "The friends of the character, or an empty list if they have none.",
					type = GraphQLList.new(u20)
				}
			},
			{
				"appearsIn",
				{
					description = "Which movies they appear in.",
					type = GraphQLList.new(v23)
				}
			},
			{
				"secretBackstory",
				{
					description = "All secrets about their past.",
					type = GraphQLString
				}
			}
		})
	end,
	resolveType = function(p1) -- line: 166
		-- upvalues: u21 (ref), u22 (ref)
		if p1.type == "Human" then
			return u21.name
		end

		if p1.type == "Droid" then
			return u22.name
		end

		assert(false)
	end
})
u21 = GraphQLObjectType.new({
	name = "Human",
	description = "A humanoid creature in the Star Wars universe.",
	fields = function() -- line: 195
		-- upvalues: Map (copy), GraphQLNonNull (copy), GraphQLString (copy), GraphQLList (copy), u20 (ref), getFriends (copy), v23 (copy), Error (copy)
		return Map.new({
			{
				"id",
				{
					description = "The id of the human.",
					type = GraphQLNonNull.new(GraphQLString)
				}
			},
			{
				"name",
				{
					description = "The name of the human.",
					type = GraphQLString
				}
			},
			{
				"friends",
				{
					description = "The friends of the human, or an empty list if they have none.",
					type = GraphQLList.new(u20),
					resolve = function(p2) -- line: 216
						-- upvalues: getFriends (copy)
						return getFriends(p2)
					end
				}
			},
			{
				"appearsIn",
				{
					description = "Which movies they appear in.",
					type = GraphQLList.new(v23)
				}
			},
			{
				"homePlanet",
				{
					description = "The home planet of the human, or null if unknown.",
					type = GraphQLString
				}
			},
			{
				"secretBackstory",
				{
					description = "Where are they from and how they came to be who they are.",
					type = GraphQLString,
					resolve = function() -- line: 240
						-- upvalues: Error (copy)
						error(Error("secretBackstory is secret."))
					end
				}
			}
		})
	end,
	interfaces = { u20 }
})
u22 = GraphQLObjectType.new({
	name = "Droid",
	description = "A mechanical creature in the Star Wars universe.",
	fields = function() -- line: 266
		-- upvalues: Map (copy), GraphQLNonNull (copy), GraphQLString (copy), GraphQLList (copy), u20 (ref), getFriends (copy), v23 (copy), Error (copy)
		return Map.new({
			{
				"id",
				{
					description = "The id of the droid.",
					type = GraphQLNonNull.new(GraphQLString)
				}
			},
			{
				"name",
				{
					description = "The name of the droid.",
					type = GraphQLString
				}
			},
			{
				"friends",
				{
					description = "The friends of the droid, or an empty list if they have none.",
					type = GraphQLList.new(u20),
					resolve = function(p3) -- line: 287
						-- upvalues: getFriends (copy)
						return getFriends(p3)
					end
				}
			},
			{
				"appearsIn",
				{
					description = "Which movies they appear in.",
					type = GraphQLList.new(v23)
				}
			},
			{
				"secretBackstory",
				{
					description = "Construction date and the name of the designer.",
					type = GraphQLString,
					resolve = function() -- line: 304
						-- upvalues: Error (copy)
						error(Error("secretBackstory is secret."))
					end
				}
			},
			{
				"primaryFunction",
				{
					description = "The primary function of the droid.",
					type = GraphQLString
				}
			}
		})
	end,
	interfaces = { u20 }
})

local v24 = GraphQLObjectType.new({
	name = "Query",
	fields = function() -- line: 337
		-- upvalues: Map (copy), u20 (ref), v23 (copy), getHero (copy), u21 (ref), GraphQLNonNull (copy), GraphQLString (copy), getHuman (copy), u22 (ref), getDroid (copy)
		return Map.new({
			{
				"hero",
				{
					type = u20,
					args = {
						episode = {
							description = "If omitted, returns the hero of the whole saga. If provided, returns the hero of that particular episode.",
							type = v23
						}
					},
					resolve = function(_, p5) -- line: 349
						-- upvalues: getHero (copy)
						return getHero(p5.episode)
					end
				}
			},
			{
				"human",
				{
					type = u21,
					args = {
						id = {
							description = "id of the human",
							type = GraphQLNonNull.new(GraphQLString)
						}
					},
					resolve = function(_, p7) -- line: 364
						-- upvalues: getHuman (copy)
						return getHuman(p7.id)
					end
				}
			},
			{
				"droid",
				{
					type = u22,
					args = {
						id = {
							description = "id of the droid",
							type = GraphQLNonNull.new(GraphQLString)
						}
					},
					resolve = function(_, p9) -- line: 379
						-- upvalues: getDroid (copy)
						return getDroid(p9.id)
					end
				}
			}
		})
	end
})

return {
	StarWarsSchema = GraphQLSchema.new({
		query = v24,
		types = {
			u21,
			u22
		}
	})
}
