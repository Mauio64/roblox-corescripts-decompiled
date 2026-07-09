local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Utils = require(Modules.AvatarExperience.Common.Utils)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local CloseFocusedScreen = require(Modules.AvatarExperience.Common.Thunks.CloseFocusedScreen)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local ItemDataValidator = require(Modules.AvatarExperience.Common.Validators.ItemDataValidator)
local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagAXTryOnScreenImprovements = SharedFlags.FFlagAXTryOnScreenImprovements
local RobuxBalance = require(Modules.AvatarExperience.Catalog.Components.RobuxBalance)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local Platform = UserInputService:GetPlatform()
local v37 = Platform == Enum.Platform.Windows or Platform == Enum.Platform.OSX
local v38 = Images["icons/navigation/close"]
local v39 = Images["icons/navigation/pushBack"]
local v40 = Images["icons/actions/truncationExpand"]
local v41 = not v37 and 0 or 0.5
local v42 = Roact.PureComponent:extend("PeekViewTopBar")

v42.validateProps = t.strictInterface({
	forwardRef = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	itemId = t.optional(t.string),
	itemType = t.optional(t.string),
	itemData = t.optional(ItemDataValidator),
	dropDownTopBar = t.optional(t.boolean),
	peekViewState = t.optional(t.any),
	closePeekView = t.optional(t.callback),
	showRobuxBalance = t.optional(t.boolean),
	topBarHeight = t.number,
	statusBarHeight = t.number,
	isPortrait = t.optional(t.boolean),
	closeFocusedScreen = t.callback,
	toggleTryOn = t.optional(t.callback),
	navigation = t.table,
	networking = t.callback,
	catalogAnalytics = t.table,
	appAnalytics = t.table,
	avatarRoute = t.table
})

function v42.init(p1) -- line: 101
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), CatalogUtils (copy), NavigationUtils (copy), Roact (copy)
	function p1.navigateBack() -- line: 102
		-- upvalues: p1 (copy)
		local navigation = p1.props.navigation

		p1.props.closeFocusedScreen(navigation)
	end
	function p1.closeFiltersAndItemDetails() -- line: 112
		-- upvalues: p1 (copy), FFlagAXMISEnableMultiShopping (copy), CatalogUtils (copy), NavigationUtils (copy)
		local navigation = p1.props.navigation

		if not FFlagAXMISEnableMultiShopping then
			local itemData = p1.props.itemData

			if itemData ~= nil then
				local itemId = p1.props.itemId
				local itemType = p1.props.itemType
				local v77 = CatalogUtils.GetItemSubType(itemType, itemData)

				p1.props.toggleTryOn(p1.props.networking, p1.props.catalogAnalytics, itemType, v77, itemId, true, p1.props.avatarRoute, navigation)
			end
		end

		NavigationUtils.closeFiltersAndItemDetails(navigation)
	end

	p1.buttonRef = p1.props.forwardRef or Roact.createRef()
	p1.secondaryButtonRef = Roact.createRef()
end
function v42.renderBothButtons(p2, p3, p4) -- line: 153
	-- upvalues: Roact (copy), Focusable (copy), v41 (copy), CursorKind (copy), ImageSetLabel (copy), v39 (copy), v38 (copy)
	return Roact.createFragment({
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 0)
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 0)
		}),
		BackButton = Roact.createElement(Focusable.TextButton, {
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0, v41),
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.Activated] = p2.navigateBack,
			[Roact.Ref] = p2.buttonRef,
			NextSelectionRight = p2.secondaryButtonRef,
			SelectionImageObject = p4(CursorKind.RoundedRectNoInset)
		}, {
			BackButtonIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 36, 0, 36),
				Image = v39,
				ImageColor3 = p3
			})
		}),
		CloseButton = Roact.createElement(Focusable.TextButton, {
			LayoutOrder = 2,
			AnchorPoint = Vector2.new(0, v41),
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.Activated] = p2.closeFiltersAndItemDetails,
			[Roact.Ref] = p2.secondaryButtonRef,
			NextSelectionLeft = p2.buttonRef,
			SelectionImageObject = p4(CursorKind.RoundedRectNoInset)
		}, {
			CloseButtonIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 36, 0, 36),
				Image = v38,
				ImageColor3 = p3
			})
		})
	})
