local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module = require("@luauforge/deferred/gfb")
local module2 = require("@luauforge/bundled/dTM")
require("@luauforge/bundled/dHK")

local module3 = require("@luauforge/deferred/gfk")

local module4 = require("@luauforge/deferred/gfc")
local module5 = require("@luauforge/deferred/gfl")
local module6 = require("@luauforge/bundled/dOc")
local v5 = module6() and game:DefineFastFlag("AXOutfitMenuUpdatesForSlotBasedEditor2", false)

local slotBasedEditorAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Surfaces.SlotBasedEditorAnalytics

local fFlagAXAddManageOutfitClickTracking = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAddManageOutfitClickTracking

local module7 = require("@luauforge/deferred/gfo")

local UIBlox = require(CorePackages.Packages.UIBlox)

local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection

local extended = Roact.PureComponent:extend("CreateOrUpdateOutfitMenu")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	duplicateOutfitId = t.optional(t.string),
	navigation = t.table,
	focusController = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback),
	saveTilePosition = t.Vector2,
	defaultChildRef = t.optional(t.table)
})

function extended:init()
	function self.saveOutfitAsNew()
		if fFlagAXAddManageOutfitClickTracking then
			slotBasedEditorAnalytics.trackAddNewAvatarClick()
		end

		if self.props.duplicateOutfitId then
			module2.navigateToNextOverlay(self.props.navigation, avatarScreen.DuplicateOutfitInfoPrompt, {
				duplicateOutfitId = self.props.duplicateOutfitId,
				saveAsNew = true
			})
		else
			module2.navigateToNextOverlay(self.props.navigation, avatarScreen.SaveOutfitPrompt)
		end
	end

	function self.updateExistingOutfit()
		if fFlagAXAddManageOutfitClickTracking then
			slotBasedEditorAnalytics.trackUpdateAvatarClick()
		end

		if self.props.duplicateOutfitId then
			module2.navigateToNextOverlay(self.props.navigation, avatarScreen.DuplicateOutfitInfoPrompt, {
				duplicateOutfitId = self.props.duplicateOutfitId,
				saveAsNew = false
			})
		else
			module2.navigateFromOverlay(self.props.navigation, avatarScreen.UpdateOutfitPage)
		end
	end

	function self.manageCharacters()
		module2.navigateFromOverlay(self.props.navigation, avatarScreen.ManageOutfitPage)
	end

	function self.closePrompt()
		module2.closeOverlay(self.props.navigation)
	end

	self:setState({ useFullWidth = false })

	function self.onNavOverlaySizeChanged(p2)
		if p2.AbsoluteSize.X < 640 then
			if not self.state.useFullWidth then
				self:setState({ useFullWidth = true })
			end
		elseif self.state.useFullWidth then
			self:setState({ useFullWidth = false })
		end
	end

	local binding, v6 = Roact.createBinding(UDim2.fromOffset(0, 0))
	self.positionOffset = binding
	self.updatePositionOffset = v6

	function self.onNavOverlayPositionChanged(p2)
		self.updatePositionOffset(UDim2.fromOffset(-p2.AbsolutePosition.X, -p2.AbsolutePosition.Y))
	end
end

function extended:renderLocalized(props2)
	local inputBindingEntries = {}

	table.insert(inputBindingEntries, {
		text = props2.saveAsNew,
		inputBindingKey = "CommonUI.Controls.Action.Confirm",
		onActivated = self.saveOutfitAsNew
	})

	table.insert(inputBindingEntries, {
		text = props2.updateExistingCharacter,
		inputBindingKey = "CommonUI.Controls.Action.Confirm",
		onActivated = self.updateExistingOutfit
	})

	table.insert(inputBindingEntries, {
		text = props2.manageCharacters,
		inputBindingKey = "CommonUI.Controls.Action.Confirm",
		onActivated = self.manageCharacters
	})

	local v6 = self.props.saveTilePosition.Y + 25
	local v7 = menuDirection.Down

	if v6 + #inputBindingEntries * 56 + 12 > self.props.screenSize.Y then
		v6 = self.props.saveTilePosition.Y - 25
		v7 = menuDirection.Up
	end

	local udim = UDim2.fromOffset(self.props.saveTilePosition.X - 42, 0)
	local udim2 = UDim2.new(0, 324, 1, 0)

	if self.state.useFullWidth then
		udim = UDim2.fromOffset(0, 0)
		udim2 = UDim2.fromScale(1, 1)
	end

	local createElement = Roact.createElement
	local v9 = {
		onAbsoluteSizeChanged = self.onNavOverlaySizeChanged,
		onAbsolutePositionChanged = self.onNavOverlayPositionChanged
	}

	local createElement2 = Roact.createElement
	local frame = focusable.Frame
	local defaultChildRefsByRef = {
		BackgroundTransparency = 1,
		Position = udim,
		Size = udim2,
		[Roact.Ref] = self.props.defaultChildRef,
		inputBindings = not module7 and {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, self.closePrompt)
		} or nil
	}

	local createElement3 = Roact.createElement

	local v14 = if not self.state.useFullWidth then self.positionOffset or nil else nil
	return createElement(module5, v9, {
		SizeFrame = createElement2(frame, defaultChildRefsByRef, {
			PositionOffsetFrame = createElement3(
				"Frame",
				{
					BackgroundTransparency = 1,
					Position = v14,
					Size = UDim2.fromScale(1, 1)
				},
				{
					ContextMenu = Roact.createElement(contextualMenu, {
						buttonProps = inputBindingEntries,
						open = true,
						menuDirection = v7,
						openPositionY = UDim.new(0, v6),
						closeBackgroundVisible = true,
						screenSize = self.props.screenSize,
						onDismiss = self.closePrompt
					})
				}
			)
		})
	})
end

function extended:render()
	return withLocalization({
		saveAsNew = v5 and "Feature.Avatar.Label.Title.AddNewAvatar" or "Feature.Avatar.Action.SaveAsNew",
		updateExistingCharacter = v5 and "Feature.Avatar.Label.Title.UpdateAvatar" or "Feature.Avatar.Action.UpdateExistingCharacter",
		manageCharacters = module6() and "Feature.Avatar.Label.Title.ManageAvatars" or "Feature.Avatar.Action.ManageCharacters"
	})(function(p2)
		return self:renderLocalized(p2)
	end)
end

local function mapStateToProps(p2, p3)
	return { duplicateOutfitId = module3(p2), screenSize = p2.ScreenSize }
end

return (module((module4((RoactRodux.connect(mapStateToProps, nil)(extended))))))
