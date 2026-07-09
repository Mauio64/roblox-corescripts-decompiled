local Parent = script:FindFirstAncestor("DiscoveryTestHelpers").Parent
local Promise = require(Parent.Promise)

local function checkAction(p1, p2: ((...any) -> ...any)) -- line: 5
	if not p1 then
		return
	end

	if typeof(p1) == "function" then
		p2(p1())

		return
	end

	if typeof(p1) == "table" then
		if p1.tap and typeof(p1.tap) == "function" then
			p1:tap(p2)

			return
		end

		p2(p1)

		return
	end

	p2(p1)
end
local function makeActionCheckMiddleware(p3: ((...any) -> ...any), b1: boolean?) -- line: 25
	-- upvalues: Promise (copy), checkAction (copy)
	return function(p4, p5) -- line: 26
		-- upvalues: b1 (copy), Promise (copy), checkAction (copy), p3 (copy)
		return function(p6) -- line: 27
			-- upvalues: b1 (copy), Promise (copy), p5 (copy), checkAction (copy), p3 (copy), p4 (copy)
			if typeof(p6) == "function" then
				if b1 then
					return Promise.resolve()
				end

				local v12 = p6(p5)

				checkAction(v12, p3)

				return v12
			end

			checkAction(p6, p3)

			return p4(p6)
		end
	end
end

return makeActionCheckMiddleware
