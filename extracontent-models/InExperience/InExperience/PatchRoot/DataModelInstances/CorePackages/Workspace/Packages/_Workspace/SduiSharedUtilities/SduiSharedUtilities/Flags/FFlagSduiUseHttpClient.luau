local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent

local HttpClient = require(parent.HttpClient)

return game:DefineFastFlag("SduiUseHttpClient", false) and HttpClient.FFlagHttpClientRetryExtensions
