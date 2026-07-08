local Parent = script:FindFirstAncestor("AuthCommon").Parent

return require(Parent.AppCommonLib).Signal.new()
