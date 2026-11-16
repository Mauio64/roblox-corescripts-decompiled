local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

local function registerBackHandler(_)
	return function() end
end

return React.createContext(registerBackHandler)
