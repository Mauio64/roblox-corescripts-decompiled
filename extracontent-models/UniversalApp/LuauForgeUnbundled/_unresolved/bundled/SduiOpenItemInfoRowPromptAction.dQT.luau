local itemDetailsSduiHost = require("@luauforge/bundled/dQp").ItemDetailsSduiHost

local module = require("@luauforge/bundled/dQa")
local sduiActionType = module.SduiActionType
local sduiErrorType = module.SduiErrors.SduiErrorType

local function readOptionalString(value)
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function readSections(sections)
	local result = {}

	if typeof(sections) ~= "table" then
		return result, sections ~= nil
	end

	local v5 = false

	for k, item in sections do
		if typeof(item) ~= "table" then
			item = nil
		end

		local heading

		if item then
			heading = item.heading

			if typeof(heading) ~= "string" or heading == "" then
				heading = nil
			end
		end

		local body

		if item then
			body = item.body

			if typeof(body) ~= "string" or body == "" then
				body = nil
			end
		end

		if heading == nil or body == nil then
			v5 = true
		else
			table.insert(result, { heading = heading, body = body })
		end
	end

	return result, v5
end

local function SduiOpenItemInfoRowPromptAction(p2, p3, data, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenItemInfoRowPrompt,
				message = "Missing actionParams"
			},
			data.appPage
		)
		return
	end

	local title = actionParams.title

	if typeof(title) ~= "string" or title == "" then
		title = nil
	end

	local message = actionParams.message

	if typeof(message) ~= "string" or message == "" then
		message = nil
	end

	local v5, v6 = readSections(actionParams.sections)

	if v6 then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenItemInfoRowPrompt,
				message = "Dropped sections without both a heading and a body",
				propName = "sections"
			},
			data.appPage
		)
	end

	if title == nil and message == nil and #v5 == 0 then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenItemInfoRowPrompt,
				message = "The prompt needs a title, a message, or at least one section"
			},
			data.appPage
		)
		return
	end

	local v7 = itemDetailsSduiHost.get(data.configKey)

	if v7 == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{
				name = sduiActionType.OpenItemInfoRowPrompt,
				message = "No Item Details page is mounted for this configKey"
			},
			data.appPage
		)
		return
	end

	local openItemInfoRowPrompt = v7.openItemInfoRowPrompt

	if not (#v5 > 0) then
		v5 = nil
	end

	openItemInfoRowPrompt({ title = title, message = message, sections = v5 })
end

return SduiOpenItemInfoRowPromptAction
