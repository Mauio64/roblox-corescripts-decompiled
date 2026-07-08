local _ = script.Parent.Parent
local TextService = game:GetService("TextService")

return function(p1) -- line: 5
	-- upvalues: TextService (copy)
	local ok, result = pcall(function() -- line: 6
		-- upvalues: TextService (copy), p1 (copy)
		return TextService:GetTextSize("", 0, p1, Vector2.new(1e999, 1e999)).Y
	end)

	return ok, result
end
