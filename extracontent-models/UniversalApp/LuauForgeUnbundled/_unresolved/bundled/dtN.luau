local makeActionCreator = require("@luauforge/bundled/dtw").makeActionCreator
require("@luauforge/bundled/dtL")

return makeActionCreator("AddTextSearchResults", function(data)
	return { searchUuid = data.searchUuid, topicId = data.topicId, entry = data.entry }
end)
