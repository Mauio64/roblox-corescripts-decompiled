local appFonts = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").AppFonts

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactRodux")
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServices").RoactServices
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServiceTags").RoactNetworking
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")

local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Localization").withLocalization

local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/FormFactor").Enums.FormFactor

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppAssets").GetImageData
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/SearchBar")
local WindowedListFrame = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/WindowedListFrame")
local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").Colors

local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Otter")

local extended = Roact.PureComponent:extend("ListSearchWidget")

local flint = colors.Flint
local obsidian = colors.Obsidian
local white = colors.White

function extended:init()
	self.state = { fullLoad = false, visible = false, filteredList = self.props.List }

	self.visibility = 0
	self.visibilityTarget = 0
	self.baseFrameRef = Roact.createRef()

	function self.getWidgetPosition()
		return UDim2.new(0.5, 0, 2 - self.visibility, 10)
	end

	function self.searchTextChanged(p2)
		local text = string.lower(p2.Text)

		if text == "" then
			if self.state.filteredList ~= self.props.List then
				self:setState({ filteredList = self.props.List })
			end
		else
			local v5 = {}

			for i, item in ipairs(self.props.List) do
				if not string.find(string.lower(item.localizedName), text, 1, true) then
					continue
				end

				table.insert(v5, item)
			end

			self:setState({ filteredList = v5 })
		end
	end

	function self.renderWidgetBackground(props)
		local v5 = 1.4 * props.closeButtonSize

		if props.isWideScreen then
			return Roact.createElement(imageSetLabel, {
				Size = UDim2.new(1, 0, 1, -v5 + 10),
				Position = props.Position,
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = flint,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				Visible = props.Visible,
				[Roact.Ref] = self.baseFrameRef
			}, {
				CloseButton = Roact.createElement(imageSetButton, {
					Size = UDim2.new(0, props.closeButtonSize, 0, props.closeButtonSize),
					AnchorPoint = Vector2.new(0, 1),
					Image = getImageData("LuaApp/icons/GameDetails/navigation/close") or "LuaApp/icons/GameDetails/navigation/close",
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
			local v6 = props.closeButtonSize + 20
			return Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 10),
				Position = props.Position,
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = flint,
				Visible = props.Visible,
				[Roact.Ref] = self.baseFrameRef
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 40),
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20),
					PaddingBottom = UDim.new(0, 10)
				}),
				CloseButton = Roact.createElement(imageSetButton, {
					Size = UDim2.new(0, props.closeButtonSize, 0, props.closeButtonSize),
					Image = getImageData("LuaApp/icons/GameDetails/navigation/close") or "LuaApp/icons/GameDetails/navigation/close",
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.21, 0),
					[Roact.Event.Activated] = props.CloseCallback
				}),
				ContentWrapper = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, -v6),
					Position = UDim2.new(0, 0, 0, v6)
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

function extended.willUnmount(p2)
	if p2.motor then
		p2.motor:destroy()
	end
end

extended.defaultProps = { SearchPlaceholder = "Feature.Chat.Label.SearchWord" }

function extended.render(data)
	local v5 = data.props.formFactor == formFactor.WIDE

	local v6 = 14

	local v7 = v6 + 36
	local v8, v9, v10

	if v5 then
		v6 = 18

		v7 = v6 + 48
		v8 = 24
		v9 = 48
		v10 = 30
	else
		v8 = 24
		v9 = 27
		v10 = 24
	end

	local v11 = v6 * 2.4
	local v12 = v11 + 40 + v8

	local v13 = data.props.VisibilityTarget == 1

	return withLocalization({
		heading = data.props.Heading,
		search = data.props.SearchPlaceholder
	})(function(p2)
		return Roact.createElement(v13 and "TextButton" or "Frame", {
			AutoButtonColor = if v13 then false else nil,
			Text = v13 and "" or nil,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1 - 0.5 * data.visibility,
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0
		}, { Roact.createElement(data.renderWidgetBackground, {
				isWideScreen = v5,
				closeButtonSize = v9,
				Position = data.getWidgetPosition(),
				CloseCallback = data.props.CloseCallback,
				Visible = data.state.visible,
				contents = {
					Heading = Roact.createElement("TextLabel", {
						Text = p2.heading,
						Size = UDim2.new(1, 0, 0, v8),
						TextSize = v8,
						Font = appFonts.default:getBold(),
						TextColor3 = white,
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					SearchBar = Roact.createElement(module4, {
						Size = UDim2.new(1, 0, 0, v11),
						Position = UDim2.new(0, 0, 0, v8 + 20),
						ImageColor3 = obsidian,
						PlaceholderText = p2.search,
						PlaceholderColor3 = flint,
						IconSize = v10,
						Text = "",
						TextSize = v6,
						TextColor3 = white,
						TextChanged = data.searchTextChanged
					}),
					ListFrame = Roact.createElement(WindowedListFrame, {
						List = data.state.filteredList,
						ScrollingFrameOffset = v12,
						TextSize = v6,
						ButtonSizeY = v7,
						ListButton = data.props.ListButton,
						ListButtonProps = {
							TextSize = v6,
							SelectionCallback = data.props.SelectionCallback
						}
					})
				}
			}) })
	end)
end

function extended:didUpdate(p2)
	if self.visibilityTarget ~= self.props.VisibilityTarget and self.motor then
		self.visibilityTarget = self.props.VisibilityTarget

		self.motor:setGoal(Otter.spring(self.visibilityTarget), { frequency = 3 })

		if self.visibilityTarget > 0 and not self.state.visible then
			self:setState({ visible = true })
		end
	end

	if p2.List ~= self.props.List or self.props.VisibilityTarget == 1 and p2.VisibilityTarget ~= 1 then
		self:setState({ filteredList = self.props.List })
	end
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor }
end)(extended)

return roactServices.connect({ networking = roactNetworking })(v5)
