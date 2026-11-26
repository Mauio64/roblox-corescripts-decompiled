local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module = require("@luauforge/deferred/gJI")
local module2 = require("@luauforge/bundled/fAe")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module3 = require("@luauforge/deferred/gJH")
local module4 = require("@luauforge/bundled/dXh")
local module5 = require("@luauforge/bundled/dPN")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local module6 = require("@luauforge/deferred/gLv")
local module7 = require("@luauforge/bundled/gJS")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local v6 = isVRAppBuild() and 120 or 0

local extended = Roact.PureComponent:extend("LCSortContextFrame")

extended.validateProps = t.strictInterface({
	navigation = t.table,
	asset = t.table,
	onUnequip = t.optional(t.callback),
	tilePositionY = t.number,
	avatarRoute = t.table,
	screenSize = t.Vector2,
	isPortrait = t.boolean,
	globalGuiInset = t.table,
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table)
})

function extended:init()
	local binding, v7 = Roact.createBinding(UDim2.fromScale(1, 1))
	self.contextMenuSize = binding
	self.updateContextMenuSize = v7

	function self.openUnequipPrompt()
		module4.navigateToNextOverlay(self.props.navigation, avatarScreen.RemoveItemPrompt, {
			asset = self.props.asset,
			onUnequip = self.props.onUnequip
		})
	end

	function self.closePrompt()
		module4.closeOverlay(self.props.navigation)
	end
end

function extended:renderLocalized(p2)
	local closePrompt = self.closePrompt
	local screenSize = self.props.screenSize

	local v7 = {}

	table.insert(v7, {
		icon = nil,
		text = p2.unequip,
		onActivated = function()
			self.openUnequipPrompt()
		end
	})

	local isPortrait = self.props.isPortrait
	local v8

	if isPortrait then
		v8 = 0
	else
		v8 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module5.LandscapeNavWidth
	end

	local v9

	if isPortrait then
		v9 = 1
	else
		v9 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module5.LandscapeSceneWidth
	end

	local v10 = not isVRAppBuild() and 0 or module6.VerticalList.Width + module6.Tile.ContextWidth

	local udim = UDim2.new(v8, v10, 0, 0)
	local udim2 = UDim2.fromScale(v9, 1)
	local v11 = self.props.tilePositionY - self.props.screenSize.Y + module6.Tile.SelectedSize + 56 + 11 + self.props.globalGuiInset.bottom + v6

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = udim,
		Size = udim2
	}, {
		SizeFrame = Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Size = self.contextMenuSize
			},
			{
				ContextMenu = Roact.createElement(contextualMenu, {
					buttonProps = v7,
					open = true,
					menuDirection = menuDirection.Up,
					openPositionY = UDim.new(1, v11),
					closeBackgroundVisible = not isVRAppBuild(),
					screenSize = screenSize,
					onDismiss = closePrompt
				})
			}
		)
	})
end

function extended:render()
	return withLocalization({ unequip = "Feature.Avatar.Action.Unequip" })(function(p2)
		return self:renderLocalized(p2)
	end)
end

return (module3((module2((module((RoactRodux.connect(function(p2, p3)
	return {
		screenSize = p2.ScreenSize,
		globalGuiInset = p2.GlobalGuiInset,
		isPortrait = module7(p2)
	}
end, nil)(extended))))))))
