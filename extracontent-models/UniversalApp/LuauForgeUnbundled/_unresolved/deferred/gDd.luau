local CorePackages = game:GetService("CorePackages")

local AppStorageService = game:GetService("AppStorageService")

local Promise = require(CorePackages.Packages.Promise)
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dzD")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local FtuxTooltipAnchor = require("@game/CoreGui/RobloxGui/Modules/Chrome/Integrations/FtuxTooltipAnchor")
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

local module3 = require("@luauforge/deferred/gDf")
local module4 = require("@luauforge/deferred/gDg")

local iconscommonnotificationOn = images["icons/common/notificationOn"]
local iconscommonnotificationOff = images["icons/common/notificationOff"]

return function(props)
	local state = nil
	local v5 = nil
	local v6, v7

	if module3() then
		local useRef = React.useRef
		local success, result = pcall(function()
			return AppStorageService:GetItem("ShowNotificationsOptInTooltip")
		end)
		local v8 = if success then result == "true" else false
		local v9 = useRef(v8)
		local setState
		state, setState = React.useState(v9.current)
		v5 = setState
		local state2, setState2 = React.useState(false)

		React.useEffect(function()
			if v9.current then
				AppStorageService:SetItem("ShowNotificationsOptInTooltip", "false")
				AppStorageService:Flush()
			end

			Promise.delay(module4()):andThen(function()
				v5(false)
				setState2(true)
			end)
		end, {})

		local v10 = useSelector(function(p2)
			return p2.TopBar.statusBarHeight
		end)

		v6 = React.useCallback(function(p2)
			if p2 ~= nil and v9.current then
				if p2.AbsolutePosition.Y < v10 + module.NAV_BAR_SIZE then
					v5(false)
				elseif not state2 then
					v5(true)
				end
			end
		end, { state2 })

		v7 = React.useCallback(function()
			v5(false)
			setState2(true)

			if props.toggleFollowExperience then
				props.toggleFollowExperience()
			end
		end, {})
	end

	local isFollowed = props.gameFollowings and props.gameFollowings.isFollowed
	local position = props.position
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint

	local createElement = React.createElement

	local v10 = if module3() then Enum.AutomaticSize.XY else Enum.AutomaticSize.Y
	local v9 = {
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		AutomaticSize = v10,
		Size = UDim2.new(1, 0, 0, 0),
		Position = position,
		AnchorPoint = anchorPoint
	}

	local createElement2 = React.createElement
	local v13 = {
		icon = if isFollowed then iconscommonnotificationOn else iconscommonnotificationOff,
		iconSize = iconSize.Medium,
		onActivated = 0
	}

	if not module3() then
		v7 = props.toggleFollowExperience
	end

	v13.onActivated = v7

	local v16 = if module3() then React.createElement(FtuxTooltipAnchor, {
		onPositionChanged = v6,
		isActive = state,
		preferredOrientation = tooltipOrientation.Top
	}) else nil
	return createElement("Frame", v9, {
		IconButton = createElement2(iconButton, v13, { Tooltip = v16 })
	})
end
