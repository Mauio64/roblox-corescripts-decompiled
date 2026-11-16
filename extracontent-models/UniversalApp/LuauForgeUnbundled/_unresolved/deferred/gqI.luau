local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dHK")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local module = require("@luauforge/deferred/goR")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module3 = require("@luauforge/bundled/cgr")

local constants = module3.Utils.Constants
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute

local getRbxthumbWithTypeSizeAndOptions = module3.Utils.getRbxthumbWithTypeSizeAndOptions
local module4 = require("@luauforge/bundled/fuD")
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigationFocus
local useTokens = Foundation.Hooks.useTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module5 = require("@luauforge/bundled/gfm")

local module6 = require("@luauforge/deferred/gqJ")

local customizeControlBar = module.CustomizeControlBar
local undoRedoBar = module.UndoRedoBar

local fFlagAXResetAvatarButton = AvatarExperienceFlags.FFlagAXResetAvatarButton
local fFlagControlBarUseProfileFrameThumbnail = AvatarExperienceFlags.FFlagControlBarUseProfileFrameThumbnail

local avatarHeadShot = constants.RbxthumbTypes.AvatarHeadShot

local function selectUserId(p2)
	return p2.LocalUserId
end

local function SlotControlBar(props, p2)
	local v5 = useTokens()
	local v6 = useNavigationFocus()
	local v7 = useAvatarRoute()
	local v8 = useNavigation()
	local v9 = useSelector(module5)

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		useSelector(selectUserId),
		avatarHeadShot,
		150,
		nil,
		nil,
		fFlagControlBarUseProfileFrameThumbnail
	)

	local v10 = React.useMemo(function()
		return props.showControlBar
			and module4.isAvatarSceneButtonsVisible(v7, v6, props.isUIFullView, props.isSceneFullView, v8)
	end, { v7, v6, props.isUIFullView, props.isSceneFullView, v8, props.showControlBar })

	local createElement = React.createElement
	local v12 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		ref = p2,
		NextSelectionLeft = props.NextSelectionLeft,
		LayoutOrder = props.LayoutOrder
	}
	local v13 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v5.Gap.Small)
		}),
		ControlBar = 0,
		UndoRedoBar = 0,
		ContextualActions = 0
	}
	local v14

	if v10 then
		local createElement2 = React.createElement
		local v16 = {
			onActiveMenuItemChanged = props.onActiveMenuItemChanged,
			thumbnailUrl = rbxthumbWithTypeSizeAndOptions,
			LayoutOrder = 1,
			showUndoRedo = 0
		}

		local v17 = if fFlagAXResetAvatarButton then props.showUndoRedo else nil
		v16.showUndoRedo = v17
		v14 = createElement2(customizeControlBar, v16)
	end

	v13.ControlBar = v14

	local v15 = if props.showUndoRedo and not fFlagAXResetAvatarButton then React.createElement(undoRedoBar, {
		direction = "vertical",
		LayoutOrder = 2
	}) else nil
	v13.UndoRedoBar = v15

	local v16 = if v10 and not v9 then React.createElement(module6, { LayoutOrder = 3 }) else nil
	v13.ContextualActions = v16
	return createElement("Frame", v12, v13)
end

return React.memo(React.forwardRef(SlotControlBar))
