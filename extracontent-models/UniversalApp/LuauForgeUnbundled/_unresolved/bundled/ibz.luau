local module = require("@luauforge/bundled/ibe")
local module2 = require("@luauforge/bundled/ibj")

local iconSize = module2.Enums.IconSize
local text = module2.Text
local view = module2.View
local icon = module2.Icon

local useTokens = module2.Hooks.useTokens

local getBuilderIconForKeycode = module2.Utility.getBuilderIconForKeycode

local function VerticalShortcutCluster(p2)
	local v5 = useTokens()

	local children = {}

	for k, shortcut in p2.shortcuts do
		local builderIconForKeycode = getBuilderIconForKeycode(shortcut.keyCode)

		local formatted = `Shortcut-{shortcut.label}`
		local createElement = module.createElement

		local v8 = {
			Label = module.createElement(text, {
				Text = shortcut.label,
				tag = "auto-xy text-title-medium content-inverse-default",
				LayoutOrder = 1
			}),
			Key = 0
		}

		local v9 = if builderIconForKeycode then module.createElement(icon, {
			name = builderIconForKeycode,
			size = iconSize.Medium,
			style = v5.Inverse.Content.Default,
			LayoutOrder = 2
		}) else nil
		v8.Key = v9
		children[formatted] = createElement(
			view,
			{ tag = "row align-y-center gap-small auto-xy", LayoutOrder = k },
			v8
		)
	end

	return module.createElement(
		view,
		{ tag = "col align-x-right gap-small auto-xy", LayoutOrder = p2.layoutOrder },
		children
	)
end

return module.memo(VerticalShortcutCluster)
