local module = require("@luauforge/bundled/hKs")
local module2 = require("@luauforge/bundled/hKr")
local constants = module.Constants

local class = {}
class.__index = class

function class.new(data)
	local v5 = {
		templateMap = data.templateMap,
		componentMap = data.componentMap,
		defaultTemplateName = data.defaultTemplateName or constants.DEFAULT_TEMPLATE_NAME
	}

	setmetatable(v5, class)
	return v5
end

function class.transform(data, p2)
	local v5 = {
		name = data.templateMap[data.defaultTemplateName] and data.templateMap[data.defaultTemplateName].name or data.defaultTemplateName,
		component = data.templateMap[data.defaultTemplateName].component,
		props = {},
		children = {}
	}

	local v6 = {
		templates = { [v5.name] = v5 },
		components = {}
	}

	if p2.dialog and p2.dialog.componentRefs then
		for i, componentRef in ipairs(p2.dialog.componentRefs) do
			if data.componentMap[componentRef] then
				table.insert(v5.children, componentRef)
			end
		end
	end

	if not p2.components then
		return v6
	end

	if p2.components.title then
		v5.props.title = p2.components.title.text
	end

	if p2.components.subtitle then
		v5.props.subtitle = p2.components.subtitle.text
	end

	if p2.components.artifacts then
		v5.props.artifacts = p2.components.artifacts
	end

	for k, component in data.componentMap do
		local component2 = p2.components[k]

		if not component2 then
			continue
		end

		local name = component.name or k

		v6.components[name] = {
			name = name,
			component = component.component,
			props = module2.Dictionary.join({ params = component2 }, component.props or {})
		}
	end

	return v6
end

return class
