local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local React = require(parent.React)

local getModalSignalStore = require(script.Parent.getModalSignalStore)

return function()
	return React.useMemo(function()
		return getModalSignalStore(false)
	end, {})
end
