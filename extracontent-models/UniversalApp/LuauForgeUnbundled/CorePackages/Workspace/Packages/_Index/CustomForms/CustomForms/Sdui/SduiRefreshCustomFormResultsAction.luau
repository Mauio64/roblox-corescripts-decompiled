local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/SduiCoreSystem")

local customFormEntry = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/customFormEntry")
local getSduiCustomFormVerticalRegistry = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Sdui/getSduiCustomFormVerticalRegistry")

local function isId(value): boolean
	return type(value) == "string" and value ~= ""
end

local function SduiRefreshCustomFormResultsAction(p2, p3, p4)
	local actionParams = if p2 then p2.actionParams else nil
	local entityId = if actionParams then actionParams.entityId else nil
	local formId = if actionParams then actionParams.formId else nil
	local cfVertical = if actionParams then actionParams.cfVertical else nil
	local configKey = p4.configKey
	local v5 = type(entityId) == "string" and entityId ~= ""

	if v5 then
		local v6 = type(formId) == "string" and formId ~= ""

		if v6 then
			local v7 = type(cfVertical) == "string" and cfVertical ~= ""

			if v7 then
				local v8 = type(configKey) == "string" and configKey ~= ""

				if v8 then
					assert(configKey, "checked above")

					local vertical = getSduiCustomFormVerticalRegistry().getVertical(cfVertical)
					local fetchResults = if vertical then vertical.fetchResults else nil

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
					}):andThen(function(p5)
						if p5 == nil then
							return nil
						end

						if customFormEntry.updateForm(configKey, formId, function()
							return p5
						end) then
							return nil
						end

						return Promise.reject(`Fresh data for form {formId} doesn't match its entry under {configKey}`)
					end)
				end
			end
		end
	end

	return Promise.resolve(nil)
end

return SduiRefreshCustomFormResultsAction
