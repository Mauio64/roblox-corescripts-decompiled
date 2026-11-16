local CorePackages = game:GetService("CorePackages")

local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local withNavigation = RoactNavigation.withNavigation
local module = require("@luauforge/bundled/fsK")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
require("@luauforge/bundled/dHK")

local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/dRQ")
local focusable = RoactGamepad.Focusable
local itemTile = UIBlox.Tile.ItemTile
local module4 = require("@luauforge/deferred/gUW")
local module5 = require("@luauforge/bundled/dwA")
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed
local module6 = require("@luauforge/deferred/gVa")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module7 = require("@luauforge/deferred/ggD")
local module8 = require("@luauforge/bundled/fvF")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad
local module9 = require("@luauforge/deferred/gmh")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module11 = require("@luauforge/bundled/cgr")
local constants = module11.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module11.Utils.getRbxthumbWithTypeSizeAndOptions

local extended = Roact.PureComponent:extend("PPEEmoteItemTile")

extended.validateProps = t.strictInterface({
	itemId = t.optional(t.string),
	titleFontStyle = t.optional(t.table),
	isSelected = t.boolean,
	itemDetailsPeekViewRefs = t.table,
	resultsListRef = t.table,
	navigation = t.table,
	avatarRoute = t.table,
	adaptiveScrolling = t.optional(t.table),
	itemData = t.optional(t.table),
	emoteAssetId = t.optional(t.string),
	name = t.optional(t.string),
	thumbnail = t.optional(t.string),
	avatarType = t.string,
	lastInputGroup = t.string,
	setEmoteAssetId = t.callback,
	navigateWithLock = t.callback,
	openItemDetails = t.callback,
	catalogAnalytics = t.table
})

function extended:init()
	self.tileRef = Roact.createRef()

	function self.activateMoreButton()
		local itemSubType = module3.GetItemSubType(self.props.itemType, self.props.itemData)
		local v5 = if self.props.itemData then self.props.itemData.priceInRobux else nil
		local v6 = {
			itemId = self.props.itemId,
			itemType = module2.ItemType.Asset,
			itemSubType = itemSubType,
			priceInRobux = v5,
			catalogAnalytics = self.props.catalogAnalytics,
			avatarRoute = self.props.avatarRoute,
			navigation = self.props.navigation,
			itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs,
			resultsListRef = self.props.resultsListRef,
			mountAsFullView = true,
			closePreviousItemDetails = true
		}

		self.props.openItemDetails(v6)
	end

	function self.toggleAdaptiveScrollingSelectedItem(p2)
		local adaptiveScrolling = self.props.adaptiveScrolling

		if not adaptiveScrolling then
			return
		end

		if p2 then
			adaptiveScrolling.setSelectedItemInstance(nil)
		elseif self.tileRef.current then
			adaptiveScrolling.setSelectedItemInstance(self.tileRef.current)
		end
	end

	function self.toggleSelectEmote()
		local itemId = self.props.itemId
		local navigation = self.props.navigation

		if itemId == self.props.emoteAssetId then
			self.props.setEmoteAssetId(nil, navigation)
			self.toggleAdaptiveScrollingSelectedItem(true)
		else
			if self.props.avatarType == module2.AvatarType.R6 then
				self.props.navigation.navigate(avatarScreen.R15UpgradePrompt, {
					bodyTextKey = "Feature.Avatar.Label.PPEEmoteR15Warning",
					onSwitchSelected = function()
						self.props.setEmoteAssetId(itemId, navigation)
						self.toggleAdaptiveScrollingSelectedItem(false)
					end,
					onOverlayClosed = function()
						logOnOverlayClosed("EmotesScrollView", (wasLastInputGamepad()))
					end
				})
				return
			end

			self.props.setEmoteAssetId(itemId, navigation)
			self.toggleAdaptiveScrollingSelectedItem(false)
		end
	end
end

function extended:shouldProvideControlsToViewItemDetails(): boolean
	if not self.props.itemId then
		return false
	end

	if self.props.isSelected then
		return true
	end

	return false
end

function extended:renderMoreButton()
	if not (self:shouldProvideControlsToViewItemDetails() and self.props.lastInputGroup ~= module5.InputType.Gamepad) then
		return nil
	end

	return Roact.createElement(module6, { activateButton = self.activateMoreButton })
end

function extended:render()
	local itemTileTitleMaxLines = module2.ItemTileTitleMaxLines
	local titleFontStyle = self.props.titleFontStyle

	local shouldProvideControlsToViewItemDetails = self:shouldProvideControlsToViewItemDetails()

	local v5 = {
		ToggleSelect = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, self.toggleSelectEmote),
		MoreDetails = 0
	}

	local v6 = if shouldProvideControlsToViewItemDetails then RoactGamepad.Input.onBegin(
		Enum.KeyCode.ButtonX,
		self.activateMoreButton,
		{ key = "CommonUI.Features.Label.More" }
	) else nil
	v5.MoreDetails = v6

	return Roact.createElement(focusable[itemTile], {
		isSelected = self.props.isSelected,
		onActivated = self.toggleSelectEmote,
		thumbnail = self.props.thumbnail,
		titleTextLineCount = itemTileTitleMaxLines,
		titleFontStyle = titleFontStyle,
		name = self.props.name,
		inputBindings = v5,
		renderTileInset = function()
			return self:renderMoreButton()
		end,
		[Roact.Ref] = self.tileRef
	})
end

local function mapStateToProps(p2, p3)
	local emoteAssetId = p2.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId
	local avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType

	local itemId = p3.itemId
	local v5, name, v6

	if itemId then
		v5 = itemData(p2.AvatarExperience.Common, itemId, module2.ItemType.Asset)

		if v5 then
			name = v5.name or nil
		end

		v6 = getRbxthumbWithTypeSizeAndOptions(itemId, constants.RbxthumbTypes.Asset, 150)
	end

	return {
		itemData = v5,
		emoteAssetId = emoteAssetId,
		name = name,
		thumbnail = v6,
		avatarType = avatarType
	}
end

local v5 = module9(extended)

local function mapDispatchToProps(callback)
	return {
		setEmoteAssetId = function(p2, p3)
			return callback(module4(p2, p3))
		end,
		navigateWithLock = function(p2)
			callback(navigateWithLock(p2))
		end,
		openItemDetails = function(p2)
			callback(module7(p2))
		end
	}
end

local v6 = withAdaptiveScrolling((module((withNavigation(
	RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v5),
	nil
)))))

return (roactServices.connect({ catalogAnalytics = module8 })(v6))
