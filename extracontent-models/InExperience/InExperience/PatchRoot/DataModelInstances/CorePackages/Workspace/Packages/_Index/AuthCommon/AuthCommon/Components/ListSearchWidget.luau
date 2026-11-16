local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local Style = require(parent.Style)
local AppFonts = Style.AppFonts

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local UIBlox = require(parent.UIBlox)

local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization

local FormFactor = require(parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local SearchBar = require(AuthCommon.Components.SearchBar)
local WindowedListFrame = require(AuthCommon.Components.WindowedListFrame)
local Style2 = require(parent.Style)
local Colors = Style2.Colors

local Otter = require(parent.Otter)

local extended = Roact.PureComponent:extend("ListSearchWidget")

local Flint = Colors.Flint
local Obsidian = Colors.Obsidian
local White = Colors.White

function extended:init()
	self.state = { fullLoad = false, visible = false, filteredList = self.props.List }

	self.visibility = 0
	self.visibilityTarget = 0
	self.baseFrameRef = Roact.createRef()

	function self.getWidgetPosition()
		return UDim2.new(0.5, 0, 2 - self.visibility, 10)
	end

	function self.searchTextChanged(p)
		local text = string.lower(p.Text)

		if text == "" then
			if self.state.filteredList ~= self.props.List then
				self:setState({ filteredList = self.props.List })
			end
		else
			local filteredList = {}

			for _, item in ipairs(self.props.List) do
				if not string.find(string.lower(item.localizedName), text, 1, true) then
					continue
				end

				table.insert(filteredList, item)
			end

			self:setState({ filteredList = filteredList })
		end
	end

	function self.renderWidgetBackground(props)
		local v = 1.4 * props.closeButtonSize

		if props.isWideScreen then
			return Roact.createElement(ImageSetLabel, {
				Size = UDim2.new(1, 0, 1, -v + 10),
				Position = props.Position,
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = Flint,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				Visible = props.Visible,
				[Roact.Ref] = self.baseFrameRef
			}, {
				CloseButton = Roact.createElement(ImageSetButton, {
					Size = UDim2.new(0, props.closeButtonSize, 0, props.closeButtonSize),
					AnchorPoint = Vector2.new(0, 1),
					Image = GetImageData("LuaApp/icons/GameDetails/navigation/close") or "LuaApp/icons/GameDetails/navigation/close",
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = props.CloseCallback
				}),
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(600, 1e999)
				}),
				ContentWrapper = Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -80, 1, -50),
						Position = UDim2.new(0, 40, 0, 40)
					},
					props.contents
				)
			})
		else
			local v2 = props.closeButtonSize + 20
			return Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 10),
				Position = props.Position,
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = Flint,
				Visible = props.Visible,
				[Roact.Ref] = self.baseFrameRef
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 40),
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20),
					PaddingBottom = UDim.new(0, 10)
				}),
				CloseButton = Roact.createElement(ImageSetButton, {
					Size = UDim2.new(0, props.closeButtonSize, 0, props.closeButtonSize),
					Image = GetImageData("LuaApp/icons/GameDetails/navigation/close") or "LuaApp/icons/GameDetails/navigation/close",
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.21, 0),
					[Roact.Event.Activated] = props.CloseCallback
				}),
				ContentWrapper = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, -v2),
					Position = UDim2.new(0, 0, 0, v2)
				}, props.contents)
			})
		end
	end
end

function extended:didMount()
	self.motor = Otter.createSingleMotor(self.visibility)
	self.motor:onStep(function(visibility)
		self.visibility = visibility

		if self.baseFrameRef.current then
			self.baseFrameRef.current.Position = self.getWidgetPosition()
			self.baseFrameRef.current.Parent.BackgroundTransparency = 1 - 0.5 * self.visibility
		end

		if visibility == 0 and self.state.visible then
			self:setState({ visible = false })
		elseif visibility == 1 and not self.state.fullLoad then
			self:setState({ fullLoad = true })
		end
	end)
end

function extended.willUnmount(p)
	if p.motor then
		p.motor:destroy()
	end
end

extended.defaultProps = { SearchPlaceholder = "Feature.Chat.Label.SearchWord" }

function extended.render(data)
	local isWideScreen = data.props.formFactor == formFactor.WIDE

	local textSize = 14

	local buttonSizeY = textSize + 36
	local textSize2, closeButtonSize, iconSize

	if isWideScreen then
		textSize = 18

		buttonSizeY = textSize + 48
		textSize2 = 24
		closeButtonSize = 48
		iconSize = 30
	else
		textSize2 = 24
		closeButtonSize = 27
		iconSize = 24
	end

	local v = textSize * 2.4
	local scrollingFrameOffset = v + 40 + textSize2

	local v2 = data.props.VisibilityTarget == 1

	return withLocalization({ heading = data.props.Heading, search = data.props.SearchPlaceholder })(function(p)
		return Roact.createElement(v2 and "TextButton" or "Frame", {
			AutoButtonColor = not v2 and nil,
			Text = v2 and "" or nil,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1 - 0.5 * data.visibility,
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0
		}, { Roact.createElement(data.renderWidgetBackground, {
				isWideScreen = isWideScreen,
				closeButtonSize = closeButtonSize,
				Position = data.getWidgetPosition(),
				CloseCallback = data.props.CloseCallback,
				Visible = data.state.visible,
				contents = {
					Heading = Roact.createElement("TextLabel", {
						Text = p.heading,
						Size = UDim2.new(1, 0, 0, textSize2),
						TextSize = textSize2,
						Font = AppFonts.default:getBold(),
						TextColor3 = White,
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					SearchBar = Roact.createElement(SearchBar, {
						Size = UDim2.new(1, 0, 0, v),
						Position = UDim2.new(0, 0, 0, textSize2 + 20),
						ImageColor3 = Obsidian,
						PlaceholderText = p.search,
						PlaceholderColor3 = Flint,
						IconSize = iconSize,
						Text = "",
						TextSize = textSize,
						TextColor3 = White,
						TextChanged = data.searchTextChanged
					}),
					ListFrame = Roact.createElement(WindowedListFrame, {
						List = data.state.filteredList,
						ScrollingFrameOffset = scrollingFrameOffset,
						TextSize = textSize,
						ButtonSizeY = buttonSizeY,
						ListButton = data.props.ListButton,
						ListButtonProps = {
							TextSize = textSize,
							SelectionCallback = data.props.SelectionCallback
						}
					})
				}
			}) })
	end)
end

function extended:didUpdate(p)
	if self.visibilityTarget ~= self.props.VisibilityTarget and self.motor then
		self.visibilityTarget = self.props.VisibilityTarget

		self.motor:setGoal(Otter.spring(self.visibilityTarget), { frequency = 3 })

		if self.visibilityTarget > 0 and not self.state.visible then
			self:setState({ visible = true })
		end
	end

	if p.List ~= self.props.List or self.props.VisibilityTarget == 1 and p.VisibilityTarget ~= 1 then
		self:setState({ filteredList = self.props.List })
	end
end

local v = RoactRodux.connect(function(p, _)
	return { formFactor = p.FormFactor }
end)(extended)

return roactServices.connect({ networking = RoactNetworking })(v)
