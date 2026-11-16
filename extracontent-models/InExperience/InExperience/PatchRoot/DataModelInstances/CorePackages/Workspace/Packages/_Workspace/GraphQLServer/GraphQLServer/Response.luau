local parent = script:FindFirstAncestor("GraphQLServer").Parent
local Promise = require(parent.Promise)
local LuauPolyfill = require(parent.LuauPolyfill)
local Error = LuauPolyfill.Error

local GraphQL = require(parent.GraphQL)
local stringify = GraphQL.stringify

local Response = {}
Response.__index = Response

function Response.new(body)
	local v = { body = body }

	setmetatable(v, Response)
	return v
end

function Response.text(p)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			if p.body.errors then
				for k, err in p.body.errors do
					if type(err) == "table" and err.name == "GraphQLError" then
						p.body.errors[k] = {
							message = err.message,
							locations = err.locations,
							extensions = err.extensions,
							path = err.path
						}
					end
				end
			end

			return stringify(p.body)
		end)

		if success then
			callback(result)
		else
			callback2(Error.new(result))
		end
	end)
end

return Response
