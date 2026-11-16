require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")
local module = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/NodeType")

return {
	TagConfigurations = {
		b = { NodeType = module.EngineTag },
		i = { NodeType = module.EngineTag },
		u = { NodeType = module.EngineTag },
		s = { NodeType = module.EngineTag },
		font = { NodeType = module.EngineTag },
		stroke = { NodeType = module.EngineTag },
		uc = { NodeType = module.EngineTag },
		sc = { NodeType = module.EngineTag },
		mark = { NodeType = module.EngineTag },
		a = { NodeType = module.InlineCustom, OverrideName = "LINK" },
		icon = { NodeType = module.InlineCustom, OverrideName = "ICON" }
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
