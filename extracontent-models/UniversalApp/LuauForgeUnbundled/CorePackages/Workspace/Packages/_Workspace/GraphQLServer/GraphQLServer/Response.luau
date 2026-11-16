local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local err = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill").Error

local stringify = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").stringify

local class = {}
class.__index = class

function class.new(p2)
	local v5 = { body = p2 }

	setmetatable(v5, class)
	return v5
end

function class.text(p2)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			if p2.body.errors then
				for k, err2 in p2.body.errors do
					if type(err2) == "table" and err2.name == "GraphQLError" then
						p2.body.errors[k] = {
							message = err2.message,
							locations = err2.locations,
							extensions = err2.extensions,
							path = err2.path
						}
					end
				end
			end

			return stringify(p2.body)
		end)

		if success then
			callback(result)
		else
			callback2(err.new(result))
		end
	end)
end

return class
