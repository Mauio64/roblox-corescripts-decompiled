local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local LoadableImage = UIBlox.App.Loading.LoadableImage
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local FFlagBoldSearchListPickerSuggestions = require(Modules.LuaApp.Flags.FFlagBoldSearchListPickerSuggestions)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v18 = Roact.PureComponent:extend("SearchBarListPickerItem")

v18.defaultProps = {
	displayIcon = nil
}

function v18.init(p1) -- line: 39
	-- upvalues: UserInputService (copy)
	p1.state = {
		menuItemDown = false
	}

	function p1.onMenuItemInputBegan(_, p3) -- line: 44
		-- upvalues: p1 (copy)
		if (p3.UserInputType == Enum.UserInputType.Touch or p3.UserInputType == Enum.UserInputType.MouseButton1) and p3.UserInputState == Enum.UserInputState.Begin then
			p1.onMenuItemDown()
		end
	end
	function p1.onMenuItemInputEnd(_, _) -- line: 55
		-- upvalues: p1 (copy)
		p1.onMenuItemUp()
	end
	function p1.eventDisconnect() -- line: 59
		-- upvalues: p1 (copy)
		if p1.userInputServiceConn then
			p1.userInputServiceConn:Disconnect()
			p1.userInputServiceConn = nil
		end
	end
	function p1.onMenuItemDown() -- line: 66
		-- upvalues: p1 (copy), UserInputService (copy)
		if not p1.state.menuItemDown then
			p1.eventDisconnect()
			p1.userInputServiceConn = UserInputService.InputEnded:Connect(function() -- line: 69
				-- upvalues: p1 (copy)
				p1.onMenuItemUp()
			end)
			p1:setState({
				menuItemDown = true
			})
		end
	end
	function p1.onMenuItemUp(p6) -- line: 78
		-- upvalues: p1 (copy)
		if p1.state.menuItemDown or p6 ~= p1.state.menuItemActive then
			p1:setState({
				menuItemDown = false
			})
		end

		p1.eventDisconnect()
	end
