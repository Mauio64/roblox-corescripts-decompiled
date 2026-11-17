local parent = script:FindFirstAncestor("SocialCarousel").Parent
local React = require(parent.React)

return { MarqueeScrollContext = React.createContext(nil) }
