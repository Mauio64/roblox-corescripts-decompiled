local TextService = game:GetService("TextService")

local v5 = {}

v5.PADDING = Vector2.new(2, 2)

function v5.GetTextBounds(p2, p3, p4, p5)
	return TextService:GetTextSize(p2, p4, p3, p5) + v5.PADDING
end

function v5.GetTextWidth(p2, p3, p4)
	return v5.GetTextBounds(p2, p3, p4, Vector2.new(10000, 10000)).X
end

function v5.GetTextHeight(p2, p3, p4, p5)
	return v5.GetTextBounds(p2, p3, p4, Vector2.new(p5, 10000)).Y
end

function v5.Truncate(value, p2, p3, p4, value2)
	local v6 = value2 or ""

	if not (p4 < v5.GetTextWidth(value, p2, p3)) then
		return value
	end

	local v7 = ""

	for k, v8 in utf8.graphemes(value) do
		local v9 = string.sub(value, 1, v8) .. v6

		if p4 < v5.GetTextWidth(v9, p2, p3) then
			return v7
		end

		v7 = v9
	end

	return ""
end

function v5:TruncateTextLabel(p2)
	self.Text = v5.Truncate(self.Text, self.Font, self.TextSize, self.AbsoluteSize.X, p2)
end

function v5.Trim(value)
	if type(value) ~= "string" then
		error(string.format("Text.Trim called on non-string type %s.", (type(value))), 2)
	end

	return (value:gsub("^%s*(.-)%s*$", "%1"))
end

function v5.RightTrim(value)
	if type(value) ~= "string" then
		error(string.format("Text.RightTrim called on non-string type %s.", (type(value))), 2)
	end

	return (value:gsub("%s+$", ""))
end

function v5.LeftTrim(value)
	if type(value) ~= "string" then
		error(string.format("Text.LeftTrim called on non-string type %s.", (type(value))), 2)
	end

	return (value:gsub("^%s+", ""))
end

function v5.SpaceNormalize(value)
	if type(value) ~= "string" then
		error(string.format("Text.SpaceNormalize called on non-string type %s.", (type(value))), 2)
	end

	return (value:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
end

function v5.Split(value, value2)
	if type(value) == "string" then
		if type(value2) == "string" then
			if value2 == "" then
				error("Text.Split called with an empty pattern.", 2)
			end
		else
			error(
				string.format(
					"Text.Split called with a pattern that is non-string type %s.",
					(type(value2))
				),
				2
			)
		end
	else
		error(string.format("Text.Split called on non-string type %s.", (type(value))), 2)
	end

	local v6 = 1
	local result = {}

	while true do
		local v7, v8 = string.find(value, value2, v6, true)

		if not (v7 and v8) then
			break
		end

		table.insert(result, (string.sub(value, v6, v7 - 1)))
		v6 = v8 + 1
	end

	table.insert(result, (string.sub(value, v6, (string.len(value)))))

	return result
end

return v5
