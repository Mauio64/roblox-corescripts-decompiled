local parent = script.Parent.Parent.Parent

local Promise = require(parent.Promise)

function createFetch(callback)
	local function fetch(p, p2)
		local v = p2 == nil and {} or p2

		local method = v.method or "GET"
		v.method = nil
		v.data = v.body
		v.body = nil
		return callback(method, p, v):andThen(function(state)
			local text = state.text
			function state.text()
				return Promise.resolve(text)
			end

			state.status = state.code
			return state
		end)
	end

	return fetch
end

return createFetch
