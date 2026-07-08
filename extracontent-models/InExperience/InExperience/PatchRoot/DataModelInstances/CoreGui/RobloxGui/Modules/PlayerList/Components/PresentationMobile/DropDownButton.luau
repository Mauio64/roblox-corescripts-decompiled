local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local Foundation = require(CorePackages.Packages.Foundation)
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local IconSize = Foundation.Enums.IconSize
local useLayoutValues = PlayerList.Common.useLayoutValues
local withStyle = UIBlox.Style.withStyle
local ParentParent = script.Parent.Parent
local Connection = ParentParent.Connection
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local IconButton = require(ParentParent.PresentationCommon.IconButton)
local Colors = require(CorePackages.Workspace.Packages.Style).Colors
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local ParentParentParent = ParentParent.Parent
local FFlagAllowDisplayingFoundationIconsForDropdown = require(ParentParentParent.Flags.FFlagAllowDisplayingFoundationIconsForDropdown)

local function isFoundationIconName(p1) -- line: 37
	-- upvalues: IconName (copy)
	return IconName[p1] ~= nil
end

local v25 = Roact.PureComponent:extend("DropDownButton")

v25.validateProps = t.strictInterface({
	contentVisible = t.boolean,
	buttonTransparency = t.any,
	text = t.string,
	layoutOrder = t.optional(t.integer),
	icon = t.union(t.string, t.table),
	lastButton = t.boolean,
	forceShowOptions = t.boolean,
	screenSizeX = t.number,
	screenSizeY = t.number,
	onActivated = t.optional(t.callback),
	onDecline = t.optional(t.callback),
	onDismiss = t.optional(t.callback),
	animatingAccept = t.optional(t.boolean),
	animatingDecline = t.optional(t.boolean),
	animatingPercentage = t.optional(t.number),
	layoutValues = t.optional(t.table)
})

function v25.init(p2) -- line: 65
	p2.state = {
		isHovered = false,
		isPressed = false,
		sizeX = 100,
		absolutePosX = 0,
		absolutePosY = 0
	}
end
function v25.getColorBackgroundAnimation(p3, p4) -- line: 75
	if p3.props.animatingPercentage == nil then
		return 0, 0
	end

	local v31 = p3.state.sizeX - p4.DropDownRightOptionSize
	local DropDownRightOptionSize = p4.DropDownRightOptionSize

	if p3.props.animatingDecline then
		v31 -= p4.DropDownRightOptionSize
	end

	local v33 = p3.state.sizeX - p4.DropDownRightOptionSize
	local v34 = DropDownRightOptionSize + v33 * p3.props.animatingPercentage
	local v35 = v31 - v33 * p3.props.animatingPercentage * 0.5

	if v35 + v34 > p3.state.sizeX then
		v35 -= v35 + v34 - p3.state.sizeX
	end

	return v35, v34
