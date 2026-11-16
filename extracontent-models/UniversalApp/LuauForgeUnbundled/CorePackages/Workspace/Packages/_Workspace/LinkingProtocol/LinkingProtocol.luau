require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Enums/DeepLinkSource")
require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Enums/SettingsRoute")
require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/LinkingProtocolTypes")

return {
	LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/LinkingProtocol"),
	AdConsentAttributionAdapter = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/AdConsentAttributionAdapter"),
	readCachedAdConsentRegion = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/readCachedAdConsentRegion"),
	getFFlagEnableAdConsentAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Flags/getFFlagEnableAdConsentAttribution"),
	Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Enums")
}
