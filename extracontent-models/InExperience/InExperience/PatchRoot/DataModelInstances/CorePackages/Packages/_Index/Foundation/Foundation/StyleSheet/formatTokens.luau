local Foundation = script:FindFirstAncestor("Foundation")

local colorScopeKeepPrefix = require(script.Parent.colorScopeKeepPrefix)
require(Foundation.Providers.Style.Tokens)
require(script.Parent.Rules.Types)

local function pascalToKebab(value: string)
	local v = value:gsub("_", "-")

	local v2 = string.gsub(v, "(%u)", function(value2)
		return "-" .. value2:lower()
	end)

	if v2:sub(1, 1) == "-" then
		return (v2:sub(2, #v2))
	end

	return v2
end

local function formatTokens(p)
	local colors = {}
	local variants = {}
	local strokes = {}
	local gaps = {}
	local radii = {}
	local sizes = {}
	local typography = {}
	local paddings = {}
	local margins = {}
	local gutters = {}
	local v = {
		colors = colors,
		variants = variants,
		strokes = strokes,
		gaps = gaps,
		radii = radii,
		sizes = sizes,
		typography = typography,
		paddings = paddings,
		margins = margins,
		gutters = gutters
	}

	if p == nil or next(p) == nil then
		return v
	end

	for k, v2 in pairs(p.Color) do
		if v2.Background then
			variants[pascalToKebab(k)] = v2
		else
			colors[k] = {}

			for k2, v3 in v2 do
				if colorScopeKeepPrefix[k] then
					k2 = k .. k2
				end

				colors[k][pascalToKebab(k2)] = v3
			end
		end
	end

	for k, v2 in pairs(p.Inverse) do
		if k ~= "Content" then
			continue
		end

		for k2, v3 in v2 do
			if colorScopeKeepPrefix[k] then
				k2 = k .. k2
			end

			colors[k][`inverse-{pascalToKebab(k2)}`] = v3
		end
	end

	for k, size in pairs(p.Stroke) do
		table.insert(strokes, { name = pascalToKebab(k), size = size })
	end

	table.insert(strokes, { name = "none", size = 0 })

	table.sort(strokes, function(a, b): boolean
		return a.size < b.size
	end)

	for k, v2 in pairs(p.Gap) do
		table.insert(gaps, { name = string.lower(k), size = UDim.new(0, v2) })
	end

	table.sort(gaps, function(a, b): boolean
		return a.size.Offset < b.size.Offset
	end)

	for k, v2 in pairs(p.Radius) do
		table.insert(radii, { name = string.lower(k), size = UDim.new(0, v2) })
	end

	table.sort(radii, function(a, b): boolean
		return a.size.Offset < b.size.Offset
	end)

	for k, v2 in pairs(p.Size) do
		table.insert(sizes, {
			name = pascalToKebab(string.split(k, "_")[2]),
			size = UDim.new(0, v2)
		})
	end

	table.insert(sizes, { name = "full", size = UDim.new(1, 0) })

	table.sort(sizes, function(a, b): boolean
		return a.size.Offset < b.size.Offset
	end)

	for k, v2 in pairs(p.Typography) do
		typography[pascalToKebab(k)] = {
			Font = v2.Font,
			TextSize = v2.FontSize,
			LineHeight = v2.LineHeight
		}
	end

	for k, v2 in pairs(p.Padding) do
		table.insert(paddings, { name = string.lower(k), size = UDim.new(0, v2) })
	end

	table.sort(paddings, function(a, b): boolean
		return a.size.Offset < b.size.Offset
	end)

	for k, v2 in pairs(p.Margin) do
		table.insert(margins, { name = string.lower(k), size = UDim.new(0, v2) })
	end

	table.sort(margins, function(a, b): boolean
		return a.size.Offset < b.size.Offset
	end)

	for k, v2 in pairs(p.Gutter) do
		table.insert(gutters, { name = string.lower(k), size = UDim.new(0, v2) })
	end

	table.sort(gutters, function(a, b): boolean
		return a.size.Offset < b.size.Offset
	end)

	return v
end

return formatTokens
