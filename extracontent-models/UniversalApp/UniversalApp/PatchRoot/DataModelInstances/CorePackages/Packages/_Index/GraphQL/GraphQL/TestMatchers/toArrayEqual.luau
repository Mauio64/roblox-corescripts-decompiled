local deepEqual = require(script.Parent.Parent.luaUtils.deepEqual)
local deepContains = require(script.Parent.Parent.luaUtils.deepContains)

local function toArrayEqual(p1, p2, p3) -- line: 18
	-- upvalues: deepContains (copy), deepEqual (copy)
	if #p1 ~= #p2 then
		return {
			pass = false,
			message = ("Expected array length %s / got length %s"):format(tostring(#p1), (tostring(#p2)))
		}
	end

	local g8 = nil
	local v10 = nil
	local g11 = nil

	for i = 1, #p1 do
		repeat
			if g8 or not p3 then
				if not g8 then
					local v9

					v9, v10 = deepEqual(p1[i], p2[i])

					if v9 then
						g11 = true

						break
					end
				end

				g8 = false

				local v12 = v10:gsub("{1}", ("{1}[%s]"):format((tostring(i)))):gsub("{2}", ("{2}[%s]"):format((tostring(i))))

				return {
					pass = false,
					message = v12
				}
			end

			local v13

			v13, v10 = deepContains(p1[i], p2[i])

			if not v13 then
				g8 = true
			end
		until not g8

		if g11 then
			g11 = false

			continue
		end
	end

	return {
		pass = true,
		message = ""
	}
end

return toArrayEqual
