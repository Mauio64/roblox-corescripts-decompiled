local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus

local focusable = RoactGamepad.Focusable
local module = require("@luauforge/bundled/dTM")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local overlay = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.Overlay

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/dNQ")
local module3 = require("@luauforge/bundled/ggp")
local module4 = require("@luauforge/bundled/fuD")
local module5 = require("@luauforge/bundled/fvh")

local module6 = require("@luauforge/deferred/gfb")
local module7 = require("@luauforge/deferred/gfc")
local module8 = require("@luauforge/deferred/ggU")

local module9 = require("@luauforge/bundled/geT")

local module10 = require("@luauforge/deferred/ggV")

local module11 = require("@luauforge/deferred/ggl")
local module12 = require("@luauforge/deferred/ggW")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXMigrateSaveOutfitPromptFromRoactGamepad = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateSaveOutfitPromptFromRoactGamepad
local fFlagAXCharacterToAvatarStrings = AvatarExperienceFlags.FFlagAXCharacterToAvatarStrings

local fFlagAXFixCustomOutfitNamesDisabled = AvatarExperienceFlags.FFlagAXFixCustomOutfitNamesDisabled

local extended = Roact.PureComponent:extend("SaveOutfitPrompt")

local strictInterface = t.strictInterface
local v5 = {
	lookId = t.optional(t.string),
	onComplete = t.optional(t.callback),
	containerWidth = 0,
	defaultChildRef = 0,
	focusController = 0,
	showCustomOutfitNames = 0,
	avatarEditorAnalytics = 0,
	onOverlayClosed = 0,
	navigation = 0,
	screenSize = 0,
	fetchingState = 0,
	shouldPreloadEditableCostumes = 0,
	ownedItemIdsBySubtype = 0,
	outfitInfos = 0,
	combinedTryOnHumanoidDescription = 0,
	createOutfit = 0,
	getEditableUserCostumes = 0,
	forwardRef = 0
}

local v6 = if not fFlagAXMigrateSaveOutfitPromptFromRoactGamepad then t.optional(t.number) else nil
v5.containerWidth = v6
local v7 = if not fFlagAXMigrateSaveOutfitPromptFromRoactGamepad then t.optional(t.table) else nil
v5.defaultChildRef = v7
local v8 = if not fFlagAXMigrateSaveOutfitPromptFromRoactGamepad then t.optional(t.table) else nil
v5.focusController = v8

v5.showCustomOutfitNames = t.boolean

v5.avatarEditorAnalytics = t.table

v5.onOverlayClosed = t.optional(t.callback)
v5.navigation = t.table

v5.screenSize = t.Vector2
v5.fetchingState = t.string
v5.shouldPreloadEditableCostumes = t.boolean
v5.ownedItemIdsBySubtype = t.table
v5.outfitInfos = t.table
v5.combinedTryOnHumanoidDescription = t.optional(t.Instance)

v5.createOutfit = t.callback
v5.getEditableUserCostumes = t.callback

v5.forwardRef = t.optional(t.table)
extended.validateProps = strictInterface(v5)

