local Parent = script:FindFirstAncestor("InlineRichText").Parent

return (require(Parent.Loggers).Logger:new("InlineRichText"))
