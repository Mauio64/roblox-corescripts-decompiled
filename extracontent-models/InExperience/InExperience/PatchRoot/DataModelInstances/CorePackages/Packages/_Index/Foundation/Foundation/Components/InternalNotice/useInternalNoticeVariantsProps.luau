local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.IconSize)
require(Foundation.Enums.InputSize)
require(Foundation.Components.Types)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local v = { tag = "text-align-x-left" }
local v2 = {
	container = { tag = "col size-full-0 auto-y" },
	content = { tag = "row align-y-top size-full-0 auto-y" },
	leading = { tag = "row align-y-top fill auto-y" },
	stack = { tag = "col fill auto-y" },
	message = v,
	link = v
}

local v3 = { tag = "size-full-0 auto-y" }
local v4 = {
	[false] = {
		message = { tag = "fill auto-y" },
		link = { tag = "auto-xy" },
		linkContainer = { tag = "auto-xy" }
	},
	[true] = {
		message = v3,
		link = { tag = v3.tag, padding = {} },
		linkContainer = v3
	}
}

local function useInternalNoticeVariantsProps(data, flag: boolean, flag2: boolean)
	local v5 = {
		tag = flag2 and "text-truncate-end" or "text-wrap"
	}

	local v6 = { tag = data.leading.gap }
	local stack = { tag = data.stack.gap }

	return (composeStyleVariant(v2, data, flag and { content = v6, stack = stack } or {
		content = { tag = data.content.gap },
		leading = v6,
		stack = stack
	}, v4[flag], { message = v5, link = v5 }))
end

return useInternalNoticeVariantsProps
