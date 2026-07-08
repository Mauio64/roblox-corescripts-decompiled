local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Number = LuauPolyfill.Number
local String = LuauPolyfill.String
local isNaN = Number.isNaN
local u6 = nil
local n1 = nil

n1 = 48

local n2 = 57

function u6(n3: number) -- line: 71
	-- upvalues: isNaN (copy), n1 (ref), n2 (ref)
	return not isNaN(n3) and (n3 >= n1 and n3 <= n2)
end

return {
	naturalCompare = function(s1: string, s2: string) -- line: 23
		-- upvalues: String (copy), u6 (ref), n1 (ref)
		local n4 = 1
		local n5 = 1

		while n4 <= #s1 and n5 <= #s2 do
			local v13 = String.charCodeAt(s1, n4)
			local v14 = String.charCodeAt(s2, n5)

			if u6(v13) and u6(v14) then
				local n6 = 0

				repeat
					n4 += 1
					n6 = n6 * 10 + v13 - n1
					v13 = String.charCodeAt(s1, n4)
				until not u6(v13) or not (n6 > 0)

				local n7 = 0

				repeat
					n5 += 1
					n7 = n7 * 10 + v14 - n1
					v14 = String.charCodeAt(s2, n5)
				until not u6(v14) or not (n7 > 0)

				if n6 < n7 then
					return -1
				end

				if not (n7 < n6) then
					continue
				end

				return 1
			end

			if v13 < v14 then
				return -1
			end

			if v14 < v13 then
				return 1
			end

			n4 += 1
			n5 += 1
		end

		return #s1 - #s2
	end
}