function extended:init()
	function self.getShowCustomCostumeNames()
		return self.props.showCustomOutfitNames
	end

	self.outfitName = self.getShowCustomCostumeNames() and "" or nil
	self.isMounted = false

	function self.checkIsMounted()
		return self.isMounted
	end

	self.state = {
		isKeyboardRepositioned = false,
		isNameInvalid = self.getShowCustomCostumeNames() and true or false
	}

	function self.saveOutfit()
		if self.state.isNameInvalid then
			return
		end

		if self.getShowCustomCostumeNames() then
			if module5.isDuplicateOutfitName(
				self.props.ownedItemIdsBySubtype,
				self.props.outfitInfos,
				self.outfitName
			) then
				local outfitName = self.outfitName
				local function saveCallback()
					local createOutfit = self.props.createOutfit

					local avatarEditorAnalytics = self.props.avatarEditorAnalytics
					local checkIsMounted = self.checkIsMounted
					local onComplete = self.props.onComplete
					local v10 = if self.props.lookId ~= nil then self.props.combinedTryOnHumanoidDescription else nil
					createOutfit(outfitName, avatarEditorAnalytics, checkIsMounted, onComplete, v10)
				end

				module.navigateToNextOverlay(
					self.props.navigation,
					avatarScreen.DuplicateOutfitNamePrompt,
					{
						outfitName = self.outfitName,
						sourcePrompt = avatarScreen.SaveOutfitPrompt,
						sourceParams = {},
						saveCallback = saveCallback,
						saveFetchingStateKey = module2.CreateOutfitKey
					}
				)
			else
				local createOutfit = self.props.createOutfit
				local outfitName = self.outfitName
				local avatarEditorAnalytics = self.props.avatarEditorAnalytics
				local checkIsMounted = self.checkIsMounted
				local onComplete = self.props.onComplete
				local v9 = if self.props.lookId ~= nil then self.props.combinedTryOnHumanoidDescription else nil
				createOutfit(outfitName, avatarEditorAnalytics, checkIsMounted, onComplete, v9)
			end
		else
			local createOutfit = self.props.createOutfit
			local v9 = fFlagAXFixCustomOutfitNamesDisabled and "" or self.outfitName
			local avatarEditorAnalytics = self.props.avatarEditorAnalytics
			local checkIsMounted = self.checkIsMounted
			local onComplete = self.props.onComplete
			local v10 = if self.props.lookId ~= nil then self.props.combinedTryOnHumanoidDescription else nil
			createOutfit(v9, avatarEditorAnalytics, checkIsMounted, onComplete, v10)
		end
	end

	function self.onOutfitNameUpdated(outfitName, p2)
		if not self.isMounted then
			return
		end

		self.outfitName = outfitName
		self:setState({ isNameInvalid = p2 })
	end

	function self.renderMiddleContent()
		return Roact.createElement(module8, {
			onOutfitNameUpdated = self.onOutfitNameUpdated
		})
	end

	self.keyboardConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
		if not self.isMounted then
			return
		end

		if not self.state.isKeyboardRepositioned and UserInputService.OnScreenKeyboardVisible then
			self:setState({ isKeyboardRepositioned = true })
		end
	end)

	function self.closePrompt()
		module.closeOverlay(self.props.navigation)

		if self.props.onComplete then
			self.props.onComplete()
		end
	end
end

function extended:checkFetchEditableOutfits()
	if self.props.shouldPreloadEditableCostumes then
		self.props.getEditableUserCostumes()
	end
end

function extended:didMount()
	self.isMounted = true

	self:checkFetchEditableOutfits()
end

function extended.willUpdate(p2, p3, p4)
	if module4.isFetchingDoneOrFailed(p2.props.fetchingState, p3.fetchingState) then
		p2.closePrompt()
	end
end

