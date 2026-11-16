local CustomForms = script:FindFirstAncestor("CustomForms")
local parent = CustomForms.Parent

local Promise = require(parent.Promise)
require(parent.SduiCoreSystem)

local customFormEntry = require(CustomForms.Sdui.customFormEntry)
local getSduiCustomFormVerticalRegistry = require(CustomForms.Sdui.getSduiCustomFormVerticalRegistry)

local function isId(value): boolean -- 4 equivalent calls inferred from this helper
	return type(value) == "string" and value ~= ""
end

local function SduiRefreshCustomFormResultsAction(p, _, p2)
	local actionParams

	if p then
		actionParams = p.actionParams
	end

	local entityId

	if actionParams then
		entityId = actionParams.entityId
	end

	local formId

	if actionParams then
		formId = actionParams.formId
	else
		formId = nil
	end

	local cfVertical

	if actionParams then
		cfVertical = actionParams.cfVertical
	end

	local configKey = p2.configKey

	if isId(entityId) and isId(formId) and isId(cfVertical) and isId(configKey) then -- inferred equivalent call
		assert(configKey, "checked above")

		local vertical = getSduiCustomFormVerticalRegistry().getVertical(cfVertical)
		local fetchResults

		if vertical then
			fetchResults = vertical.fetchResults
		end

		if not fetchResults then
			return Promise.resolve(nil)
		end

		local form = customFormEntry.findForm(configKey, formId)

		if form == nil then
			return Promise.resolve(nil)
		end

		return Promise.try(fetchResults, {
			entityId = entityId,
			formId = formId,
			cfVertical = cfVertical,
			current = form
		}):andThen(function(p3)
			if p3 == nil then
				return nil
			end

			if customFormEntry.updateForm(configKey, formId, function()
				return p3
			end) then
				return nil
			end

			return Promise.reject(`Fresh data for form {formId} doesn't match its entry under {configKey}`)
		end)
	end

	return Promise.resolve(nil)
end

return SduiRefreshCustomFormResultsAction
