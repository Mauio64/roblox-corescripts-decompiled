local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local NavOverlayContainer = require(Modules.AvatarExperience.Common.Components.NavOverlayContainer)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local with10ftUIPadding = require(Modules.AvatarExperience.Common.Components.with10ftUIPadding)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXFixGamepadNavigationOnOutfitManagement = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixGamepadNavigationOnOutfitManagement
local UIBlox = require(CorePackages.Packages.UIBlox)
local HeaderBar = UIBlox.App.Bar.HeaderBar
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local v18 = Images["component_assets/circle_17"]
local v19 = Roact.PureComponent:extend("NavOverlayPageContainer")

v19.validateProps = t.strictInterface({
	headerBarProps = t.strictInterface({
		title = t.string,
		renderLeft = t.optional(t.callback),
		renderRight = t.optional(t.callback)
	}),
	onDismiss = if not FFlagAXFixGamepadNavigationOnOutfitManagement then t.callback else t.optional(t.callback),
	ZIndex = t.optional(t.integer),
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil,
	[Roact.Children] = t.table,
	globalGuiInset = t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	}),
	isPortrait = t.boolean,
	statusBarHeight = t.number,
	designTokens = t.any,
	forwardRef = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else t.optional(t.union(t.callback, t.table))
})

function v19.renderWithProviders(p1, p2) -- line: 71
	-- upvalues: v18 (copy), Images (copy), Roact (copy), FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), GamepadFocusHandlerForPage (copy), NavOverlayContainer (copy), HeaderBar (copy), Cryo (copy)
	local Theme = p2.Theme
	local globalGuiInset = p1.props.globalGuiInset
	local BackgroundDefault = Theme.BackgroundDefault
	local t1 = {}

	if not p1.props.isPortrait then
		BackgroundDefault = Theme.BackgroundMuted

		local ImageRectSize = v18.ImageRectSize
		local ImageRectOffset = v18.ImageRectOffset
		local ImageRectSizeX = ImageRectSize.X
		local v31 = ImageRectSizeX / 2

		t1 = {
			BackgroundTransparency = 1,
			Image = v18.Image,
			ScaleType = Enum.ScaleType.Slice,
			SliceScale = 1 / Images.ImagesResolutionScale,
			SliceCenter = Rect.new(v31 - 1, v31 - 1, v31 + 1, v31),
			ImageRectSize = Vector2.new(ImageRectSizeX, v31),
			ImageRectOffset = ImageRectOffset,
			ImageTransparency = Theme.BackgroundDefault.Transparency,
			ImageColor3 = Theme.BackgroundDefault.Color
		}
	end

	local v32 = globalGuiInset.bottom > 0
	local statusBarHeight = p1.props.statusBarHeight
	local designTokens = p1.props.designTokens
	local v35 = not designTokens and 0 or designTokens.bottomPadding

	return Roact.createElement("TextButton", {
		BackgroundColor3 = Theme.Overlay.Color,
		BackgroundTransparency = Theme.Overlay.Transparency,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		AutoButtonColor = false,
		[Roact.Ref] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else p1.props.forwardRef,
		[Roact.Event.Activated] = p1.props.onDismiss,
		Selectable = if not FFlagAXMigrateAXToGlobalAutofocus or p1.props.onDismiss then nil else false
	}, {
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = p1.props.focusController
		}) else nil,
		NavOverlayContainer = Roact.createElement(NavOverlayContainer, {}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			StatusBarBackground = Roact.createElement("TextButton", {
				LayoutOrder = 1,
				Text = "",
				BorderSizePixel = 0,
				AutoButtonColor = false,
				BackgroundColor3 = BackgroundDefault.Color,
				BackgroundTransparency = p1.props.isPortrait and BackgroundDefault.Transparency or 1,
				Size = UDim2.new(1, 0, 0, statusBarHeight),
				Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil
			}),
			HeaderBarBackground = Roact.createElement("TextButton", {
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = 2,
				BackgroundColor3 = BackgroundDefault.Color,
				BackgroundTransparency = BackgroundDefault.Transparency,
				Size = UDim2.new(1, 0, 0, 44),
				Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil
			}, {
				HeaderBar = Roact.createElement(HeaderBar, Cryo.Dictionary.join(p1.props.headerBarProps, {
					backgroundTransparency = 1,
					barHeight = 44
				}))
			}),
			ContentsFrame = Roact.createElement("ImageButton", Cryo.Dictionary.join({
				BorderSizePixel = 0,
				ClipsDescendants = true,
				AutoButtonColor = false,
				LayoutOrder = 3,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency,
				Position = UDim2.fromOffset(0, 44),
				Size = UDim2.new(1, 0, 1, -(44 + statusBarHeight) + v35)
			}, t1), p1.props[Roact.Children]),
			BottomInsetBackground = v32 and Roact.createElement("TextButton", {
				BorderSizePixel = 0,
				Text = "",
				ZIndex = 3,
				AutoButtonColor = false,
				LayoutOrder = 4,
				BackgroundColor3 = Theme.BackgroundDefault.Color,
				BackgroundTransparency = Theme.BackgroundDefault.Transparency,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, globalGuiInset.bottom),
				Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil
			})
		})
	})
end
function v19.render(p3) -- line: 201
	-- upvalues: withStyle (copy)
	return withStyle(function(p4) -- line: 202
		-- upvalues: p3 (copy)
		return p3:renderWithProviders(p4)
	end)
end

local function mapStateToProps(p5, _) -- line: 207
	-- upvalues: selectIsPortrait (copy)
	return {
		globalGuiInset = p5.GlobalGuiInset,
		isPortrait = selectIsPortrait(p5),
		statusBarHeight = p5.TopBar.statusBarHeight
	}
end

local v21 = with10ftUIPadding(v19)

return RoactRodux.connect(mapStateToProps, nil)(v21)
