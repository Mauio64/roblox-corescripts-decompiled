local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Assets = require(ParentParent.Resources.Assets)
local divideTransparency = require(ParentParent.Utility.divideTransparency)
local ThemedButton = require(script.Parent.ThemedButton)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)
local Divider = require(script.Parent.Divider)
local BarOnTopScrollingFrame = require(script.Parent.BarOnTopScrollingFrame)
local FocusHandler = require(script.Parent.Connection.FocusHandler)
local withLocalization = require(ParentParent.Localization.withLocalization)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v19 = Roact.PureComponent:extend("DropDownSelection")

v19.validateProps = t.intersection(t.strictInterface({
	Size = t.UDim2,
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer),
	placeHolderText = t.optional(t.string),
	selectedIndex = t.numberMin(0),
	selections = t.array(t.string),
	localize = t.boolean,
	enabled = t.boolean,
	truncate = t.optional(t.boolean),
	selectionChanged = t.callback,
	canOpen = t.optional(t.boolean),
	canCaptureFocus = t.optional(t.boolean),
	selectionParentName = t.optional(t.string),
	ButtonRef = t.optional(t.table)
}), function(p1) -- line: 54
	if p1.selectedIndex > #p1.selections then
		return false, "selectedIndex must not be greater than the number of selections"
	end

	return true
end)
v19.defaultProps = {
	canOpen = true
}

function v19.init(p2) -- line: 67
	-- upvalues: Roact (copy)
	p2.rootRef = Roact.createRef()
	p2.firstOptionRef = Roact.createRef()
	p2.openDropDownButtonRef = p2.props.ButtonRef or Roact.createRef()
	p2.state = {
		isOpen = false,
		dropDownItemHeight = 10,
		absolutePositionX = 0,
		absolutePositionY = 0,
		screenSizeX = 0,
		screenSizeY = 0
	}
	p2.ancestryConnection = nil
	p2.sizeConnection = nil
end
function v19.getDerivedStateFromProps(p3) -- line: 86
	if not p3.canOpen then
		return {
			isOpen = false
		}
	end

	return nil
end
function v19.renderDropDownList(p4, p5, p6) -- line: 95
	-- upvalues: Roact (copy), ThemedButton (copy), Assets (copy), divideTransparency (copy), ImageSetLabel (copy), ThemedTextLabel (copy), Divider (copy)
	local t1 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for i, v in ipairs(p4.props.selections) do
		local u29 = v

		if p4.props.localize then
			u29 = p6[i]
		end

		local n1 = -25

		if p4.props.truncate and i == 1 then
			n1 = -48
		end

		t1["button" .. i] = Roact.createElement(ThemedButton, {
			normalThemeKey = "BackgroundUIDefault",
			hoverThemeKey = "BackgroundOnHover",
			Size = UDim2.new(1, 0, 0, p4.state.dropDownItemHeight - 1),
			LayoutOrder = i * 2,
			onActivated = function() -- line: 119
				-- upvalues: p4 (copy), i (copy)
				p4:setState({
					isOpen = false
				})
				p4.props.selectionChanged(i)
			end,
			ButtonRef = i == 1 and p4.firstOptionRef or nil,
			imageProps = Assets.Images.WhiteSquare,
			renderChildren = function(_, p8, p9) -- line: 130
				-- upvalues: p5 (copy), divideTransparency (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), p4 (copy), i (copy), ThemedTextLabel (copy), n1 (ref), u29 (ref)
				local v44 = p8 and p5.Theme.IconOnHover or p5.Theme.IconDefault
				local Color = v44.Color
				local v46 = divideTransparency(v44.Transparency, not p9 and 1 or 2)

				return {
					SelectedIcon = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0.5),
						Size = UDim2.new(0, 15, 0, 12),
						Position = UDim2.new(1, -25, 0.5, 0),
						Image = Assets.Images.SelectedCheck,
						ImageColor3 = Color,
						ImageTransparency = v46,
						Visible = p4.props.selectedIndex == i
					}),
					TextLabel = Roact.createElement(ThemedTextLabel, {
						fontKey = "Header2",
						themeKey = "TextEmphasis",
						Position = UDim2.new(0, 25, 0, 0),
						Size = UDim2.new(1, n1, 1, 0),
						Text = u29,
						TextTruncate = if not p4.props.truncate then Enum.TextTruncate.None else Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}
			end
		})

		if i < #p4.props.selections then
			t1["divider" .. i] = Roact.createElement(Divider, {
				LayoutOrder = i * 2 + 1
			})
		end
	end

	return t1
