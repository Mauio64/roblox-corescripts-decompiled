local parent = script:FindFirstAncestor("RoactServiceTags").Parent

local RoactServices = require(parent.RoactServices)
return (RoactServices.RoactServices.createService(script.Name))
