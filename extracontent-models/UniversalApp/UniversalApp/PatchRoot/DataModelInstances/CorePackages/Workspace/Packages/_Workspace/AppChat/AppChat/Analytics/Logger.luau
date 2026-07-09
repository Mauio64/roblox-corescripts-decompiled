local Parent = script:FindFirstAncestor("AppChat").Parent

return (require(Parent.Loggers).Logger:new("AppChat Analytics"))
