local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local react = dependencies.React
local ContactImporterAnalyticsContext = require(script.Parent.ContactImporterAnalyticsContext)

return function()
	return react.useContext(ContactImporterAnalyticsContext)
end