end
function v19.renderFocusHandler(p10) -- line: 170
	-- upvalues: Roact (copy), FocusHandler (copy), ContextActionService (copy), GuiService (copy)
	return p10.props.selectionParentName and Roact.createElement(FocusHandler, {
		isFocused = p10.props.canOpen and p10.state.isOpen,
		didFocus = function() -- line: 175
			-- upvalues: ContextActionService (copy), p10 (copy), GuiService (copy)
			ContextActionService:BindCoreAction("settings_dropdown_close_action", function(_, p12) -- line: 176
				-- upvalues: p10 (copy)
				if p12 == Enum.UserInputState.End then
					p10:setState({
						isOpen = false
					})

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonB)

			if p10.props.canCaptureFocus then
				GuiService:RemoveSelectionGroup(p10.props.selectionParentName)
				GuiService:AddSelectionParent(p10.props.selectionParentName, p10.rootRef.current)
				GuiService.SelectedCoreObject = p10.firstOptionRef.current
			end
		end,
		didBlur = function() -- line: 191
			-- upvalues: ContextActionService (copy), GuiService (copy), p10 (copy)
			ContextActionService:UnbindCoreAction("settings_dropdown_close_action")
			GuiService:RemoveSelectionGroup(p10.props.selectionParentName)

			if p10.props.canOpen and (not p10.state.isOpen and p10.props.canCaptureFocus) then
				GuiService.SelectedCoreObject = p10.openDropDownButtonRef.current
			end
		end
	}) or nil
end
function v19.render(p13) -- line: 203
	-- upvalues: withFoundationOrUIBloxStyle (copy), withLocalization (copy), Assets (copy), Roact (copy), ThemedButton (copy), divideTransparency (copy), ImageSetLabel (copy), ThemedTextLabel (copy), BarOnTopScrollingFrame (copy)
	return withFoundationOrUIBloxStyle(function(p14) -- line: 204
		return {
			Theme = {
				BackgroundUIDefault = {
					Color = p14.Color.Surface.Surface_300.Color3,
					Transparency = p14.Color.Surface.Surface_300.Transparency
				},
				IconDefault = {
					Color = p14.Color.Content.Default.Color3,
					Transparency = p14.Color.Content.Default.Transparency
				},
				IconOnHover = {
					Color = p14.Color.Content.Emphasis.Color3,
					Transparency = p14.Color.Content.Emphasis.Transparency
				}
			}
		}
	end, function(p15) -- line: 212
		-- upvalues: withLocalization (copy), p13 (copy), Assets (copy), Roact (copy), ThemedButton (copy), divideTransparency (copy), ImageSetLabel (copy), ThemedTextLabel (copy), BarOnTopScrollingFrame (copy)
		return withLocalization(p13.props.localize and p13.props.selections or {})(function(p16) -- line: 213
			-- upvalues: p13 (copy), Assets (copy), p15 (copy), Roact (copy), ThemedButton (copy), divideTransparency (copy), ImageSetLabel (copy), ThemedTextLabel (copy), BarOnTopScrollingFrame (copy)
			local placeHolderText = p13.props.placeHolderText

			if p13.props.selectedIndex > 0 then
				placeHolderText = if not p13.props.localize then p13.props.selections[p13.props.selectedIndex] else p16[p13.props.selectedIndex]
			end

			local ShadowSize = Assets.Images.Shadow.Size
			local v54 = math.min(#p13.props.selections, 7.5) * 44
			local v55 = p13:renderDropDownList(p15, p16)

			return Roact.createElement("Frame", {
				Size = p13.props.Size,
				Position = p13.props.Position,
				LayoutOrder = p13.props.LayoutOrder,
				BackgroundTransparency = 1,
				[Roact.Ref] = p13.rootRef,
				[Roact.Change.AbsoluteSize] = function(p17) -- line: 235
					-- upvalues: p13 (copy)
					p13:setState({
						dropDownItemHeight = p17.AbsoluteSize.Y
					})
				end,
				[Roact.Change.AbsolutePosition] = function(p18) -- line: 241
					-- upvalues: p13 (copy)
					p13:setState({
						absolutePositionX = p18.AbsolutePosition.X,
						absolutePositionY = p18.AbsolutePosition.Y
					})
				end
			}, {
				OpenDropDownButton = Roact.createElement(ThemedButton, {
					normalThemeKey = "SecondaryDefault",
					hoverThemeKey = "SecondaryOnHover",
					Size = UDim2.new(1, 0, 1, 0),
					Visible = not p13.state.isOpen,
					enabled = p13.props.enabled,
					onActivated = function() -- line: 252
						-- upvalues: p13 (copy)
						p13:setState({
							isOpen = true
						})
					end,
					imageProps = Assets.Images.RoundedRectBorder,
					renderChildren = function(p19, p20, p21) -- line: 260
						-- upvalues: p15 (copy), divideTransparency (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), placeHolderText (ref), p13 (copy)
						local v61 = p20 and p15.Theme.IconOnHover or p15.Theme.IconDefault
						local Color = v61.Color
						local v63 = divideTransparency(v61.Transparency, not p21 and 1 or 2)

						return {
							ButtonIcon = Roact.createElement(ImageSetLabel, {
								BackgroundTransparency = 1,
								Size = UDim2.new(0, 36, 0, 36),
								Position = UDim2.new(1, -16, 0.5, 0),
								AnchorPoint = Vector2.new(1, 0.5),
								Image = Assets.Images.ExpandArrow,
								ImageColor3 = Color,
								ImageTransparency = v63
							}),
							ButtonText = Roact.createElement(ThemedTextLabel, {
								themeKey = "SecondaryContent",
								fontKey = "Header2",
								Text = placeHolderText,
								Position = UDim2.new(0, 12, 0, 0),
								Size = UDim2.new(1, not p13.props.truncate and -12 or -48, 1, 0),
								TextTransparency = p19,
								TextTruncate = if not p13.props.truncate then Enum.TextTruncate.None else Enum.TextTruncate.AtEnd,
								TextXAlignment = Enum.TextXAlignment.Left
							})
						}
					end,
					ButtonRef = p13.openDropDownButtonRef
				}),
				CloseDropDownArea = Roact.createElement("TextButton", {
					BackgroundTransparency = 1,
					Text = "",
					Position = UDim2.new(0, -p13.state.absolutePositionX, 0, -p13.state.absolutePositionY),
					Size = UDim2.new(0, p13.state.screenSizeX, 0, p13.state.screenSizeY),
					Visible = p13.state.isOpen,
					Selectable = false,
					[Roact.Event.Activated] = function() -- line: 299
						-- upvalues: p13 (copy)
						p13:setState({
							isOpen = false
						})
					end,
					ZIndex = 2
				}),
				DropDownShadow = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					ZIndex = 3,
					Image = Assets.Images.Shadow.Image,
					Position = UDim2.new(0, -ShadowSize, 0, -ShadowSize),
					Size = UDim2.new(1, ShadowSize * 2, 0, ShadowSize * 2 + 8 + v54),
					ScaleType = Assets.Images.Shadow.ScaleType,
					SliceCenter = Assets.Images.Shadow.SliceCenter,
					Visible = p13.state.isOpen
				}, {
					FocusHandler = p13:renderFocusHandler(),
					DropDownBackground = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						SliceScale = 0.5,
						Image = Assets.Images.RoundedRect.Image,
						ImageColor3 = p15.Theme.BackgroundUIDefault.Color,
						ImageTransparency = p15.Theme.BackgroundUIDefault.Transparency,
						ScaleType = Assets.Images.RoundedRect.ScaleType,
						Size = UDim2.new(1, -(ShadowSize * 2), 1, -(ShadowSize * 2)),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						SliceCenter = Assets.Images.RoundedRect.SliceCenter
					}, {
						DropDownList = Roact.createElement(BarOnTopScrollingFrame, {
							Position = UDim2.new(0, 0, 0, 4),
							Size = UDim2.new(1, 0, 1, -8),
							CanvasSize = UDim2.new(1, 0, 0, #p13.props.selections * p13.state.dropDownItemHeight)
						}, v55)
					})
				})
			})
		end)
	end)
