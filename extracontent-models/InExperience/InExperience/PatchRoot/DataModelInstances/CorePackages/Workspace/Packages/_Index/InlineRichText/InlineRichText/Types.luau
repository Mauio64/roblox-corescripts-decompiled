local parent = script:FindFirstAncestor("InlineRichText").Parent

require(parent.Foundation)
require(parent.InlineLayout)
require(script.Parent.Enums.TokenName)
require(script.Parent.Enums.NodeType)
require(script.Parent.Enums.LinkType)
require(script.Parent.Enums.LinkBehavior)

return {}
