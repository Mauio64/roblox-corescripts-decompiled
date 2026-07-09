local Parent = script:FindFirstAncestor("GameIconRodux").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator
local ArgCheck = require(Parent.ArgCheck)

return makeActionCreator(script.Name, function(p1) -- line: 10
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "iconsTable")

	return {
		gameIcons = p1
	}
end)
