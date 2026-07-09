local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)
local tutils = require(SduiCoreSystemParent.tutils)

require(SduiCoreSystem.SduiBuilderTypes)

local SduiConfigTypes = require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local validateInterface = require(SduiCoreSystem.validateInterface)
local SduiTemplateInterface = SduiConfigTypes.SduiTemplateInterface
local t1 = {}

local function deepJoinArrays(p1, p2) -- line: 26
	-- upvalues: tutils (copy)
	local v15 = p2 or {}

	for _, v17 in (tutils.deepCopy(p1)) do
		table.insert(v15, v17)
	end

	return v15
end
local function deepJoin(p3, p4) -- line: 36
	-- upvalues: t1 (copy), tutils (copy), deepJoin (copy)
	if not p3 then
		return p4
	end

	local v20 = p4 or t1
	local v21 = tutils.deepCopy(p3)

	for v22, v23 in v20 do
		if typeof(v23) == "table" then
			v21[v22] = deepJoin(v21[v22], v23)
		else
			v21[v22] = v23
		end
	end

	return v21
end

local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 60
	-- upvalues: t2 (copy)
	local t4 = {
		_registeredTemplates = t3 or {}
	}

	setmetatable(t4, t2)

	return t4
end
function t2.getTemplate(p5, s1: string) -- line: 69
	return p5._registeredTemplates[s1]
end
function t2.shouldResolveTemplate(_, p7) -- line: 73
	return p7.templateKey ~= nil and p7.templateKey ~= "NONE"
end
function t2.resolveTemplateForConfig(p8, p9, p10, t5: {[any]: any}?) -- line: 80
	-- upvalues: SduiErrors (copy), validateInterface (copy), SduiTemplateInterface (copy), t2 (copy), Cryo (copy), t1 (copy), deepJoin (copy), tutils (copy)
	local templateKey = p9.templateKey

	if not templateKey or templateKey == "NONE" then
		return true
	end

	assert(templateKey, "templateKey must exist")

	local v35 = t5 or {}

	assert(v35, "seen exists")

	if v35[p9] then
		p10.dependencies.logger.reportError(SduiErrors.SduiErrorType.DetectedCycleInTemplates, {
			componentType = p9.componentType,
			value = templateKey,
			message = `Found cycle in template with key { templateKey }`
		}, p10.appPage)
		p9.templateKey = "NONE"

		return false
	end

	v35[p9] = true

	local v36 = p8._registeredTemplates[templateKey]

	if v36 == nil then
		p10.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToFindTemplate, {
			componentType = p9.componentType,
			value = templateKey,
			message = `Failed to find template for key { templateKey }`
		}, p10.appPage)
		p9.templateKey = "NONE"

		return false
	end

	assert(v36, "template exists")

	local v37, v38 = validateInterface(v36, SduiTemplateInterface, false)

	if not v37 then
		p10.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidComponentConfig, {
			message = `Invalid Template for templateKey { templateKey }. err: { v38 }`,
			componentType = p9.componentType or v36.componentType,
			name = templateKey
		}, p10.appPage)
	end

	t2.resolveTemplateForConfig(p8, v36, p10, v35)
	p9.templateKey = "NONE"

	if not p9.componentType then
		p9.componentType = v36.componentType
	elseif p9.componentType and v36.componentType and p9.componentType ~= v36.componentType then
		p10.dependencies.logger.reportError(SduiErrors.SduiErrorType.ComponentTypeMismatchWithTemplate, {
			componentType = p9.componentType,
			value = templateKey,
			message = `Mismatch in componentType for template { templateKey }. Component { p9.componentType } and template { v36.componentType }`
		}, p10.appPage)

		return false
	end

	if v36.analyticsData then
		p9.analyticsData = Cryo.Dictionary.join(v36.analyticsData, p9.analyticsData or t1)
	end

	if v36.props then
		local ok, result = pcall(function() -- line: 158
			-- upvalues: deepJoin (copy), v36 (copy), p9 (copy)
			return (deepJoin(v36.props, p9.props))
		end)

		if not ok then
			p10.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToJoinTemplateProps, {
				componentType = p9.componentType,
				value = templateKey,
				message = result
			}, p10.appPage)
		else
			p9.props = result
		end
	end

	if v36.children then
		local children = v36.children
		local v42 = p9.children or {}

		for _, v44 in (tutils.deepCopy(children)) do
			table.insert(v42, v44)
		end

		p9.children = v42
	end

	if v36.conditionalProps then
		local conditionalProps = v36.conditionalProps
		local v46 = p9.conditionalProps or {}

		for _, v48 in (tutils.deepCopy(conditionalProps)) do
			table.insert(v46, v48)
		end

		p9.conditionalProps = v46
	end

	return true
end

return t2
