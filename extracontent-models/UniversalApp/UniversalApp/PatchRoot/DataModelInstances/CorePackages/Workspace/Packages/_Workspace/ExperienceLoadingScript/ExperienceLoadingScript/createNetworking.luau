local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local HttpService = game:GetService("HttpService")

return require(Parent.Http).NetworkLayers.requestInternalWrapper(HttpService)
