local parent = script:FindFirstAncestor("TextChannelWindow").Parent
require(parent.ChatUIPrimitives.ExpressionCatalogResource)

local debugExpressionCatalog = {
	status = "enabled",
	version = "studio-debug",
	categoryGroups = {
		{
			categoryGroupId = "quick-words",
			name = "Quick Words",
			categories = {
				{
					categoryId = "general",
					name = "General",
					items = {
						{
							content = {
								kind = "preset",
								presetId = "studio-follow-me",
								text = "Follow me"
							}
						},
						{
							content = {
								kind = "preset",
								presetId = "studio-good-game",
								text = "Good game!"
							}
						},
						{
							content = {
								kind = "preset",
								presetId = "studio-this-way",
								text = "This way"
							}
						}
					}
				},
				{
					categoryId = "reactions",
					name = "Reactions",
					items = {
						{
							content = {
								kind = "preset",
								presetId = "studio-awesome",
								text = "Awesome!"
							}
						},
						{
							content = { kind = "preset", presetId = "studio-oops", text = "Oops!" }
						}
					}
				}
			}
		}
	}
}

local function getDebugExpressionCatalog()
	return debugExpressionCatalog
end

return getDebugExpressionCatalog
