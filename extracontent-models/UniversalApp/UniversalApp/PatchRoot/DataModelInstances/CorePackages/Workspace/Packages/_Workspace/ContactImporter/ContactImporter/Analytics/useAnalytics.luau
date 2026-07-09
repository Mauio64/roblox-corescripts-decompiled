local ParentParent = script.Parent.Parent
local React = require(ParentParent.dependencies).React
local ContactImporterAnalyticsContext = require(script.Parent.ContactImporterAnalyticsContext)

return function() -- line: 6
	-- upvalues: React (copy), ContactImporterAnalyticsContext (copy)
	return React.useContext(ContactImporterAnalyticsContext)
end
