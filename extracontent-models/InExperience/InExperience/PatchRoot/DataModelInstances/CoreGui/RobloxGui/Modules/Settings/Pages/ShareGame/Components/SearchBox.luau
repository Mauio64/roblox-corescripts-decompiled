local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local Constants = require(RobloxGui.Modules.Settings.Pages.ShareGame.Constants)

local extended = Roact.Component:extend("SearchBox")

local ShareGameIcons = require(RobloxGui.Modules.Settings.Pages.ShareGame.Spritesheets.ShareGameIcons)
local imagePath = ShareGameIcons:GetImagePath()

local frame = ShareGameIcons:GetFrame("search_border")
local rect = Rect.new(3, 3, 4, 4)

local frame2 = ShareGameIcons:GetFrame("search_small")

local frame3 = ShareGameIcons:GetFrame("clear")

local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Theme = require(RobloxGui.Modules.Settings.Theme)
local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

function extended:init()
	self.state = { isTextWritten = false }

	self.searchField = nil
end

function extended:render()
	local anchorPoint = self.props.anchorPoint
	local onTextBoxFocusLost = self.props.onTextBoxFocusLost
	local onTextBoxFocused = self.props.onTextBoxFocused
	local position = self.props.position
	local searchFieldRef = self.props.searchFieldRef
	local size = self.props.size
	local visible = self.props.visible
	local zIndex = self.props.zIndex

	local isTextWritten = self.state.isTextWritten
	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = anchorPoint,
		Position = position,
		Size = size,
		Visible = visible,
		Image = imagePath,
		ImageRectOffset = frame.offset,
		ImageRectSize = frame.size,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		ZIndex = zIndex
	}, {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6)
		}),
		SearchIcon = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = imagePath,
			ImageRectOffset = frame2.offset,
			ImageRectSize = frame2.size,
			Size = UDim2.new(0, 16, 0, 16),
			ZIndex = zIndex
		}),
		SearchField = Roact.createElement("TextBox", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 28, 0.5, 0),
			Size = UDim2.new(1, -56, 1, 0),
			ClearTextOnFocus = false,
			PlaceholderColor3 = Constants.Color.GRAY3,
			PlaceholderText = translator:FormatByKey("Feature.SettingsHub.Label.SearchForFriendsPlaceholder.FriendsRename"),
			Text = "",
			TextColor3 = Constants.Color.WHITE,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = Theme.textSize(16),
			Font = Theme.font(Enum.Font.SourceSans),
			ZIndex = zIndex,
			[Roact.Ref] = function(searchField)
				self.searchField = searchField

				if searchFieldRef then
					searchFieldRef(searchField)
				end
			end,
			[Roact.Event.Focused] = function()
				if onTextBoxFocused then
					onTextBoxFocused()
				end
			end,
			[Roact.Event.FocusLost] = function(p)
				if onTextBoxFocusLost then
					onTextBoxFocusLost(p.Text)
				end
			end
		}),
		ClearButton = Roact.createElement("ImageButton", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.new(0, 16, 0, 16),
			Image = imagePath,
			ImageRectOffset = frame3.offset,
			ImageRectSize = frame3.size,
			ZIndex = zIndex,
			Visible = isTextWritten,
			[Roact.Event.Activated] = function()
				if self.searchField then
					self.searchField.Text = ""

					self.searchField:CaptureFocus()
				end
			end
		})
	})
end

function extended:didMount()
	local searchField = self.searchField
	local onTextChanged = self.props.onTextChanged

	if searchField then
		self.textBoxChangedConnection = searchField:GetPropertyChangedSignal("Text"):Connect(function()
			local text = searchField.Text
			self:setState({
				isTextWritten = text:len() > 0
			})

			onTextChanged(text)
		end)
	end
end

function extended.willUnmount(p)
	if p.textBoxChangedConnection then
		p.textBoxChangedConnection:Disconnect()
	end
end

return extended
