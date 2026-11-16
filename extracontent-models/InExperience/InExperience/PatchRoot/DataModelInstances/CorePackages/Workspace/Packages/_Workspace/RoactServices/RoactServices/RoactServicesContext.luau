local parent = script.Parent.Parent
local Roact = require(parent.Roact)

require(script.Parent.RoactServicesTypes)

return (Roact.createContext(nil))
