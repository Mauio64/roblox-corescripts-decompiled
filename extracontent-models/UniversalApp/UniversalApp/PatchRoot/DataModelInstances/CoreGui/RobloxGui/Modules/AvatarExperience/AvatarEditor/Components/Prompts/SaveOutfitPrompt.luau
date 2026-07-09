local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local Focusable = RoactGamepad.Focusable
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Overlay = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.Overlay
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local CharacterManagerUtils = require(Modules.AvatarExperience.Common.Util.CharacterManagerUtils)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local OutfitNameTextBox = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.OutfitNameTextBox)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local CheckShouldPreloadEditableCostumes = require(Modules.AvatarExperience.AvatarEditor.Selectors.CheckShouldPreloadEditableCostumes)
local CreateOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.CreateOutfit)
local GetEditableOutfits = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetEditableOutfits)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMigrateSaveOutfitPromptFromRoactGamepad = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSaveOutfitPromptFromRoactGamepad
local FFlagAXCharacterToAvatarStrings = AvatarExperienceFlags.FFlagAXCharacterToAvatarStrings
local FFlagAXUpdateSlotBasedEditorToastAndPrompts = AvatarExperienceFlags.FFlagAXUpdateSlotBasedEditorToastAndPrompts
local FFlagAXFixCustomOutfitNamesDisabled = AvatarExperienceFlags.FFlagAXFixCustomOutfitNamesDisabled
local v38 = Roact.PureComponent:extend("SaveOutfitPrompt")

v38.validateProps = t.strictInterface({
	lookId = t.optional(t.string),
	onComplete = t.optional(t.callback),
	containerWidth = if not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then t.optional(t.number) else nil,
	defaultChildRef = if not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then t.optional(t.table) else nil,
	focusController = if not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then t.optional(t.table) else nil,
	showCustomOutfitNames = t.boolean,
	avatarEditorAnalytics = t.table,
	onOverlayClosed = t.optional(t.callback),
	navigation = t.table,
	screenSize = t.Vector2,
	fetchingState = t.string,
	shouldPreloadEditableCostumes = t.boolean,
	ownedItemIdsBySubtype = t.table,
	outfitInfos = t.table,
	combinedTryOnHumanoidDescription = t.optional(t.Instance),
	createOutfit = t.callback,
	getEditableUserCostumes = t.callback,
	forwardRef = t.optional(t.table)
})

