local Foundation = script:FindFirstAncestor("Foundation")
local Logger = require(Foundation.Utility.Logger)

require(Foundation.Components.Types)

local function getRoundedNumber(n1: number) -- line: 27
	return math.round(n1 * 1000) / 1000
end
local function getRGBAValues(color3: Color3, n2: number?) -- line: 31
	local v13 = math.round(color3.R * 255)
	local v14 = math.round(color3.G * 255)
	local v15 = math.round(color3.B * 255)

	if n2 then
		return v13, v14, v15, math.round((1 - n2) * 1000) / 1000
	end

	return v13, v14, v15
end
local function collectTokens(p1, s1: string, s2: string?, b1: boolean?) -- line: 77
	-- upvalues: collectTokens (copy)
	local t1 = {}

	for v50, v51 in p1 do
		local v52 = if not s2 then v50 else `{ s2 }.{ v50 }`

		if type(v51) == "table" and not getmetatable(v51) and (not b1 or (type(v51) ~= "table" or (v51.Color3 == nil or (typeof(v51.Color3) ~= "Color3" or (v51.Transparency == nil or typeof(v51.Transparency) ~= "number"))))) then
			for _, v54 in (collectTokens(v51, s1, v52, b1)) do
				table.insert(t1, v54)
			end
		else
			table.insert(t1, {
				key = v50,
				value = v51,
				category = s1,
				fullPath = v52
			})
		end
	end

	return t1
end
local function getTokenValue(p2, s3: string) -- line: 243
	for _, v90 in string.split(s3, ".") do
		if p2 == nil or type(p2) ~= "table" then
			return nil
		end

		p2 = p2[v90]
	end

	return p2
end
local function tokenOverrideValuesCompatible(p3, p4) -- line: 273
	-- upvalues: tokenOverrideValuesCompatible (copy)
	if p3 == nil or p4 == nil then
		return false
	end

	if type(p3) ~= "table" or type(p4) ~= "table" then
		return typeof(p3) == typeof(p4)
	end

	for v100, v101 in p3 do
		if not tokenOverrideValuesCompatible(v101, p4[v100]) then
			return false
		end
	end

	for v102 in p4 do
		if p3[v102] == nil then
			return false
		end
	end

	return true
end
local function resolveTokenOverrideSource(p5, p6) -- line: 294
	-- upvalues: getTokenValue (copy), Logger (copy)
	if type(p6) == "string" then
		local v105 = getTokenValue(p5, p6)

		if v105 == nil then
			Logger:warning(`Token override skipped: unknown source token path "{ p6 }"`)

			return nil
		end

		return v105
	end

	return p6
end

