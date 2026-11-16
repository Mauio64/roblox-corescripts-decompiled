local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.Hooks.useProfileNames)

return function(p, p2)
	if p == nil or p2 == nil then
		return nil
	end

	local name = p.namesByUserId[tostring(p2)]
	return if name then name.combinedName else nil
end
