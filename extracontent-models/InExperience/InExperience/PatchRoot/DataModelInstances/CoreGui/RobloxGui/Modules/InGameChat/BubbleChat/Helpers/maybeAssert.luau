local GlobalConfig = require(script.Parent.Parent.GlobalConfig)

local function maybeAssert(...) -- line: 4
	-- upvalues: GlobalConfig (copy)
	if GlobalConfig.actionValidation then
		return assert(...)
	end
end

return maybeAssert
