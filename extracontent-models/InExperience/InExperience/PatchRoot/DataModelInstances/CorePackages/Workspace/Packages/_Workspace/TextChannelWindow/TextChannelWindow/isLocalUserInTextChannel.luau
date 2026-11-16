local findLocalTextSource = require(script.Parent.findLocalTextSource)

local function isLocalUserInTextChannel(p, p2: string): boolean
	return findLocalTextSource(p, p2) ~= nil
end

return isLocalUserInTextChannel
