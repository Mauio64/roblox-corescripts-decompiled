local module = require("@luauforge/bundled/fHU")

local module2 = require("@luauforge/bundled/fIt")
local module3 = require("@luauforge/bundled/fIy")

local function GameLandingPageLayout(props)
	local v5 = module3()

	return module.createElement(module2, {
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
		isSignUpInProgress = props.isSignUpInProgress
	})
end

return GameLandingPageLayout
