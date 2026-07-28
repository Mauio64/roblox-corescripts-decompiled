local Parent = script:FindFirstAncestor("InterventionShared").Parent

return (require(Parent.AppCommonLib).Signal.new())
