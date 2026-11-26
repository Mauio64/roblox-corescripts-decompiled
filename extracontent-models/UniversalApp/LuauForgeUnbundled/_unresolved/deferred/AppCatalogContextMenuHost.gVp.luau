local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useRef = React.useRef
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local function AppCatalogContextMenuHost(p2): nil
	local v5 = useDispatch()

	local v6 = useRef(p2.navigation)

	React.useEffect(function()
		local current = v6.current
		local params = if not (current == nil or current.state == nil) then current.state.params else nil

		if params ~= nil and params.itemId ~= nil and params.itemType ~= nil then
			current.navigate(avatarScreen.CatalogContextMenu, {
				itemId = params.itemId,
				itemType = params.itemType,
				hideItemDetailsButtonVisible = true,
				onOverlayClosed = function()
					v5(RobloxAppToastsRodux(true))
				end
			})

			return
		end

		v5(RobloxAppToastsRodux(true))
		mutedError("AppCatalogContextMenuHost mounted without itemId/itemType")
	end, { v5 })

	return nil
end

return AppCatalogContextMenuHost
