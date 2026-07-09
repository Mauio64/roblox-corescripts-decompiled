local DetailsPageLayoutRoot = require(script.DetailsPageLayoutRoot)
local DetailsPageLayoutHeader = require(script.DetailsPageLayoutHeader)
local DetailsPageLayoutContent = require(script.DetailsPageLayoutContent)
local DetailsPageLayoutActions = require(script.DetailsPageLayoutActions)

return {
	Root = DetailsPageLayoutRoot,
	Header = DetailsPageLayoutHeader,
	Content = DetailsPageLayoutContent,
	Actions = DetailsPageLayoutActions,
	DetailsPageLayoutContext = require(script.DetailsPageLayoutContext)
}
