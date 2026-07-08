local Foundation = script:FindFirstAncestor("Foundation")
local Device = require(Foundation.Enums.Device)

require(Foundation.Enums.Theme)
require(Foundation.Providers.Style.Tokens)
require(script.Parent.Rules.Types)

local Flags = require(Foundation.Utility.Flags)
local getGeneratedRules = require(Foundation.Utility.getGeneratedRules)
local getOverrideAttributes = require(script.Parent.getOverrideAttributes)
local scaleValue = require(Foundation.Utility.scaleValue)
local Folder = Instance.new("Folder")

Folder.Name = "FoundationStyleSheets"
Folder.Parent = Foundation

local t1 = {}

local function createStyleSheet(p1, p2, n1: number?, p3) -- line: 47
	-- upvalues: Device (copy), Folder (copy), getOverrideAttributes (copy), getGeneratedRules (copy)
	local v17 = p2 or Device.Desktop
	local v18 = n1 or 1
	local StyleSheet = Instance.new("StyleSheet")

	StyleSheet.Name = if p3 == nil then `{ p1 }-{ v17 }-{ v18 }` else `{ p1 }-{ v17 }-{ v18 }-{ tostring(p3) }`
	StyleSheet.Parent = Folder

	return {
		theme = p1,
		device = v17,
		scale = v18,
		tokenOverrides = p3,
		overrideAttributes = getOverrideAttributes(p1, v17, p3),
		instance = StyleSheet,
		tags = {},
		rules = getGeneratedRules(p1, v17),
		attributes = {}
	}
end
local function createStyleRule(p4, s1: string) -- line: 73
	local v22 = "." .. s1
	local v23 = p4.modifier == nil and "" or ":" .. p4.modifier
	local v24 = v22 .. v23 .. (p4.pseudo == nil and "" or " ::" .. p4.pseudo)

	if p4.pseudo ~= nil then
		v24 ..= ", " .. v22 .. v23 .. " > " .. p4.pseudo
	end

	local StyleRule = Instance.new("StyleRule")

	StyleRule.Name = v24
	StyleRule.Priority = p4.priority or 1
	StyleRule.Selector = v24
	StyleRule:SetProperties(p4.properties)

	return StyleRule
end
local function applyAttributes(t2: {[any]: any}, t3: {[any]: any}?) -- line: 91
	-- upvalues: Flags (copy), scaleValue (copy)
	if not t3 then
		return
	end

	for _, v29 in t3 do
		if not t2.attributes[v29.name] then
			local v30 = t2.overrideAttributes[v29.name]
			local v31 = if v30 == nil then v29.value else v30
			local v32 = if not Flags.FoundationDisableTokenScaling then scaleValue(v31, t2.scale) else v31

			t2.attributes[v29.name] = true
			t2.instance:SetAttribute(v29.name, v32)
		end
	end
end
local function addRegisteredStyleSheetTags(t4: {[any]: any}, t5: {[any]: any}) -- line: 109
	-- upvalues: createStyleRule (copy), applyAttributes (copy)
	for _, v36 in t5 do
		if not t4.tags[v36] then
			local v37 = t4.rules[v36]

			if v37 then
				createStyleRule(v37, v36).Parent = t4.instance
				applyAttributes(t4, v37.attributes)

				if v37.children then
					for _, v39 in v37.children do
						createStyleRule(v39, v39.tag).Parent = t4.instance
						applyAttributes(t4, v39.attributes)
					end
				end

				t4.tags[v36] = true
			end
		end
	end
end

return {
	getStyleSheet = function(p5, p6, n2: number?, p7) -- line: 139
		-- upvalues: Device (copy), t1 (copy), createStyleSheet (copy)
		local v44 = p6 or Device.Desktop
		local v45 = n2 or 1

		for v46, v47 in t1 do
			if p5 == v47.theme and v44 == v47.device and v45 == v47.scale and p7 == v47.tokenOverrides then
				return v46
			end
		end

		local v48 = createStyleSheet(p5, v44, v45, p7)

		t1[v48.instance] = v48

		return v48.instance
	end,
	addStyleTags = function(p8, t6: {[any]: any}) -- line: 162
		-- upvalues: t1 (copy), addRegisteredStyleSheetTags (copy)
		local v51 = t1[p8]

		if not v51 then
			error("StyleSheet not found in registry")
		end

		addRegisteredStyleSheetTags(v51, t6)
	end
}
