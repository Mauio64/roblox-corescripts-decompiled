local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local AppStorageService = game:GetService("AppStorageService")
local Promise = require(CorePackages.Packages.Promise)
local React = require(CorePackages.Packages.React)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.LuaApp.Constants)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local GameDetailNotificationsButtonHint = require(Modules.LuaApp.Components.GameDetails.GameDetailNotificationsButtonHint)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local GetFFlagLuaAppEnableNotificationsEDPTooltip = require(Modules.LuaApp.Flags.GetFFlagLuaAppEnableNotificationsEDPTooltip)
local GetFIntNotificationsEDPTooltipTimeLimit = require(Modules.LuaApp.Flags.GetFIntNotificationsEDPTooltipTimeLimit)
local v17 = Images["icons/common/notificationOn"]
local v18 = Images["icons/common/notificationOff"]

return function(t1: {[any]: any}) -- line: 35
	-- upvalues: GetFFlagLuaAppEnableNotificationsEDPTooltip (copy), AppStorageService (copy), React (copy), Promise (copy), GetFIntNotificationsEDPTooltipTimeLimit (copy), useSelector (copy), Constants (copy), IconButton (copy), v17 (copy), v18 (copy), IconSize (copy), GameDetailNotificationsButtonHint (copy), TooltipOrientation (copy)
	local v20 = nil
	local u21 = nil
	local v22 = nil
	local v23 = nil

	if GetFFlagLuaAppEnableNotificationsEDPTooltip() then
		local useRef = React.useRef
		local ok, result = pcall(function() -- line: 39
			-- upvalues: AppStorageService (copy)
			return AppStorageService:GetItem("ShowNotificationsOptInTooltip")
		end)
		local v27 = useRef(not not ok and result == "true")
		local v28

		v20, v28 = React.useState(v27.current)
		u21 = v28

		local v29, v30 = React.useState(false)

		React.useEffect(function() -- line: 58
			-- upvalues: v27 (copy), AppStorageService (copy), Promise (copy), GetFIntNotificationsEDPTooltipTimeLimit (copy), u21 (ref), v30 (copy)
			if v27.current then
				AppStorageService:SetItem("ShowNotificationsOptInTooltip", "false")
				AppStorageService:Flush()
			end

			Promise.delay(GetFIntNotificationsEDPTooltipTimeLimit()):andThen(function() -- line: 64
				-- upvalues: u21 (ref), v30 (copy)
				u21(false)
				v30(true)
			end)
		end, {})

		local v31 = useSelector(function(p1) -- line: 69
			return p1.TopBar.statusBarHeight
		end)

		v23 = React.useCallback(function(p2) -- line: 73
			-- upvalues: v27 (copy), v31 (copy), Constants (copy), u21 (ref), v29 (copy)
			if p2 ~= nil and v27.current then
				if p2.AbsolutePosition.Y < v31 + Constants.NAV_BAR_SIZE then
					u21(false)

					return
				end

				if not v29 then
					u21(true)
				end
			end
		end, { v29 })
		v22 = React.useCallback(function() -- line: 88
			-- upvalues: u21 (ref), v30 (copy), t1 (copy)
			u21(false)
			v30(true)

			if t1.toggleFollowExperience then
				t1.toggleFollowExperience()
			end
		end, {})
	end

	local v32 = t1.gameFollowings and t1.gameFollowings.isFollowed
	local position = t1.position
	local layoutOrder = t1.layoutOrder
	local anchorPoint = t1.anchorPoint

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		AutomaticSize = if not GetFFlagLuaAppEnableNotificationsEDPTooltip() then Enum.AutomaticSize.Y else Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		Position = position,
		AnchorPoint = anchorPoint
	}, {
		IconButton = React.createElement(IconButton, {
			icon = if not v32 then v18 else v17,
			iconSize = IconSize.Medium,
			onActivated = if not GetFFlagLuaAppEnableNotificationsEDPTooltip() then t1.toggleFollowExperience else v22
		}, {
			Tooltip = if not GetFFlagLuaAppEnableNotificationsEDPTooltip() then nil else React.createElement(GameDetailNotificationsButtonHint, {
				onPositionChanged = v23,
				isActive = v20,
				preferredOrientation = TooltipOrientation.Top
			})
		})
	})
end
