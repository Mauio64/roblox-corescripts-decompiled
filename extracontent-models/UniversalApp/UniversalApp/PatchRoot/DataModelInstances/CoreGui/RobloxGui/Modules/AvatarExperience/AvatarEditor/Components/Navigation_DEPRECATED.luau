local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local withNavigation = RoactNavigation.withNavigation
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local RemoveNewAssetNotification = require(Modules.AvatarExperience.Common.Actions.RemoveNewAssetNotification)
local RemoveNewOutfitNotification = require(Modules.AvatarExperience.Common.Actions.RemoveNewOutfitNotification)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local NavigationFrame = require(Modules.AvatarExperience.Common.Components.NavBar.NavigationFrame)
local withOpaqueAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withOpaqueAvatarRoute)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local NavigatedToDeepLinkAvatarEditor = require(Modules.AvatarExperience.AvatarEditor.Actions.NavigatedToDeepLinkAvatarEditor)
local DeepLinkUtils = require(Modules.AvatarExperience.Common.DeepLinkUtils)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local Exit3DFullView = require(Modules.AvatarExperience.Common.Thunks.Exit3DFullView)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v29 = Roact.PureComponent:extend("Navigation")

v29.validateProps = t.strictInterface({
	analytics = t.table,
	axAnalytics = t.table,
	layoutOrderMain = t.number,
	layoutOrderSub = t.number,
	navHeightMain = t.number,
	navHeightSub = t.number,
	absoluteSizeChanged = t.callback,
	navBarRef = t.table,
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	backToTopSignal = t.optional(t.table),
	avatarType = t.string,
	selectedCategoryIndex = t.number,
	selectedSubcategoryIndex = t.number,
	newItemNotifications = t.table,
	externalNavigationRequest = t.table,
	exit3DFullView = t.callback,
	setCategoryAndSubcategory = t.callback,
	clearTryOns = t.callback,
	removeNewAssetNotification = t.callback,
	removeNewOutfitNotification = t.callback,
	navigatedToDeepLinkAvatarEditor = t.callback,
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil,
	navigation = t.table,
	opaqueRoute = t.table,
	networking = t.callback
})

function v29.removeNewItemNotificationIfNeeded(p1, p2, p3) -- line: 83
	-- upvalues: GetAvatarEditorCategories (copy), Constants (copy), Constants2 (copy)
	local v37 = GetAvatarEditorCategories()
	local Subcategories = v37[p2].Subcategories
	local v39 = Subcategories and (not not Subcategories[p3] and Subcategories[p3].AssetTypeIdStrings) or v37[p2].AssetTypeIdStrings

	if v39 then
		for _, v41 in v39 do
			if p1.props.newItemNotifications[v41] then
				p1.props.removeNewAssetNotification(v41)
			end
		end

		return
	end

	if p1.props.newItemNotifications[Constants.NewOutfitNotificationKey] then
		if Subcategories and Subcategories[p3] and Subcategories[p3].SearchUuid == Constants2.PurchasedCharacterKey then
			p1.props.removeNewOutfitNotification(Constants.OutfitTypes.Avatar)

			return
		end
	elseif p1.props.newItemNotifications[Constants.NewDHOutfitNotificationKey] and Subcategories and Subcategories[p3] and Subcategories[p3].Name == "Style" then
		p1.props.removeNewOutfitNotification(Constants.OutfitTypes.DynamicHead)
	end
end
function v29.setCategoryAndSubcategory(t1: {[any]: any}, n1: number?, n2: number?) -- line: 119
	local analytics = t1.props.analytics
	local axAnalytics = t1.props.axAnalytics
	local navigation = t1.props.navigation
	local backToTopSignal = t1.props.backToTopSignal

	if backToTopSignal and (n1 == nil or n1 == t1.props.selectedCategoryIndex) and (n2 == nil or n2 == t1.props.selectedSubcategoryIndex) then
		backToTopSignal:fire()
	end

	t1.props.setCategoryAndSubcategory(n1, n2, analytics)
	t1.props.exit3DFullView(axAnalytics, navigation.state.routeName)
