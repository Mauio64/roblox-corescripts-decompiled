local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Otter = InGameMenuDependencies.Otter
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Foundation = require(CorePackages.Packages.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local parent = script.Parent.Parent

local SetCurrentPage = require(parent.Actions.SetCurrentPage)

local Pages = require(script.Parent.Pages)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)
local Divider = require(script.Parent.Divider)

local withLocalization = require(parent.Localization.withLocalization)

local divideTransparency = require(parent.Utility.divideTransparency)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local extended = Roact.PureComponent:extend("NavigationButton")

function extended:init(p)
	local fillProgress = p.selected and 1 or 0
	local binding, v3 = Roact.createBinding(fillProgress)

	self.fillSize = binding:map(function(p2)
		return UDim2.new(p2, 0, 1, 0)
	end)

	local binding2, setHoverTransparency = Roact.createBinding(0)
	self.hoverTransparency = binding2
	self.setHoverTransparency = setHoverTransparency

	self.motor = Otter.createGroupMotor({ fillProgress = fillProgress, hoverTransparency = 0 })

	self.motor:onStep(function(p2)
		v3(p2.fillProgress)
		self.setHoverTransparency(p2.hoverTransparency)
	end)

	self:setState({ hovering = false, pressing = false })
end

function extended:renderWithSelectionCursor(callback)
	local props = self.props

	return withLocalization({ text = props.text })(function(p)
		return withFoundationOrUIBloxStyle(function(p2)
			return {
				Theme = {
					BackgroundOnPress = {
						Color = p2.Color.State.Press.Color3,
						Transparency = p2.Color.State.Press.Transparency
					},
					BackgroundOnHover = {
						Color = p2.Color.State.Hover.Color3,
						Transparency = p2.Color.State.Hover.Transparency
					},
					IconEmphasis = {
						Color = p2.Color.Content.Emphasis.Color3,
						Transparency = p2.Color.Content.Emphasis.Transparency
					},
					TextEmphasis = {
						Color = p2.Color.Content.Emphasis.Color3,
						Transparency = p2.Color.Content.Emphasis.Transparency
					},
					BackgroundMuted = {
						Color = p2.Color.Surface.Surface_200.Color3,
						Transparency = p2.Color.Surface.Surface_200.Transparency
					}
				}
			}
		end, function(p2)
			local v3 = self.state.pressing and not props.selected
			local v4 = { Transparency = 1, Color = Color3.new(1, 1, 1) }

			if self.state.pressing then
				v4 = p2.Theme.BackgroundOnPress
			elseif self.state.hovering then
				v4 = p2.Theme.BackgroundOnHover
			end

			local createElement = Roact.createElement
			local v5 = {
				AutoButtonColor = false,
				BackgroundTransparency = v4.Transparency,
				BackgroundColor3 = v4.Color,
				BorderSizePixel = 0,
				LayoutOrder = props.LayoutOrder,
				Size = UDim2.new(1, 0, 0, 70),
				Text = "",
				SelectionImageObject = callback(v2.Square),
				[Roact.Event.Activated] = props.onActivated
			}
			local ref = Roact.Ref
			local v6

			if props.LayoutOrder == 1 then
				v6 = props.mainPageFirstButtonRef or nil
			end

			v5[ref] = v6
			v5[Roact.Event.MouseEnter] = function()
				self:setState({ hovering = true })
			end
			v5[Roact.Event.MouseLeave] = function()
				self:setState({ hovering = false, pressing = false })
			end
			v5[Roact.Event.InputBegan] = function(_, p3)
				if
					p3.UserInputType == Enum.UserInputType.MouseButton1
					or p3.UserInputType == Enum.UserInputType.Touch
				then
					self:setState({ pressing = true })
				end
			end
			v5[Roact.Event.InputEnded] = function(_, p3)
				if
					p3.UserInputType == Enum.UserInputType.MouseButton1
					or p3.UserInputType == Enum.UserInputType.Touch
				then
					self:setState({ pressing = false })
				end
			end

			local createElement2 = Roact.createElement
			local v7 = {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ZIndex = 3,
				BackgroundTransparency = 1
			}
			local icon

			if FFlagCoreUiMigrateUIBloxToFoundation then
				icon = Roact.createElement(Icon, {
					AnchorPoint = Vector2.new(0, 0.5),
					name = props.icon,
					size = IconSize.Medium,
					style = {
						Color3 = p2.Theme.IconEmphasis.Color,
						Transparency = divideTransparency(p2.Theme.IconEmphasis.Transparency, v3 and 2 or 1)
					},
					Position = UDim2.new(0, 28, 0.5, 0),
					ZIndex = 3
				})
			else
				icon = Roact.createElement(ImageSetLabel, {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					Image = props.icon,
					ImageColor3 = p2.Theme.IconEmphasis.Color,
					ImageTransparency = divideTransparency(p2.Theme.IconEmphasis.Transparency, v3 and 2 or 1),
					Position = UDim2.new(0, 28, 0.5, 0),
					Size = UDim2.new(0, 36, 0, 36),
					ZIndex = 3
				})
			end

			return createElement("TextButton", v5, {
				ContentContainer = createElement2("Frame", v7, {
					Icon = icon,
					Text = Roact.createElement(ThemedTextLabel, {
						fontKey = "Header1",
						themeKey = "TextEmphasis",
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 80, 0.5, 0),
						Size = UDim2.new(1, -104, 1, 0),
						Text = p.text,
						TextTransparency = divideTransparency(p2.Theme.TextEmphasis.Transparency, v3 and 2 or 1),
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 3
					})
				}),
				SelectedFill = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = self.fillSize,
					BackgroundColor3 = p2.Theme.BackgroundMuted.Color,
					ZIndex = 2
				})
			})
		end)
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

function extended.didUpdate(data)
	data.motor:setGoal({
		fillProgress = Otter.spring(data.props.selected and 1 or 0, { frequency = 2.5 }),
		hoverTransparency = Otter.spring(data.state.hovering and 1 or 0, { frequency = 5 })
	})
end

local function PageNavigation(props)
	local children = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}

	local count = #Pages.pagesByIndex
	local layoutOrder = 1

	for i, page in ipairs(Pages.pagesByIndex) do
		if page.parentPage ~= Constants.MainPagePageKey then
			continue
		end

		local v3 = "Page" .. page.key
		local createElement = Roact.createElement
		local v4 = {
			icon = page.icon,
			LayoutOrder = layoutOrder,
			selected = props.currentPage == page.key,
			text = page.title,
			onActivated = function()
				props.setCurrentPage(page.key)
			end,
			mainPageFirstButtonRef = 0
		}
		local mainPageFirstButtonRef

		if layoutOrder == 1 then
			mainPageFirstButtonRef = props.mainPageFirstButtonRef or nil
		end

		v4.mainPageFirstButtonRef = mainPageFirstButtonRef
		children[v3] = createElement(extended, v4)

		layoutOrder += 1

		if not (i < count) then
			continue
		end

		children["Divider" .. layoutOrder] = Roact.createElement(Divider, {
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, -24, 0, 1)
		})

		layoutOrder += 1
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = props.Position,
		Size = UDim2.new(1, -Constants.Zone.ContentOffset, 0, count * 70 + (count - 1))
	}, children)
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { currentPage = p.menuPage }
end, function(callback)
	return {
		setCurrentPage = function(p)
			callback(SetCurrentPage(p))
			SendAnalytics("open_" .. p .. "_tab", Constants.AnalyticsMenuActionName, {})
		end
	}
end)(PageNavigation)
