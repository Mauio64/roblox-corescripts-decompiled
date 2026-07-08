local ParentParent = script.Parent.Parent.Parent
local Promise = require(ParentParent.Promise)

function createFetch(p1) -- line: 9
	-- upvalues: Promise (copy)
	local function fetch(p2, p3) -- line: 10
		-- upvalues: p1 (copy), Promise (copy)
		if p3 == nil then
			p3 = {}
		end

		local v7 = p3.method or "GET"

		p3.method = nil
		p3.data = p3.body
		p3.body = nil

		return p1(v7, p2, p3):andThen(function(p4) -- line: 19
			-- upvalues: Promise (copy)
			local text = p4.text

			function p4.text() -- line: 21
				-- upvalues: Promise (copy), text (copy)
				return Promise.resolve(text)
			end

			p4.status = p4.code

			return p4
		end)
	end

	return fetch
end

return createFetch
