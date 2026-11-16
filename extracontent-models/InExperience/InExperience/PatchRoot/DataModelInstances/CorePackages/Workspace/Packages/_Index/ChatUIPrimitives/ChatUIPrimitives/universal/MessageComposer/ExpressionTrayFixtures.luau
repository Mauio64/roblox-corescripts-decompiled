local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
require(ChatUIPrimitives.UniversalMessage.Types)

local ExpressionTrayFixtures = {}

ExpressionTrayFixtures.quickWordsGroup = {
	categoryGroupId = "quick-words",
	name = "Quick Words",
	categories = {
		{
			categoryId = "general",
			name = "General",
			items = {
				{
					content = { kind = "preset", presetId = "good-game", text = "Good game" }
				},
				{
					content = { kind = "preset", presetId = "good-luck", text = "Good luck" }
				},
				{
					content = { kind = "preset", presetId = "play-again", text = "Play again" }
				}
			}
		},
		{
			categoryId = "play-together",
			name = "Play together",
			items = {
				{
					content = { kind = "preset", presetId = "want-to-play", text = "Want to play?" }
				},
				{
					content = { kind = "preset", presetId = "join-me", text = "Join me" }
				}
			}
		}
	}
}

ExpressionTrayFixtures.emojisGroup = {
	categoryGroupId = "emojis",
	name = "Emojis",
	categories = {
		{
			categoryId = "top-picks",
			name = "Top picks",
			items = {
				{
					content = {
						kind = "emoji",
						emojiId = "grinning-face",
						unicode = "😀",
						name = "grinning-face"
					}
				},
				{
					content = {
						kind = "emoji",
						emojiId = "waving-hand",
						unicode = "👋",
						name = "waving-hand"
					}
				},
				{
					content = {
						kind = "emoji",
						emojiId = "thumbs-up",
						unicode = "👍",
						name = "thumbs-up"
					}
				},
				{
					content = {
						kind = "emoji",
						emojiId = "party-popper",
						unicode = "🎉",
						name = "party-popper"
					}
				}
			}
		}
	}
}

ExpressionTrayFixtures.enabledCatalog = {
	status = "enabled",
	categoryGroups = { ExpressionTrayFixtures.quickWordsGroup, ExpressionTrayFixtures.emojisGroup }
}

ExpressionTrayFixtures.disabledCatalog = { status = "disabled", categoryGroups = {} }

ExpressionTrayFixtures.quickWordsOnlyCatalog = {
	status = "enabled",
	categoryGroups = { ExpressionTrayFixtures.quickWordsGroup }
}

ExpressionTrayFixtures.emojisOnlyCatalog = {
	status = "enabled",
	categoryGroups = { ExpressionTrayFixtures.emojisGroup }
}

return ExpressionTrayFixtures
