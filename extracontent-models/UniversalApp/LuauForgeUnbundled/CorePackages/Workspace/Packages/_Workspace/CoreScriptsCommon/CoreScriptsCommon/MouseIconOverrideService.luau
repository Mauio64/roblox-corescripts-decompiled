local UserInputService = game:GetService("UserInputService")

local v5 = {}

local function update()
	local v6 = v5[#v5]

	if v6 then
		UserInputService.OverrideMouseIconBehavior = v6[2]
	else
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
	end
end

return {
	push = function(value, p2)
		assert(type(value) == "userdata" or type(value) == "string", "key")
		assert(typeof(p2) == "EnumItem", "behavior")
		assert(p2.EnumType == Enum.OverrideMouseIconBehavior, "behavior.EnumType")

		for i, v6 in ipairs(v5) do
			if v6[1] == value then
				table.remove(v5, i)
				break
			end
		end

		table.insert(v5, { value, p2 })
		local v6 = v5[#v5]

		if v6 then
			UserInputService.OverrideMouseIconBehavior = v6[2]
		else
			UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		end
	end,
	pop = function(value)
		assert(type(value) == "userdata" or type(value) == "string", "key")
		local v6 = nil

		for i, v8 in ipairs(v5) do
			if v8[1] == value then
				v6 = i
				break
			end
		end

		if v6 then
			table.remove(v5, v6)
		end

		local v8 = v5[#v5]

		if v8 then
			UserInputService.OverrideMouseIconBehavior = v8[2]
		else
			UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
		end
	end
}
