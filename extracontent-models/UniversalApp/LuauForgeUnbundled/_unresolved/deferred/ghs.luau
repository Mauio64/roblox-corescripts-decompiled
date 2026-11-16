local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module = require("@luauforge/bundled/dTM")

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
require("@luauforge/bundled/dHK")

local module2 = require("@luauforge/deferred/gfc")

local module3 = require("@luauforge/deferred/gfb")

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local fFlagAXCharacterToAvatarStrings = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCharacterToAvatarStrings

local extended = Roact.PureComponent:extend("DuplicateOutfitInfoPrompt")

extended.validateProps = t.strictInterface({
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

function extended:init()
	function self.saveOutfit()
		module.navigateToNextOverlay(self.props.navigation, avatarScreen.SaveOutfitPrompt)
	end

	function self.updateExisting()
		module.navigateFromOverlay(self.props.navigation, avatarScreen.UpdateOutfitPage)
	end

	function self.closePrompt()
		module.closeOverlay(self.props.navigation)
	end
end

function extended:renderLocalized(props2)
	local v5

	if self.props.duplicateOutfitName and self.props.showCustomOutfitNames then
		v5 = props2.savedSimilarCharacter
	else
		v5 = props2.savedSimilarCharacterNoName
	end

	local v6, v7

	if self.props.saveAsNew then
		v6 = props2.addNewAvatarConfirmText
		v7 = self.saveOutfit
	else
		v6 = props2.updateAvatarConfirmText
		v7 = self.updateExisting
	end

	local createElement = Roact.createElement
	local v9 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

	local createElement2 = Roact.createElement
	local v12 = {
		title = props2.titleText,
		bodyText = v5,
		buttonStackInfo = 0,
		position = 0,
		screenSize = 0,
		defaultChildRef = 0
	}

	local v15 = {
		props = { onActivated = self.closePrompt, text = props2.cancelButtonText },
		isDefaultChild = true
	}

	local v17 = if fFlagAXCharacterToAvatarStrings then buttonType.PrimaryContextual else buttonType.PrimarySystem
	v12.buttonStackInfo = {
		buttons = {
			v15,
			{
				buttonType = v17,
				props = { onActivated = v7, text = v6 }
			}
		}
	}

	v12.position = UDim2.fromScale(0.5, 0.5)
	v12.screenSize = self.props.screenSize
	v12.defaultChildRef = self.props.defaultChildRef
	return createElement("Frame", v9, {
		Alert = createElement2(interactiveAlert, v12)
	})
end

function extended:render()
	return withLocalization({
		titleText = fFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.Title.DuplicateAvatar" or "Feature.Avatar.Heading.DuplicateCharacter",
		savedSimilarCharacter = fFlagAXCharacterToAvatarStrings and {
			"Feature.Avatar.Message.AddAvatarAgain",
			prevAvatar = self.props.duplicateOutfitName
		} or "Feature.Avatar.Label.SavedSimilarCharacter",
		savedSimilarCharacterNoName = fFlagAXCharacterToAvatarStrings and "Feature.Avatar.Label.Message.DuplicateAvatar" or "Feature.Avatar.Label.SavedSimilarCharacterNoName",
		addNewAvatarConfirmText = "Feature.Avatar.Label.Add",
		updateAvatarConfirmText = "Feature.Avatar.Label.Replace",
		cancelButtonText = "Feature.Avatar.Action.Cancel"
	})(function(p2)
		return self:renderLocalized(p2)
	end)
end

local function mapStateToProps(p2, p3)
	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos

	local v5 = if outfitInfos[p3.duplicateOutfitId] then outfitInfos[p3.duplicateOutfitId].name else nil

	return { screenSize = p2.ScreenSize, duplicateOutfitName = v5 }
end

local v5 = RoactRodux.connect(mapStateToProps, nil)(extended)

return (module3((module2((roactAppPolicy.connect(function(p2, p3)
	return { showCustomOutfitNames = p2.getCustomOutfitNames() }
end)(v5))))))
