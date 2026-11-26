local module = require("@luauforge/bundled/fyW")
local module2 = require("@luauforge/bundled/fzF")
return require("@luauforge/bundled/dFr").makeActionCreator("UpdatePromptType", function(p2, p3, p4)
	local v5

	if p3 == nil then
		v5 = true
	else
		v5 = module2.isEnumValue(p3)

		if not v5 then
			if p2 then
				v5 = typeof(p4) == "table" and module.isEnumValue(module.fromRawValue(p4.displayType))
			else
				v5 = p2
			end
		end
	end

	assert(v5, "Expected the passed prompt type must either be a valid enum value or nil")

	return {
		isGeneric = p2,
		promptType = p3,
		metadata = p4,
		lastUpdatedPromptTypeAt = DateTime.now()
	}
end)
