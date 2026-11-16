local parent = script.Parent.Parent.Parent
local Enums = require(parent.Analytics.Enums)
local ContextTypes = Enums.ContextTypes

return function(p)
	if p == nil then
		return nil
	end

	return ContextTypes[p.rawValue()].rawValue()
end
