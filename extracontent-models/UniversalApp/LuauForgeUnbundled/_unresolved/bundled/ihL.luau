local authConsoleLayoutTokenMapper = require("@game/CorePackages/Workspace/Packages/AuthCommon").DesignTokenMappers.authConsoleLayoutTokenMapper
local abuseReportingTokenMapper

if require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAbuseReport10ft() then
	abuseReportingTokenMapper = require("@luauforge/bundled/hKm").abuseReportingTokenMapper
end

local experienceDetailsTokenMapper = require("@luauforge/bundled/dtb").Modules.LuaApp.DesignTokenMappers.experienceDetailsTokenMapper
local multiPageSignupTokenMapper, activationFrameworkTokenMapper

if require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableMultiPageSignup() then
	multiPageSignupTokenMapper = require("@luauforge/bundled/hMD").Components.MultiPageSignupTokenMapper

	activationFrameworkTokenMapper = require("@luauforge/bundled/ihM").Components.ActivationFrameworkTokenMapper
end

return {
	App = require("@luauforge/bundled/ihN"),
	HomeOmniFeed = require("@luauforge/bundled/ihO"),
	Search = require("@luauforge/bundled/ihP"),
	SeeAll = require("@luauforge/bundled/ihQ"),
	ExperienceDetails = experienceDetailsTokenMapper,
	AuthConsoleLayout = authConsoleLayoutTokenMapper,
	LoginView = require("@luauforge/bundled/ihR"),
	SignUpView = require("@luauforge/bundled/ihS"),
	AuthCompliance = require("@luauforge/bundled/ihT"),
	LandingPage = require("@luauforge/bundled/ihU"),
	Layout = require("@luauforge/bundled/ihV"),
	AbuseReporting = abuseReportingTokenMapper,
	More = require("@luauforge/bundled/ihW"),
	CrossDeviceLogin = require("@luauforge/bundled/ihX"),
	FriendsLanding = require("@luauforge/bundled/ihY"),
	GamepadDisconnect = require("@luauforge/bundled/fCf").Gamepad.GamepadDisconnectTokenMapper,
	Banner = require("@luauforge/bundled/ihZ"),
	MultiPageSignup = multiPageSignupTokenMapper,
	ActivationFramework = activationFrameworkTokenMapper
}
