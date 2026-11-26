local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local dash = dependencies.Dash
require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/LocalTypes")
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

return function(options, options2)
	local v5 = getDeepValue(options2 or {}, "hasSentRequest") or {}

	return dash.map(options or {}, function(p2)
		return dash.join(p2, {
			hasSentRequest = v5[p2.contactId],
			isMatchedContact = true
		})
	end)
end
