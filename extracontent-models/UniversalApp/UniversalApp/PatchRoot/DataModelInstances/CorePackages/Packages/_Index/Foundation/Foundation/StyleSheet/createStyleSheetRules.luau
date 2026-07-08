local scriptParent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local StyleRule = require(scriptParent.StyleRule)

require(scriptParent.Rules.Types)
require(Foundation.Enums.Device)

local Flags = require(Foundation.Utility.Flags)

require(Foundation.Enums.Theme)
require(scriptParent.getOverrideAttributes)

local scaleValue = require(Foundation.Utility.scaleValue)

local function insertRule(t1: {[any]: any}, p1, s1: string) -- line: 23
	-- upvalues: React (copy), StyleRule (copy)
	local properties = p1.properties
	local v15 = "." .. s1
	local v16 = p1.modifier == nil and "" or ":" .. p1.modifier
	local v17 = v15 .. v16 .. (p1.pseudo == nil and "" or " ::" .. p1.pseudo)

	if p1.pseudo ~= nil then
		v17 ..= ", " .. v15 .. v16 .. " > " .. p1.pseudo
	end

	table.insert(t1, React.createElement(StyleRule, {
		key = v17,
		Priority = p1.priority,
		Selector = v17,
		properties = properties
	}))
end
local function updateRuleAttributes(p2, t2: {[any]: any}?, t3: {[any]: any}, n1: number?, p3) -- line: 46
	-- upvalues: Flags (copy), scaleValue (copy)
	local v23 = t2 or {}
	local v24 = if not Flags.FoundationDisableTokenScaling then n1 or 1 else 1

	for _, v26 in v23 do
		local v27 = if not p3 then nil else p3[v26.name]
		local v28 = if v27 == nil then v26.value else v27
		local v29 = scaleValue(v28, v24)

		if v29 ~= t3[v26.name] then
			p2:SetAttribute(v26.name, v29)
			t3[v26.name] = v29
		end
	end
end
local function createStyleSheetRules(t4: {[any]: any}, t5: {[any]: any}, p4, t6: {[any]: any}?, n2: number?, p5) -- line: 67
	-- upvalues: updateRuleAttributes (copy), insertRule (copy)
	local t7 = {}

	for v37, _ in t5 do
		local v39 = t4[v37]

		if v39 ~= nil then
			if p4 and t6 then
				updateRuleAttributes(p4, v39.attributes, t6, n2, p5)
			end

			insertRule(t7, v39, v37)

			if v39.children then
				for _, v41 in v39.children do
					if p4 and t6 then
						updateRuleAttributes(p4, v41.attributes, t6, n2, p5)
					end

					insertRule(t7, v41, v41.tag)
				end
			end
		end
	end

	return t7
end

return createStyleSheetRules
