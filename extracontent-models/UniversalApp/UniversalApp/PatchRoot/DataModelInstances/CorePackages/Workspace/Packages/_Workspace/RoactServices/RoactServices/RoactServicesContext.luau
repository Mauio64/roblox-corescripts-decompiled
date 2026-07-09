local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)

require(script.Parent.RoactServicesTypes)

return (Roact.createContext(nil))