end
function v42.isFirstItemDetailVisible(p5) -- line: 216
	-- upvalues: AvatarScreen (copy), NavigationUtils (copy)
	local previousPages = p5.props.avatarRoute.previousPages
	local n1 = 0

	if #previousPages == 0 then
		return nil
	end

	for _, v in pairs(previousPages) do
		if v.name == AvatarScreen.ItemDetails then
			n1 += 1
		end
	end

	return n1 == 0 and NavigationUtils.isFirstItemDetailsPage(p5.props.navigation)
end
function v42.render(p6) -- line: 232
	-- upvalues: NavigationUtils (copy), FFlagAXTryOnScreenImprovements (copy), withStyle (copy), withSelectionCursorProvider (copy), PeekViewState (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), v41 (copy), RobuxBalance (copy), Focusable (copy), CursorKind (copy), ImageSetLabel (copy), v38 (copy), v39 (copy), v40 (copy)
	local statusBarHeight = p6.props.statusBarHeight
	local topBarHeight = p6.props.topBarHeight
	local u60 = NavigationUtils.isFirstItemDetailsPage(p6.props.navigation)

	if p6.props.dropDownTopBar then
		u60 = true
	end

	local v61 = if not FFlagAXTryOnScreenImprovements then p6.props.navigation.getParam("fromProfile") else nil
	local u62 = nil

	if not FFlagAXTryOnScreenImprovements then
		u62 = p6.props.navigation.getParam("fromHome")
	end

	local v63 = p6.props.navigation.getParam("showFullWithNoPeekView")
	local v64 = v63 and not u60
	local v65 = p6:isFirstItemDetailVisible()

	return withStyle(function(p7) -- line: 250
		-- upvalues: withSelectionCursorProvider (copy), FFlagAXTryOnScreenImprovements (copy), v61 (copy), v63 (copy), u62 (ref), p6 (copy), PeekViewState (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v64 (copy), Roact (copy), v41 (copy), statusBarHeight (copy), RobuxBalance (copy), Focusable (copy), v65 (copy), CursorKind (copy), u60 (ref), ImageSetLabel (copy), v38 (copy), v39 (copy), v40 (copy), topBarHeight (copy)
		return withSelectionCursorProvider(function(p8) -- line: 251
			-- upvalues: FFlagAXTryOnScreenImprovements (copy), v61 (copy), v63 (copy), u62 (ref), p7 (copy), p6 (copy), PeekViewState (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v64 (copy), Roact (copy), v41 (copy), statusBarHeight (copy), RobuxBalance (copy), Focusable (copy), v65 (copy), CursorKind (copy), u60 (ref), ImageSetLabel (copy), v38 (copy), v39 (copy), v40 (copy), topBarHeight (copy)
			local v89 = if not FFlagAXTryOnScreenImprovements and (not v61 and (not v63 and not u62)) then Color3.new(1, 1, 1) else p7.Theme.IconEmphasis.Color
			local n2 = 1
			local BackgroundDefaultColor = nil

			if v63 and p6.props.isPortrait then
				n2 = 0
				BackgroundDefaultColor = p7.Theme.BackgroundDefault.Color
			end

			local v92 = p6.props.dropDownTopBar and p6.props.peekViewState == PeekViewState.Full
			local v93 = if not FFlagRenameDeprecatedUIBloxTokens then p7.Tokens.Global.Size_600 else p7.Tokens.Size.Size_1200
			local v94 = if not FFlagRenameDeprecatedUIBloxTokens then p7.Tokens.Global.Size_600 else p7.Tokens.Size.Size_1200
			local v95 = if not v64 then {
				RobuxBalance = if not p6.props.showRobuxBalance then nil else Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					AnchorPoint = Vector2.new(1, v41),
					Position = UDim2.new(1, -if not FFlagRenameDeprecatedUIBloxTokens then p7.Tokens.Global.Space_150 else p7.Tokens.Size.Size_300, v41, statusBarHeight)
				}, {
					RobuxBalance = Roact.createElement(RobuxBalance, {
						[Roact.Ref] = p6.robuxBalanceRef
					})
				}),
				TouchFriendlyNavigationButton = not v92 and Roact.createElement(Focusable.TextButton, {
					AnchorPoint = Vector2.new(0, v41),
					Position = UDim2.new(0, 15, v41, statusBarHeight),
					Size = UDim2.new(0, 36, 0, 36),
					BackgroundTransparency = 1,
					Text = "",
					[Roact.Event.Activated] = p6.navigateBack,
					[Roact.Ref] = p6.buttonRef,
					Visible = v65,
					NextSelectionDown = p6.props.NextSelectionDown,
					SelectionImageObject = p8(CursorKind.RoundedRectNoInset)
				}, {
					CloseButton = u60 and Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 36, 0, 36),
						Image = v38,
						ImageColor3 = v89
					}),
					BackButton = not u60 and Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 36, 0, 36),
						Image = v39,
						ImageColor3 = v89
					})
				}),
				TouchFriendlyDownButton = v92 and Roact.createElement(Focusable.TextButton, {
					AnchorPoint = Vector2.new(0, v41),
					Position = UDim2.new(0, if not FFlagRenameDeprecatedUIBloxTokens then p7.Tokens.Global.Space_150 else p7.Tokens.Size.Size_300, v41, statusBarHeight),
					Size = UDim2.new(0, 36, 0, 36),
					BackgroundTransparency = 1,
					Text = "",
					[Roact.Event.Activated] = p6.props.closePeekView,
					[Roact.Ref] = p6.buttonRef,
					Visible = v65,
					NextSelectionDown = p6.props.NextSelectionDown,
					SelectionImageObject = p8(CursorKind.RoundedRectNoInset)
				}, {
					DownButton = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, v93, 0, v94),
						Image = v40,
						ImageColor3 = v89
					})
				})
			} else p6:renderBothButtons(v89, p8)

			return Roact.createElement(Focusable.Frame, {
				Active = true,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, topBarHeight),
				BackgroundTransparency = n2,
				BackgroundColor3 = BackgroundDefaultColor,
				NextSelectionLeft = p6.props.NextSelectionLeft,
				NextSelectionRight = p6.props.NextSelectionRight,
				NextSelectionUp = p6.props.NextSelectionUp,
				NextSelectionDown = p6.props.NextSelectionDown
			}, v95)
		end)
	end)
