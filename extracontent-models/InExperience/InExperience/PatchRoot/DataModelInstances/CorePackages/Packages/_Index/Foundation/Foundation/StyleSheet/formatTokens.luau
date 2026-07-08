local Foundation = script:FindFirstAncestor("Foundation")
local colorScopeKeepPrefix = require(script.Parent.colorScopeKeepPrefix)

require(Foundation.Providers.Style.Tokens)
require(script.Parent.Rules.Types)

local function pascalToKebab(s1: string) -- line: 10
	local v6 = s1:gsub("_", "-")
	local v7 = string.gsub(v6, "(%u)", function(p1) -- line: 15
		return "-" .. p1:lower()
	end)

	if v7:sub(1, 1) == "-" then
		v7 = v7:sub(2, #v7)
	end

	return v7
end
local function formatTokens(p2) -- line: 28
	-- upvalues: pascalToKebab (copy), colorScopeKeepPrefix (copy)
	local t1 = {}
	local t2 = {}
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local t7 = {}
	local t8 = {}
	local t9 = {}
	local t10 = {}
	local t11 = {
		colors = t1,
		variants = t2,
		strokes = t3,
		gaps = t4,
		radii = t5,
		sizes = t6,
		typography = t7,
		paddings = t8,
		margins = t9,
		gutters = t10
	}

	if p2 == nil or next(p2) == nil then
		return t11
	end

	for k, v in pairs(p2.Color) do
		if v.Background then
			t2[pascalToKebab(k)] = v
		else
			t1[k] = {}

			for v22, v23 in v do
				local v24 = if not colorScopeKeepPrefix[k] then v22 else k .. v22

				t1[k][pascalToKebab(v24)] = v23
			end
		end
	end

	for k, v in pairs(p2.Inverse) do
		if k == "Content" then
			for v27, v28 in v do
				local v29 = if not colorScopeKeepPrefix[k] then v27 else k .. v27

				t1[k][`inverse-{ pascalToKebab(v29) }`] = v28
			end
		end
	end

	for k, v in pairs(p2.Stroke) do
		table.insert(t3, {
			name = pascalToKebab(k),
			size = v
		})
	end

	table.insert(t3, {
		name = "none",
		size = 0
	})
	table.sort(t3, function(p3, p4) -- line: 86
		return p3.size < p4.size
	end)

	for k, v in pairs(p2.Gap) do
		table.insert(t4, {
			name = string.lower(k),
			size = UDim.new(0, v)
		})
	end

	table.sort(t4, function(p5, p6) -- line: 94
		return p5.size.Offset < p6.size.Offset
	end)

	for k, v in pairs(p2.Radius) do
		table.insert(t5, {
			name = string.lower(k),
			size = UDim.new(0, v)
		})
	end

	table.sort(t5, function(p7, p8) -- line: 102
		return p7.size.Offset < p8.size.Offset
	end)

	for k, v in pairs(p2.Size) do
		local v38 = string.split(k, "_")[2]

		table.insert(t6, {
			name = pascalToKebab(v38),
			size = UDim.new(0, v)
		})
	end

	table.insert(t6, {
		name = "full",
		size = UDim.new(1, 0)
	})
	table.sort(t6, function(p9, p10) -- line: 114
		return p9.size.Offset < p10.size.Offset
	end)

	for k, v in pairs(p2.Typography) do
		t7[pascalToKebab(k)] = {
			Font = v.Font,
			TextSize = v.FontSize,
			LineHeight = v.LineHeight
		}
	end

	for k, v in pairs(p2.Padding) do
		table.insert(t8, {
			name = string.lower(k),
			size = UDim.new(0, v)
		})
	end

	table.sort(t8, function(p11, p12) -- line: 130
		return p11.size.Offset < p12.size.Offset
	end)

	for k, v in pairs(p2.Margin) do
		table.insert(t9, {
			name = string.lower(k),
			size = UDim.new(0, v)
		})
	end

	table.sort(t9, function(p13, p14) -- line: 138
		return p13.size.Offset < p14.size.Offset
	end)

	for k, v in pairs(p2.Gutter) do
		table.insert(t10, {
			name = string.lower(k),
			size = UDim.new(0, v)
		})
	end

	table.sort(t10, function(p15, p16) -- line: 146
		return p15.size.Offset < p16.size.Offset
	end)

	return t11
end

return formatTokens
