local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local withNavigation = RoactNavigation.withNavigation
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local Focusable = RoactGamepad.Focusable
local ItemTile = UIBlox.Tile.ItemTile
local SetEmoteAssetId = require(Modules.AvatarExperience.ProfilePictureEditor.Thunks.SetEmoteAssetId)
local Constants2 = require(Modules.LuaApp.Constants)
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local ItemTileDetailButton = require(Modules.AvatarExperience.Common.Components.ItemTileDetailButton)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local OpenItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenItemDetails)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local withLastInputGroup = require(Modules.AvatarExperience.Common.Components.withLastInputGroup)
local withAdaptiveScrolling = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.withAdaptiveScrolling
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants3 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local v31 = Roact.PureComponent:extend("PPEEmoteItemTile")

v31.validateProps = t.strictInterface({
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

function v31.init(p1) -- line: 76
	-- upvalues: Roact (copy), CatalogUtils (copy), Constants (copy), AvatarScreen (copy), wasLastInputGamepad (copy), logOnOverlayClosed (copy)
	p1.tileRef = Roact.createRef()

	function p1.activateMoreButton() -- line: 79
		-- upvalues: CatalogUtils (copy), p1 (copy), Constants (copy)
		local v53 = CatalogUtils.GetItemSubType(p1.props.itemType, p1.props.itemData)
		local v54 = if not p1.props.itemData then nil else p1.props.itemData.priceInRobux
		local t1 = {
			mountAsFullView = true,
			closePreviousItemDetails = true,
			itemId = p1.props.itemId,
			itemType = Constants.ItemType.Asset,
			itemSubType = v53,
			priceInRobux = v54,
			catalogAnalytics = p1.props.catalogAnalytics,
			avatarRoute = p1.props.avatarRoute,
			navigation = p1.props.navigation,
			itemDetailsPeekViewRefs = p1.props.itemDetailsPeekViewRefs,
			resultsListRef = p1.props.resultsListRef
		}

		p1.props.openItemDetails(t1)
	end
	function p1.toggleAdaptiveScrollingSelectedItem(b1: boolean?) -- line: 98
		-- upvalues: p1 (copy)
		local adaptiveScrolling = p1.props.adaptiveScrolling

		if not adaptiveScrolling then
			return
		end

		if b1 then
			adaptiveScrolling.setSelectedItemInstance(nil)

			return
		end

		if p1.tileRef.current then
			adaptiveScrolling.setSelectedItemInstance(p1.tileRef.current)
		end
	end
	function p1.toggleSelectEmote() -- line: 110
		-- upvalues: p1 (copy), Constants (copy), AvatarScreen (copy), wasLastInputGamepad (copy), logOnOverlayClosed (copy)
		local itemId = p1.props.itemId
		local navigation = p1.props.navigation

		if itemId == p1.props.emoteAssetId then
			p1.props.setEmoteAssetId(nil, navigation)
			p1.toggleAdaptiveScrollingSelectedItem(true)

			return
		end

		if p1.props.avatarType == Constants.AvatarType.R6 then
			p1.props.navigation.navigate(AvatarScreen.R15UpgradePrompt, {
				bodyTextKey = "Feature.Avatar.Label.PPEEmoteR15Warning",
				onSwitchSelected = function() -- line: 123
					-- upvalues: p1 (copy), itemId (copy), navigation (copy)
					p1.props.setEmoteAssetId(itemId, navigation)
					p1.toggleAdaptiveScrollingSelectedItem(false)
				end,
				onOverlayClosed = function() -- line: 127
					-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy)
					local v64 = wasLastInputGamepad()

					logOnOverlayClosed("EmotesScrollView", v64)
				end
			})

			return
		end

		p1.props.setEmoteAssetId(itemId, navigation)
		p1.toggleAdaptiveScrollingSelectedItem(false)
	end
end
function v31.shouldProvideControlsToViewItemDetails(p2) -- line: 142
	if not p2.props.itemId then
		return false
	end

	if not p2.props.isSelected then
		return false
	end

	return true
end
function v31.renderMoreButton(p3) -- line: 160
	-- upvalues: Constants2 (copy), Roact (copy), ItemTileDetailButton (copy)
	if not p3:shouldProvideControlsToViewItemDetails() then
		return nil
	end

	if p3.props.lastInputGroup == Constants2.InputType.Gamepad then
		return nil
	end

	return Roact.createElement(ItemTileDetailButton, {
		activateButton = p3.activateMoreButton
	})
end
function v31.render(p4) -- line: 177
	-- upvalues: Constants (copy), RoactGamepad (copy), Roact (copy), Focusable (copy), ItemTile (copy)
	local ItemTileTitleMaxLines = Constants.ItemTileTitleMaxLines
	local titleFontStyle = p4.props.titleFontStyle
	local v42 = p4:shouldProvideControlsToViewItemDetails()
	local t2 = {
		ToggleSelect = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, p4.toggleSelectEmote),
		MoreDetails = if not v42 then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, p4.activateMoreButton, {
			key = "CommonUI.Features.Label.More"
		})
	}

	return Roact.createElement(Focusable[ItemTile], {
		isSelected = p4.props.isSelected,
		onActivated = p4.toggleSelectEmote,
		thumbnail = p4.props.thumbnail,
		titleTextLineCount = ItemTileTitleMaxLines,
		titleFontStyle = titleFontStyle,
		name = p4.props.name,
		inputBindings = t2,
		renderTileInset = function() -- line: 200
			-- upvalues: p4 (copy)
			return p4:renderMoreButton()
		end,
		[Roact.Ref] = p4.tileRef
	})
end

local function mapStateToProps(p5, p6) -- line: 207
	-- upvalues: ItemData (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants3 (copy)
	local emoteAssetId = p5.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId
	local AvatarType = p5.AvatarExperience.AvatarEditor.Character.AvatarType
	local itemId = p6.itemId
	local v49 = nil
	local v50 = nil
	local v51 = nil

	if itemId then
		v49 = ItemData(p5.AvatarExperience.Common, itemId, Constants.ItemType.Asset)
		v50 = v49 and v49.name or nil
		v51 = getRbxthumbWithTypeSizeAndOptions(itemId, Constants3.RbxthumbTypes.Asset, 150)
	end

	return {
		itemData = v49,
		emoteAssetId = emoteAssetId,
		name = v50,
		thumbnail = v51,
		avatarType = AvatarType
	}
end

local v33 = withLastInputGroup(v31)

local function mapDispatchToProps(p7) -- line: 232
	-- upvalues: SetEmoteAssetId (copy), NavigateWithLock (copy), OpenItemDetails (copy)
	return {
		setEmoteAssetId = function(p8, p9) -- line: 234
			-- upvalues: p7 (copy), SetEmoteAssetId (copy)
			return p7(SetEmoteAssetId(p8, p9))
		end,
		navigateWithLock = function(p10) -- line: 237
			-- upvalues: p7 (copy), NavigateWithLock (copy)
			p7(NavigateWithLock(p10))
		end,
		openItemDetails = function(p11) -- line: 240
			-- upvalues: p7 (copy), OpenItemDetails (copy)
			p7(OpenItemDetails(p11))
		end
	}
end

local v35 = withAdaptiveScrolling((withAvatarRoute((withNavigation(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v33), nil)))))

return (RoactServices.connect({
	catalogAnalytics = Analytics
})(v35))
