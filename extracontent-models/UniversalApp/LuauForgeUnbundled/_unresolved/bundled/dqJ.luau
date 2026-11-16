local module = require("@luauforge/bundled/dqz")
local discoveryEventErrorLogger = require("@luauforge/bundled/dqK").DiscoveryEventErrorLogger
local fFlagSafetyResourceBannerTelemetry = require("@luauforge/bundled/dqB").FFlagSafetyResourceBannerTelemetry

local v5 = {}

function v5.new()
	return {}
end

function v5.fromTextSearchEntryJson(data)
	if type(data) ~= "table" then
		return module.error("TextSearchEntry.fromTextSearchEntryJson expects textSearchEntryJson to be a table")
	end

	if type(data.name) ~= "string" then
		return module.error("TextSearchEntry.fromTextSearchEntryJson expects textSearchEntryJson.name to be a string")
	end

	if data.contentType ~= "Text" then
		return module.error("TextSearchEntry.fromTextSearchEntryJson expects textSearchEntryJson.contentType to be 'Text'")
	end

	local v6 = v5.new()

	v6.text = data.name

	if fFlagSafetyResourceBannerTelemetry then
		local safetyResource = data.safetyResource

		if safetyResource ~= nil then
			local v7 = {}

			if type(safetyResource) == "table" then
				if
					type(safetyResource.moderationCategory) ~= "string"
					or safetyResource.moderationCategory == ""
				then
					table.insert(v7, "moderationCategory")
				end

				if
					type(safetyResource.textFilterRequestId) ~= "string"
					or safetyResource.textFilterRequestId == ""
				then
					table.insert(v7, "textFilterRequestId")
				end
			else
				table.insert(v7, "safetyResource (expected table)")
			end

			if #v7 == 0 then
				v6.safetyResource = {
					moderationCategory = safetyResource.moderationCategory,
					textFilterRequestId = safetyResource.textFilterRequestId
				}
			else
				discoveryEventErrorLogger.reportError(
					"SafetyResourceBannerInvalidMetadata",
					`Missing or empty fields: {table.concat(v7, ", ")}`
				)
			end
		end
	end

	return module.success(v6)
end

return v5
