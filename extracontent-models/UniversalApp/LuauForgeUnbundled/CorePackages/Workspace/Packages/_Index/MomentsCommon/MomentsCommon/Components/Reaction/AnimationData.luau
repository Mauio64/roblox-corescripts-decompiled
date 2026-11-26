require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/Reaction/ReactionAnimation")

local v5 = {
	crying = {
		name = "sob",
		frameCount = 91,
		frameSize = 48,
		internalPadding = 2,
		padding = 24,
		stride = 72,
		columns = 14,
		rows = 7,
		sheetWidth = 984,
		sheetHeight = 480,
		fps = 45
	},
	fire = {
		name = "fire",
		frameCount = 91,
		frameSize = 48,
		internalPadding = 2,
		padding = 24,
		stride = 72,
		columns = 14,
		rows = 7,
		sheetWidth = 984,
		sheetHeight = 480,
		fps = 45
	},
	heart = {
		name = "love",
		frameCount = 91,
		frameSize = 48,
		internalPadding = 2,
		padding = 24,
		stride = 72,
		columns = 14,
		rows = 7,
		sheetWidth = 984,
		sheetHeight = 480,
		fps = 45
	},
	["laugh-joy"] = {
		name = "joy",
		frameCount = 91,
		frameSize = 48,
		internalPadding = 0,
		padding = 24,
		stride = 72,
		columns = 14,
		rows = 7,
		sheetWidth = 984,
		sheetHeight = 480,
		fps = 45
	},
	skull = {
		name = "skull",
		frameCount = 91,
		frameSize = 48,
		internalPadding = 2,
		padding = 24,
		stride = 72,
		columns = 14,
		rows = 7,
		sheetWidth = 984,
		sheetHeight = 480,
		fps = 45
	},
	["thumbs-up"] = {
		name = "like",
		frameCount = 91,
		frameSize = 48,
		internalPadding = 2,
		padding = 24,
		stride = 72,
		columns = 14,
		rows = 7,
		sheetWidth = 984,
		sheetHeight = 480,
		fps = 45
	},
	wow = {
		name = "wow",
		frameCount = 91,
		frameSize = 48,
		internalPadding = 2,
		padding = 24,
		stride = 72,
		columns = 14,
		rows = 7,
		sheetWidth = 984,
		sheetHeight = 480,
		fps = 45
	}
}

local function getAnimationData(p2)
	return v5[p2]
end

return getAnimationData
