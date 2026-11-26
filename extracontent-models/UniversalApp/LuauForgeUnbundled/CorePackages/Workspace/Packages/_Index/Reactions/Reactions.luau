local module = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Constants")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionSize")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionTrigger")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/Reaction")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/ReactionButton")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/ReactionChip")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/ReactionPicker")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/ReactionPickerPopover")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/ReactionPill")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/ReactionExplosion")
return {
	Constants = module,
	Enums = {
		ReactionType = module2,
		ReactionSize = module3,
		ReactionTrigger = module4
	},
	Utils = {
		applyReactionTrigger = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/applyReactionTrigger"),
		abbreviateReactionCount = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/abbreviateReactionCount"),
		getTopReactions = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/getTopReactions"),
		reactionTypeFromEmojiName = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/reactionTypeFromEmojiName")
	},
	Reaction = module5,
	ReactionButton = module6,
	ReactionChip = module7,
	ReactionPicker = module8,
	ReactionPickerPopover = module9,
	ReactionPill = module10,
	ReactionExplosion = module11
}