function extended:renderAlertLocalized(props2)
	local showCustomCostumeNames = self.getShowCustomCostumeNames()
	local screenSize = self.props.screenSize

	local udim = UDim2.new(0.5, 0, 0.5, 0)

	if self.state.isKeyboardRepositioned then
		udim = UDim2.new(0.5, 0, 0, (screenSize.Y - UserInputService.OnScreenKeyboardSize.Y) / 2)
	end

	local createElement = Roact.createElement
	local v9 = if fFlagAXMigrateSaveOutfitPromptFromRoactGamepad then overlay else focusable.Frame
	local v10 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		inputBindings = not fFlagAXMigrateSaveOutfitPromptFromRoactGamepad and {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, self.closePrompt),
			Confirm = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() end, {
				key = "CommonUI.Controls.Action.Confirm"
			})
		} or nil
	}

	local createElement2 = Roact.createElement
	local v13 = {
		isRoactGamepadEnabled = if fFlagAXMigrateSaveOutfitPromptFromRoactGamepad then false else nil,
		title = props2.titleText,
		bodyText = 0,
		buttonStackInfo = 0,
		middleContent = 0,
		isMiddleContentFocusable = 0,
		position = 0,
		screenSize = 0,
		defaultChildRef = 0
	}

	local v15 = if not (fFlagAXCharacterToAvatarStrings or not showCustomCostumeNames) then props2.messageText or nil else nil
	v13.bodyText = v15

	local v18 = {
		props = { onActivated = self.closePrompt, text = props2.cancelButtonText },
		isDefaultChild = not fFlagAXMigrateSaveOutfitPromptFromRoactGamepad or nil
	}

	local v20 = if fFlagAXCharacterToAvatarStrings then buttonType.PrimaryContextual else buttonType.PrimarySystem
	local v21 = {
		isLoading = self.props.fetchingState == retrievalStatus.Fetching,
		isDisabled = 0,
		onActivated = 0,
		text = 0
	}
	local v22 = if showCustomCostumeNames then self.state.isNameInvalid or false else false
	v21.isDisabled = v22
	v21.onActivated = self.saveOutfit
	v21.text = props2.confirmButtonText
	v13.buttonStackInfo = {
		buttons = {
			v18,
			{ buttonType = v20, props = v21 }
		}
	}

	local v23 = if showCustomCostumeNames then self.renderMiddleContent or nil else nil
	v13.middleContent = v23

	if fFlagAXMigrateSaveOutfitPromptFromRoactGamepad then
		showCustomCostumeNames = nil
	end

	v13.isMiddleContentFocusable = showCustomCostumeNames

	v13.position = udim
	v13.screenSize = self.props.screenSize

	local v24 = if not fFlagAXMigrateSaveOutfitPromptFromRoactGamepad then self.props.defaultChildRef else nil
	v13.defaultChildRef = v24
	return createElement(v9, v10, {
		Alert = createElement2(interactiveAlert, v13)
	})
end

function extended:render()
	return withLocalization({
		titleText = fFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.Title.AvatarName" or "Feature.Avatar.Heading.SaveCostume",
		messageText = "Feature.Avatar.Label.EnterCostumeName",
		confirmButtonText = "Feature.Avatar.Label.Add",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		warningText = "Feature.Avatar.Label.CostumeWarning"
	})(function(p2)
		if fFlagAXMigrateSaveOutfitPromptFromRoactGamepad then
			return self:renderAlertLocalized(p2)
		end

		return withSelectionCursorProvider(function(p3)
			return self:renderAlertLocalized(p2, p3)
		end)
	end)
end

function extended:didUpdate(p2, p3)
	self:checkFetchEditableOutfits()
end

function extended:willUnmount()
	self.keyboardConnection:disconnect()
	self.keyboardConnection = nil
	self.isMounted = false
end

local v9 = RoactRodux.connect(function(p2, p3)
	local v10 = if p3.lookId ~= nil then module3.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(p2) else nil

	return {
		fetchingState = performFetch.GetStatus(p2, module2.CreateOutfitKey),
		screenSize = p2.ScreenSize,
		shouldPreloadEditableCostumes = module10(p2),
		ownedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype,
		outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos,
		combinedTryOnHumanoidDescription = v10
	}
end, function(callback)
	return {
		createOutfit = function(p2, p3, p4, p5, p6)
			callback(module11(p2, p3, p4, p5, p6))
		end,
		getEditableUserCostumes = function()
			return callback(module12())
		end
	}
end)(extended)

local v10 = roactAppPolicy.connect(function(p2, p3)
	return { showCustomOutfitNames = p2.getCustomOutfitNames() }
end)(v9)

local v11 = roactServices.connect({ avatarEditorAnalytics = module9 })(v10)

if not fFlagAXMigrateSaveOutfitPromptFromRoactGamepad then
	v11 = module7(v11)
end

local v12 = module6(v11)

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v12, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
