local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local React = require(Parent.React)
local getModalSignalStore = require(script.Parent.getModalSignalStore)

return function() -- line: 8
	-- upvalues: React (copy), getModalSignalStore (copy)
	return React.useMemo(function() -- line: 9
		-- upvalues: getModalSignalStore (copy)
		return getModalSignalStore(false)
	end, {})
end
