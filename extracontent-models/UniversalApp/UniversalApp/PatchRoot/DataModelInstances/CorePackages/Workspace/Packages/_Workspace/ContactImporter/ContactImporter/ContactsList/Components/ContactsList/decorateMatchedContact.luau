local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local Dash = dependencies.Dash

require(ContactImporter.Common.LocalTypes)

local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

return function(p1, p2) -- line: 8
	-- upvalues: getDeepValue (copy), Dash (copy)
	local v7 = getDeepValue(p2 or {}, "hasSentRequest") or {}

	return Dash.map(p1 or {}, function(p3) -- line: 11
		-- upvalues: Dash (copy), v7 (copy)
		return Dash.join(p3, {
			isMatchedContact = true,
			hasSentRequest = v7[p3.contactId]
		})
	end)
end
