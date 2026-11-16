local module = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/Contexts")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/Sources")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/PresenceTypes")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/SubPages")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/FriendStatuses")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/EventTypes")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/Pages")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/RecommendationContextTypes")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/ContextualInfoTypes")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/DiagEventTypes")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/PlatformSpecificity")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/LoadingStages")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/EntityTypes")

return {
	Contexts = module,
	Sources = module2,
	EventTypes = module6,
	FriendStatuses = module5,
	PresenceTypes = module3,
	SubPages = module4,
	Pages = module7,
	RecommendationContextTypes = module8,
	ContextualInfoTypes = module9,
	DiagEventTypes = module10,
	PlatformSpecificity = module11,
	LoadingStages = module12,
	SupportedTelemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/SupportedTelemetryBackends"),
	EntityTypes = module13
}
