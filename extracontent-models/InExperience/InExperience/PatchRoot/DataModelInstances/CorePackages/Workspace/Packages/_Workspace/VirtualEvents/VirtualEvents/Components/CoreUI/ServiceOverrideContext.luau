local parent = script.Parent.Parent.Parent.Parent

local SocialService = game:GetService("SocialService")

local React = require(parent.React)

return React.createContext({ socialService = SocialService })
