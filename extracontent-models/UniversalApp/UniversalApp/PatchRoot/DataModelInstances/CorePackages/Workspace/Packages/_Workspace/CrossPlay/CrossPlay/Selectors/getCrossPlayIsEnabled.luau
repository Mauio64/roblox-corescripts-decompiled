local CrossPlay = script:FindFirstAncestor("CrossPlay")

require(CrossPlay.Reducers.CrossPlaySettings)

local function getCrossPlayIsEnabled(p1) -- line: 6
	local CrossPlaySettings = p1.CrossPlaySettings

	return CrossPlaySettings.Status.isEnabled and CrossPlaySettings.Status.isSystemPrivilegeEnabled or false
end

return getCrossPlayIsEnabled
