require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useProfileNames")

return function(p2, p3)
	if p2 == nil or p3 == nil then
		return nil
	end

	local name = p2.namesByUserId[tostring(p3)]

	if name then
		return name.combinedName
	end

	return nil
end
