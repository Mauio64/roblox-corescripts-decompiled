local Parent = script:FindFirstAncestor("UiShellEvents").Parent

return (require(Parent.Loggers).Logger:new("UiShellEvents"))
