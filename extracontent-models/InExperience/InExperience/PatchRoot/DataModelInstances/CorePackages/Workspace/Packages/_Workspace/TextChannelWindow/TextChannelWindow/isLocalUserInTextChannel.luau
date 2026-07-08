local findLocalTextSource = require(script.Parent.findLocalTextSource)

local function isLocalUserInTextChannel(p1, s1: string) -- line: 6
	-- upvalues: findLocalTextSource (copy)
	return findLocalTextSource(p1, s1) ~= nil
end

return isLocalUserInTextChannel