function v38.init(p1) -- line: 93
	-- upvalues: FFlagAXFixCustomOutfitNamesDisabled (copy), Utils2 (copy), NavigationUtils (copy), AvatarScreen (copy), Constants (copy), Roact (copy), OutfitNameTextBox (copy), UserInputService (copy)
	function p1.getShowCustomCostumeNames() -- line: 94
		-- upvalues: p1 (copy)
		return p1.props.showCustomOutfitNames
	end

	p1.outfitName = if not p1.getShowCustomCostumeNames() then nil else ""
	p1.isMounted = false

	function p1.checkIsMounted() -- line: 101
		-- upvalues: p1 (copy)
		return p1.isMounted
	end

	p1.state = {
		isKeyboardRepositioned = false,
		isNameInvalid = not not p1.getShowCustomCostumeNames()
	}

	function p1.saveOutfit() -- line: 110
		-- upvalues: p1 (copy), FFlagAXFixCustomOutfitNamesDisabled (copy), Utils2 (copy), NavigationUtils (copy), AvatarScreen (copy), Constants (copy)
		if p1.state.isNameInvalid then
			return
		end

		if not p1.getShowCustomCostumeNames() then
			p1.props.createOutfit(if not FFlagAXFixCustomOutfitNamesDisabled then p1.outfitName else "", p1.props.avatarEditorAnalytics, p1.checkIsMounted, p1.props.onComplete, if p1.props.lookId == nil then nil else p1.props.combinedTryOnHumanoidDescription)

			return
		end

		if Utils2.isDuplicateOutfitName(p1.props.ownedItemIdsBySubtype, p1.props.outfitInfos, p1.outfitName) then
			local outfitName = p1.outfitName

			NavigationUtils.navigateToNextOverlay(p1.props.navigation, AvatarScreen.DuplicateOutfitNamePrompt, {
				outfitName = p1.outfitName,
				sourcePrompt = AvatarScreen.SaveOutfitPrompt,
				sourceParams = {},
				saveCallback = function() -- line: 134
					-- upvalues: p1 (copy), outfitName (copy)
					p1.props.createOutfit(outfitName, p1.props.avatarEditorAnalytics, p1.checkIsMounted, p1.props.onComplete, if p1.props.lookId == nil then nil else p1.props.combinedTryOnHumanoidDescription)
				end,
				saveFetchingStateKey = Constants.CreateOutfitKey
			})

			return
		end

		p1.props.createOutfit(p1.outfitName, p1.props.avatarEditorAnalytics, p1.checkIsMounted, p1.props.onComplete, if p1.props.lookId == nil then nil else p1.props.combinedTryOnHumanoidDescription)
	end
	function p1.onOutfitNameUpdated(p2, p3) -- line: 164
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		p1.outfitName = p2
		p1:setState({
			isNameInvalid = p3
		})
	end
	function p1.renderMiddleContent() -- line: 175
		-- upvalues: Roact (copy), OutfitNameTextBox (copy), p1 (copy)
		return Roact.createElement(OutfitNameTextBox, {
			onOutfitNameUpdated = p1.onOutfitNameUpdated
		})
	end

	p1.keyboardConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 181
		-- upvalues: p1 (copy), UserInputService (copy)
		if not p1.isMounted then
			return
		end

		if not p1.state.isKeyboardRepositioned and UserInputService.OnScreenKeyboardVisible then
			p1:setState({
				isKeyboardRepositioned = true
			})
		end
	end)

	function p1.closePrompt() -- line: 192
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)

		if p1.props.onComplete then
			p1.props.onComplete()
		end
	end
end
function v38.checkFetchEditableOutfits(p4) -- line: 200
	if p4.props.shouldPreloadEditableCostumes then
		p4.props.getEditableUserCostumes()
	end
end
function v38.didMount(p5) -- line: 207
	p5.isMounted = true
	p5:checkFetchEditableOutfits()
end
function v38.willUpdate(p6, p7, _) -- line: 213
	-- upvalues: Utils (copy)
	if Utils.isFetchingDoneOrFailed(p6.props.fetchingState, p7.fetchingState) then
		p6.closePrompt()
	end
end
function v38.renderAlertLocalized(p9, p10) -- line: 219
	-- upvalues: UserInputService (copy), Roact (copy), FFlagAXMigrateSaveOutfitPromptFromRoactGamepad (copy), Overlay (copy), Focusable (copy), RoactGamepad (copy), InteractiveAlert (copy), FFlagAXCharacterToAvatarStrings (copy), ButtonType (copy), RetrievalStatus (copy)
	local v51 = p9.getShowCustomCostumeNames()
	local screenSize = p9.props.screenSize
	local uDim2 = UDim2.new(0.5, 0, 0.5, 0)

	if p9.state.isKeyboardRepositioned then
		uDim2 = UDim2.new(0.5, 0, 0, (screenSize.Y - UserInputService.OnScreenKeyboardSize.Y) / 2)
	end

	return Roact.createElement(if not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then Focusable.Frame else Overlay, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		inputBindings = if not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p9.closePrompt),
			Confirm = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 239
			end, {
				key = "CommonUI.Controls.Action.Confirm"
			})
		} else nil
	}, {
		Alert = Roact.createElement(InteractiveAlert, {
			isRoactGamepadEnabled = not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad and nil,
			title = p10.titleText,
			bodyText = if not FFlagAXCharacterToAvatarStrings then v51 and p10.messageText or nil else nil,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = p9.closePrompt,
							text = p10.cancelButtonText
						},
						isDefaultChild = not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad or nil
					},
					{
						buttonType = if not FFlagAXCharacterToAvatarStrings then ButtonType.PrimarySystem else ButtonType.PrimaryContextual,
						props = {
							isLoading = p9.props.fetchingState == RetrievalStatus.Fetching,
							isDisabled = not not v51 and (p9.state.isNameInvalid or false),
							onActivated = p9.saveOutfit,
							text = p10.confirmButtonText
						}
					}
				}
			},
			middleContent = v51 and p9.renderMiddleContent or nil,
			isMiddleContentFocusable = if not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then v51 else nil,
			position = uDim2,
			screenSize = p9.props.screenSize,
			defaultChildRef = if not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then p9.props.defaultChildRef else nil
		})
	})
