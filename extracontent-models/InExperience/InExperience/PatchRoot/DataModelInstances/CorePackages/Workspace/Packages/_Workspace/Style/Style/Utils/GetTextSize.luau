local TextService = game:GetService("TextService")

return function(...) -- line: 8
	-- upvalues: TextService (copy)
	return TextService:GetTextSize(...) + Vector2.new(2, 2)
end
