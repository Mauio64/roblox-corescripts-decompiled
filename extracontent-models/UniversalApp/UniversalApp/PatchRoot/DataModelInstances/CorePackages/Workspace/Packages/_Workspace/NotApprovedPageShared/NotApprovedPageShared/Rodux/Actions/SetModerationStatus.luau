local Parent = script:FindFirstAncestor("NotApprovedPageShared").Parent
local ArgCheck = require(Parent.ArgCheck)

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 7
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "boolean", "SetModerationStatus action expects `moderationStatus` to be a boolean")

	return {
		userModerated = p1
	}
end)
