local InlineRichText = script:FindFirstAncestor("InlineRichText")

require(InlineRichText.Types)

local NodeType = require(InlineRichText.Enums.NodeType)

return {
	TagConfigurations = {
		b = {
			NodeType = NodeType.EngineTag
		},
		i = {
			NodeType = NodeType.EngineTag
		},
		u = {
			NodeType = NodeType.EngineTag
		},
		s = {
			NodeType = NodeType.EngineTag
		},
		font = {
			NodeType = NodeType.EngineTag
		},
		stroke = {
			NodeType = NodeType.EngineTag
		},
		uc = {
			NodeType = NodeType.EngineTag
		},
		sc = {
			NodeType = NodeType.EngineTag
		},
		mark = {
			NodeType = NodeType.EngineTag
		},
		a = {
			OverrideName = "LINK",
			NodeType = NodeType.InlineCustom
		},
		icon = {
			OverrideName = "ICON",
			NodeType = NodeType.InlineCustom
		}
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
