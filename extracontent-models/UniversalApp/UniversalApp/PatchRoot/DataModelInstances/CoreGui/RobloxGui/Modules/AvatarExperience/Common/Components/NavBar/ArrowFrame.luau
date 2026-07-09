local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ArrowNav = require(Modules.AvatarExperience.Common.Components.NavBar.ArrowNav)
local ArrowNavV2 = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.ArrowNavV2
local Constants = require(Modules.AvatarExperience.Common.Constants)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local Images = UIBlox.App.ImageSet.Images
local FFlagAXMoveCatalogFilterToL1Navigation = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMoveCatalogFilterToL1Navigation
local v12 = Images["icons/actions/cycleLeft"]
local v13 = Images["icons/actions/cycleRight"]

local function ArrowFrame(t1: {[any]: any}) -- line: 45
	-- upvalues: FFlagAXMoveCatalogFilterToL1Navigation (copy), useTokens (copy), React (copy), ArrowNavV2 (copy), ArrowNav (copy), v12 (copy), Constants (copy), v13 (copy)
	local v16 = t1.ZIndex or 1
	local v17 = t1.isVisibleRight == nil or (t1.isVisibleRight or true)
	local v18 = t1.isVisibleLeft == nil or (t1.isVisibleLeft or true)
	local defaultUseProps = t1.defaultUseProps
	local onPressHoldInputBegan = t1.onPressHoldInputBegan
	local onPressHoldInputEnded = t1.onPressHoldInputEnded
	local v22 = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else t1.supportFilterButton
	local v23 = if not FFlagAXMoveCatalogFilterToL1Navigation or not v22 then nil else t1.isFilterButtonVisible
	local v24 = if not FFlagAXMoveCatalogFilterToL1Navigation then nil else useTokens()
	local v25, v26 = React.useState(false)
	local v27 = React.useCallback(function() -- line: 60
		-- upvalues: v26 (copy)
		v26(true)
	end, {})
	local v28 = React.useCallback(function() -- line: 64
		-- upvalues: v26 (copy)
		v26(false)
	end, {})
	local v29 = (not FFlagAXMoveCatalogFilterToL1Navigation or not v22) and -6 or 0
	local v30 = (not FFlagAXMoveCatalogFilterToL1Navigation or not v23) and -30 or -(t1.filterButtonWidth or 0)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = v16,
		[React.Event.MouseEnter] = v27,
		[React.Event.MouseLeave] = v28
	}, {
		ArrowLeft = React.createElement(if not FFlagAXMoveCatalogFilterToL1Navigation or not v22 then ArrowNav else ArrowNavV2, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, v29, 0.5, 0),
			Image = if not FFlagAXMoveCatalogFilterToL1Navigation or not v22 then v12 else nil,
			Visible = v25 and v18,
			navDirection = Constants.NavigationDirection.IS_LEFT,
			defaultUseProps = defaultUseProps,
			onPressHoldInputBegan = onPressHoldInputBegan,
			onPressHoldInputEnded = onPressHoldInputEnded,
			tokens = if not FFlagAXMoveCatalogFilterToL1Navigation or not v22 then nil else v24
		}),
		ArrowRight = React.createElement(if not FFlagAXMoveCatalogFilterToL1Navigation or not v22 then ArrowNav else ArrowNavV2, {
			AnchorPoint = Vector2.new((not FFlagAXMoveCatalogFilterToL1Navigation or not v22) and 0 or 1, 0.5),
			Position = UDim2.new(1, v30, 0.5, 0),
			Image = if not FFlagAXMoveCatalogFilterToL1Navigation or not v22 then v13 else nil,
			Visible = v25 and v17,
			navDirection = Constants.NavigationDirection.IS_RIGHT,
			defaultUseProps = defaultUseProps,
			onPressHoldInputBegan = onPressHoldInputBegan,
			onPressHoldInputEnded = onPressHoldInputEnded,
			tokens = if not FFlagAXMoveCatalogFilterToL1Navigation or not v22 then nil else v24
		})
	})
end

return React.memo(ArrowFrame)
