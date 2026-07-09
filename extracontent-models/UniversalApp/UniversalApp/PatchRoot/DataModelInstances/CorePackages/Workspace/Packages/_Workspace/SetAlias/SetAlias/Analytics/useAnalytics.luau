local ParentParent = script.Parent.Parent
local SetAliasAnalyticsContext = require(script.Parent.SetAliasAnalyticsContext)
local React = require(ParentParent.dependencies).React

return function() -- line: 8
	-- upvalues: React (copy), SetAliasAnalyticsContext (copy)
	return React.useContext(SetAliasAnalyticsContext)
end
