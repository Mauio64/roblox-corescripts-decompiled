local UserInputService = game:GetService("UserInputService")
local t1 = {}

local function update() -- line: 18
	-- upvalues: t1 (copy), UserInputService (copy)
	local v4 = t1[#t1]

	if v4 then
		UserInputService.OverrideMouseIconBehavior = v4[2]

		return
	end

	UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
end

return {
	push = function(s1: string, p1) -- line: 28
		-- upvalues: t1 (copy), UserInputService (copy)
		assert(type(s1) == "userdata" or type(s1) == "string", "key")
		assert(typeof(p1) == "EnumItem", "behavior")
		assert(p1.EnumType == Enum.OverrideMouseIconBehavior, "behavior.EnumType")

		for i, v in ipairs(t1) do
			if s1 == v[1] then
				table.remove(t1, i)

				break
			end
		end

		table.insert(t1, {
			s1,
			p1
		})

		local v9 = t1[#t1]

		if v9 then
			UserInputService.OverrideMouseIconBehavior = v9[2]

			return
		end

		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
	end,
	pop = function(p2) -- line: 43
		-- upvalues: t1 (copy), UserInputService (copy)
		assert(type(p2) == "userdata" or type(p2) == "string", "key")

		local v11 = nil

		for i, v in ipairs(t1) do
			if p2 == v[1] then
				v11 = i

				break
			end
		end

		if v11 then
			table.remove(t1, v11)
		end

		local v14 = t1[#t1]

		if v14 then
			UserInputService.OverrideMouseIconBehavior = v14[2]

			return
		end

		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
	end
}
