local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics")

return { new = SocialLuaAnalytics.Telemetry.new, contexts = SocialLuaAnalytics.Analytics.Enums.Contexts }
