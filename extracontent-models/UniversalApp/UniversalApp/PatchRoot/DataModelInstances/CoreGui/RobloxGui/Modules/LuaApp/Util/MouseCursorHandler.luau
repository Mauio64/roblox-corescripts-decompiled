local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local handleMouseCursor = require(script.Parent.handleMouseCursor)

local function MouseCursorHandler() -- line: 6
	-- upvalues: React (copy), handleMouseCursor (copy)
	React.useEffect(function() -- line: 7
		-- upvalues: handleMouseCursor (copy)
		return handleMouseCursor()
	end, {})

	return nil
end

return MouseCursorHandler
