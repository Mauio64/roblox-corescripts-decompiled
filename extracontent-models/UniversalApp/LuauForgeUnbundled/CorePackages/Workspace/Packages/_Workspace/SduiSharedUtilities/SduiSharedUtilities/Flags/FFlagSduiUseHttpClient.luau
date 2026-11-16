local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/HttpClient")

return game:DefineFastFlag("SduiUseHttpClient", false) and HttpClient.FFlagHttpClientRetryExtensions
