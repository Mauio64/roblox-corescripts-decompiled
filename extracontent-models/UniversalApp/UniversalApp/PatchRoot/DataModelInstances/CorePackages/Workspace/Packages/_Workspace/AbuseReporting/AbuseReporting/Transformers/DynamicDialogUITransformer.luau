local Parent = script:FindFirstAncestor("AbuseReporting").Parent
local ServerUI = require(Parent.ServerUI)
local Cryo = require(Parent.Cryo)
local Constants = ServerUI.Constants
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 22
	-- upvalues: Constants (copy), t1 (copy)
	local t3 = {
		templateMap = t2.templateMap,
		componentMap = t2.componentMap,
		defaultTemplateName = t2.defaultTemplateName or Constants.DEFAULT_TEMPLATE_NAME
	}

	setmetatable(t3, t1)

	return t3
end
function t1.transform(p1, p2) -- line: 33
	-- upvalues: Cryo (copy)
	local t4 = {
		name = p1.templateMap[p1.defaultTemplateName] and p1.templateMap[p1.defaultTemplateName].name or p1.defaultTemplateName,
		component = p1.templateMap[p1.defaultTemplateName].component,
		props = {},
		children = {}
	}
	local t5 = {
		templates = {
			[t4.name] = t4
		},
		components = {}
	}

	if p2.dialog and p2.dialog.componentRefs then
		for _, v in ipairs(p2.dialog.componentRefs) do
			if p1.componentMap[v] then
				table.insert(t4.children, v)
			end
		end
	end

	if p2.components then
		if p2.components.title then
			t4.props.title = p2.components.title.text
		end

		if p2.components.subtitle then
			t4.props.subtitle = p2.components.subtitle.text
		end

		if p2.components.artifacts then
			t4.props.artifacts = p2.components.artifacts
		end

		for v14, v15 in p1.componentMap do
			local v16 = p2.components[v14]

			if v16 then
				local v17 = v15.name or v14

				t5.components[v17] = {
					name = v17,
					component = v15.component,
					props = Cryo.Dictionary.join({
						params = v16
					}, v15.props or {})
				}
			end
		end
	end

	return t5
end

return t1
