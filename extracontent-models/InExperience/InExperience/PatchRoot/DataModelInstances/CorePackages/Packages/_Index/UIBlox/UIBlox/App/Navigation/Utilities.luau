local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local InputType = require(ParentParent.Enums.InputType)
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)

require(scriptParent.ShortcutBar.Types)

return {
	filterItems = function(p1, p2) -- line: 35
		-- upvalues: Cryo (copy), InputType (copy)
		local v9 = Cryo.List.filter(p1, function(p3, _) -- line: 37
			local icon = p3.icon

			return typeof(icon) == "string" or typeof(icon) == "table" and icon.Image
		end)

		if not p2 then
			return v9
		end

		assert(p2, "Assert inputType not nil at this point to silence type checker")

		return (Cryo.List.join(v9, Cryo.List.filterMap(p1, function(p5, _) -- line: 11
			-- upvalues: p2 (copy), InputType (copy), Cryo (copy)
			local icon = p5.icon

			if typeof(icon) == "string" or typeof(icon) == "table" and icon.Image then
				return
			end

			if typeof(icon) == "EnumItem" or #icon > 0 and typeof(icon[1]) == "EnumItem" and p2 == InputType.MouseAndKeyboard then
				return p5
			end

			if icon[p2] then
				return Cryo.Dictionary.join(p5, {
					icon = icon[p2]
				})
			end
		end)))
	end
}
