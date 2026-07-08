local ParentParent = script.Parent.Parent.Parent
local ContextTypes = require(ParentParent.Analytics.Enums).ContextTypes

return function(p1) -- line: 6
	-- upvalues: ContextTypes (copy)
	if p1 == nil then
		return nil
	end

	return ContextTypes[p1.rawValue()].rawValue()
end
