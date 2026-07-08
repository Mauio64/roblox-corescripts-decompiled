local Foundation = script:FindFirstAncestor("Foundation")
local CornerProperty = require(Foundation.Enums.CornerProperty)

require(script.Parent.Types)

local uDim = UDim.new(0, 0)
local t1 = {
	CornerProperty.TopLeft,
	CornerProperty.TopRight,
	CornerProperty.BottomRight,
	CornerProperty.BottomLeft
}
local t2 = {
	["top-left"] = CornerProperty.TopLeft,
	["top-right"] = CornerProperty.TopRight,
	["bottom-right"] = CornerProperty.BottomRight,
	["bottom-left"] = CornerProperty.BottomLeft
}
local t3 = {
	top = {
		CornerProperty.TopLeft,
		CornerProperty.TopRight
	},
	bottom = {
		CornerProperty.BottomLeft,
		CornerProperty.BottomRight
	},
	left = {
		CornerProperty.TopLeft,
		CornerProperty.BottomLeft
	},
	right = {
		CornerProperty.TopRight,
		CornerProperty.BottomRight
	}
}

local function cornerProperties(p1, t4: {[any]: any}) -- line: 44
	local t5 = {}

	for _, v14 in t4 do
		t5[v14] = p1
	end

	return t5
end
local function zeroedBaseline(s1: string) -- line: 54
	-- upvalues: uDim (copy), t1 (copy)
	local t6 = {
		pseudo = "UICorner",
		priority = 0,
		tag = s1
	}
	local v17 = uDim
	local t7 = {}

	for _, v20 in t1 do
		t7[v20] = v17
	end

	t6.properties = t7

	return t6
end
local function cornerRules(p2, p3: ((...any) -> ...any)) -- line: 63
	-- upvalues: t1 (copy), t3 (copy), uDim (copy), t2 (copy)
	local t8 = {}

	for _, v25 in p2 do
		local v26 = p3(v25)
		local cornerValue = v26.cornerValue
		local attributes = v26.attributes
		local t9 = {
			pseudo = "UICorner",
			priority = 1,
			tag = `radius-{ v25.name }`
		}
		local t10 = {}

		for _, v32 in t1 do
			t10[v32] = cornerValue
		end

		t9.properties = t10
		t9.attributes = attributes
		table.insert(t8, t9)

		for v33, v34 in t3 do
			local v35 = `radius-{ v33 }-{ v25.name }`
			local t11 = {
				pseudo = "UICorner",
				priority = 2,
				tag = v35
			}
			local t12 = {}

			for _, v39 in v34 do
				t12[v39] = cornerValue
			end

			t11.properties = t12
			t11.attributes = attributes

			local t13 = {}
			local t14 = {
				pseudo = "UICorner",
				priority = 0,
				tag = v35
			}
			local v42 = uDim
			local t15 = {}

			for _, v45 in t1 do
				t15[v45] = v42
			end

			t14.properties = t15
			t13[1] = t14
			t11.children = t13
			table.insert(t8, t11)
		end

		for v46, v47 in t2 do
			local v48 = `radius-{ v46 }-{ v25.name }`
			local t16 = {
				pseudo = "UICorner",
				priority = 3,
				tag = v48
			}
			local t17 = {}

			for _, v52 in { v47 } do
				t17[v52] = cornerValue
			end

			t16.properties = t17
			t16.attributes = attributes

			local t18 = {}
			local t19 = {
				pseudo = "UICorner",
				priority = 0,
				tag = v48
			}
			local v55 = uDim
			local t20 = {}

			for _, v58 in t1 do
				t20[v58] = v55
			end

			t19.properties = t20
			t18[1] = t19
			t16.children = t18
			table.insert(t8, t16)
		end
	end

	return t8
end

return cornerRules
