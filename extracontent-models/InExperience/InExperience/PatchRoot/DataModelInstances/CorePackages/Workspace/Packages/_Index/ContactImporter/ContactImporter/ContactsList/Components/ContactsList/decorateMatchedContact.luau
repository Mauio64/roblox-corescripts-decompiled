local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local dash = dependencies.Dash
require(ContactImporter.Common.LocalTypes)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

return function(options, options2)
	local v = getDeepValue(options2 or {}, "hasSentRequest") or {}

	return dash.map(options or {}, function(p)
		return dash.join(p, { hasSentRequest = v[p.contactId], isMatchedContact = true })
	end)
end
