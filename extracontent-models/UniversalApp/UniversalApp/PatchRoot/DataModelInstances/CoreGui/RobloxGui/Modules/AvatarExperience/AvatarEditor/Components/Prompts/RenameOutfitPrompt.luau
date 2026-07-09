local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Focusable = RoactGamepad.Focusable
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local OutfitNameTextBox = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.OutfitNameTextBox)
local CheckShouldPreloadEditableCostumes = require(Modules.AvatarExperience.AvatarEditor.Selectors.CheckShouldPreloadEditableCostumes)
local RenameOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.RenameOutfit)
local GetEditableOutfits = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetEditableOutfits)
local FFlagAXCharacterToAvatarStrings = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCharacterToAvatarStrings
local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local FFlagAXFixDeselectOutfitInManage = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixDeselectOutfitInManage
local v32 = Roact.PureComponent:extend("RenameOutfitPrompt")

v32.validateProps = t.strictInterface({
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

function v32.init(p1) -- line: 84
	-- upvalues: Utils2 (copy), Constants (copy), NavigationUtils (copy), AvatarScreen (copy), Roact (copy), OutfitNameTextBox (copy), UserInputService (copy)
	p1:setState({
		isKeyboardRepositioned = false,
		costumeName = "",
		isNameInvalid = true
	})

	function p1.renameOutfit() -- line: 91
		-- upvalues: p1 (copy), Utils2 (copy), Constants (copy), NavigationUtils (copy), AvatarScreen (copy)
		if p1.state.isNameInvalid then
			return
		end

		local costumeName = p1.state.costumeName

		if Utils2.isDuplicateOutfitName(p1.props.ownedItemIdsBySubtype, p1.props.outfitInfos, costumeName) then
			local costumeId = p1.props.costumeId
			local v56 = Constants.RenameOutfitKey .. costumeId

			NavigationUtils.navigateToNextOverlay(p1.props.navigation, AvatarScreen.DuplicateOutfitNamePrompt, {
				outfitName = costumeName,
				sourcePrompt = AvatarScreen.RenameOutfitPrompt,
				sourceParams = {
					costumeId = p1.props.costumeId
				},
				saveCallback = function() -- line: 106
					-- upvalues: p1 (copy), costumeId (copy), costumeName (copy)
					p1.props.renameOutfit(p1.props.avatarEditorAnalytics, costumeId, costumeName)
				end,
				saveFetchingStateKey = v56
			})

			return
		end

		p1.props.renameOutfit(p1.props.avatarEditorAnalytics, p1.props.costumeId, costumeName)
	end
	function p1.onOutfitNameUpdated(p2, p3) -- line: 127
		-- upvalues: p1 (copy)
		p1:setState({
			costumeName = p2,
			isNameInvalid = p3
		})
	end
	function p1.renderMiddleContent() -- line: 134
		-- upvalues: Roact (copy), OutfitNameTextBox (copy), p1 (copy)
		return Roact.createElement(OutfitNameTextBox, {
			onOutfitNameUpdated = p1.onOutfitNameUpdated
		})
	end
	function p1.onScreenKeyboardVisibleChanged() -- line: 140
		-- upvalues: p1 (copy), UserInputService (copy)
		if p1.state.isKeyboardRepositioned ~= UserInputService.OnScreenKeyboardVisible then
			p1:setState({
				isKeyboardRepositioned = UserInputService.OnScreenKeyboardVisible
			})
		end
	end
	function p1.closePrompt() -- line: 148
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v32.checkFetchEditableCostumes(p4) -- line: 153
	if p4.props.shouldPreloadEditableCostumes then
		p4.props.getEditableUserCostumes()
	end
end
function v32.didMount(p5) -- line: 160
	p5:checkFetchEditableCostumes()
end
function v32.willUpdate(p6, p7, _) -- line: 164
	-- upvalues: Utils (copy)
	if Utils.isFetchingDoneOrFailed(p6.props.fetchingState, p7.fetchingState) then
		p6.closePrompt()
	end
end
function v32.renderWithProviders(p9, p10) -- line: 170
	-- upvalues: UserInputService (copy), Roact (copy), FFlagAXFixDeselectOutfitInManage (copy), Focusable (copy), FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation (copy), RoactGamepad (copy), ExternalEventConnection (copy), InteractiveAlert (copy), FFlagAXCharacterToAvatarStrings (copy), ButtonType (copy), RetrievalStatus (copy)
	local screenSize = p9.props.screenSize
	local uDim2 = UDim2.new(0.5, 0, 0.5, 0)

	if p9.state.isKeyboardRepositioned then
		uDim2 = UDim2.new(0.5, 0, 0, (screenSize.Y - UserInputService.OnScreenKeyboardSize.Y) / 2)
	end

	return Roact.createElement(if not FFlagAXFixDeselectOutfitInManage then Focusable.Frame else Focusable.TextButton, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutoButtonColor = not FFlagAXFixDeselectOutfitInManage and nil,
		Text = if not FFlagAXFixDeselectOutfitInManage then nil else "",
		Selectable = not FFlagAXFixDeselectOutfitInManage and nil,
		[Roact.Event.Activated] = if not FFlagAXFixDeselectOutfitInManage then nil else p9.closePrompt,
		[Roact.Ref] = p9.props.focusNavigationRef,
		inputBindings = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p9.closePrompt),
			Confirm = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 195
			end, {
				key = "CommonUI.Controls.Action.Confirm"
			})
		} else nil
	}, {
		KeyboardConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"),
			callback = p9.onScreenKeyboardVisibleChanged
		}),
		Alert = Roact.createElement(InteractiveAlert, {
			isMiddleContentFocusable = true,
			title = p10.titleText,
			bodyText = if not FFlagAXCharacterToAvatarStrings then p10.messageText else nil,
			buttonStackInfo = {
				buttons = {
					{
						isDefaultChild = true,
						props = {
							onActivated = p9.closePrompt,
							text = p10.cancelButtonText
						}
					},
					{
						buttonType = if not FFlagAXCharacterToAvatarStrings then ButtonType.PrimarySystem else ButtonType.PrimaryContextual,
						props = {
							isDisabled = p9.state.isNameInvalid,
							isLoading = p9.props.fetchingState == RetrievalStatus.Fetching,
							onActivated = p9.renameOutfit,
							text = p10.confirmButtonText
						}
					}
				}
			},
			middleContent = p9.renderMiddleContent,
			position = uDim2,
			screenSize = p9.props.screenSize,
			defaultChildRef = p9.props.defaultChildRef
		})
	})
