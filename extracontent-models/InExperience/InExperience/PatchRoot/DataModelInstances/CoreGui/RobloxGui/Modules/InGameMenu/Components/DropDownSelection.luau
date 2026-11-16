local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local Assets = require(parent.Resources.Assets)
local divideTransparency = require(parent.Utility.divideTransparency)

local ThemedButton = require(script.Parent.ThemedButton)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)
local Divider = require(script.Parent.Divider)
local BarOnTopScrollingFrame = require(script.Parent.BarOnTopScrollingFrame)
local FocusHandler = require(script.Parent.Connection.FocusHandler)

local withLocalization = require(parent.Localization.withLocalization)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.PureComponent:extend("DropDownSelection")

extended.validateProps = t.intersection(t.strictInterface({
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
}), function(p)
	if p.selectedIndex > #p.selections then
		return false, "selectedIndex must not be greater than the number of selections"
	end

	return true
end)

extended.defaultProps = { canOpen = true }

function extended:init()
	self.rootRef = Roact.createRef()
	self.firstOptionRef = Roact.createRef()
	self.openDropDownButtonRef = self.props.ButtonRef or Roact.createRef()

	self.state = {
		isOpen = false,
		dropDownItemHeight = 10,
		absolutePositionX = 0,
		absolutePositionY = 0,
		screenSizeX = 0,
		screenSizeY = 0
	}

	self.ancestryConnection = nil
	self.sizeConnection = nil
end

function extended.getDerivedStateFromProps(p)
	if p.canOpen then
		return nil
	end

	return { isOpen = false }
end

function extended:renderDropDownList(p, p2)
	local children = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for i, selection in ipairs(self.props.selections) do
		if self.props.localize then
			selection = p2[i]
		end

		local v = self.props.truncate and i == 1 and -48 or -25

		local v2 = "button" .. i
		local createElement = Roact.createElement
		local v3 = {
			Size = UDim2.new(1, 0, 0, self.state.dropDownItemHeight - 1),
			LayoutOrder = i * 2,
			onActivated = function()
				self:setState({ isOpen = false })

				self.props.selectionChanged(i)
			end,
			normalThemeKey = "BackgroundUIDefault",
			hoverThemeKey = "BackgroundOnHover",
			ButtonRef = 0,
			imageProps = 0,
			renderChildren = 0
		}
		local buttonRef

		if i == 1 then
			buttonRef = self.firstOptionRef or nil
		end

		v3.ButtonRef = buttonRef
		v3.imageProps = Assets.Images.WhiteSquare

		function v3.renderChildren(_, p3, p4)
			local iconOnHover = p3 and p.Theme.IconOnHover or p.Theme.IconDefault
			local color = iconOnHover.Color
			local imageTransparency = divideTransparency(iconOnHover.Transparency, p4 and 2 or 1)

			local children2 = {
				SelectedIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Size = UDim2.new(0, 15, 0, 12),
					Position = UDim2.new(1, -25, 0.5, 0),
					Image = Assets.Images.SelectedCheck,
					ImageColor3 = color,
					ImageTransparency = imageTransparency,
					Visible = self.props.selectedIndex == i
				}),
				TextLabel = 0
			}

			local createElement2 = Roact.createElement
			local v4 = {
				fontKey = "Header2",
				themeKey = "TextEmphasis",
				Position = UDim2.new(0, 25, 0, 0),
				Size = UDim2.new(1, v, 1, 0),
				Text = selection,
				TextTruncate = 0,
				TextXAlignment = 0
			}
			local textTruncate

			if self.props.truncate then
				textTruncate = Enum.TextTruncate.AtEnd
			else
				textTruncate = Enum.TextTruncate.None
			end

			v4.TextTruncate = textTruncate
			v4.TextXAlignment = Enum.TextXAlignment.Left
			children2.TextLabel = createElement2(ThemedTextLabel, v4)
			return children2
		end

		children[v2] = createElement(ThemedButton, v3)

		if i < #self.props.selections then
			children["divider" .. i] = Roact.createElement(Divider, {
				LayoutOrder = i * 2 + 1
			})
		end
	end

	return children
end

