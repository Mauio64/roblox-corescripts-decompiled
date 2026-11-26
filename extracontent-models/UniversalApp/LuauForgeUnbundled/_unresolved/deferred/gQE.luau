local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local focusable = RoactGamepad.Focusable

local images = UIBlox.App.ImageSet.Images

local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/fCe")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/egx")
local module3 = require("@luauforge/bundled/ecq")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module4 = require("@luauforge/bundled/dXh")
local module5 = require("@luauforge/deferred/gOU")
require("@luauforge/bundled/dKT")

local module6 = require("@luauforge/bundled/fDz")
local module7 = require("@luauforge/bundled/fAe")
local module8 = require("@luauforge/bundled/fDf")
local module9 = require("@luauforge/deferred/gLe")

local module10 = require("@luauforge/deferred/gQF")

local peekViewState = require("@luauforge/bundled/dCI").PeekViewState

local platform = UserInputService:GetPlatform()
local v5 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX

local iconsnavigationclose = images["icons/navigation/close"]
local iconsnavigationpushBack = images["icons/navigation/pushBack"]
local iconsactionstruncationExpand = images["icons/actions/truncationExpand"]
local v6 = v5 and 0.5 or 0
local extended = Roact.PureComponent:extend("PeekViewTopBar")

extended.validateProps = t.strictInterface({
	forwardRef = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	itemId = t.optional(t.string),
	itemType = t.optional(t.string),
	itemData = t.optional(module9),
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

function extended:init()
	function self.navigateBack()
		local navigation = self.props.navigation
		self.props.closeFocusedScreen(navigation)
	end

	function self.closeFiltersAndItemDetails()
		local navigation = self.props.navigation

		module4.closeFiltersAndItemDetails(navigation)
	end

	self.buttonRef = self.props.forwardRef or Roact.createRef()
	self.secondaryButtonRef = Roact.createRef()
end

function extended:renderBothButtons(p2, callback)
	return Roact.createFragment({
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 0)
		}),
		UIPadding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, 0) }),
		BackButton = Roact.createElement(focusable.TextButton, {
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0, v6),
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.Activated] = self.navigateBack,
			[Roact.Ref] = self.buttonRef,
			NextSelectionRight = self.secondaryButtonRef,
			SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
		}, {
			BackButtonIcon = Roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 36, 0, 36),
				Image = iconsnavigationpushBack,
				ImageColor3 = p2
			})
		}),
		CloseButton = Roact.createElement(focusable.TextButton, {
			LayoutOrder = 2,
			AnchorPoint = Vector2.new(0, v6),
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.Activated] = self.closeFiltersAndItemDetails,
			[Roact.Ref] = self.secondaryButtonRef,
			NextSelectionLeft = self.buttonRef,
			SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
		}, {
			CloseButtonIcon = Roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 36, 0, 36),
				Image = iconsnavigationclose,
				ImageColor3 = p2
			})
		})
	})
end

function extended:isFirstItemDetailVisible()
	local previousPages = self.props.avatarRoute.previousPages
	local count = 0

	if #previousPages == 0 then
		return nil
	end

	for k, previousPage in pairs(previousPages) do
		if previousPage.name == avatarScreen.ItemDetails then
			count += 1
		end
	end

	return count == 0 and module4.isFirstItemDetailsPage(self.props.navigation)
end

