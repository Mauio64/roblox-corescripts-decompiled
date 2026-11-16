local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local llama = dependencies.llama
local Enums = require(script.Parent.Parent.Analytics.Enums)
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local SubPages = Enums.SubPages
local Pages = Enums.Pages
require(script.Parent.Parent.Analytics.FireEvent.Types)
local isEnum = require(script.Parent.Parent.Utils.isEnum)
local t = dependencies.t
local formatKeyValidationError = require(script.Parent.formatKeyValidationError)
local formatErrorForIncorrectKey = require(script.Parent.formatErrorForIncorrectKey)

local strictInterface = t.strictInterface({
	context = t.any,
	eventType = t.any,
	additionalInfo = t.optional(t.table),
	formatRulesForAdditionalInfo = t.optional(t.table)
})

return function(p, options): boolean
	llama.Dictionary.map(p, function(data, p2)
		if isEnum(p2) then
			p2 = p2.rawValue()
		end

		assert(Contexts.isEnumValue(data.context), formatKeyValidationError("context", "a Context enum", p2))
		assert(EventTypes.isEnumValue(data.eventType), formatKeyValidationError("eventType", "an EventType enum", p2))

		assert(
			type(data.additionalInfo) == "table" or data.additionalInfo == nil,
			formatKeyValidationError("additionalInfo", "nil or a table", p2)
		)

		assert(
			type(data.formatRulesForAdditionalInfo) == "table" or data.formatRulesForAdditionalInfo == nil,
			formatKeyValidationError("formatRulesForAdditionalInfo", "nil or a table", p2)
		)

		assert(formatErrorForIncorrectKey(strictInterface)(data, p2))

		if data.additionalInfo then
			assert(
				data.additionalInfo.subpage == nil or SubPages.isEnumValue(data.additionalInfo.subpage),
				formatKeyValidationError("subpage additional info", "SubPages enum", p2)
			)

			assert(
				data.additionalInfo.page == nil or Pages.isEnumValue(data.additionalInfo.page),
				formatKeyValidationError("page additional info", "Pages enum", p2)
			)

			llama.Dictionary.map(options or {}, function(callback, p3)
				assert(callback(data.additionalInfo[p3]), p3 .. " key is invalid. Issue with: " .. p2)
			end)
		end
	end)

	return true
end
