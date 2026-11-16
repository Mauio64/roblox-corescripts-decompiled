local authConsoleLayoutTokenMapper = require("@game/CorePackages/Workspace/Packages/AuthCommon").DesignTokenMappers.authConsoleLayoutTokenMapper
local abuseReportingTokenMapper

if require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAbuseReport10ft() then
	abuseReportingTokenMapper = require("@luauforge/bundled/hyW").abuseReportingTokenMapper
end

local experienceDetailsTokenMapper = require("@luauforge/bundled/dpZ").Modules.LuaApp.DesignTokenMappers.experienceDetailsTokenMapper
local multiPageSignupTokenMapper, activationFrameworkTokenMapper

if require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableMultiPageSignup() then
	multiPageSignupTokenMapper = require("@luauforge/bundled/hBm").Components.MultiPageSignupTokenMapper

	activationFrameworkTokenMapper = require("@luauforge/bundled/hXM").Components.ActivationFrameworkTokenMapper
end

return {
	App = require("@luauforge/bundled/hXN"),
	HomeOmniFeed = require("@luauforge/bundled/hXO"),
	Search = require("@luauforge/bundled/hXP"),
	SeeAll = require("@luauforge/bundled/hXQ"),
	ExperienceDetails = experienceDetailsTokenMapper,
	AuthConsoleLayout = authConsoleLayoutTokenMapper,
	LoginView = require("@luauforge/bundled/hXR"),
	SignUpView = require("@luauforge/bundled/hXS"),
	AuthCompliance = require("@luauforge/bundled/hXT"),
	LandingPage = require("@luauforge/bundled/hXU"),
	Layout = require("@luauforge/bundled/hXV"),
	AbuseReporting = abuseReportingTokenMapper,
	More = require("@luauforge/bundled/hXW"),
	CrossDeviceLogin = require("@luauforge/bundled/hXX"),
	FriendsLanding = require("@luauforge/bundled/hXY"),
	GamepadDisconnect = require("@luauforge/bundled/fuE").Gamepad.GamepadDisconnectTokenMapper,
	Banner = require("@luauforge/bundled/hXZ"),
	MultiPageSignup = multiPageSignupTokenMapper,
	ActivationFramework = activationFrameworkTokenMapper
}
