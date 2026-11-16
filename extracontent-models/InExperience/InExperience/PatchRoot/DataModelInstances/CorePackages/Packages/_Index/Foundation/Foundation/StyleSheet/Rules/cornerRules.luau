local Foundation = script:FindFirstAncestor("Foundation")

local CornerProperty = require(Foundation.Enums.CornerProperty)
require(script.Parent.Types)

local udim = UDim.new(0, 0)

local v = {
	CornerProperty.TopLeft,
	CornerProperty.TopRight,
	CornerProperty.BottomRight,
	CornerProperty.BottomLeft
}

local v2 = {
	["top-left"] = CornerProperty.TopLeft,
	["top-right"] = CornerProperty.TopRight,
	["bottom-right"] = CornerProperty.BottomRight,
	["bottom-left"] = CornerProperty.BottomLeft
}

local v3 = {
	top = { CornerProperty.TopLeft, CornerProperty.TopRight },
	bottom = { CornerProperty.BottomLeft, CornerProperty.BottomRight },
	left = { CornerProperty.TopLeft, CornerProperty.BottomLeft },
	right = { CornerProperty.TopRight, CornerProperty.BottomRight }
}

local function cornerProperties(p, items)
	local result = {}

	for _, item in items do
		result[item] = p
	end

	return result
end

local function zeroedBaseline(tag: string)
	local udims = {}

	local v4 = { tag = tag, pseudo = "UICorner", priority = 0, properties = 0 }

	for _, v5 in v do
		udims[v5] = udim
	end

	v4.properties = udims
	return v4
end

local function cornerRules(items, callback)
	local result = {}

	for _, item in items do
		local v4 = callback(item)
		local cornerValue = v4.cornerValue
		local attributes = v4.attributes

		local v5 = {
			tag = `radius-{item.name}`,
			pseudo = "UICorner",
			priority = 1,
			properties = 0,
			attributes = 0
		}
		local cornerValues = {}

		for _, v6 in v do
			cornerValues[v6] = cornerValue
		end

		v5.properties = cornerValues
		v5.attributes = attributes
		table.insert(result, v5)

		for k, v6 in v3 do
			local formatted = `radius-{k}-{item.name}`
			local cornerValues2 = {}

			local v7 = {
				tag = formatted,
				pseudo = "UICorner",
				priority = 2,
				properties = 0,
				attributes = 0,
				children = 0
			}

			for _, v8 in v6 do
				cornerValues2[v8] = cornerValue
			end

			v7.properties = cornerValues2
			v7.attributes = attributes
			local udims = {}

			local v8 = { tag = formatted, pseudo = "UICorner", priority = 0, properties = 0 }

			local children = { nil }

			for _, v9 in v do
				udims[v9] = udim
			end

			v8.properties = udims
			children[1] = v8

			v7.children = children
			table.insert(result, v7)
		end

		for k, v6 in v2 do
			local formatted = `radius-{k}-{item.name}`
			local cornerValues2 = {}

			local v7 = {
				tag = formatted,
				pseudo = "UICorner",
				priority = 3,
				properties = 0,
				attributes = 0,
				children = 0
			}

			for _, v8 in { v6 } do
				cornerValues2[v8] = cornerValue
			end

			v7.properties = cornerValues2
			v7.attributes = attributes
			local udims = {}

			local v8 = { tag = formatted, pseudo = "UICorner", priority = 0, properties = 0 }

			local children = { nil }

			for _, v9 in v do
				udims[v9] = udim
			end

			v8.properties = udims
			children[1] = v8

			v7.children = children
			table.insert(result, v7)
		end
	end

	return result
end

return cornerRules