end
function v25.render(p5) -- line: 96
	-- upvalues: WithLayoutValues (copy), withStyle (copy), Colors (copy), FFlagAllowDisplayingFoundationIconsForDropdown (copy), IconName (copy), Roact (copy), Foundation (copy), IconVariant (copy), IconSize (copy), ImageSetLabel (copy), FFlagEnableMobilePlayerListOnConsole (copy), IconButton (copy), Images (copy)
	return WithLayoutValues(function(p6) -- line: 97
		-- upvalues: withStyle (copy), p5 (copy), Colors (copy), FFlagAllowDisplayingFoundationIconsForDropdown (copy), IconName (copy), Roact (copy), Foundation (copy), IconVariant (copy), IconSize (copy), ImageSetLabel (copy), FFlagEnableMobilePlayerListOnConsole (copy), IconButton (copy), Images (copy)
		return withStyle(function(p7) -- line: 98
			-- upvalues: p6 (ref), p5 (copy), Colors (copy), FFlagAllowDisplayingFoundationIconsForDropdown (copy), IconName (copy), Roact (copy), Foundation (copy), IconVariant (copy), IconSize (copy), ImageSetLabel (copy), FFlagEnableMobilePlayerListOnConsole (copy), IconButton (copy), Images (copy)
			p6 = p5.props.layoutValues

			local t1 = {
				Transparency = 1,
				Color = Color3.new(1, 1, 1)
			}

			if p5.state.isPressed then
				t1 = p7.Theme.BackgroundOnPress
			elseif p5.state.isHovered then
				t1 = p7.Theme.BackgroundOnHover
			end

			local s1 = ""

			if p5.props.lastButton then
				s1 = "rbxasset://textures/ui/BottomRoundedRect8px.png"
			end

			local v45 = p5.props.onActivated ~= nil or p5.props.animatingAccept
			local v46 = p5.props.onDecline ~= nil or p5.props.animatingDecline
			local v47 = p5.props.onDecline ~= nil or (p5.props.animatingPercentage ~= nil or p5.props.forceShowOptions)
			local v48, v49 = p5:getColorBackgroundAnimation(p6)
			local Green = Colors.Green

			if p5.props.animatingDecline then
				Green = Colors.Red
			elseif p5.props.forceShowOptions then
				Green = Colors.White
			end

			local v51 = p6.DropDownPadding * 2 + p6.DropDownIconSize
			local v52 = p6.DropDownRightOptionSize * 2

			if v47 then
				v51 += v52
			end

			local icon = p5.props.icon
			local v54 = if not FFlagAllowDisplayingFoundationIconsForDropdown or IconName[icon] == nil then Roact.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, p6.DropDownIconSize, 0, p6.DropDownIconSize),
				ImageColor3 = p7.Theme.IconEmphasis.Color,
				Image = p5.props.icon
			}) else Roact.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, p6.DropDownIconSize, 0, p6.DropDownIconSize)
			}, {
				Icon = Roact.createElement(Foundation.Icon, {
					name = IconName[icon],
					variant = IconVariant.Regular,
					size = IconSize.Large,
					style = {
						Color3 = p7.Theme.IconEmphasis.Color,
						Transparency = p7.Theme.IconEmphasis.Transparency
					},
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})
			})

			local function onMouseButton1Down() -- line: 166
				-- upvalues: v47 (copy), p5 (copy)
				if not v47 then
					p5:setState({
						isPressed = true
					})
				end
			end
			local function onMouseButton1Up() -- line: 174
				-- upvalues: p5 (copy)
				p5:setState({
					isPressed = false
				})
			end

			return Roact.createElement("ImageButton", {
				LayoutOrder = p5.props.layoutOrder,
				Image = s1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 16),
				SliceScale = 0.5,
				ImageTransparency = p5.props.lastButton and p5.props.buttonTransparency or 1,
				ImageColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, 0, 0, p6.DropDownButtonSizeY),
				BackgroundTransparency = if not p5.props.lastButton then p5.props.buttonTransparency else 1,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Selectable = not v47,
				[Roact.Event.Activated] = not v47 and p5.props.onActivated or nil,
				[Roact.Event.MouseEnter] = function() -- line: 198
					-- upvalues: v47 (copy), p5 (copy)
					if not v47 then
						p5:setState({
							isHovered = true
						})
					end
				end,
				[Roact.Event.MouseLeave] = function() -- line: 206
					-- upvalues: p5 (copy)
					p5:setState({
						isHovered = false,
						isPressed = false
					})
				end,
				[Roact.Change.AbsoluteSize] = function(p8) -- line: 213
					-- upvalues: p5 (copy)
					p5:setState({
						sizeX = p8.AbsoluteSize.X
					})
				end,
				[Roact.Change.AbsolutePosition] = function(p9) -- line: 219
					-- upvalues: p5 (copy)
					p5:setState({
						absolutePosX = p9.AbsolutePosition.X,
						absolutePosY = p9.AbsolutePosition.Y
					})
				end,
				[Roact.Event.MouseButton1Down] = onMouseButton1Down,
				[Roact.Event.MouseButton1Up] = onMouseButton1Up
			}, {
				ColorBackground = Roact.createElement("ImageLabel", {
					ZIndex = 1,
					SliceScale = 0.5,
					BorderSizePixel = 0,
					Visible = p5.props.animatingPercentage ~= nil and p5.props.contentVisible,
					Size = UDim2.new(0, v49, 1, 0),
					Position = UDim2.fromOffset(v48, 0),
					Image = s1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 24, 16),
					ImageTransparency = p5.props.lastButton and p6.IconButtonBackgroundTransparency or 1,
					ImageColor3 = Green,
					BackgroundTransparency = if not p5.props.lastButton then p6.IconButtonBackgroundTransparency else 1,
					BackgroundColor3 = Green
				}),
				HoverBackground = Roact.createElement("ImageLabel", {
					ZIndex = 2,
					SliceScale = 0.5,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					Visible = p5.props.contentVisible,
					Image = s1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 24, 16),
					ImageTransparency = p5.props.lastButton and t1.Transparency or 1,
					ImageColor3 = t1.Color,
					BackgroundTransparency = if not p5.props.lastButton then t1.Transparency else 1,
					BackgroundColor3 = t1.Color
				}, {
					InitalPadding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, p6.DropDownPadding)
					}),
					ListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, p6.DropDownPadding)
					}),
					Icon = v54,
					Text = Roact.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -v51, 1, 0),
						Text = p5.props.text,
						Font = p7.Font.Header2.Font,
						TextSize = if not FFlagEnableMobilePlayerListOnConsole then p7.Font.BaseSize * p7.Font.Header2.RelativeSize else p6.DropDownButtonTextSize,
						TextColor3 = p7.Theme.TextEmphasis.Color,
						TextTransparency = p7.Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd
					}),
					ButtonContainer = Roact.createElement("Frame", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Visible = v47,
						Size = UDim2.new(0, v52, 1, 0)
					}, {
						ConfirmButton = v45 and Roact.createElement(IconButton, {
							size = UDim2.fromScale(0.5, 1),
							position = UDim2.fromScale(0.5, 0),
							backgroundColor = p5.props.onDecline and Colors.Green or Colors.White,
							icon = Images["icons/actions/accept"],
							showBackground = p5.props.animatingPercentage == nil,
							onActivated = p5.props.onActivated
						}) or nil,
						DeclineButton = v46 and Roact.createElement(IconButton, {
							size = UDim2.fromScale(0.5, 1),
							position = UDim2.new(0, 0, 0, 0),
							backgroundColor = Colors.Red,
							icon = Images["icons/actions/reject"],
							showBackground = p5.props.animatingPercentage == nil,
							onActivated = p5.props.onDecline
						}) or nil
					})
				}),
				DismissInputHandler = Roact.createElement("ImageButton", {
					Image = "",
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(p5.props.screenSizeX, p5.props.screenSizeY),
					Position = UDim2.fromOffset(-p5.state.absolutePosX, -p5.state.absolutePosY),
					Visible = p5.props.onDismiss ~= nil and p5.props.contentVisible,
					[Roact.Event.Activated] = p5.props.onDismiss
				}),
				Divider = not p5.props.lastButton and Roact.createElement("Frame", {
					ZIndex = 3,
					BorderSizePixel = 0,
					Visible = p5.props.contentVisible,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.fromScale(0, 1),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = p7.Theme.Divider.Transparency,
					BackgroundColor3 = p7.Theme.Divider.Color
				})
			})
		end)
	end)
end

local function mapStateToProps(p10) -- line: 350
	return {
		screenSizeX = p10.screenSize.X,
		screenSizeY = p10.screenSize.Y
	}
end

return RoactRodux.connect(mapStateToProps, nil)(function(p11) -- line: 342
	-- upvalues: useLayoutValues (copy), Roact (copy), v25 (copy), Cryo (copy)
	local v38 = useLayoutValues()

	return Roact.createElement(v25, Cryo.Dictionary.join(p11, {
		layoutValues = v38
	}))
end)
