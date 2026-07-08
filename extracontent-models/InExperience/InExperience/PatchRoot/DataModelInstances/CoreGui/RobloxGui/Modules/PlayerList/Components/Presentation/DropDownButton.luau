local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local IconSize = Foundation.Enums.IconSize
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local ParentParent = script.Parent.Parent
local Connection = ParentParent.Connection
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local IconButton = require(ParentParent.PresentationCommon.IconButton)
local Colors = require(CorePackages.Workspace.Packages.Style).Colors
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local ParentParentParent = ParentParent.Parent
local FFlagAllowDisplayingFoundationIconsForDropdown = require(ParentParentParent.Flags.FFlagAllowDisplayingFoundationIconsForDropdown)

local function isFoundationIconName(p1) -- line: 35
	-- upvalues: IconName (copy)
	return IconName[p1] ~= nil
end

local v23 = Roact.PureComponent:extend("DropDownButton")

v23.validateProps = t.strictInterface({
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
	animatingPercentage = t.optional(t.number)
})

function v23.init(p2) -- line: 58
	p2.state = {
		isHovered = false,
		isPressed = false,
		sizeX = 100,
		absolutePosX = 0,
		absolutePosY = 0
	}
end
function v23.getColorBackgroundAnimation(p3, p4) -- line: 68
	if p3.props.animatingPercentage == nil then
		return 0, 0
	end

	local v29 = p3.state.sizeX - p4.DropDownRightOptionSize
	local DropDownRightOptionSize = p4.DropDownRightOptionSize

	if p3.props.animatingDecline then
		v29 -= p4.DropDownRightOptionSize
	end

	local v31 = p3.state.sizeX - p4.DropDownRightOptionSize
	local v32 = DropDownRightOptionSize + v31 * p3.props.animatingPercentage
	local v33 = v29 - v31 * p3.props.animatingPercentage * 0.5

	if v33 + v32 > p3.state.sizeX then
		v33 -= v33 + v32 - p3.state.sizeX
	end

	return v33, v32
