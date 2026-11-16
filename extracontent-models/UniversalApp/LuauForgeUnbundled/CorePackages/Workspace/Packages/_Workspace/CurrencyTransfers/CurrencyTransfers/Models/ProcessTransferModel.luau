local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/t")

local class = {}

function class.new(p2)
	assert(class.isValid(p2))

	class.__index = class

	setmetatable(p2, class)

	return p2
end

function class.mock(options)
	return (class.new({
		success = (options or {}).success or true
	}))
end

function class.format(p2)
	return (class.new({ success = p2.success }))
end

class.isValid = t.strictInterface({ success = t.boolean })

return class