end
function v18.renderWithProviders(p7, p8) -- line: 88
	-- upvalues: withStyle (copy), FFlagBoldSearchListPickerSuggestions (copy), Roact (copy), Focusable (copy), CursorKind (copy), ImageSetLabel (copy), Images (copy), DEPRECATED_ImageSetLabel (copy), FitTextLabel (copy), FitChildren (copy), LoadableImage (copy)
	local item = p7.props.item
	local layoutOrder = p7.props.layoutOrder
	local separatorEnabled = p7.props.separatorEnabled
	local menuItemDown = p7.state.menuItemDown
	local isRichItem = item.isRichItem
	local isRecentCatalogSearchItem = item.isRecentCatalogSearchItem
	local forwardRef = p7.props.forwardRef

	return withStyle(function(p9) -- line: 100
		-- upvalues: FFlagBoldSearchListPickerSuggestions (copy), item (copy), p7 (copy), isRichItem (copy), Roact (copy), Focusable (copy), menuItemDown (copy), layoutOrder (copy), forwardRef (copy), p8 (copy), CursorKind (copy), isRecentCatalogSearchItem (copy), ImageSetLabel (copy), Images (copy), DEPRECATED_ImageSetLabel (copy), FitTextLabel (copy), FitChildren (copy), LoadableImage (copy), separatorEnabled (copy)
		local v39 = if not FFlagBoldSearchListPickerSuggestions then nil else item.text

		if FFlagBoldSearchListPickerSuggestions and (p7.props.currentKeyword and not isRichItem) then
			local EmphasisColor3 = p9.Tokens.Color.Content.Emphasis.Color3
			local v41 = `rgb({ math.round(EmphasisColor3.r * 255) },{ math.round(EmphasisColor3.g * 255) },{ math.round(EmphasisColor3.b * 255) })`
			local v42 = v39:lower():find(p7.props.currentKeyword:lower())

			if v42 then
				local v43 = v39:sub(v42, v42 + p7.props.currentKeyword:len() - 1)
				local v44 = `<font color="{ v41 }"><b>`

				v39 = `{ v44 }{ v39:gsub(v43, `</b></font>{ v43 }{ v44 }`, 1) }</b></font>`
			elseif not p7.props.currentKeyword:lower():find(v39:lower()) then
				v39 = `<font color="{ v41 }"><b>` .. v39 .. "</b></font>"
			end
		end

		return Roact.createElement(Focusable.ImageButton, {
			BackgroundColor3 = menuItemDown and p9.Theme.BackgroundOnPress.Color or p9.Theme.BackgroundDefault.Color,
			BackgroundTransparency = menuItemDown and p9.Theme.BackgroundOnPress.Transparency or 1,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, not isRichItem and 56 or 64),
			AutomaticSize = Enum.AutomaticSize.Y,
			[Roact.Event.Activated] = item.onSelect,
			[Roact.Event.InputBegan] = p7.onMenuItemInputBegan,
			[Roact.Event.InputEnded] = p7.onMenuItemInputEnd,
			NextSelectionLeft = p7.props.NextSelectionLeft,
			NextSelectionRight = p7.props.NextSelectionRight,
			NextSelectionUp = p7.props.NextSelectionUp,
			NextSelectionDown = p7.props.NextSelectionDown,
			[Roact.Ref] = forwardRef,
			SelectionImageObject = p8(CursorKind.RoundedRectNoInset)
		}, {
			Container = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 9)
				}),
				LeftSpacing = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(0, 0, 0, not isRichItem and 56 or 64)
				}),
				SearchIcon = if not isRecentCatalogSearchItem then Roact.createElement(DEPRECATED_ImageSetLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = "LuaApp/icons/ic-search-new",
					LayoutOrder = 2,
					Size = UDim2.new(0, 24, 0, 24),
					ImageColor3 = p9.Theme.IconDefault.Color,
					ImageTransparency = p9.Theme.IconDefault.Transparency
				}) else Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.new(0, 24, 0, 24),
					Image = Images["icons/menu/recent"],
					ImageColor3 = p9.Theme.IconDefault.Color,
					ImageTransparency = p9.Theme.IconDefault.Transparency
				}),
				Content = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 3,
					Size = UDim2.new(1, -112, 1, 0)
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 5)
					}),
					TitleText = Roact.createElement(FitTextLabel, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						RichText = if not FFlagBoldSearchListPickerSuggestions then nil else p7.props.currentKeyword ~= nil and not isRichItem,
						Text = if not FFlagBoldSearchListPickerSuggestions then item.text else v39,
						Font = p9.Font.Body.Font,
						TextSize = p9.Font.BaseSize * p9.Font.Body.RelativeSize,
						TextColor3 = p9.Theme.TextDefault.Color,
						TextTransparency = p9.Theme.TextDefault.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = if not FFlagBoldSearchListPickerSuggestions then Enum.TextYAlignment.Top else isRichItem and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
						fitAxis = FitChildren.FitAxis.Height
					}),
					CategoryText = isRichItem and Roact.createElement(FitTextLabel, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Text = "Game",
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						Font = p9.Font.CaptionBody.Font,
						TextSize = p9.Font.BaseSize * p9.Font.CaptionBody.RelativeSize,
						TextColor3 = p9.Theme.TextMuted.Color,
						TextTransparency = p9.Theme.TextMuted.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						fitAxis = FitChildren.FitAxis.Height
					})
				}),
				RichIcon = isRichItem and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 4,
					Size = UDim2.new(0, 44, 0, 44),
					Position = UDim2.new(1, -44, 0, 0)
				}, {
					Shadow = Roact.createElement("Frame", {
						BorderSizePixel = 0,
						ZIndex = 10,
						Size = UDim2.new(0, 36, 0, 36),
						Position = UDim2.new(0, 8, 0, 0),
						BackgroundColor3 = p9.Theme.BackgroundOnHover.Color,
						BackgroundTransparency = p9.Theme.BackgroundOnHover.Transparency
					}),
					Border = Roact.createElement("Frame", {
						BorderSizePixel = 0,
						ZIndex = 11,
						Size = UDim2.new(0, 36, 0, 36),
						Position = UDim2.new(0, 2, 0, 6),
						BackgroundColor3 = p9.Theme.BackgroundDefault.Color,
						BackgroundTransparency = p9.Theme.BackgroundDefault.Transparency
					}),
					GameIcon = Roact.createElement(LoadableImage, {
						BackgroundTransparency = 1,
						useShimmerAnimationWhileLoading = true,
						ZIndex = 12,
						Size = UDim2.new(0, 36, 0, 36),
						Position = UDim2.new(0, 0, 0, 8),
						Image = item.displayIcon
					})
				})
			}),
			Separator = separatorEnabled and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = p9.Theme.Divider.Color,
				BackgroundTransparency = p9.Theme.Divider.Transparency,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0)
			})
		})
	end)
end
function v18.render(p10) -- line: 285
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p11) -- line: 286
		-- upvalues: p10 (copy)
		return p10:renderWithProviders(p11)
	end)
end
function v18.willUnmount(p12) -- line: 291
	p12.eventDisconnect()
end

return Roact.forwardRef(function(p13, p14) -- line: 295
	-- upvalues: Roact (copy), v18 (copy), Cryo (copy)
	return Roact.createElement(v18, Cryo.Dictionary.join(p13, {
		forwardRef = p14
	}))
end)
