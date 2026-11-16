local parent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local parent2 = Foundation.Parent
local React = require(parent2.React)
local StyleRule = require(parent.StyleRule)
require(parent.Rules.Types)

require(Foundation.Enums.ColorMode)
require(Foundation.Enums.Device)
local Flags = require(Foundation.Utility.Flags)
require(parent.getOverrideAttributes)
local scaleValue = require(Foundation.Utility.scaleValue)

local function insertRule(list, props, p: string)
	local properties = props.properties

	local v = "." .. p
	local v2 = props.modifier == nil and "" or ":" .. props.modifier
	local selector = v .. v2 .. (props.pseudo == nil and "" or " ::" .. props.pseudo)

	if props.pseudoName ~= nil then
		selector ..= " #" .. props.pseudoName
	end

	if props.pseudo ~= nil and props.pseudoName == nil then
		selector ..= ", " .. v .. v2 .. " > " .. props.pseudo
	end

	table.insert(
		list,
		React.createElement(StyleRule, {
			key = selector,
			Priority = props.priority,
			Selector = selector,
			properties = properties
		})
	)
end

local function updateRuleAttributes(instance, attributes, p, value: number?, p2)
	local v = Flags.FoundationDisableTokenScaling and 1 or value or 1

	for _, v2 in attributes or {} do
		local v3

		if p2 then
			v3 = p2[v2.name]
		end

		if v3 == nil then
			v3 = v2.value
		end

		local v4 = scaleValue(v3, v)

		if p[v2.name] == v4 then
			continue
		end

		instance:SetAttribute(v2.name, v4)
		p[v2.name] = v4
	end
end

local function createStyleSheetRules(p, items, p2, p3, p4: number?, p5)
	local styleSheetRules = {}

	for k, _ in items do
		local v = p[k]

		if v == nil then
			continue
		end

		if p2 and p3 then
			updateRuleAttributes(p2, v.attributes, p3, p4, p5)
		end

		insertRule(styleSheetRules, v, k)

		if not v.children then
			continue
		end

		for _, child in v.children do
			if p2 and p3 then
				updateRuleAttributes(p2, child.attributes, p3, p4, p5)
			end

			insertRule(styleSheetRules, child, child.tag)
		end
	end

	return styleSheetRules
end

return createStyleSheetRules
