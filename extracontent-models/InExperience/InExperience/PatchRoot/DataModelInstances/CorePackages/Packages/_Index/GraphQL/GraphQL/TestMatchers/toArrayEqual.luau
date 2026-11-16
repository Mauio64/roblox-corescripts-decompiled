local deepEqual = require(script.Parent.Parent.luaUtils.deepEqual)
local deepContains = require(script.Parent.Parent.luaUtils.deepContains)

local function toArrayEqual(list, list2, p)
	if #list ~= #list2 then
		return {
			pass = false,
			message = ("Expected array length %s / got length %s"):format(tostring(#list), (tostring(#list2)))
		}
	end

	for i = 1, #list do
		local v

		if p then
			local v2
			v2, v = deepContains(list[i], list2[i])

			if v2 then
				continue
			end
		else
			local v2
			v2, v = deepEqual(list[i], list2[i])

			if v2 then
				continue
			end
		end

		return {
			pass = false,
			message = v:gsub("{1}", ("{1}[%s]"):format((tostring(i)))):gsub("{2}", ("{2}[%s]"):format((tostring(i))))
		}
	end

	return { pass = true, message = "" }
end

return toArrayEqual
