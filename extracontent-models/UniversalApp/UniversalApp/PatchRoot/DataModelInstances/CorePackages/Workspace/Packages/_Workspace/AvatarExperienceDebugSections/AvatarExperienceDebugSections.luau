local function v1() -- line: 16
end

local DevOnly = script:FindFirstChild("DevOnly")

if DevOnly == nil then
	return {
		register = function() -- line: 21
			-- upvalues: v1 (copy)
			return v1
		end
	}
end

local u3 = false
local u4 = nil

return {
	register = function() -- line: 30
		-- upvalues: u3 (ref), u4 (ref), v1 (copy), DevOnly (copy)
		if u3 then
			return u4 or v1
		end

		u3 = true

		local t1 = {}

		for _, child in DevOnly:GetChildren() do
			local ok, result = pcall(require, child)

			if ok and type(result) == "function" then
				table.insert(t1, result)
			end
		end

		function u4() -- line: 44
			-- upvalues: t1 (copy), u3 (ref), u4 (ref)
			for _, v11 in t1 do
				v11()
			end

			u3 = false
			u4 = nil
		end

		return u4
	end
}