end
function v32.render(p11) -- line: 239
	-- upvalues: withLocalization (copy), FFlagAXCharacterToAvatarStrings (copy)
	return withLocalization({
		messageText = "Feature.Avatar.Label.EnterNewCostumeName",
		confirmButtonText = "Feature.Avatar.Action.Save",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		titleText = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Heading.RenameCharacter" or "Feature.Avatar.Label.Title.AvatarName"
	})(function(p12) -- line: 247
		-- upvalues: p11 (copy)
		return p11:renderWithProviders(p12)
	end)
end
function v32.didUpdate(p13, _, _) -- line: 252
	p13:checkFetchEditableCostumes()
end

local function mapStateToProps(p16, p17) -- line: 256
	-- upvalues: Constants (copy), PerformFetch (copy), CheckShouldPreloadEditableCostumes (copy)
	local v52 = Constants.RenameOutfitKey .. p17.costumeId

	return {
		fetchingState = PerformFetch.GetStatus(p16, v52),
		screenSize = p16.ScreenSize,
		shouldPreloadEditableCostumes = CheckShouldPreloadEditableCostumes(p16),
		ownedItemIdsBySubtype = p16.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype,
		outfitInfos = p16.AvatarExperience.AvatarEditor.OutfitInfos
	}
end
local function mapDispatchToProps(p18) -- line: 270
	-- upvalues: RenameOutfit (copy), GetEditableOutfits (copy)
	return {
		renameOutfit = function(p19, p20, p21) -- line: 272
			-- upvalues: p18 (copy), RenameOutfit (copy)
			p18(RenameOutfit(p19, p20, p21))
		end,
		getEditableUserCostumes = function() -- line: 275
			-- upvalues: p18 (copy), GetEditableOutfits (copy)
			return p18(GetEditableOutfits())
		end
	}
end

local v35 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v32)

return (withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	avatarEditorAnalytics = Analytics
})(v35))))))
