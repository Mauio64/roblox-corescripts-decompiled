local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

return (require(Parent.Loggers).Logger:new("ServerTriggeredModals"))