end

local v43 = withNavigation(v42)

local function mapStateToProps(p9, _) -- line: 389
	-- upvalues: Utils (copy), DeviceOrientationMode (copy)
	local DeviceOrientation = p9.DeviceOrientation

	return {
		topBarHeight = Utils.getTopBarHeightAvatarScene(p9),
		statusBarHeight = p9.TopBar.statusBarHeight,
		isPortrait = DeviceOrientation == DeviceOrientationMode.Portrait
	}
end
local function mapDispatchToProps(p11: ((...any) -> ...any)) -- line: 399
	-- upvalues: CloseFocusedScreen (copy), ToggleTryOnThunk (copy)
	return {
		closeFocusedScreen = function(p12) -- line: 401
			-- upvalues: p11 (copy), CloseFocusedScreen (copy)
			p11(CloseFocusedScreen(p12))
		end,
		toggleTryOn = function(p13, p14, p15, p16, p17, p18, p19, p20) -- line: 405
			-- upvalues: p11 (copy), ToggleTryOnThunk (copy)
			p11(ToggleTryOnThunk(p13, p14, p15, p16, p17, p18, p19, p20))
		end
	}
end

local v46 = RoactServices.connect({
	catalogAnalytics = Analytics,
	appAnalytics = RoactAnalytics,
	networking = RoactNetworking
})(v43)
local u47 = withAvatarRoute((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v46)))

return Roact.forwardRef(function(p21, p22) -- line: 440
	-- upvalues: Roact (copy), u47 (ref), Cryo (copy)
	return Roact.createElement(u47, Cryo.Dictionary.join(p21, {
		forwardRef = p22
	}))
end)
