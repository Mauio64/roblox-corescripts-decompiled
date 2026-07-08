local Parent = script:FindFirstAncestor("SocialCommon").Parent
local FormFactor = require(Parent.FormFactor)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

return function() -- line: 7
	-- upvalues: useSelector (copy), FormFactor (copy)
	return useSelector(function(p1) -- line: 8
		-- upvalues: FormFactor (copy)
		return p1.FormFactor == FormFactor.Enums.FormFactor.WIDE
	end)
end
