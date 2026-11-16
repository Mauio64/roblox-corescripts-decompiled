local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/tutils")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local SduiConfigTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local validateInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/validateInterface")
local sduiTemplateInterface = SduiConfigTypes.SduiTemplateInterface

local v5 = {}

local function deepJoinArrays(p2, options)
	local copy = tutils.deepCopy(p2)
	local result = options or {}

	for k, v6 in copy do
		table.insert(result, v6)
	end

	return result
end

local function deepJoin(props, props2)
	if not props then
		return props2
	end

	local copy = tutils.deepCopy(props)

	for k, v7 in props2 or v5 do
		if typeof(v7) == "table" then
			copy[k] = deepJoin(copy[k], v7)
		else
			copy[k] = v7
		end
	end

	return copy
end

local class = {}
class.__index = class

function class.new(options)
	local v6 = {
		_registeredTemplates = options or {}
	}

	setmetatable(v6, class)

	return v6
end

function class:getTemplate(p3)
	return self._registeredTemplates[p3]
end

function class:shouldResolveTemplate(p3): boolean
	return p3.templateKey ~= nil and p3.templateKey ~= "NONE"
end

function class:resolveTemplateForConfig(state, p3, options): boolean
	local templateKey = state.templateKey

	if not templateKey or templateKey == "NONE" then
		return true
	end

	assert(templateKey, "templateKey must exist")

	local v6 = options or {}
	assert(v6, "seen exists")

	if v6[state] then
		p3.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.DetectedCycleInTemplates,
			{
				componentType = state.componentType,
				value = templateKey,
				message = `Found cycle in template with key {templateKey}`
			},
			p3.appPage
		)
		state.templateKey = "NONE"
		return false
	else
		v6[state] = true

		local registeredTemplate = self._registeredTemplates[templateKey]

		if registeredTemplate == nil then
			p3.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.FailedToFindTemplate,
				{
					componentType = state.componentType,
					value = templateKey,
					message = `Failed to find template for key {templateKey}`
				},
				p3.appPage
			)
			state.templateKey = "NONE"
			return false
		else
			assert(registeredTemplate, "template exists")

			local v7, v8 = validateInterface(registeredTemplate, sduiTemplateInterface, false)

			if not v7 then
				p3.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidComponentConfig, {
					message = `Invalid Template for templateKey {templateKey}. err: {v8}`,
					componentType = state.componentType or registeredTemplate.componentType,
					name = templateKey
				}, p3.appPage)
			end

			class.resolveTemplateForConfig(self, registeredTemplate, p3, v6)

			state.templateKey = "NONE"

			if state.componentType then
				if
					state.componentType
					and registeredTemplate.componentType
					and state.componentType ~= registeredTemplate.componentType
				then
					p3.dependencies.logger.reportError(
						SduiErrors.SduiErrorType.ComponentTypeMismatchWithTemplate,
						{
							componentType = state.componentType,
							value = templateKey,
							message = `Mismatch in componentType for template {templateKey}. Component {state.componentType} and template {registeredTemplate.componentType}`
						},
						p3.appPage
					)
					return false
				end
			else
				state.componentType = registeredTemplate.componentType
			end

			if registeredTemplate.analyticsData then
				state.analyticsData = Cryo.Dictionary.join(
					registeredTemplate.analyticsData,
					state.analyticsData or v5
				)
			end

			if registeredTemplate.props then
				local success, result = pcall(function()
					return (deepJoin(registeredTemplate.props, state.props))
				end)

				if success then
					state.props = result
				else
					p3.dependencies.logger.reportError(
						SduiErrors.SduiErrorType.FailedToJoinTemplateProps,
						{
							componentType = state.componentType,
							value = templateKey,
							message = result
						},
						p3.appPage
					)
				end
			end

			if registeredTemplate.children then
				local children = registeredTemplate.children
				local children2 = state.children or {}
				local copy = tutils.deepCopy(children)

				for k, v9 in copy do
					table.insert(children2, v9)
				end

				state.children = children2
			end

			if not registeredTemplate.conditionalProps then
				return true
			end

			local conditionalProps = registeredTemplate.conditionalProps
			local conditionalProps2 = state.conditionalProps or {}
			local copy = tutils.deepCopy(conditionalProps)

			for k, v9 in copy do
				table.insert(conditionalProps2, v9)
			end

			state.conditionalProps = conditionalProps2

			return true
		end
	end
end

return class
