local module = require("@luauforge/deferred/giZ")

local v5 = {
	[1] = module.Duplicate,
	[2] = module.NameNotAllowed,
	[3] = module.NameNotAllowed,
	[4] = module.FolderLimit,
	[409] = module.Duplicate,
	[400] = module.NameNotAllowed
}

local function mapFolderMutationError(p2)
	local responseCode = if typeof(p2) == "table" then p2.responseCode else nil

	if typeof(responseCode) == "number" then
		return v5[responseCode] or module.Generic
	end

	return module.Generic
end

return mapFolderMutationError
