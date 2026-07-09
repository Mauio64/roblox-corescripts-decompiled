local Parent = script:FindFirstAncestor("CollectionViews").Parent

require(Parent.Style)
require(Parent.Foundation)
require(Parent.Signals)

return {
	CollectionItemSize = {
		XSmall = "XSmall",
		Small = "Small",
		Medium = "Medium",
		Large = "Large",
		XLarge = "XLarge"
	}
}
