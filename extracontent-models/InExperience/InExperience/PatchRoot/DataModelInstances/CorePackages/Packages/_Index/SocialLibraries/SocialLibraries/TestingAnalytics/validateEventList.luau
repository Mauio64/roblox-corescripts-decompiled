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
local v13 = t.strictInterface({
	context = t.any,
	eventType = t.any,
	additionalInfo = t.optional(t.table),
	formatRulesForAdditionalInfo = t.optional(t.table)
})

return function(p1, t1: {[any]: any}?) -- line: 23
	-- upvalues: llama (copy), isEnum (copy), Contexts (copy), formatKeyValidationError (copy), EventTypes (copy), formatErrorForIncorrectKey (copy), v13 (copy), SubPages (copy), Pages (copy)
	llama.Dictionary.map(p1, function(p2, p3) -- line: 24
		-- upvalues: isEnum (copy), Contexts (copy), formatKeyValidationError (copy), EventTypes (copy), formatErrorForIncorrectKey (copy), v13 (copy), SubPages (copy), Pages (copy), llama (copy), t1 (copy)
		local v18 = if not isEnum(p3) then p3 else p3.rawValue()

		assert(Contexts.isEnumValue(p2.context), formatKeyValidationError("context", "a Context enum", v18))
		assert(EventTypes.isEnumValue(p2.eventType), formatKeyValidationError("eventType", "an EventType enum", v18))
		assert(type(p2.additionalInfo) == "table" or p2.additionalInfo == nil, formatKeyValidationError("additionalInfo", "nil or a table", v18))
		assert(type(p2.formatRulesForAdditionalInfo) == "table" or p2.formatRulesForAdditionalInfo == nil, formatKeyValidationError("formatRulesForAdditionalInfo", "nil or a table", v18))
		assert(formatErrorForIncorrectKey(v13)(p2, v18))

		if p2.additionalInfo then
			assert(p2.additionalInfo.subpage == nil or SubPages.isEnumValue(p2.additionalInfo.subpage), formatKeyValidationError("subpage additional info", "SubPages enum", v18))
			assert(p2.additionalInfo.page == nil or Pages.isEnumValue(p2.additionalInfo.page), formatKeyValidationError("page additional info", "Pages enum", v18))
			llama.Dictionary.map(t1 or {}, function(p4, p5) -- line: 53
				-- upvalues: p2 (copy), v18 (copy)
				assert(p4(p2.additionalInfo[p5]), p5 .. " key is invalid. Issue with: " .. v18)
			end)
		end
	end)

	return true
end
