local parent = script:FindFirstAncestor("SocialCarousel").Parent

local React = require(parent.React)

require(script.Parent.createMarqueeSessionStore)

return { MarqueeSessionContext = React.createContext(nil) }
