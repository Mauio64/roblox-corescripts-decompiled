local CorePackages = game:GetService("CorePackages")
local engagementScreenTokenMapper = require(CorePackages.Workspace.Packages.EngagementScreen).engagementScreenTokenMapper
local v3 = if not require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAbuseReport10ft() then nil else require(CorePackages.Workspace.Packages.AbuseReporting).abuseReportingTokenMapper
local experienceDetailsTokenMapper = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.DesignTokenMappers.experienceDetailsTokenMapper
local MultiPageSignupTokenMapper = nil
local ActivationFrameworkTokenMapper = nil

if require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableMultiPageSignup() then
	MultiPageSignupTokenMapper = require(CorePackages.Workspace.Packages.MultiPageSignup).Components.MultiPageSignupTokenMapper
	ActivationFrameworkTokenMapper = require(CorePackages.Workspace.Packages.UserActivationFramework).Components.ActivationFrameworkTokenMapper
end

return {
	App = require(script.Parent.appTokenMapper),
	HomeOmniFeed = require(script.Parent.homeOmniFeedTokenMapper),
	Search = require(script.Parent.searchTokenMapper),
	SeeAll = require(script.Parent.seeAllTokenMapper),
	ExperienceDetails = experienceDetailsTokenMapper,
	EngagementScreen = engagementScreenTokenMapper,
	LoginView = require(script.Parent.loginViewTokenMapper),
	SignUpView = require(script.Parent.signUpPageViewTokenMapper),
	AuthCompliance = require(script.Parent.complianceTokenMapper),
	LandingPage = require(script.Parent.landingPageTokenMapper),
	Layout = require(script.Parent.layoutTokenMapper),
	AbuseReporting = v3,
	More = require(script.Parent.moreTokenMappers),
	CrossDeviceLogin = require(script.Parent.crossDeviceLoginTokenMapper),
	FriendsLanding = require(script.Parent.friendsLandingTokenMapper),
	GamepadDisconnect = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadDisconnectTokenMapper,
	Banner = require(script.Parent.bannerTokenMapper),
	MultiPageSignup = MultiPageSignupTokenMapper,
	ActivationFramework = ActivationFrameworkTokenMapper
}
