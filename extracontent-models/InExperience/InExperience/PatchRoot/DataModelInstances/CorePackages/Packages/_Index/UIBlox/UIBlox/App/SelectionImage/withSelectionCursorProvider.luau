local ParentParent = script.Parent.Parent.Parent.Parent
local withCursorMigration = require(ParentParent.Foundation).UNSTABLE.withCursorMigration

local function SelectionCursorConsumer(p1) -- line: 7
	-- upvalues: withCursorMigration (copy)
	return withCursorMigration(p1)
end

return SelectionCursorConsumer
