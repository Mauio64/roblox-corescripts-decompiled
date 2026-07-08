local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)

require(Foundation.Components.Types)

local function tagToTable(p1) -- line: 11
	if type(p1) == "string" then
		return {
			[p1] = true
		}
	end

	return p1
end
local function mergeTags(p2, p3) -- line: 20
	-- upvalues: Dash (copy)
	if not p2 then
		return p3
	end

	if not p3 then
		return p2
	end

	if type(p2) == "table" or type(p3) == "table" then
		local v10 = if type(p2) ~= "string" then p2 else {
			[p2] = true
		}
		local v11 = if type(p3) ~= "string" then p3 else {
			[p3] = true
		}

		return Dash.join(v10, v11)
	end

	return `{ p2 } { p3 }`
end
local function mergeProps(t1: {[any]: any}, t2: {[any]: any}) -- line: 40
	-- upvalues: Dash (copy), mergeTags (copy)
	local v14 = Dash.join(t1, t2)

	v14.tag = mergeTags(t1.tag, t2.tag)

	return v14
end

function composeStyleVariant(t3: {[any]: any}, ...) -- line: 48
	-- upvalues: Dash (copy), mergeTags (copy)
	local v16 = Dash.copy(t3)

	Dash.forEachArgs(function(p4) -- line: 50
		-- upvalues: v16 (copy), Dash (copy), mergeTags (copy)
		if p4 == nil then
			return
		end

		for v18, v19 in p4 do
			local v20 = v16
			local v21 = v16[v18] or {}
			local v22 = Dash.join(v21, v19)

			v22.tag = mergeTags(v21.tag, v19.tag)
			v20[v18] = v22
		end
	end, ...)

	return v16
end

return composeStyleVariant
