local parent = script:FindFirstAncestor("ProgressLoading").Parent

local HttpService = game:GetService("HttpService")

local Http = require(parent.Http)
return Http.NetworkLayers.requestInternalWrapper(HttpService)
