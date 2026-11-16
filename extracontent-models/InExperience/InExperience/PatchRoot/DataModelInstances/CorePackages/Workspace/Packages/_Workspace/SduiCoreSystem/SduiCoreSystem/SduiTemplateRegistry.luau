local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local Cryo = require(parent.Cryo)
local tutils = require(parent.tutils)

require(SduiCoreSystem.SduiBuilderTypes)
local SduiConfigTypes = require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local validateInterface = require(SduiCoreSystem.validateInterface)
local SduiTemplateInterface = SduiConfigTypes.SduiTemplateInterface

local v = {}

local function deepJoinArrays(p, options)
	local copy = tutils.deepCopy(p)
	local result = options or {}

	for _, v2 in copy do
		table.insert(result, v2)
	end

	return result
end

local function deepJoin(props, props2)
	if not props then
		return props2
	end

	local copy = tutils.deepCopy(props)

	for k, v2 in props2 or v do
		if typeof(v2) == "table" then
			copy[k] = deepJoin(copy[k], v2)
		else
			copy[k] = v2
		end
	end

	return copy
end

local SduiTemplateRegistry = {}
SduiTemplateRegistry.__index = SduiTemplateRegistry

function SduiTemplateRegistry.new(options)
	local v2 = {
		_registeredTemplates = options or {}
	}

	setmetatable(v2, SduiTemplateRegistry)

	return v2
end

function SduiTemplateRegistry:getTemplate(p: string)
	return self._registeredTemplates[p]
end

function SduiTemplateRegistry.shouldResolveTemplate(_, p): boolean
	return p.templateKey ~= nil and p.templateKey ~= "NONE"
end

function SduiTemplateRegistry:resolveTemplateForConfig(state, p, options): boolean
	local templateKey = state.templateKey

	if not templateKey or templateKey == "NONE" then
		return true
	end

	assert(templateKey, "templateKey must exist")

	local v2 = options or {}
	assert(v2, "seen exists")

	if v2[state] then
		p.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.DetectedCycleInTemplates,
			{
				componentType = state.componentType,
				value = templateKey,
				message = `Found cycle in template with key {templateKey}`
			},
			p.appPage
		)
		state.templateKey = "NONE"
		return false
	else
		v2[state] = true

		local registeredTemplate = self._registeredTemplates[templateKey]

		if registeredTemplate == nil then
			p.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.FailedToFindTemplate,
				{
					componentType = state.componentType,
					value = templateKey,
					message = `Failed to find template for key {templateKey}`
				},
				p.appPage
			)
			state.templateKey = "NONE"
			return false
		else
			assert(registeredTemplate, "template exists")

			local v3, v4 = validateInterface(registeredTemplate, SduiTemplateInterface, false)

			if not v3 then
				p.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidComponentConfig, {
					message = `Invalid Template for templateKey {templateKey}. err: {v4}`,
					componentType = state.componentType or registeredTemplate.componentType,
					name = templateKey
				}, p.appPage)
			end

			SduiTemplateRegistry.resolveTemplateForConfig(self, registeredTemplate, p, v2)

			state.templateKey = "NONE"

			if state.componentType then
				if
					state.componentType
					and registeredTemplate.componentType
					and state.componentType ~= registeredTemplate.componentType
				then
					p.dependencies.logger.reportError(
						SduiErrors.SduiErrorType.ComponentTypeMismatchWithTemplate,
						{
							componentType = state.componentType,
							value = templateKey,
							message = `Mismatch in componentType for template {templateKey}. Component {state.componentType} and template {registeredTemplate.componentType}`
						},
						p.appPage
					)
					return false
				end
			else
				state.componentType = registeredTemplate.componentType
			end

			if registeredTemplate.analyticsData then
				state.analyticsData = Cryo.Dictionary.join(registeredTemplate.analyticsData, state.analyticsData or v)
			end

			if registeredTemplate.props then
				local success, result = pcall(function()
					return (deepJoin(registeredTemplate.props, state.props))
				end)

				if success then
					state.props = result
				else
					p.dependencies.logger.reportError(
						SduiErrors.SduiErrorType.FailedToJoinTemplateProps,
						{
							componentType = state.componentType,
							value = templateKey,
							message = result
						},
						p.appPage
					)
				end
			end

			if registeredTemplate.children then
				local children = registeredTemplate.children
				local children2 = state.children or {}
				local copy = tutils.deepCopy(children)

				for _, v5 in copy do
					table.insert(children2, v5)
				end

				state.children = children2
			end

			if not registeredTemplate.conditionalProps then
				return true
			end

			local conditionalProps = registeredTemplate.conditionalProps
			local conditionalProps2 = state.conditionalProps or {}
			local copy = tutils.deepCopy(conditionalProps)

			for _, v5 in copy do
				table.insert(conditionalProps2, v5)
			end

			state.conditionalProps = conditionalProps2

			return true
		end
	end
end

return SduiTemplateRegistry