function extended:renderFocusHandler()
	local focusHandler

	if self.props.selectionParentName then
		focusHandler = Roact.createElement(FocusHandler, {
			isFocused = self.props.canOpen and self.state.isOpen,
			didFocus = function()
				ContextActionService:BindCoreAction("settings_dropdown_close_action", function(_, p)
					if p ~= Enum.UserInputState.End then
						return Enum.ContextActionResult.Pass
					end

					self:setState({ isOpen = false })
					return Enum.ContextActionResult.Sink
				end, false, Enum.KeyCode.ButtonB)

				if self.props.canCaptureFocus then
					GuiService:RemoveSelectionGroup(self.props.selectionParentName)
					GuiService:AddSelectionParent(self.props.selectionParentName, self.rootRef.current)
					GuiService.SelectedCoreObject = self.firstOptionRef.current
				end
			end,
			didBlur = function()
				ContextActionService:UnbindCoreAction("settings_dropdown_close_action")
				GuiService:RemoveSelectionGroup(self.props.selectionParentName)

				if self.props.canOpen and not self.state.isOpen and self.props.canCaptureFocus then
					GuiService.SelectedCoreObject = self.openDropDownButtonRef.current
				end
			end
		}) or nil
	end

	return focusHandler
end

function extended:render()
	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				BackgroundUIDefault = {
					Color = p.Color.Surface.Surface_300.Color3,
					Transparency = p.Color.Surface.Surface_300.Transparency
				},
				IconDefault = {
					Color = p.Color.Content.Default.Color3,
					Transparency = p.Color.Content.Default.Transparency
				},
				IconOnHover = {
					Color = p.Color.Content.Emphasis.Color3,
					Transparency = p.Color.Content.Emphasis.Transparency
				}
			}
		}
	end, function(p)
		return withLocalization(self.props.localize and self.props.selections or {})(function(p2)
			local text = self.props.placeHolderText

			if self.props.selectedIndex > 0 then
				if self.props.localize then
					text = p2[self.props.selectedIndex]
				else
					text = self.props.selections[self.props.selectedIndex]
				end
			end

			local size = Assets.Images.Shadow.Size
			local v = math.min(#self.props.selections, 7.5) * 44
			local dropDownList = self:renderDropDownList(p, p2)

			return Roact.createElement("Frame", {
				Size = self.props.Size,
				Position = self.props.Position,
				LayoutOrder = self.props.LayoutOrder,
				BackgroundTransparency = 1,
				[Roact.Ref] = self.rootRef,
				[Roact.Change.AbsoluteSize] = function(p3)
					self:setState({ dropDownItemHeight = p3.AbsoluteSize.Y })
				end,
				[Roact.Change.AbsolutePosition] = function(p3)
					self:setState({
						absolutePositionX = p3.AbsolutePosition.X,
						absolutePositionY = p3.AbsolutePosition.Y
					})
				end
			}, {
				OpenDropDownButton = Roact.createElement(ThemedButton, {
					Size = UDim2.new(1, 0, 1, 0),
					Visible = not self.state.isOpen,
					enabled = self.props.enabled,
					onActivated = function()
						self:setState({ isOpen = true })
					end,
					normalThemeKey = "SecondaryDefault",
					hoverThemeKey = "SecondaryOnHover",
					imageProps = Assets.Images.RoundedRectBorder,
					renderChildren = function(textTransparency, p3, p4)
						local iconOnHover = p3 and p.Theme.IconOnHover or p.Theme.IconDefault
						local color = iconOnHover.Color
						local imageTransparency = divideTransparency(iconOnHover.Transparency, p4 and 2 or 1)

						local children = {
							ButtonIcon = Roact.createElement(ImageSetLabel, {
								BackgroundTransparency = 1,
								Size = UDim2.new(0, 36, 0, 36),
								Position = UDim2.new(1, -16, 0.5, 0),
								AnchorPoint = Vector2.new(1, 0.5),
								Image = Assets.Images.ExpandArrow,
								ImageColor3 = color,
								ImageTransparency = imageTransparency
							}),
							ButtonText = 0
						}

						local createElement = Roact.createElement
						local v2 = {
							Text = text,
							themeKey = "SecondaryContent",
							fontKey = "Header2",
							Position = UDim2.new(0, 12, 0, 0),
							Size = UDim2.new(1, self.props.truncate and -48 or -12, 1, 0),
							TextTransparency = textTransparency,
							TextTruncate = 0,
							TextXAlignment = 0
						}
						local textTruncate

						if self.props.truncate then
							textTruncate = Enum.TextTruncate.AtEnd
						else
							textTruncate = Enum.TextTruncate.None
						end

						v2.TextTruncate = textTruncate

						v2.TextXAlignment = Enum.TextXAlignment.Left
						children.ButtonText = createElement(ThemedTextLabel, v2)
						return children
					end,
					ButtonRef = self.openDropDownButtonRef
				}),
				CloseDropDownArea = Roact.createElement("TextButton", {
					BackgroundTransparency = 1,
					Text = "",
					Position = UDim2.new(0, -self.state.absolutePositionX, 0, -self.state.absolutePositionY),
					Size = UDim2.new(0, self.state.screenSizeX, 0, self.state.screenSizeY),
					Visible = self.state.isOpen,
					Selectable = false,
					[Roact.Event.Activated] = function()
						self:setState({ isOpen = false })
					end,
					ZIndex = 2
				}),
				DropDownShadow = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.Shadow.Image,
					Position = UDim2.new(0, -size, 0, -size),
					Size = UDim2.new(1, size * 2, 0, size * 2 + 8 + v),
					ScaleType = Assets.Images.Shadow.ScaleType,
					SliceCenter = Assets.Images.Shadow.SliceCenter,
					Visible = self.state.isOpen,
					ZIndex = 3
				}, {
					FocusHandler = self:renderFocusHandler(),
					DropDownBackground = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Image = Assets.Images.RoundedRect.Image,
						ImageColor3 = p.Theme.BackgroundUIDefault.Color,
						ImageTransparency = p.Theme.BackgroundUIDefault.Transparency,
						ScaleType = Assets.Images.RoundedRect.ScaleType,
						Size = UDim2.new(1, -(size * 2), 1, -(size * 2)),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						SliceCenter = Assets.Images.RoundedRect.SliceCenter,
						SliceScale = 0.5
					}, {
						DropDownList = Roact.createElement(BarOnTopScrollingFrame, {
							Position = UDim2.new(0, 0, 0, 4),
							Size = UDim2.new(1, 0, 1, -8),
							CanvasSize = UDim2.new(1, 0, 0, #self.props.selections * self.state.dropDownItemHeight)
						}, dropDownList)
					})
				})
			})
		end)
	end)