end
function v19.watchLayerCollector(p22, p23) -- line: 342
	p22:setState({
		screenSizeX = p23.AbsoluteSize.X,
		screenSizeY = p23.AbsoluteSize.Y
	})
	p22.sizeConnection = p23:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 348
		-- upvalues: p22 (copy), p23 (copy)
		p22:setState({
			screenSizeX = p23.AbsoluteSize.X,
			screenSizeY = p23.AbsoluteSize.Y
		})
	end)
end
function v19.didMount(p24) -- line: 356
	local current = p24.rootRef.current
	local LayerCollector = current:FindFirstAncestorWhichIsA("LayerCollector")

	if LayerCollector == nil then
		p24.ancestryConnection = current.AncestryChanged:Connect(function() -- line: 361
			-- upvalues: LayerCollector (ref), current (copy), p24 (copy)
			LayerCollector = current:FindFirstAncestorWhichIsA("LayerCollector")

			if LayerCollector ~= nil then
				p24.ancestryConnection:Disconnect()
				p24.ancestryConnection = nil
				p24:watchLayerCollector(LayerCollector)
			end
		end)
	else
		p24:watchLayerCollector(LayerCollector)
	end
end
function v19.didUpdate(p25, p26) -- line: 374
	-- upvalues: Roact (copy)
	if p26.ButtonRef ~= p25.props.ButtonRef then
		p25.openDropDownButtonRef = p25.props.ButtonRef or Roact.createRef()
	end

	if p25.state.isOpen and p26.canCaptureFocus ~= p25.props.canCaptureFocus then
		p25:setState({
			isOpen = false
		})
	end
end
function v19.willUnmount(p27) -- line: 385
	if p27.ancestryConnection then
		p27.ancestryConnection:Disconnect()
	end

	if p27.sizeConnection then
		p27.sizeConnection:Disconnect()
	end
end

return v19
