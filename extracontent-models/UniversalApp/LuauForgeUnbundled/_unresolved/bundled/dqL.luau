local makeActionCreator = require("@luauforge/bundled/dqu").makeActionCreator
require("@luauforge/bundled/dqJ")

return makeActionCreator("AddTextSearchResults", function(data)
	return { searchUuid = data.searchUuid, topicId = data.topicId, entry = data.entry }
end)
