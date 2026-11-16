local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local view = Foundation.View
local compositionTags = require("@luauforge/bundled/gns").CompositionTags

local module = require("@luauforge/bundled/fox")
local module2 = require("@luauforge/deferred/goQ")

local module3 = require("@luauforge/deferred/eXk")
local module4 = require("@luauforge/deferred/gTi")
local defineFastFlag = game:DefineFastFlag("RetainTopBarOnProfileTabPageView", false)
local fFlagAXMeTabTopScrim = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMeTabTopScrim

local fFlagAXUseProfileIconEntryPoint = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseProfileIconEntryPoint
local module5 = require("@luauforge/deferred/gVG")

local module6 = require("@luauforge/deferred/goT")

local function ProfileTabPageView(props)
	local v5 = fFlagAXUseProfileIconEntryPoint and props.showSegmentedMenu == false
	local v6

	if defineFastFlag or props.isAtProfileRoot then
		local createElement = React.createElement
		local container = module.Container
		local v7 = {
			leftItem = props.leftItem,
			centerItem = if not v5 then module4 else nil,
			titleText = v5 and "" or nil,
			useParentSizeForCenterItem = true,
			transparentBackground = props.topBarTransparent,
			showTopScrim = 0,
			ZIndex = 2,
			tag = 0,
			sideMarginOverride = 0
		}
		local v9 = if fFlagAXMeTabTopScrim then props.topBarTransparent else nil
		v7.showTopScrim = v9

		v7.tag = compositionTags.ContentRegion.Header
		v6 = createElement(container, v7)
	end

	local v7 = not props.isPortrait

	if v7 then
		v7 = props.isLandscapeTopBarVisible == false and v6 ~= nil
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v12 = {
		isSceneFullView = false,
		isUIFullView = props.isPortrait,
		isDisabled = 0,
		showUndoRedo = 0,
		showControlBar = 0,
		showRobuxBalance = 0,
		showSaveButton = false,
		topBar = 0,
		reserveTopBarOffset = 0
	}
	local v13 = if module5 then props.hideAvatarScene else nil
	v12.isDisabled = v13
	v12.showUndoRedo = not module5 or not props.hideAvatarScene
	local v14 = if module5 then not props.hideAvatarScene else nil
	v12.showControlBar = v14
	local v15 = if module5 then not props.hideAvatarScene else nil
	v12.showRobuxBalance = v15

	local v16 = if not (props.isPortrait or module6 and v7) then v6 else nil
	v12.topBar = v16

	v12.reserveTopBarOffset = module6 and v7 and true or nil
	local v10 = {
		AvatarExperienceView = createElement2(module2, v12, {
			ProfileWrapper = React.createElement(module3, props.wrapperProps)
		}),
		OverlayTopBar = 0
	}

	if not props.isOverlayTopBarVisible then
		v6 = nil
	end

	v10.OverlayTopBar = v6
	return createElement(view, {
		tag = { ["data-testid=ProfileTabPageView"] = true, ["size-full"] = true }
	}, v10)
end

return ProfileTabPageView
