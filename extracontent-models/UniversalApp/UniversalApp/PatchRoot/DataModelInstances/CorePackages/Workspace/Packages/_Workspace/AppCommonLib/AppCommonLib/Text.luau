local TextService = game:GetService("TextService")
local t1 = {
	PADDING = Vector2.new(2, 2)
}

function t1.GetTextBounds(p1, p2, p3, p4) -- line: 12
	-- upvalues: TextService (copy), t1 (copy)
	return TextService:GetTextSize(p1, p3, p2, p4) + t1.PADDING
end
function t1.GetTextWidth(p5, p6, p7) -- line: 16
	-- upvalues: t1 (copy)
	return t1.GetTextBounds(p5, p6, p7, Vector2.new(10000, 10000)).X
end
function t1.GetTextHeight(p8, p9, p10, p11) -- line: 20
	-- upvalues: t1 (copy)
	return t1.GetTextBounds(p8, p9, p10, Vector2.new(p11, 10000)).Y
end
function t1.Truncate(p12, p13, p14, p15, p16) -- line: 25
	-- upvalues: t1 (copy)
	local v19 = p16 or ""

	if p15 < t1.GetTextWidth(p12, p13, p14) then
		local s1 = ""

		for _, v22 in utf8.graphemes(p12) do
			local v23 = string.sub(p12, 1, v22) .. v19

			if p15 < t1.GetTextWidth(v23, p13, p14) then
				return s1
			end

			s1 = v23
		end

		return ""
	end

	return p12
end
function t1.TruncateTextLabel(p17, p18) -- line: 45
	-- upvalues: t1 (copy)
	p17.Text = t1.Truncate(p17.Text, p17.Font, p17.TextSize, p17.AbsoluteSize.X, p18)
end
function t1.Trim(p19) -- line: 51
	if type(p19) ~= "string" then
		error(string.format("Text.Trim called on non-string type %s.", (type(p19))), 2)
	end

	return (p19:gsub("^%s*(.-)%s*$", "%1"))
end
function t1.RightTrim(p20) -- line: 59
	if type(p20) ~= "string" then
		error(string.format("Text.RightTrim called on non-string type %s.", (type(p20))), 2)
	end

	return (p20:gsub("%s+$", ""))
end
function t1.LeftTrim(p21) -- line: 67
	if type(p21) ~= "string" then
		error(string.format("Text.LeftTrim called on non-string type %s.", (type(p21))), 2)
	end

	return (p21:gsub("^%s+", ""))
end
function t1.SpaceNormalize(p22) -- line: 75
	if type(p22) ~= "string" then
		error(string.format("Text.SpaceNormalize called on non-string type %s.", (type(p22))), 2)
	end

	return (p22:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
end
function t1.Split(p23, p24) -- line: 83
	if type(p23) ~= "string" then
		error(string.format("Text.Split called on non-string type %s.", (type(p23))), 2)
	elseif type(p24) ~= "string" then
		error(string.format("Text.Split called with a pattern that is non-string type %s.", (type(p24))), 2)
	elseif p24 == "" then
		error("Text.Split called with an empty pattern.", 2)
	end

	local t2 = {}
	local n1 = 1

	while true do
		local start, stop = string.find(p23, p24, n1, true)

		if not start or not stop then
			break
		end

		table.insert(t2, (string.sub(p23, n1, start - 1)))
		n1 = stop + 1
	end

	table.insert(t2, (string.sub(p23, n1, (string.len(p23)))))

	return t2
end

return t1