end
function v38.render(p11) -- line: 285
	-- upvalues: withLocalization (copy), FFlagAXCharacterToAvatarStrings (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), FFlagAXMigrateSaveOutfitPromptFromRoactGamepad (copy), withSelectionCursorProvider (copy)
	return withLocalization({
		messageText = "Feature.Avatar.Label.EnterCostumeName",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		warningText = "Feature.Avatar.Label.CostumeWarning",
		titleText = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Heading.SaveCostume" or "Feature.Avatar.Label.Title.AvatarName",
		confirmButtonText = not FFlagAXUpdateSlotBasedEditorToastAndPrompts and "Feature.Avatar.Action.Save" or "Feature.Avatar.Label.Add"
	})(function(p12) -- line: 296
		-- upvalues: FFlagAXMigrateSaveOutfitPromptFromRoactGamepad (copy), p11 (copy), withSelectionCursorProvider (copy)
		if FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then
			return p11:renderAlertLocalized(p12)
		end

		return withSelectionCursorProvider(function(p13) -- line: 300
			-- upvalues: p11 (copy), p12 (copy)
			return p11:renderAlertLocalized(p12, p13)
		end)
	end)
end
function v38.didUpdate(p14, _, _) -- line: 306
	p14:checkFetchEditableOutfits()
end
function v38.willUnmount(p17) -- line: 310
	p17.keyboardConnection:disconnect()
	p17.keyboardConnection = nil
	p17.isMounted = false
end

local v39 = RoactRodux.connect(function(p18, p19) -- line: 316
	-- upvalues: CharacterManagerUtils (copy), PerformFetch (copy), Constants (copy), CheckShouldPreloadEditableCostumes (copy)
	local v61 = if p19.lookId == nil then nil else CharacterManagerUtils.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn(p18)

	return {
		fetchingState = PerformFetch.GetStatus(p18, Constants.CreateOutfitKey),
		screenSize = p18.ScreenSize,
		shouldPreloadEditableCostumes = CheckShouldPreloadEditableCostumes(p18),
		ownedItemIdsBySubtype = p18.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype,
		outfitInfos = p18.AvatarExperience.AvatarEditor.OutfitInfos,
		combinedTryOnHumanoidDescription = v61
	}
end, function(p20) -- line: 328
	-- upvalues: CreateOutfit (copy), GetEditableOutfits (copy)
	return {
		createOutfit = function(p21, p22, p23, p24, p25) -- line: 330
			-- upvalues: p20 (copy), CreateOutfit (copy)
			p20(CreateOutfit(p21, p22, p23, p24, p25))
		end,
		getEditableUserCostumes = function() -- line: 333
			-- upvalues: p20 (copy), GetEditableOutfits (copy)
			return p20(GetEditableOutfits())
		end
	}
end)(v38)
local v40 = RoactAppPolicy.connect(function(p26, _) -- line: 339
	return {
		showCustomOutfitNames = p26.getCustomOutfitNames()
	}
end)(v39)
local v41 = RoactServices.connect({
	avatarEditorAnalytics = Analytics
})(v40)

if not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then
	v41 = withOverlayFocusHandling(v41)
end

local u42 = withMappedNavigationParams(v41)

return Roact.forwardRef(function(p28, p29) -- line: 355
	-- upvalues: Roact (copy), u42 (ref), Cryo (copy)
	return Roact.createElement(u42, Cryo.Dictionary.join(p28, {
		forwardRef = p29
	}))
end)
