local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/constants")

return {
	EmojiWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/Components/EmojiWrapper"),
	AboutVerifiedBadgeModal = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/Components/AboutVerifiedBadgeModal"),
	installReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/installReducer"),
	emoji = { verified = constants.VERIFIED_EMOJI, premium = constants.PREMIUM_EMOJI },
	appendVerifiedBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/Utils/appendVerifiedBadge"),
	appendPremiumBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/Utils/appendPremiumBadge"),
	isCreatorOfGameVerified = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/Utils/isCreatorOfGameVerified")
}
