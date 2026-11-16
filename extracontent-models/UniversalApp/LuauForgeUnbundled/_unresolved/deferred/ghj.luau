local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module = require("@luauforge/bundled/dTM")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@luauforge/bundled/dHK")

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/geT")

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local focusable = RoactGamepad.Focusable

local module3 = require("@luauforge/bundled/dNQ")
local module4 = require("@luauforge/bundled/fuD")
local module5 = require("@luauforge/bundled/fvh")
local module6 = require("@luauforge/deferred/gfc")

local module7 = require("@luauforge/deferred/gfb")
local module8 = require("@luauforge/deferred/ggU")

local module9 = require("@luauforge/deferred/ggV")

local module10 = require("@luauforge/deferred/ghk")
local module11 = require("@luauforge/deferred/ggW")

local fFlagAXCharacterToAvatarStrings = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCharacterToAvatarStrings

local fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local extended = Roact.PureComponent:extend("RenameOutfitPrompt")

extended.validateProps = t.strictInterface({
	costumeId = t.string,
	containerWidth = t.optional(t.number),
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback),
	focusController = t.optional(t.table),
	avatarEditorAnalytics = t.table,
	navigation = t.table,
	screenSize = t.Vector2,
	fetchingState = t.string,
	shouldPreloadEditableCostumes = t.boolean,
	ownedItemIdsBySubtype = t.table,
	outfitInfos = t.table,
	renameOutfit = t.callback,
	getEditableUserCostumes = t.callback
})

function extended:init()
	self:setState({
		isKeyboardRepositioned = false,
		costumeName = "",
		isNameInvalid = true
	})

	function self.renameOutfit()
		if self.state.isNameInvalid then
			return
		end

		local costumeName = self.state.costumeName

		if not module5.isDuplicateOutfitName(
			self.props.ownedItemIdsBySubtype,
			self.props.outfitInfos,
			costumeName
		) then
			self.props.renameOutfit(self.props.avatarEditorAnalytics, self.props.costumeId, costumeName)

			return
		end

		local costumeId = self.props.costumeId
		local function fn()
			self.props.renameOutfit(self.props.avatarEditorAnalytics, costumeId, costumeName)
		end
		local v5 = module3.RenameOutfitKey .. costumeId

		module.navigateToNextOverlay(self.props.navigation, avatarScreen.DuplicateOutfitNamePrompt, {
			outfitName = costumeName,
			sourcePrompt = avatarScreen.RenameOutfitPrompt,
			sourceParams = { costumeId = self.props.costumeId },
			saveCallback = fn,
			saveFetchingStateKey = v5
		})
	end

	function self.onOutfitNameUpdated(p2, p3)
		self:setState({ costumeName = p2, isNameInvalid = p3 })
	end

	function self.renderMiddleContent()
		return Roact.createElement(module8, {
			onOutfitNameUpdated = self.onOutfitNameUpdated
		})
	end

	function self.onScreenKeyboardVisibleChanged()
		if self.state.isKeyboardRepositioned ~= UserInputService.OnScreenKeyboardVisible then
			self:setState({
				isKeyboardRepositioned = UserInputService.OnScreenKeyboardVisible
			})
		end
	end

	function self.closePrompt()
		module.closeOverlay(self.props.navigation)
	end
end

function extended:checkFetchEditableCostumes()
	if self.props.shouldPreloadEditableCostumes then
		self.props.getEditableUserCostumes()
	end
end

function extended:didMount()
	self:checkFetchEditableCostumes()
end

function extended.willUpdate(p2, p3, p4)
	if module4.isFetchingDoneOrFailed(p2.props.fetchingState, p3.fetchingState) then
		p2.closePrompt()
	end
end

function extended:renderWithProviders(props2)
	local screenSize = self.props.screenSize

	local udim = UDim2.new(0.5, 0, 0.5, 0)

	if self.state.isKeyboardRepositioned then
		udim = UDim2.new(0.5, 0, 0, (screenSize.Y - UserInputService.OnScreenKeyboardSize.Y) / 2)
	end

	local createElement = Roact.createElement
	local textButton = focusable.TextButton
	local v5 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Selectable = false,
		[Roact.Event.Activated] = self.closePrompt,
		[Roact.Ref] = self.props.focusNavigationRef,
		inputBindings = not fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, self.closePrompt),
			Confirm = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() end, {
				key = "CommonUI.Controls.Action.Confirm"
			})
		} or nil
	}

	local v6 = {
		KeyboardConnection = Roact.createElement(externalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"),
			callback = self.onScreenKeyboardVisibleChanged
		}),
		Alert = 0
	}

	local createElement2 = Roact.createElement
	local v8 = {
		title = props2.titleText,
		bodyText = 0,
		buttonStackInfo = 0,
		middleContent = 0,
		isMiddleContentFocusable = true,
		position = 0,
		screenSize = 0,
		defaultChildRef = 0
	}
	local v9 = if not fFlagAXCharacterToAvatarStrings then props2.messageText else nil
	v8.bodyText = v9

	local v12 = {
		props = { onActivated = self.closePrompt, text = props2.cancelButtonText },
		isDefaultChild = true
	}

	local v14 = if fFlagAXCharacterToAvatarStrings then buttonType.PrimaryContextual else buttonType.PrimarySystem
	v8.buttonStackInfo = {
		buttons = {
			v12,
			{
				buttonType = v14,
				props = {
					isDisabled = self.state.isNameInvalid,
					isLoading = self.props.fetchingState == retrievalStatus.Fetching,
					onActivated = self.renameOutfit,
					text = props2.confirmButtonText
				}
			}
		}
	}

	v8.middleContent = self.renderMiddleContent

	v8.position = udim
	v8.screenSize = self.props.screenSize
	v8.defaultChildRef = self.props.defaultChildRef
	v6.Alert = createElement2(interactiveAlert, v8)
	return createElement(textButton, v5, v6)
end

function extended:render()
	return withLocalization({
		titleText = fFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.Title.AvatarName" or "Feature.Avatar.Heading.RenameCharacter",
		messageText = "Feature.Avatar.Label.EnterNewCostumeName",
		confirmButtonText = "Feature.Avatar.Action.Save",
		cancelButtonText = "Feature.Avatar.Action.Cancel"
	})(function(p2)
		return self:renderWithProviders(p2)
	end)
end

function extended:didUpdate(p2, p3)
	self:checkFetchEditableCostumes()
end

local function mapStateToProps(p2, p3)
	local v5 = module3.RenameOutfitKey .. p3.costumeId

	return {
		fetchingState = performFetch.GetStatus(p2, v5),
		screenSize = p2.ScreenSize,
		shouldPreloadEditableCostumes = module9(p2),
		ownedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype,
		outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos
	}
end

local function mapDispatchToProps(callback)
	return {
		renameOutfit = function(p2, p3, p4)
			callback(module10(p2, p3, p4))
		end,
		getEditableUserCostumes = function()
			return callback(module11())
		end
	}
end

local v5 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

return (module7((module6((roactServices.connect({ avatarEditorAnalytics = module2 })(v5))))))
