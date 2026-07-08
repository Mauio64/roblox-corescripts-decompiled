local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local Promise = require(Parent.Promise)
local Error = require(Parent.LuauPolyfill).Error
local stringify = require(Parent.GraphQL).stringify
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 19
	-- upvalues: t1 (copy)
	local t2 = {
		body = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.text(p2) -- line: 28
	-- upvalues: Promise (copy), stringify (copy), Error (copy)
	return Promise.new(function(resolve, reject) -- line: 29
		-- upvalues: p2 (copy), stringify (copy), Error (copy)
		local ok, result = pcall(function() -- line: 30
			-- upvalues: p2 (copy), stringify (copy)
			if p2.body.errors then
				for v13, v14 in p2.body.errors do
					if type(v14) == "table" and v14.name == "GraphQLError" then
						p2.body.errors[v13] = {
							message = v14.message,
							locations = v14.locations,
							extensions = v14.extensions,
							path = v14.path
						}
					end
				end
			end

			return stringify(p2.body)
		end)

		if ok then
			resolve(result)

			return
		end

		reject(Error.new(result))
	end)
end

return t1
