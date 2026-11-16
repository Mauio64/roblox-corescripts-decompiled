local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ArrowNav = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Control/HorizontalNav/ArrowNav")
local arrowNavV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.ArrowNavV2
local module2 = require("@luauforge/bundled/dMx")
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local images = UIBlox.App.ImageSet.Images

local fFlagAXMoveCatalogFilterToL1Navigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMoveCatalogFilterToL1Navigation

local iconsactionscycleLeft = images["icons/actions/cycleLeft"]
local iconsactionscycleRight = images["icons/actions/cycleRight"]

local function ArrowFrame(props)
	local zIndex = props.ZIndex or 1
	local v5 = props.isVisibleRight == nil or (props.isVisibleRight or true)
	local v6 = props.isVisibleLeft == nil or (props.isVisibleLeft or true)
	local defaultUseProps = props.defaultUseProps
	local onPressHoldInputBegan = props.onPressHoldInputBegan
	local onPressHoldInputEnded = props.onPressHoldInputEnded
	local supportFilterButton = if fFlagAXMoveCatalogFilterToL1Navigation then props.supportFilterButton else nil
	local isFilterButtonVisible

	if fFlagAXMoveCatalogFilterToL1Navigation and supportFilterButton then
		isFilterButtonVisible = props.isFilterButtonVisible
	end

	local v7 = if fFlagAXMoveCatalogFilterToL1Navigation then useTokens() else nil

	local state, setState = React.useState(false)

	local v8 = React.useCallback(function()
		setState(true)
	end, {})

	local v9 = React.useCallback(function()
		setState(false)
	end, {})

	local v11 = not (fFlagAXMoveCatalogFilterToL1Navigation and isFilterButtonVisible) and -30
		or -(props.filterButtonWidth or 0)

	local createElement = React.createElement
	local v13 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = zIndex,
		[React.Event.MouseEnter] = v8,
		[React.Event.MouseLeave] = v9
	}

	local createElement2 = React.createElement
	local v14

	if fFlagAXMoveCatalogFilterToL1Navigation and supportFilterButton then
		v14 = arrowNavV2
	else
		v14 = ArrowNav
	end

	local v15 = {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(
			0,
			fFlagAXMoveCatalogFilterToL1Navigation and supportFilterButton and 0 or -6,
			0.5,
			0
		),
		Image = 0,
		Visible = 0,
		navDirection = 0,
		defaultUseProps = 0,
		onPressHoldInputBegan = 0,
		onPressHoldInputEnded = 0,
		tokens = 0
	}
	local v16 = if not (fFlagAXMoveCatalogFilterToL1Navigation and supportFilterButton) then iconsactionscycleLeft else nil
	v15.Image = v16
	v15.Visible = state and v6
	v15.navDirection = module2.NavigationDirection.IS_LEFT
	v15.defaultUseProps = defaultUseProps
	v15.onPressHoldInputBegan = onPressHoldInputBegan
	v15.onPressHoldInputEnded = onPressHoldInputEnded
	local v17 = if fFlagAXMoveCatalogFilterToL1Navigation and supportFilterButton then v7 else nil
	v15.tokens = v17
	local children = { ArrowLeft = createElement2(v14, v15), ArrowRight = 0 }

	local createElement3 = React.createElement
	local v18

	if fFlagAXMoveCatalogFilterToL1Navigation and supportFilterButton then
		v18 = arrowNavV2
	else
		v18 = ArrowNav
	end

	local v19 = {
		AnchorPoint = Vector2.new(
			fFlagAXMoveCatalogFilterToL1Navigation and supportFilterButton and 1 or 0,
			0.5
		),
		Position = UDim2.new(1, v11, 0.5, 0),
		Image = 0,
		Visible = 0,
		navDirection = 0,
		defaultUseProps = 0,
		onPressHoldInputBegan = 0,
		onPressHoldInputEnded = 0,
		tokens = 0
	}
	local v20 = if not (fFlagAXMoveCatalogFilterToL1Navigation and supportFilterButton) then iconsactionscycleRight else nil
	v19.Image = v20

	v19.Visible = state and v5
	v19.navDirection = module2.NavigationDirection.IS_RIGHT
	v19.defaultUseProps = defaultUseProps
	v19.onPressHoldInputBegan = onPressHoldInputBegan
	v19.onPressHoldInputEnded = onPressHoldInputEnded

	if not (fFlagAXMoveCatalogFilterToL1Navigation and supportFilterButton) then
		v7 = nil
	end

	v19.tokens = v7
	children.ArrowRight = createElement3(v18, v19)
	return createElement("Frame", v13, children)
end

return React.memo(ArrowFrame)
