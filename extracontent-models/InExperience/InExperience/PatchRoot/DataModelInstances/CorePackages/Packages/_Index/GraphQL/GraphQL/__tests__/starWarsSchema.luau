local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map

local invariant = require(parent.jsutils.invariant)
invariant = invariant.invariant

local schema = require(parent.type.schema)
local graphQLSchema = schema.GraphQLSchema
local scalars = require(parent.type.scalars)
local graphQLString = scalars.GraphQLString
local definition = require(parent.type.definition)
local graphQLList = definition.GraphQLList
local graphQLNonNull = definition.GraphQLNonNull
local graphQLEnumType = definition.GraphQLEnumType
local graphQLInterfaceType = definition.GraphQLInterfaceType
local graphQLObjectType = definition.GraphQLObjectType

local starWarsData = require(script.Parent.starWarsData)
local getFriends = starWarsData.getFriends
local getHero = starWarsData.getHero
local getHuman = starWarsData.getHuman
local getDroid = starWarsData.getDroid

local v = nil
local v2 = nil
local v3 = nil

local v4 = graphQLEnumType.new({
	name = "Episode",
	description = "One of the films in the Star Wars Trilogy",
	values = Map.new({
		{
			"NEW_HOPE",
			{ value = 4, description = "Released in 1977." }
		},
		{
			"EMPIRE",
			{ value = 5, description = "Released in 1980." }
		},
		{
			"JEDI",
			{ value = 6, description = "Released in 1983." }
		}
	})
})

v = graphQLInterfaceType.new({
	name = "Character",
	description = "A character in the Star Wars Trilogy",
	fields = function()
		return Map.new({
			{
				"id",
				{
					type = graphQLNonNull.new(graphQLString),
					description = "The id of the character."
				}
			},
			{
				"name",
				{ type = graphQLString, description = "The name of the character." }
			},
			{
				"friends",
				{
					type = graphQLList.new(v),
					description = "The friends of the character, or an empty list if they have none."
				}
			},
			{
				"appearsIn",
				{ type = graphQLList.new(v4), description = "Which movies they appear in." }
			},
			{
				"secretBackstory",
				{ type = graphQLString, description = "All secrets about their past." }
			}
		})
	end,
	resolveType = function(p)
		if p.type == "Human" then
			return v2.name
		end

		if p.type == "Droid" then
			return v3.name
		end

		assert(false)
	end
})

v2 = graphQLObjectType.new({
	name = "Human",
	description = "A humanoid creature in the Star Wars universe.",
	fields = function()
		return Map.new({
			{
				"id",
				{
					type = graphQLNonNull.new(graphQLString),
					description = "The id of the human."
				}
			},
			{
				"name",
				{ type = graphQLString, description = "The name of the human." }
			},
			{
				"friends",
				{
					type = graphQLList.new(v),
					description = "The friends of the human, or an empty list if they have none.",
					resolve = function(p)
						return getFriends(p)
					end
				}
			},
			{
				"appearsIn",
				{ type = graphQLList.new(v4), description = "Which movies they appear in." }
			},
			{
				"homePlanet",
				{
					type = graphQLString,
					description = "The home planet of the human, or null if unknown."
				}
			},
			{
				"secretBackstory",
				{
					type = graphQLString,
					description = "Where are they from and how they came to be who they are.",
					resolve = function()
						error(Error("secretBackstory is secret."))
					end
				}
			}
		})
	end,
	interfaces = { v }
})

v3 = graphQLObjectType.new({
	name = "Droid",
	description = "A mechanical creature in the Star Wars universe.",
	fields = function()
		return Map.new({
			{
				"id",
				{
					type = graphQLNonNull.new(graphQLString),
					description = "The id of the droid."
				}
			},
			{
				"name",
				{ type = graphQLString, description = "The name of the droid." }
			},
			{
				"friends",
				{
					type = graphQLList.new(v),
					description = "The friends of the droid, or an empty list if they have none.",
					resolve = function(p)
						return getFriends(p)
					end
				}
			},
			{
				"appearsIn",
				{ type = graphQLList.new(v4), description = "Which movies they appear in." }
			},
			{
				"secretBackstory",
				{
					type = graphQLString,
					description = "Construction date and the name of the designer.",
					resolve = function()
						error(Error("secretBackstory is secret."))
					end
				}
			},
			{
				"primaryFunction",
				{ type = graphQLString, description = "The primary function of the droid." }
			}
		})
	end,
	interfaces = { v }
})

local query = graphQLObjectType.new({
	name = "Query",
	fields = function()
		return Map.new({
			{
				"hero",
				{
					type = v,
					args = {
						episode = {
							description = "If omitted, returns the hero of the whole saga. If provided, returns the hero of that particular episode.",
							type = v4
						}
					},
					resolve = function(_, p)
						return getHero(p.episode)
					end
				}
			},
			{
				"human",
				{
					type = v2,
					args = {
						id = {
							description = "id of the human",
							type = graphQLNonNull.new(graphQLString)
						}
					},
					resolve = function(_, p)
						return getHuman(p.id)
					end
				}
			},
			{
				"droid",
				{
					type = v3,
					args = {
						id = {
							description = "id of the droid",
							type = graphQLNonNull.new(graphQLString)
						}
					},
					resolve = function(_, p)
						return getDroid(p.id)
					end
				}
			}
		})
	end
})

return {
	StarWarsSchema = graphQLSchema.new({
		query = query,
		types = { v2, v3 }
	})
}
