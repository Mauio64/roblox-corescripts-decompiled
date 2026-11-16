local parent = script:FindFirstAncestor("Moments").Parent

require(parent.React)
require(parent.Signals)

require(script.Parent.createPagerStore)

return {}
