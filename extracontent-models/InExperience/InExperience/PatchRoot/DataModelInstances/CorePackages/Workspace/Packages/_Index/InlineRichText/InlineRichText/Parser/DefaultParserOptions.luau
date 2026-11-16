local InlineRichText = script:FindFirstAncestor("InlineRichText")
require(InlineRichText.Types)
local NodeType = require(InlineRichText.Enums.NodeType)

return {
	TagConfigurations = {
		b = { NodeType = NodeType.EngineTag },
		i = { NodeType = NodeType.EngineTag },
		u = { NodeType = NodeType.EngineTag },
		s = { NodeType = NodeType.EngineTag },
		font = { NodeType = NodeType.EngineTag },
		stroke = { NodeType = NodeType.EngineTag },
		uc = { NodeType = NodeType.EngineTag },
		sc = { NodeType = NodeType.EngineTag },
		mark = { NodeType = NodeType.EngineTag },
		a = { NodeType = NodeType.InlineCustom, OverrideName = "LINK" },
		icon = { NodeType = NodeType.InlineCustom, OverrideName = "ICON" }
	},
	TagAliases = {
		strong = "b",
		em = "i",
		strike = "s",
		del = "s",
		uppercase = "uc",
		smallcaps = "sc"
	}
}
