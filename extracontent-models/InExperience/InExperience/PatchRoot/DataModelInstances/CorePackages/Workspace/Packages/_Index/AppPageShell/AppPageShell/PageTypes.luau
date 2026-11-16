local parent = script:FindFirstAncestor("AppPageShell").Parent

local AppComposition = require(parent.AppComposition)
require(parent.Foundation)
require(parent.React)

local Layout = AppComposition.CompositionTags.Layout

return {}
