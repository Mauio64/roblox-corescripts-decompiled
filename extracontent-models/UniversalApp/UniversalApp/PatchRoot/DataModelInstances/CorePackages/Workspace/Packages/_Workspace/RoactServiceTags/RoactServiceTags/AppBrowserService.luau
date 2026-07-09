local Parent = script:FindFirstAncestor("RoactServiceTags").Parent

return (require(Parent.RoactServices).RoactServices.createService(script.Name))
