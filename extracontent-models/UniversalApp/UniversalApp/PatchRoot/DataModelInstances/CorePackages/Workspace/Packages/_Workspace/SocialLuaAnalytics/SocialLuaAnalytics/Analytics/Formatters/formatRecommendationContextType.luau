local ParentParent = script.Parent.Parent.Parent
local RecommendationContextTypes = require(ParentParent.Analytics.Enums).RecommendationContextTypes

return function(p1) -- line: 5
	-- upvalues: RecommendationContextTypes (copy)
	if p1 == nil then
		return nil
	end

	return RecommendationContextTypes[p1.rawValue()].rawValue()
end
