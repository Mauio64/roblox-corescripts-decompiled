local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local FFlagAXCharacterToAvatarStrings = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCharacterToAvatarStrings
local v16 = Roact.PureComponent:extend("DuplicateOutfitInfoPrompt")
local FFlagAXUpdateSlotBasedEditorToastAndPrompts = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXUpdateSlotBasedEditorToastAndPrompts

v16.validateProps = t.strictInterface({
	saveAsNew = t.boolean,
	duplicateOutfitId = t.string,
	onOverlayClosed = t.optional(t.callback),
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	showCustomOutfitNames = t.boolean,
	navigation = t.table,
	screenSize = t.Vector2,
	duplicateOutfitName = t.optional(t.string)
})

function v16.init(p1) -- line: 60
	-- upvalues: NavigationUtils (copy), AvatarScreen (copy)
	function p1.saveOutfit() -- line: 61
		-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy)
		NavigationUtils.navigateToNextOverlay(p1.props.navigation, AvatarScreen.SaveOutfitPrompt)
	end
	function p1.updateExisting() -- line: 65
		-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy)
		NavigationUtils.navigateFromOverlay(p1.props.navigation, AvatarScreen.UpdateOutfitPage)
	end
	function p1.closePrompt() -- line: 69
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v16.renderLocalized(p2, p3) -- line: 74
	-- upvalues: FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy), FFlagAXCharacterToAvatarStrings (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local v23 = if not p2.props.duplicateOutfitName or not p2.props.showCustomOutfitNames then p3.savedSimilarCharacterNoName else if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then if not FFlagAXCharacterToAvatarStrings then p3.savedSimilarCharacter .. "\n" .. p2.props.duplicateOutfitName else p3.savedSimilarCharacter .. "\n\n" .. "\"" .. p2.props.duplicateOutfitName .. "\"" else p3.savedSimilarCharacter
	local v24, saveOutfit

	if p2.props.saveAsNew then
		v24 = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then p3.saveAsNewConfirmText else p3.addNewAvatarConfirmText
		saveOutfit = p2.saveOutfit
	else
		v24 = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then p3.updateExistingConfirmText else p3.updateAvatarConfirmText
		saveOutfit = p2.updateExisting
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Alert = Roact.createElement(InteractiveAlert, {
			title = p3.titleText,
			bodyText = v23,
			buttonStackInfo = {
				buttons = {
					{
						isDefaultChild = true,
						props = {
							onActivated = p2.closePrompt,
							text = p3.cancelButtonText
						}
					},
					{
						buttonType = if not FFlagAXCharacterToAvatarStrings then ButtonType.PrimarySystem else ButtonType.PrimaryContextual,
						props = {
							onActivated = saveOutfit,
							text = v24
						}
					}
				}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = p2.props.screenSize,
			defaultChildRef = p2.props.defaultChildRef
		})
	})
end
function v16.render(p4) -- line: 136
	-- upvalues: withLocalization (copy), FFlagAXCharacterToAvatarStrings (copy), FFlagAXUpdateSlotBasedEditorToastAndPrompts (copy)
	return withLocalization({
		saveAsNewConfirmText = "Feature.Avatar.Action.Save",
		cancelButtonText = "Feature.Avatar.Action.Cancel",
		titleText = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Heading.DuplicateCharacter" or "Feature.Avatar.Label.Title.DuplicateAvatar",
		savedSimilarCharacter = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.SavedSimilarCharacter" or (not FFlagAXUpdateSlotBasedEditorToastAndPrompts and "Feature.Avatar.Label.Message.DuplicateAvatar" or {
			"Feature.Avatar.Message.AddAvatarAgain",
			prevAvatar = p4.props.duplicateOutfitName
		}),
		savedSimilarCharacterNoName = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.SavedSimilarCharacterNoName" or "Feature.Avatar.Label.Message.DuplicateAvatar",
		updateExistingConfirmText = not FFlagAXCharacterToAvatarStrings and "Feature.Avatar.Action.GotIt" or "Feature.Avatar.Action.Save",
		addNewAvatarConfirmText = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then nil else "Feature.Avatar.Label.Add",
		updateAvatarConfirmText = if not FFlagAXUpdateSlotBasedEditorToastAndPrompts then nil else "Feature.Avatar.Label.Replace"
	})(function(p5) -- line: 163
		-- upvalues: p4 (copy)
		return p4:renderLocalized(p5)
	end)
end

local function mapStateToProps(p6, p7) -- line: 168
	local OutfitInfos = p6.AvatarExperience.AvatarEditor.OutfitInfos
	local name = nil

	if OutfitInfos[p7.duplicateOutfitId] then
		name = OutfitInfos[p7.duplicateOutfitId].name
	end

	return {
		screenSize = p6.ScreenSize,
		duplicateOutfitName = name
	}
end

local v19 = RoactRodux.connect(mapStateToProps, nil)(v16)

return (withMappedNavigationParams((withOverlayFocusHandling((RoactAppPolicy.connect(function(p8, _) -- line: 184
	return {
		showCustomOutfitNames = p8.getCustomOutfitNames()
	}
end)(v19))))))