end
function v23.render(p5) -- line: 89
	-- upvalues: WithLayoutValues (copy), withFoundationOrUIBloxStyle (copy), Enabled (copy), Colors (copy), FFlagAllowDisplayingFoundationIconsForDropdown (copy), IconName (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), IconSize (copy), Roact (copy), Foundation (copy), IconVariant (copy), ImageSetLabel (copy), IconButton (copy), Images (copy)
	return WithLayoutValues(function(p6) -- line: 90
		-- upvalues: withFoundationOrUIBloxStyle (copy), Enabled (copy), p5 (copy), Colors (copy), FFlagAllowDisplayingFoundationIconsForDropdown (copy), IconName (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), IconSize (copy), Roact (copy), Foundation (copy), IconVariant (copy), ImageSetLabel (copy), IconButton (copy), Images (copy)
		return withFoundationOrUIBloxStyle(function(p7, p8) -- line: 91
			return {
				Theme = {
					BackgroundContrast = {
						Color = p7.Color.Surface.Surface_100.Color3,
						Transparency = p7.Color.Surface.Surface_100.Transparency
					},
					BackgroundOnHover = {
						Color = p7.Color.State.Hover.Color3,
						Transparency = p7.Color.State.Hover.Transparency
					},
					BackgroundOnPress = {
						Color = p7.Color.State.Press.Color3,
						Transparency = p7.Color.State.Press.Transparency
					},
					BackgroundUIContrast = {
						Color = p7.Color.OverMedia.OverMedia_0.Color3,
						Transparency = p7.Color.OverMedia.OverMedia_0.Transparency
					},
					Divider = {
						Color = p7.Color.Stroke.Emphasis.Color3,
						Transparency = p7.Color.Stroke.Emphasis.Transparency
					},
					IconEmphasis = {
						Color = p7.Color.Content.Emphasis.Color3,
						Transparency = p7.Color.Content.Emphasis.Transparency
					},
					TextEmphasis = {
						Color = p7.Color.Content.Emphasis.Color3,
						Transparency = p7.Color.Content.Emphasis.Transparency
					}
				},
				Font = {
					BaseSize = 1,
					Header2 = {
						Font = p7.Typography.TitleLarge.Font,
						RelativeSize = p7.Typography.TitleLarge.FontSize
					}
				},
				Settings = {
					PreferredTransparency = p8.preferredTransparency
				}
			}
		end, function(p9) -- line: 134
			-- upvalues: Enabled (copy), p6 (copy), p5 (copy), Colors (copy), FFlagAllowDisplayingFoundationIconsForDropdown (copy), IconName (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), IconSize (copy), Roact (copy), Foundation (copy), IconVariant (copy), ImageSetLabel (copy), IconButton (copy), Images (copy)
			local t1 = {
				Color = if not Enabled() then p9.Theme.BackgroundContrast.Color else p9.Theme.BackgroundUIContrast.Color,
				Transparency = p6.OverrideBackgroundTransparency * p9.Settings.PreferredTransparency
			}
			local t2 = {
				Transparency = 1,
				Color = Color3.new(1, 1, 1)
			}

			if p5.state.isPressed then
				t2 = p9.Theme.BackgroundOnPress
			elseif p5.state.isHovered then
				t2 = p9.Theme.BackgroundOnHover
			end

			local s1 = ""

			if p5.props.lastButton then
				s1 = "rbxasset://textures/ui/BottomRoundedRect8px.png"
			end

			local v43 = p5.props.onActivated ~= nil or p5.props.animatingAccept
			local v44 = p5.props.onDecline ~= nil or p5.props.animatingDecline
			local v45 = p5.props.onDecline ~= nil or (p5.props.animatingPercentage ~= nil or p5.props.forceShowOptions)
			local v46, v47 = p5:getColorBackgroundAnimation(p6)
			local Green = Colors.Green

			if p5.props.animatingDecline then
				Green = Colors.Red
			elseif p5.props.forceShowOptions then
				Green = Colors.White
			end

			local v49 = p6.DropDownPadding * 2 + p6.DropDownIconSize
			local v50 = p6.DropDownRightOptionSize * 2

			if v45 then
				v49 += v50
			end

			local function onMouseButton1Down() -- line: 178
				-- upvalues: v45 (copy), p5 (copy)
				if not v45 then
					p5:setState({
						isPressed = true
					})
				end
			end
			local function onMouseButton1Up() -- line: 186
				-- upvalues: p5 (copy)
				p5:setState({
					isPressed = false
				})
			end

			local icon = p5.props.icon
			local v56

			if FFlagAllowDisplayingFoundationIconsForDropdown and IconName[icon] ~= nil or FFlagCoreUiMigrateUIBloxToFoundation then
				local v54 = nil
				local Large = nil

				if IconName[icon] ~= nil then
					v54 = IconName[icon]
					Large = IconSize.Large
				elseif FFlagCoreUiMigrateUIBloxToFoundation then
					v54 = if typeof(icon) ~= "string" then nil else icon
					Large = IconSize.Medium
				end

				v56 = if not v54 then Roact.createElement(Foundation.Image, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = icon.Image,
					imageRect = {
						offset = icon.ImageRectOffset,
						size = icon.ImageRectSize
					},
					Size = UDim2.new(0, p6.DropDownIconSize, 0, p6.DropDownIconSize),
					imageStyle = {
						Color3 = p9.Theme.IconEmphasis.Color,
						Transparency = p9.Theme.IconEmphasis.Transparency
					}
				}) else Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, p6.DropDownIconSize, 0, p6.DropDownIconSize)
				}, {
					Icon = Roact.createElement(Foundation.Icon, {
						name = v54,
						variant = IconVariant.Regular,
						size = Large,
						style = {
							Color3 = p9.Theme.IconEmphasis.Color,
							Transparency = p9.Theme.IconEmphasis.Transparency
						},
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0)
					})
				})
			else
				v56 = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, p6.DropDownIconSize, 0, p6.DropDownIconSize),
					ImageColor3 = p9.Theme.IconEmphasis.Color,
					Image = p5.props.icon
				})
			end

			return Roact.createElement("ImageButton", {
				LayoutOrder = p5.props.layoutOrder,
				Image = s1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 16),
				SliceScale = 0.5,
				ImageTransparency = p5.props.lastButton and t1.Transparency or 1,
				ImageColor3 = t1.Color,
				Size = UDim2.new(1, 0, 0, p6.DropDownButtonSizeY),
				BackgroundTransparency = if not p5.props.lastButton then t1.Transparency else 1,
				BackgroundColor3 = t1.Color,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				[Roact.Event.Activated] = not v45 and p5.props.onActivated or nil,
				[Roact.Event.MouseEnter] = function() -- line: 266
					-- upvalues: v45 (copy), p5 (copy)
					if not v45 then
						p5:setState({
							isHovered = true
						})
					end
				end,
				[Roact.Event.MouseLeave] = function() -- line: 274
					-- upvalues: p5 (copy)
					p5:setState({
						isHovered = false,
						isPressed = false
					})
				end,
				[Roact.Change.AbsoluteSize] = function(p10) -- line: 281
					-- upvalues: p5 (copy)
					p5:setState({
						sizeX = p10.AbsoluteSize.X
					})
				end,
				[Roact.Change.AbsolutePosition] = function(p11) -- line: 287
					-- upvalues: p5 (copy)
					p5:setState({
						absolutePosX = p11.AbsolutePosition.X,
						absolutePosY = p11.AbsolutePosition.Y
					})
				end,
				[Roact.Event.MouseButton1Down] = onMouseButton1Down,
				[Roact.Event.MouseButton1Up] = onMouseButton1Up
			}, {
				ColorBackground = Roact.createElement("ImageLabel", {
					ZIndex = 1,
					SliceScale = 0.5,
					BorderSizePixel = 0,
					Visible = p5.props.animatingPercentage ~= nil,
					Size = UDim2.new(0, v47, 1, 0),
					Position = UDim2.new(0, v46, 0, 0),
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
					Size = UDim2.new(1, 0, 1, 0),
					Image = s1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 24, 16),
					ImageTransparency = p5.props.lastButton and t2.Transparency or 1,
					ImageColor3 = t2.Color,
					BackgroundTransparency = if not p5.props.lastButton then t2.Transparency else 1,
					BackgroundColor3 = t2.Color
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
					Icon = v56,
					Text = Roact.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -v49, 1, 0),
						Text = p5.props.text,
						Font = p9.Font.Header2.Font,
						TextSize = p9.Font.BaseSize * p9.Font.Header2.RelativeSize,
						TextColor3 = p9.Theme.TextEmphasis.Color,
						TextTransparency = p9.Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd
					}),
					ButtonContainer = Roact.createElement("Frame", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Visible = v45,
						Size = UDim2.new(0, v50, 1, 0)
					}, {
						ConfirmButton = v43 and Roact.createElement(IconButton, {
							size = UDim2.new(0.5, 0, 1, 0),
							position = UDim2.new(0.5, 0, 0, 0),
							backgroundColor = p5.props.onDecline and Colors.Green or Colors.White,
							icon = if not FFlagCoreUiMigrateUIBloxToFoundation then Images["icons/actions/accept"] else "icons/actions/accept",
							showBackground = p5.props.animatingPercentage == nil,
							onActivated = p5.props.onActivated
						}) or nil,
						DeclineButton = v44 and Roact.createElement(IconButton, {
							size = UDim2.new(0.5, 0, 1, 0),
							position = UDim2.new(0, 0, 0, 0),
							backgroundColor = Colors.Red,
							icon = if not FFlagCoreUiMigrateUIBloxToFoundation then Images["icons/actions/reject"] else "icons/actions/reject",
							showBackground = p5.props.animatingPercentage == nil,
							onActivated = p5.props.onDecline
						}) or nil
					})
				}),
				DismissInputHandler = Roact.createElement("ImageButton", {
					Image = "",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, p5.props.screenSizeX, 0, p5.props.screenSizeY),
					Position = UDim2.new(0, -p5.state.absolutePosX, 0, -p5.state.absolutePosY),
					Visible = p5.props.onDismiss ~= nil,
					[Roact.Event.Activated] = p5.props.onDismiss
				}),
				Divider = not p5.props.lastButton and Roact.createElement("Frame", {
					ZIndex = 3,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = p9.Theme.Divider.Transparency,
					BackgroundColor3 = p9.Theme.Divider.Color
				})
			})
		end)
	end)
end

local function mapStateToProps(p12) -- line: 411
	return {
		screenSizeX = p12.screenSize.X,
		screenSizeY = p12.screenSize.Y
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(v23)
