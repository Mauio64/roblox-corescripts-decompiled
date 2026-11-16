local parent = script:FindFirstAncestor("CollectionViews").Parent
require(parent.Style)
require(parent.Foundation)
require(parent.Signals)

return {
	CollectionItemSize = {
		XSmall = "XSmall",
		Small = "Small",
		Medium = "Medium",
		Large = "Large",
		XLarge = "XLarge"
	}
}