end

function extended:watchLayerCollector(instance)
	self:setState({ screenSizeX = instance.AbsoluteSize.X, screenSizeY = instance.AbsoluteSize.Y })

	self.sizeConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:setState({
			screenSizeX = instance.AbsoluteSize.X,
			screenSizeY = instance.AbsoluteSize.Y
		})
	end)
end

function extended:didMount()
	local current = self.rootRef.current
	local layerCollector = current:FindFirstAncestorWhichIsA("LayerCollector")

	if layerCollector == nil then
		self.ancestryConnection = current.AncestryChanged:Connect(function()
			layerCollector = current:FindFirstAncestorWhichIsA("LayerCollector")

			if layerCollector ~= nil then
				self.ancestryConnection:Disconnect()
				self.ancestryConnection = nil
				self:watchLayerCollector(layerCollector)
			end
		end)
	else
		self:watchLayerCollector(layerCollector)
	end
end

function extended:didUpdate(p)
	if p.ButtonRef ~= self.props.ButtonRef then
		self.openDropDownButtonRef = self.props.ButtonRef or Roact.createRef()
	end

	if self.state.isOpen and p.canCaptureFocus ~= self.props.canCaptureFocus then
		self:setState({ isOpen = false })
	end
end

function extended.willUnmount(p)
	if p.ancestryConnection then
		p.ancestryConnection:Disconnect()
	end

	if p.sizeConnection then
		p.sizeConnection:Disconnect()
	end
end

return extended
