local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local v3 = require(InlineRichText.Logger):new(script.Name)
local Cryo = require(InlineRichTextParent.Cryo)
local t1 = {}

local function getMemoKey(s1: string, s2: string) -- line: 25
	return `${ s1 }___${ s2 }`
end
local function getMemo(s3: string, s4: string, s5: string) -- line: 29
	-- upvalues: t1 (copy)
	local v15 = `${ s4 }___${ s5 }`

	return t1[s3][v15]
end
local function setMemo(s6: string, s7: string, s8: string, b1: boolean) -- line: 35
	-- upvalues: t1 (copy)
	local v20 = `${ s7 }___${ s8 }`

	t1[s6][v20] = b1
end
local function isDescendant(t2: {[any]: any}, s9: string, s10: string, s11: string) -- line: 40
	-- upvalues: t1 (copy), v3 (copy), Cryo (copy)
	if not t1[s9] then
		t1[s9] = {}
	end

	local t3 = {}

	local function dfs(s12: string) -- line: 46
		-- upvalues: t3 (copy), s9 (copy), s11 (copy), t1 (copy), t2 (copy), v3 (copy), Cryo (copy), dfs (copy)
		t3[s12] = true

		local v28 = s9
		local v29 = `${ s12 }___${ s11 }`
		local v30 = t1[v28][v29]

		if v30 ~= nil then
			return v30
		end

		local v31 = t2[s12]

		if not v31 then
			v3:error(`Node { s12 } not found in graph`)

			local v32 = s9
			local v33 = `${ s12 }___${ s11 }`

			t1[v32][v33] = false

			return false
		end

		if v31.children[s11] then
			local v34 = s9
			local v35 = `${ s12 }___${ s11 }`

			t1[v34][v35] = true

			return true
		end

		local v36 = false

		for _, v38 in (Cryo.List.filter(Cryo.Dictionary.keys(v31.children), function(p1) -- line: 64
			-- upvalues: t3 (copy), v31 (copy)
			if not t3[p1] and v31.children[p1] then
				return true
			end

			return false
		end)) do
			if dfs(v38) then
				v36 = true

				break
			end
		end

		local v39 = s9
		local v40 = `${ s12 }___${ s11 }`

		t1[v39][v40] = v36

		return v36
	end

	return (dfs(s10))
end

return isDescendant
