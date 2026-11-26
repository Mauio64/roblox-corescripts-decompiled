local module = require("@luauforge/bundled/gmo")
require("@luauforge/bundled/gmL")
local fFlagEnablePioneerLandingPageSso = require("@luauforge/bundled/gmA").FFlagEnablePioneerLandingPageSso

local module2 = require("@luauforge/bundled/gmO")
local module3 = require("@luauforge/bundled/gmT")

local function GameLandingPageLayout(props)
	local v5 = module3()

	local createElement = module.createElement
	local v7 = {
		gameName = v5.gameName,
		creatorName = v5.creatorName,
		isCreatorVerified = v5.isCreatorVerified,
		thumbnailUrl = v5.thumbnailUrl,
		onPlayNow = props.onPlayNow,
		onSignIn = props.onSignIn,
		onCreateAccount = props.onCreateAccount,
		defaultRef = props.defaultRef,
		containerRef = props.containerRef,
		showBrazilContentRatingBadge = props.showBrazilContentRatingBadge,
		isSignUpInProgress = props.isSignUpInProgress,
		externalIdentityProviders = 0,
		activeExternalIdentityProvider = 0,
		onExternalIdentityActivated = 0
	}
	local v8 = if fFlagEnablePioneerLandingPageSso then props.externalIdentityProviders else nil
	v7.externalIdentityProviders = v8

	local v9 = if fFlagEnablePioneerLandingPageSso then props.activeExternalIdentityProvider else nil
	v7.activeExternalIdentityProvider = v9

	local v10 = if fFlagEnablePioneerLandingPageSso then props.onExternalIdentityActivated else nil
	v7.onExternalIdentityActivated = v10
	return createElement(module2, v7)
end

return GameLandingPageLayout
