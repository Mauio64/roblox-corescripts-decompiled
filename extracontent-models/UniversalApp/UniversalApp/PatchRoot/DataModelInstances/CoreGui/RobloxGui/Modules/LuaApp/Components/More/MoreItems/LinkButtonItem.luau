local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local openExternalBrowser = require(Modules.LuaApp.openExternalBrowser)
local MoreStatusButton = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreStatusButton)

require(script.Parent.Types)

local function LinkButtonItem(p1) -- line: 16
	-- upvalues: useRoactService (copy), AppLinking (copy), useLocalization (copy), React (copy), openExternalBrowser (copy), MoreStatusButton (copy)
	local layoutOrder = p1.layoutOrder
	local itemData = p1.itemData
	local textKey = itemData.textKey
	local rightImage = itemData.rightImage
	local v15 = if not itemData.context then nil else itemData.context.url
	local v16 = useRoactService(AppLinking)
	local v17 = useLocalization({
		title = textKey
	})
	local v18 = React.useCallback(function() -- line: 29
		-- upvalues: v15 (copy), openExternalBrowser (copy), v16 (copy)
		if v15 then
			openExternalBrowser(v16, v15)
		end
	end, { v15 })

	return React.createElement(MoreStatusButton, {
		layoutOrder = layoutOrder,
		title = v17.title,
		icon = rightImage,
		onActivated = v18
	})
end

return LinkButtonItem
