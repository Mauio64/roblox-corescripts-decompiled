local parent = script.Parent.Parent.Parent.Parent

local Foundation = require(parent.Foundation)

local withCursorMigration = Foundation.UNSTABLE.withCursorMigration

local function SelectionCursorConsumer(p)
	return withCursorMigration(p)
end

return SelectionCursorConsumer
