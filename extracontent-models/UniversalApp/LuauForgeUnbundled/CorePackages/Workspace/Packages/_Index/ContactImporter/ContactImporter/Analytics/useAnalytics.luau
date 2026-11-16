local react = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies").React
local ContactImporterAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/ContactImporterAnalyticsContext")

return function()
	return react.useContext(ContactImporterAnalyticsContext)
end