end
function v29.init(p4) -- line: 139
	-- upvalues: Constants (copy), AvatarScreen (copy), GetAvatarEditorCategories (copy), wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	local function promptR15UpgradeIfNecessary(p5) -- line: 140
		-- upvalues: Constants (copy), p4 (copy), AvatarScreen (copy)
		local v84 = ({
			[Constants.PageType.Animation] = "Feature.Avatar.Message.R15AnimationsPrompt",
			[Constants.PageType.Emotes] = "Feature.Avatar.Message.R15EmotesPrompt",
			[Constants.PageType.BodyStyle] = "Feature.Avatar.Message.R15StylesPrompt"
		})[p5]

		if v84 ~= nil then
			p4.props.navigation.navigate(AvatarScreen.R15UpgradePrompt, {
				onOverlayClosed = p4.onR15PromptClosed,
				bodyTextKey = v84
			})
		end
	end

	function p4.selectCategory(p6) -- line: 161
		-- upvalues: p4 (copy), Constants (copy), GetAvatarEditorCategories (copy), promptR15UpgradeIfNecessary (copy)
		p4:removeNewItemNotificationIfNeeded(p6, 1)
		p4:setCategoryAndSubcategory(p6, nil)

		if p4.props.avatarType == Constants.AvatarType.R6 then
			local v86 = GetAvatarEditorCategories()[p6]

			promptR15UpgradeIfNecessary(v86.PageType)
		end
	end
	function p4.onR15PromptClosed() -- line: 176
		-- upvalues: wasLastInputGamepad (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p4 (copy)
		local v87 = wasLastInputGamepad()

		logOnOverlayClosed("Navigation", v87)

		if not FFlagAXMigrateAXToGlobalAutofocus and v87 then
			p4.props.focusController.captureFocus()
		end
	end
	function p4.selectSubcategory(p7, p8) -- line: 185
		-- upvalues: p4 (copy), Constants (copy), GetAvatarEditorCategories (copy), promptR15UpgradeIfNecessary (copy)
		p4:removeNewItemNotificationIfNeeded(p7, p8)

		if p4.props.avatarType == Constants.AvatarType.R6 then
			local v90 = GetAvatarEditorCategories()[p7]

			if v90 then
				local v91 = v90.Subcategories[p8]

				if v91 then
					promptR15UpgradeIfNecessary(v91.PageType)
				end
			end
		end

		p4:setCategoryAndSubcategory(nil, p8)
	end

	local v51 = p4.props.navigation.getParam("avatarEditorCategory")

	if v51 then
		p4.selectCategory(v51)
	end

	local v52 = p4.props.navigation.getParam("avatarEditorSubcategory")

	if v52 then
		p4.selectSubcategory(v51, v52)
	end
end
function v29.onSubNavigationPropsDidUpdate(p9) -- line: 214
	local selectedCategoryIndex = p9.props.selectedCategoryIndex
	local selectedSubcategoryIndex = p9.props.selectedSubcategoryIndex

	return function(p10, p11) -- line: 218
		-- upvalues: selectedCategoryIndex (copy), selectedSubcategoryIndex (copy)
		local selectedCategoryIndex2 = p10.selectedCategoryIndex
		local selectedSubcategoryIndex2 = p10.selectedSubcategoryIndex
		local v96 = selectedCategoryIndex2 ~= selectedCategoryIndex
		local v97 = selectedSubcategoryIndex2 ~= selectedSubcategoryIndex

		if not v96 and not v97 then
			return
		end

		if v96 and p11.current then
			p11.current.CanvasPosition = Vector2.new()
		end
	end
end
function v29.willUpdate(p12, p13) -- line: 235
	-- upvalues: DeepLinkUtils (copy), NavigationUtils (copy)
	local v58 = p13.selectedCategoryIndex ~= p12.props.selectedCategoryIndex or p13.selectedSubcategoryIndex ~= p12.props.selectedSubcategoryIndex

	if DeepLinkUtils.avatarEditorDeepLinkExists(p12.props.externalNavigationRequest) then
		v58 = false
	end

	if v58 then
		p12.props.clearTryOns()
		NavigationUtils.closeFiltersAndItemDetails(p12.props.navigation)
	end
end
function v29.render(p14) -- line: 256
	-- upvalues: GetAvatarEditorCategories (copy), Roact (copy), NavigationFrame (copy)
	local layoutOrderMain = p14.props.layoutOrderMain
	local layoutOrderSub = p14.props.layoutOrderSub
	local navHeightMain = p14.props.navHeightMain
	local navHeightSub = p14.props.navHeightSub
	local selectedCategoryIndex = p14.props.selectedCategoryIndex
	local selectedSubcategoryIndex = p14.props.selectedSubcategoryIndex
	local absoluteSizeChanged = p14.props.absoluteSizeChanged
	local v67 = GetAvatarEditorCategories()
	local navBarRef = p14.props.navBarRef

	return Roact.createElement(NavigationFrame, {
		shouldUseCategoryId = false,
		layoutOrderMain = layoutOrderMain,
		navHeightMain = navHeightMain,
		layoutOrderSub = layoutOrderSub,
		navHeightSub = navHeightSub,
		categoryTable = v67,
		selectedCategoryIndex = selectedCategoryIndex,
		selectCategory = p14.selectCategory,
		selectedSubcategoryIndex = selectedSubcategoryIndex,
		subcategoryTable = v67[selectedCategoryIndex].Subcategories,
		onSubNavigationPropsDidUpdate = p14:onSubNavigationPropsDidUpdate(),
		selectSubcategory = p14.selectSubcategory,
		absoluteSizeChanged = absoluteSizeChanged,
		navigationFrameRef = navBarRef,
		NextSelectionUp = p14.props.NextSelectionUp,
		NextSelectionDown = p14.props.NextSelectionDown
	})
end
function v29.processAvatarEditorDeepLink(p15) -- line: 289
	-- upvalues: DeepLinkUtils (copy)
	local externalNavigationRequest = p15.props.externalNavigationRequest
	local v71 = externalNavigationRequest.params or {}

	if DeepLinkUtils.avatarEditorDeepLinkExists(externalNavigationRequest) then
		p15.props.navigatedToDeepLinkAvatarEditor({
			category = v71.category,
			subcategory = v71.subcategory
		})
	end
end
function v29.didMount(p16) -- line: 300
	p16:processAvatarEditorDeepLink()
end
function v29.didUpdate(p17, p18) -- line: 304
	-- upvalues: AvatarScreen (copy)
	p17:processAvatarEditorDeepLink()

	local name = p17.props.opaqueRoute.name

	if name ~= p18.opaqueRoute.name and name == AvatarScreen.AvatarEditor then
		p17:removeNewItemNotificationIfNeeded(p17.props.selectedCategoryIndex, p17.props.selectedSubcategoryIndex)
	end

	local v76 = p18.navigation.getParam("avatarEditorCategory")
	local v77 = p17.props.navigation.getParam("avatarEditorCategory")

	if v77 and v77 ~= v76 then
		p17.selectCategory(v77)
	end

	local v78 = p18.navigation.getParam("avatarEditorSubcategory")
	local v79 = p17.props.navigation.getParam("avatarEditorSubcategory")

	if v79 and v79 ~= v78 then
		p17.selectSubcategory(v77, v79)
	end
end

local v30 = RoactServices.connect({
	networking = RoactNetworking
})(v29)

local function mapStateToProps(p19) -- line: 334
	return {
		avatarType = p19.AvatarExperience.AvatarEditor.Character.AvatarType,
		selectedCategoryIndex = p19.AvatarExperience.AvatarEditor.Categories.category,
		selectedSubcategoryIndex = p19.AvatarExperience.AvatarEditor.Categories.subcategory,
		newItemNotifications = p19.AvatarExperience.AvatarEditor.NewItemNotifications,
		externalNavigationRequest = p19.AvatarExperience.ExternalNavigationRequest or {}
	}
end
local function mapDispatchToProps(p20) -- line: 346
	-- upvalues: SetCategoryAndSubcategory (copy), ClearTryOns (copy), RemoveNewAssetNotification (copy), RemoveNewOutfitNotification (copy), Exit3DFullView (copy), NavigatedToDeepLinkAvatarEditor (copy)
	return {
		setCategoryAndSubcategory = function(p21, p22, p23) -- line: 348
			-- upvalues: p20 (copy), SetCategoryAndSubcategory (copy)
			p20(SetCategoryAndSubcategory(p21, p22, p23))
		end,
		clearTryOns = function() -- line: 352
			-- upvalues: p20 (copy), ClearTryOns (copy)
			p20(ClearTryOns())
		end,
		removeNewAssetNotification = function(p24) -- line: 356
			-- upvalues: p20 (copy), RemoveNewAssetNotification (copy)
			p20(RemoveNewAssetNotification(p24))
		end,
		removeNewOutfitNotification = function(p25) -- line: 360
			-- upvalues: p20 (copy), RemoveNewOutfitNotification (copy)
			p20(RemoveNewOutfitNotification(p25))
		end,
		exit3DFullView = function(p26, p27) -- line: 364
			-- upvalues: p20 (copy), Exit3DFullView (copy)
			p20(Exit3DFullView(p26, p27))
		end,
		navigatedToDeepLinkAvatarEditor = function(p28) -- line: 368
			-- upvalues: p20 (copy), NavigatedToDeepLinkAvatarEditor (copy)
			p20(NavigatedToDeepLinkAvatarEditor(p28))
		end
	}
end

local u33 = withOpaqueAvatarRoute((withNavigation((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v30)))))

if FFlagAXMigrateAXToGlobalAutofocus then
	return u33
end

return function(p29) -- line: 383
	-- upvalues: RoactGamepad (copy), Roact (copy), u33 (ref), Cryo (copy)
	return RoactGamepad.withFocusController(function(p30) -- line: 384
		-- upvalues: Roact (copy), u33 (ref), Cryo (copy), p29 (copy)
		return Roact.createElement(u33, Cryo.Dictionary.join(p29, {
			focusController = p30
		}))
	end)
end
