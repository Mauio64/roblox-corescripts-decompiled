local Parent = script:FindFirstAncestor("AvatarExperienceServerDrivenUi").Parent
local mutedError = require(Parent.Loggers).mutedError

local function wrapZeroArgAction(p1: ((...any) -> ...any)?) -- line: 10
	-- upvalues: mutedError (copy)
	if typeof(p1) ~= "function" then
		if p1 ~= nil then
			mutedError(`Expected function, got { typeof(p1) }`)
		end

		return nil
	end

	return function() -- line: 17
		-- upvalues: p1 (copy)
		p1(nil, nil, nil)
	end
end

return wrapZeroArgAction
