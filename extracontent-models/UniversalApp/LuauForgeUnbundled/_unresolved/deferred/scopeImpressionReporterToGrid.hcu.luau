require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local function scopeImpressionReporterToGrid(p2, callback)
	return function(p3)
		local current = p2.current

		if current and p3.visibleInstance:IsDescendantOf(current) then
			callback(p3)
		end
	end
end

return scopeImpressionReporterToGrid
