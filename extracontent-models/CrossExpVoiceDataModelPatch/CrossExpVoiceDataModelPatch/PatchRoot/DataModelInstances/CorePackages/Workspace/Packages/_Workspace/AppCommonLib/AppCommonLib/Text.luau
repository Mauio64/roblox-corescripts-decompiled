local TextService = game:GetService("TextService")

local Text = {}

Text.PADDING = Vector2.new(2, 2)

function Text.GetTextBounds(p, p2, p3, p4)
	return TextService:GetTextSize(p, p3, p2, p4) + Text.PADDING
end

function Text.GetTextWidth(p, p2, p3)
	return Text.GetTextBounds(p, p2, p3, Vector2.new(10000, 10000)).X
end

function Text.GetTextHeight(p, p2, p3, p4)
	return Text.GetTextBounds(p, p2, p3, Vector2.new(p4, 10000)).Y
end

function Text.Truncate(value, p, p2, p3, value2)
	local v = value2 or ""

	if not (p3 < Text.GetTextWidth(value, p, p2)) then
		return value
	end

	local v2 = ""

	for _, v3 in utf8.graphemes(value) do
		local v4 = string.sub(value, 1, v3) .. v

		if p3 < Text.GetTextWidth(v4, p, p2) then
			return v2
		end

		v2 = v4
	end

	return ""
end

function Text:TruncateTextLabel(p)
	self.Text = Text.Truncate(self.Text, self.Font, self.TextSize, self.AbsoluteSize.X, p)
end

function Text.Trim(value)
	if type(value) ~= "string" then
		error(string.format("Text.Trim called on non-string type %s.", (type(value))), 2)
	end

	return (value:gsub("^%s*(.-)%s*$", "%1"))
end

function Text.RightTrim(value)
	if type(value) ~= "string" then
		error(string.format("Text.RightTrim called on non-string type %s.", (type(value))), 2)
	end

	return (value:gsub("%s+$", ""))
end

function Text.LeftTrim(value)
	if type(value) ~= "string" then
		error(string.format("Text.LeftTrim called on non-string type %s.", (type(value))), 2)
	end

	return (value:gsub("^%s+", ""))
end

function Text.SpaceNormalize(value)
	if type(value) ~= "string" then
		error(string.format("Text.SpaceNormalize called on non-string type %s.", (type(value))), 2)
	end

	return (value:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
end

function Text.Split(value, value2)
	if type(value) == "string" then
		if type(value2) == "string" then
			if value2 == "" then
				error("Text.Split called with an empty pattern.", 2)
			end
		else
			error(string.format("Text.Split called with a pattern that is non-string type %s.", (type(value2))), 2)
		end
	else
		error(string.format("Text.Split called on non-string type %s.", (type(value))), 2)
	end

	local v = 1
	local result = {}

	while true do
		local v2, v3 = string.find(value, value2, v, true)

		if not (v2 and v3) then
			break
		end

		table.insert(result, (string.sub(value, v, v2 - 1)))
		v = v3 + 1
	end

	table.insert(result, (string.sub(value, v, (string.len(value)))))

	return result
end

return Text