function extended:render()
	local statusBarHeight = self.props.statusBarHeight
	local topBarHeight = self.props.topBarHeight
	local firstItemDetailsPage = module4.isFirstItemDetailsPage(self.props.navigation)
	local v7 = self.props.dropDownTopBar and true or firstItemDetailsPage

	local param = self.props.navigation.getParam("showFullWithNoPeekView")
	local v8 = param and not v7
	local firstItemDetailVisible = self:isFirstItemDetailVisible()

	return withStyle(function(p2)
		return withSelectionCursorProvider(function(callback)
			local color = p2.Theme.IconEmphasis.Color
			local color2, v9

			if param and self.props.isPortrait then
				color2 = p2.Theme.BackgroundDefault.Color
				v9 = 0
			else
				v9 = 1
			end

			local v10 = self.props.dropDownTopBar and self.props.peekViewState == peekViewState.Full
			local size_1200 = p2.Tokens.Size.Size_1200
			local size_1200_2 = p2.Tokens.Size.Size_1200
			local v11

			if v8 then
				v11 = self:renderBothButtons(color, callback)
			else
				v11 = {
					RobuxBalance = 0,
					TouchFriendlyNavigationButton = 0,
					TouchFriendlyDownButton = 0
				}
				local v12

				if self.props.showRobuxBalance then
					v12 = Roact.createElement("Frame", {
						AutomaticSize = Enum.AutomaticSize.XY,
						AnchorPoint = Vector2.new(1, v6),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, -p2.Tokens.Size.Size_300, v6, statusBarHeight),
						ZIndex = 0
					}, {
						RobuxBalance = Roact.createElement(module10, {
							[Roact.Ref] = self.robuxBalanceRef
						})
					})
				end

				v11.RobuxBalance = v12

				local v13 = not v10

				if v13 then
					v13 = Roact.createElement(focusable.TextButton, {
						AnchorPoint = Vector2.new(0, v6),
						Position = UDim2.new(0, 15, v6, statusBarHeight),
						Size = UDim2.new(0, 36, 0, 36),
						BackgroundTransparency = 1,
						Text = "",
						[Roact.Event.Activated] = self.navigateBack,
						[Roact.Ref] = self.buttonRef,
						Visible = firstItemDetailVisible,
						NextSelectionDown = self.props.NextSelectionDown,
						SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
					}, {
						CloseButton = v7 and Roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 36, 0, 36),
							Image = iconsnavigationclose,
							ImageColor3 = color
						}),
						BackButton = not v7 and Roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 36, 0, 36),
							Image = iconsnavigationpushBack,
							ImageColor3 = color
						})
					})
				end

				v11.TouchFriendlyNavigationButton = v13

				if v10 then
					v10 = Roact.createElement(focusable.TextButton, {
						AnchorPoint = Vector2.new(0, v6),
						Position = UDim2.new(0, p2.Tokens.Size.Size_300, v6, statusBarHeight),
						Size = UDim2.new(0, 36, 0, 36),
						BackgroundTransparency = 1,
						Text = "",
						[Roact.Event.Activated] = self.props.closePeekView,
						[Roact.Ref] = self.buttonRef,
						Visible = firstItemDetailVisible,
						NextSelectionDown = self.props.NextSelectionDown,
						SelectionImageObject = callback(cursorKind.RoundedRectNoInset)
					}, {
						DownButton = Roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, size_1200, 0, size_1200_2),
							Image = iconsactionstruncationExpand,
							ImageColor3 = color
						})
					})
				end

				v11.TouchFriendlyDownButton = v10
			end

			return Roact.createElement(focusable.Frame, {
				Active = true,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, topBarHeight),
				BorderSizePixel = 0,
				BackgroundTransparency = v9,
				BackgroundColor3 = color2,
				NextSelectionLeft = self.props.NextSelectionLeft,
				NextSelectionRight = self.props.NextSelectionRight,
				NextSelectionUp = self.props.NextSelectionUp,
				NextSelectionDown = self.props.NextSelectionDown
			}, v11)
		end)
	end)
end

local v7 = withNavigation(extended)

local function mapStateToProps(p2, p3)
	local deviceOrientation = p2.DeviceOrientation

	return {
		topBarHeight = module.getTopBarHeightAvatarScene(p2),
		statusBarHeight = p2.TopBar.statusBarHeight,
		isPortrait = deviceOrientation == deviceOrientationMode.Portrait
	}
end

local function mapDispatchToProps(callback)
	return {
		closeFocusedScreen = function(p2)
			callback(module5(p2))
		end,
		toggleTryOn = function(p2, p3, p4, p5, p6, p7, p8, p9)
			callback(module6(p2, p3, p4, p5, p6, p7, p8, p9))
		end
	}
end

local v8 = roactServices.connect({
	catalogAnalytics = module8,
	appAnalytics = module3,
	networking = module2
})(v7)

local v9 = module7((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v8)))

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v9, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
