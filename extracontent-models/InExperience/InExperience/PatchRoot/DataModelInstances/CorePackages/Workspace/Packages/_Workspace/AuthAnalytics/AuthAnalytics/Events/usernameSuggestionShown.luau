local ParentParent = script.Parent.Parent
local checkAndSendEvent = require(ParentParent.Utils.checkAndSendEvent)

return function(s1: string, s2: string, t1: {[any]: any}, s3: string) -- line: 7
	-- upvalues: checkAndSendEvent (copy)
	assert(type(t1) == "table", "Expected suggestions to be a table")

	local t2 = {
		state = s2,
		suggestions = `[{ table.concat(t1, ",") }]`,
		field = s3
	}

	checkAndSendEvent(s1, "usernameSuggestionShown", t2)
end
