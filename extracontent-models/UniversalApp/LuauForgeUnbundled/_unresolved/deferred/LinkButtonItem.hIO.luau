local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local module = require("@luauforge/bundled/eeH")
local module2 = require("@luauforge/deferred/fyr")

local module3 = require("@luauforge/bundled/hHS")
require("@luauforge/bundled/hHQ")

local function LinkButtonItem(p2)
	local layoutOrder = p2.layoutOrder
	local itemData = p2.itemData

	local textKey = itemData.textKey
	local rightImage = itemData.rightImage
	local url = if itemData.context then itemData.context.url else nil

	local v5 = module(appLinking)
	local v6 = useLocalization({ title = textKey })

	local v7 = React.useCallback(function()
		if url then
			module2(v5, url)
		end
	end, { url })

	return React.createElement(module3, {
		layoutOrder = layoutOrder,
		title = v6.title,
		icon = rightImage,
		onActivated = v7
	})
end

return LinkButtonItem
