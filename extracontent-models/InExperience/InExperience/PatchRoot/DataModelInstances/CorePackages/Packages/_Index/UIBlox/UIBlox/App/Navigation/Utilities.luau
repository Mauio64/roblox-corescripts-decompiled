local parent = script.Parent
local parent2 = parent.Parent.Parent
local InputType = require(parent2.Enums.InputType)
local parent3 = parent2.Parent
local Cryo = require(parent3.Cryo)
require(parent.ShortcutBar.Types)

return {
	filterItems = function(p, p2)
		local filtered = Cryo.List.filter(p, function(p3, _)
			local icon = p3.icon

			if typeof(icon) == "string" then
				return true
			else
				return typeof(icon) == "table" and icon.Image
			end
		end)

		if not p2 then
			return filtered
		end

		assert(p2, "Assert inputType not nil at this point to silence type checker")
		return (Cryo.List.join(filtered, Cryo.List.filterMap(p, function(p3, _)
			local icon = p3.icon

			if typeof(icon) == "string" or typeof(icon) == "table" and icon.Image then
				return
			end

			if
				typeof(icon) == "EnumItem"
				or #icon > 0 and typeof(icon[1]) == "EnumItem" and p2 == InputType.MouseAndKeyboard
			then
				return p3
			end

			if icon[p2] then
				return Cryo.Dictionary.join(p3, { icon = icon[p2] })
			end
		end)))
	end
}
