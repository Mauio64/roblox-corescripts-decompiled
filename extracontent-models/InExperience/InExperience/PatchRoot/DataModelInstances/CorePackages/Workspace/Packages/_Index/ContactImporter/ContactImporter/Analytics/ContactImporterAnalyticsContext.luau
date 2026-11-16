local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local roact = dependencies.Roact
local dash = dependencies.Dash

return roact.createContext({ fireAnalyticsEvent = dash.noop })