return {
	isColorStyle = function(p7) -- line: 19
		return type(p7) == "table" and (p7.Color3 ~= nil and (typeof(p7.Color3) == "Color3" and (p7.Transparency ~= nil and typeof(p7.Transparency) == "number")))
	end,
	formatColorPreviewHTML = function(color3: Color3, n3: number?) -- line: 39
		local v18 = math.round(color3.R * 255)
		local v19 = math.round(color3.G * 255)
		local v20 = math.round(color3.B * 255)
		local v21

		if n3 then
			v21 = math.round((1 - n3) * 1000) / 1000
		else
			v21 = nil
		end

		return `<span class="color-preview" style="background-color: rgba({ v18 },{ v19 },{ v20 },{ v21 or 1 });"></span>`
	end,
	formatTokenValue = function(p8) -- line: 45
		if typeof(p8) == "Color3" then
			return `rgb({ math.round(p8.R * 255) }, { math.round(p8.G * 255) }, { math.round(p8.B * 255) })`
		end

		if typeof(p8) == "number" then
			return (tostring(math.round(p8 * 1000) / 1000))
		end

		if type(p8) == "table" and (p8.Color3 ~= nil and (typeof(p8.Color3) == "Color3" and (p8.Transparency ~= nil and typeof(p8.Transparency) == "number"))) then
			local p8Color3 = p8.Color3
			local p8Transparency = p8.Transparency
			local v25 = math.round(p8Color3.R * 255)
			local v26 = math.round(p8Color3.G * 255)
			local v27 = math.round(p8Color3.B * 255)
			local v28

			if p8Transparency then
				v28 = math.round((1 - p8Transparency) * 1000) / 1000
			else
				v28 = nil
			end

			return `rgba({ v25 }, { v26 }, { v27 }, { v28 })`
		end

		return (tostring(p8))
	end,
	formatTokenValueHTML = function(p9) -- line: 60
		if typeof(p9) == "Color3" then
			local v30 = math.round(p9.R * 255)
			local v31 = math.round(p9.G * 255)
			local v32 = math.round(p9.B * 255)

			return `<span class="color">{ `<span class="color-preview" style="background-color: rgba({ math.round(p9.R * 255) },{ math.round(p9.G * 255) },{ math.round(p9.B * 255) },{ nil or 1 });"></span>` } rgb({ v30 }, { v31 }, { v32 })</span>`
		end

		if typeof(p9) == "number" then
			return (tostring(math.round(p9 * 1000) / 1000))
		end

		if type(p9) == "table" and (p9.Color3 ~= nil and (typeof(p9.Color3) == "Color3" and (p9.Transparency ~= nil and typeof(p9.Transparency) == "number"))) then
			local p9Color3 = p9.Color3
			local p9Transparency = p9.Transparency
			local v35 = math.round(p9Color3.R * 255)
			local v36 = math.round(p9Color3.G * 255)
			local v37 = math.round(p9Color3.B * 255)
			local v38

			if p9Transparency then
				v38 = math.round((1 - p9Transparency) * 1000) / 1000
			else
				v38 = nil
			end

			local p9Color3_2 = p9.Color3
			local p9Transparency2 = p9.Transparency
			local v41 = math.round(p9Color3_2.R * 255)
			local v42 = math.round(p9Color3_2.G * 255)
			local v43 = math.round(p9Color3_2.B * 255)
			local v44

			if p9Transparency2 then
				v44 = math.round((1 - p9Transparency2) * 1000) / 1000
			else
				v44 = nil
			end

			return `<span class="color">{ `<span class="color-preview" style="background-color: rgba({ v41 },{ v42 },{ v43 },{ v44 or 1 });"></span>` } rgba({ v35 }, { v36 }, { v37 }, { v38 })</span>`
		end

		return (tostring(p9))
	end,
	collectTokens = collectTokens,
	collectTokensWithSubcategories = function(p10, s4: string, s5: string?, b2: boolean?) -- line: 104
		-- upvalues: collectTokens (copy)
		local t2 = {}

		for v60, v61 in p10 do
			local v62 = if not s5 then v60 else `{ s5 }.{ v60 }`

			if type(v61) == "table" then
				if b2 and (type(v61) == "table" and (v61.Color3 ~= nil and (typeof(v61.Color3) == "Color3" and (v61.Transparency ~= nil and typeof(v61.Transparency) == "number")))) then
					local v63 = not s5 and "Default" or s5:split(".")[1]

					if not t2[v63] then
						t2[v63] = {}
					end

					table.insert(t2[v63], {
						key = v60,
						value = v61,
						category = s4,
						fullPath = v62
					})
				elseif not s5 then
					local v64 = collectTokens(v61, s4, v60, b2)

					if #v64 > 0 then
						t2[v60] = v64
					end
				else
					local v65 = collectTokens(v61, s4, v62, b2)
					local v66 = s5:split(".")[1]

					if not t2[v66] then
						t2[v66] = {}
					end

					for _, v68 in v65 do
						table.insert(t2[v66], v68)
					end
				end
			else
				local v69 = not s5 and "Default" or s5:split(".")[1]

				if not t2[v69] then
					t2[v69] = {}
				end

				table.insert(t2[v69], {
					key = v60,
					value = v61,
					category = s4,
					fullPath = v62
				})
			end
		end

		return t2
	end,
	hasSubcategories = function(p11) -- line: 168
		for _, v72 in p11 do
			if type(v72) ~= "table" then
				continue
			end

			local v73 = false

			for _, v75 in v72 do
				if type(v75) == "table" or typeof(v75) == "Color3" or typeof(v75) == "number" then
					v73 = true

					break
				end
			end

			if v73 then
				return true
			end
		end

		return false
	end,
	sortTokens = function(s6: string, s7: string, b3: boolean?) -- line: 196
		if s6:find("(%u%a+)_(%d+)%.?(%u?%w*)") and s7:find("(%u%a+)_(%d+)%.?(%u?%w*)") then
			local v79, v80, v81 = s6:match("(%u%a+)_(%d+)%.?(%u?%w*)")
			local v82, v83, v84 = s7:match("(%u%a+)_(%d+)%.?(%u?%w*)")

			if v79 == v82 then
				if v80 == v83 then
					return v81 < v84
				end

				return tonumber(v80) < tonumber(v83)
			end

			return s6 < s7
		end

		if b3 then
			local v85 = s6:match("| (%-?[%d.]+) |$")
			local v86 = s7:match("| (%-?[%d.]+) |$")

			return tonumber(v85) < tonumber(v86)
		end

		return s6 < s7
	end,
	orderedTokenCategories = {
		"Color",
		"Stroke",
		"Size",
		"Radius",
		"Padding",
		"Margin",
		"Gap",
		"Typography",
		"FontSize",
		"FontWeight",
		"LineHeight",
		"Ease",
		"Time",
		"Inverse",
		"DarkMode",
		"LightMode",
		"Config"
	},
	getTokenValue = getTokenValue,
	setTokenValue = function(p12, s8: string, p13) -- line: 256
		local parts = string.split(s8, ".")

		for i = 1, #parts - 1 do
			local v96 = parts[i]

			if p12[v96] == nil then
				return
			end

			p12 = p12[v96]
		end

		local v97 = parts[#parts]

		if p12 and v97 then
			p12[v97] = p13
		end
	end,
	resolveTokenOverride = function(p14, s9: string, p15) -- line: 307
		-- upvalues: getTokenValue (copy), Logger (copy), tokenOverrideValuesCompatible (copy)
		local v109

		if type(p15) == "string" then
			v109 = getTokenValue(p14, p15)

			if v109 == nil then
				Logger:warning(`Token override skipped: unknown source token path "{ p15 }"`)
				v109 = nil
			end
		else
			v109 = p15
		end

		if v109 == nil then
			return nil
		end

		local v110 = getTokenValue(p14, s9)

		if v110 == nil then
			Logger:warning(`Token override skipped: unknown target token path "{ s9 }"`)

			return nil
		end

		if not tokenOverrideValuesCompatible(v110, v109) then
			Logger:warning(`Token override skipped: type or shape mismatch for "{ s9 }"`)

			return nil
		end

		return v109
	end,
	_resolveTokenOverrideSource = resolveTokenOverrideSource
}
