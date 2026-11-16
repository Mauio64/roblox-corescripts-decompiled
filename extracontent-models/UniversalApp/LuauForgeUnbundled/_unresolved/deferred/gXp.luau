local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)

local fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation

local module = require("@luauforge/deferred/gfl")

local module2 = require("@luauforge/bundled/gfm")
require("@luauforge/bundled/dHK")
local module3 = require("@luauforge/deferred/gmY")

local fFlagCleanupTenFootUiPaddingAndAnalytics = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCleanupTenFootUiPaddingAndAnalytics

local UIBlox = require(CorePackages.Packages.UIBlox)
local headerBar = UIBlox.App.Bar.HeaderBar
local withStyle = UIBlox.Style.withStyle
local images = UIBlox.App.ImageSet.Images

local component_assetscircle_17 = images["component_assets/circle_17"]

local extended = Roact.PureComponent:extend("NavOverlayPageContainer")

local strictInterface = t.strictInterface
local tablesByChildren = {
	["headerBarProps"] = nil,
	["headerBarProps"] = nil,
	headerBarProps = t.strictInterface({
		title = t.string,
		renderLeft = t.optional(t.callback),
		renderRight = t.optional(t.callback)
	}),
	onDismiss = t.optional(t.callback),
	ZIndex = t.optional(t.integer),
	[Roact.Children] = t.table,
	globalGuiInset = t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	}),
	isPortrait = t.boolean,
	statusBarHeight = t.number
}

local v5 = if not fFlagCleanupTenFootUiPaddingAndAnalytics then t.any else nil
tablesByChildren.designTokens = v5

local v6 = if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then t.optional(t.union(t.callback, t.table)) else nil
tablesByChildren.forwardRef = v6
extended.validateProps = strictInterface(tablesByChildren)

function extended:renderWithProviders(p3)
	local theme = p3.Theme

	local globalGuiInset = self.props.globalGuiInset

	local v7 = theme.BackgroundDefault
	local v8

	if self.props.isPortrait then
		v8 = {}
	else
		v7 = theme.BackgroundMuted

		local imageRectSize = component_assetscircle_17.ImageRectSize
		local imageRectOffset = component_assetscircle_17.ImageRectOffset

		local x = imageRectSize.X
		local v9 = x / 2

		v8 = {
			BackgroundTransparency = 1,
			Image = component_assetscircle_17.Image,
			ScaleType = Enum.ScaleType.Slice,
			SliceScale = 1 / images.ImagesResolutionScale,
			SliceCenter = Rect.new(v9 - 1, v9 - 1, v9 + 1, v9),
			ImageRectSize = Vector2.new(x, v9),
			ImageRectOffset = imageRectOffset,
			ImageTransparency = theme.BackgroundDefault.Transparency,
			ImageColor3 = theme.BackgroundDefault.Color
		}
	end

	local v9 = globalGuiInset.bottom > 0

	local statusBarHeight = self.props.statusBarHeight

	local designTokens = if not fFlagCleanupTenFootUiPaddingAndAnalytics then self.props.designTokens else nil
	local v10 = not designTokens and 0 or designTokens.bottomPadding

	local createElement = Roact.createElement
	local v12 = {
		["BackgroundColor3"] = nil,
		["BackgroundColor3"] = nil,
		["BackgroundColor3"] = nil,
		BackgroundColor3 = theme.Overlay.Color,
		BackgroundTransparency = theme.Overlay.Transparency,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		AutoButtonColor = false
	}

	local ref = Roact.Ref
	local v13 = if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then self.props.forwardRef else nil
	v12[ref] = v13

	v12[Roact.Event.Activated] = self.props.onDismiss
	local v14 = if not self.props.onDismiss then false else nil
	v12.Selectable = v14
	return createElement("TextButton", v12, {
		NavOverlayContainer = Roact.createElement(module, {}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			StatusBarBackground = Roact.createElement("TextButton", {
				BackgroundColor3 = v7.Color,
				BackgroundTransparency = self.props.isPortrait and v7.Transparency or 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, statusBarHeight),
				Text = "",
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Selectable = false
			}),
			HeaderBarBackground = Roact.createElement("TextButton", {
				BackgroundColor3 = v7.Color,
				BackgroundTransparency = v7.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 44),
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = 2,
				Selectable = false
			}, {
				HeaderBar = Roact.createElement(
					headerBar,
					Cryo.Dictionary.join(self.props.headerBarProps, {
						backgroundTransparency = 1,
						barHeight = 44
					})
				)
			}),
			ContentsFrame = Roact.createElement("ImageButton", Cryo.Dictionary.join({
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, 44),
				Size = UDim2.new(1, 0, 1, -(44 + statusBarHeight) + v10),
				ClipsDescendants = true,
				AutoButtonColor = false,
				LayoutOrder = 3
			}, v8), self.props[Roact.Children]),
			BottomInsetBackground = v9 and Roact.createElement("TextButton", {
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, globalGuiInset.bottom),
				Text = "",
				ZIndex = 3,
				AutoButtonColor = false,
				LayoutOrder = 4,
				Selectable = false
			})
		})
	})
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithProviders(p2)
	end)
end

local function mapStateToProps(p2, p3)
	return {
		globalGuiInset = p2.GlobalGuiInset,
		isPortrait = module2(p2),
		statusBarHeight = p2.TopBar.statusBarHeight
	}
end

if not fFlagCleanupTenFootUiPaddingAndAnalytics then
	extended = module3(extended)
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
