require(script.Parent.types)

local function once(p1) -- line: 5
	local u4 = false

	local function notAgain() -- line: 7
		-- upvalues: u4 (ref), p1 (copy)
		if not u4 then
			u4 = true
			p1()
		end
	end

	return notAgain
end
local function createCachedResource(p2) -- line: 16
	local u7 = nil
	local u8 = nil
	local n1 = 0

	local function disposeResource() -- line: 21
		-- upvalues: n1 (ref), u7 (ref), u8 (ref)
		n1 -= 1

		if n1 == 0 then
			u7 = nil

			if u8 ~= nil then
				local v14 = u8

				u8 = nil
				v14()
			end
		end
	end
	local function constructResource() -- line: 33
		-- upvalues: u8 (ref), u7 (ref), p2 (copy)
		local v15, v16 = p2()

		u8 = v15
		u7 = v16
	end
	local function handleError(b1: boolean, ...) -- line: 37
		-- upvalues: n1 (ref), u7 (ref), u8 (ref)
		if not b1 then
			n1 -= 1

			if n1 == 0 then
				u7 = nil

				if u8 ~= nil then
					local v18 = u8

					u8 = nil
					v18()
				end
			end

			error(...)
		end
	end
	local function cachedResource() -- line: 44
		-- upvalues: n1 (ref), handleError (copy), constructResource (copy), disposeResource (copy), u7 (ref)
		n1 += 1

		if n1 == 1 then
			handleError(pcall(constructResource))
		end

		local v19 = disposeResource
		local u20 = false

		local function notAgain() -- line: 7
			-- upvalues: u20 (ref), v19 (copy)
			if not u20 then
				u20 = true
				v19()
			end
		end

		return notAgain, u7
	end

	return cachedResource
end

return createCachedResource
