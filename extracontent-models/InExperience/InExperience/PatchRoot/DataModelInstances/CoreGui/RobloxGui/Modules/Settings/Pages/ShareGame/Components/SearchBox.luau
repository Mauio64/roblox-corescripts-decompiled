local CorePackages = game:GetService("CorePackages")
local FFlagConnectionsToFriendsRename = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionsToFriendsRename
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(RobloxGui.Modules.Settings.Pages.ShareGame.Constants)
local v6 = Roact.Component:extend("SearchBox")
local ShareGameIcons = require(RobloxGui.Modules.Settings.Pages.ShareGame.Spritesheets.ShareGameIcons)
local ImagePath = ShareGameIcons:GetImagePath()
local Frame = ShareGameIcons:GetFrame("search_border")
local rect = Rect.new(3, 3, 4, 4)
local Frame2 = ShareGameIcons:GetFrame("search_small")
local Frame3 = ShareGameIcons:GetFrame("clear")
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Theme = require(RobloxGui.Modules.Settings.Theme)
local v15 = require(ShareGame.getTranslator)()

function v6.init(p1) -- line: 40
	p1.state = {
		isTextWritten = false
	}
	p1.searchField = nil
end
function v6.render(p2) -- line: 47
	-- upvalues: Roact (copy), ImagePath (copy), Frame (copy), rect (copy), ImagePath (copy), Frame2 (copy), Constants (copy), FFlagConnectionsToFriendsRename (copy), v15 (copy), Theme (copy), ImagePath (copy), Frame3 (copy)
	local anchorPoint = p2.props.anchorPoint
	local onTextBoxFocusLost = p2.props.onTextBoxFocusLost
	local onTextBoxFocused = p2.props.onTextBoxFocused
	local position = p2.props.position
	local searchFieldRef = p2.props.searchFieldRef
	local size = p2.props.size
	local visible = p2.props.visible
	local zIndex = p2.props.zIndex
	local isTextWritten = p2.state.isTextWritten

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = anchorPoint,
		Position = position,
		Size = size,
		Visible = visible,
		Image = ImagePath,
		ImageRectOffset = Frame.offset,
		ImageRectSize = Frame.size,
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
			Image = ImagePath,
			ImageRectOffset = Frame2.offset,
			ImageRectSize = Frame2.size,
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
			PlaceholderText = if not FFlagConnectionsToFriendsRename then v15:FormatByKey("Feature.SettingsHub.Label.SearchForFriendsPlaceholder") else v15:FormatByKey("Feature.SettingsHub.Label.SearchForFriendsPlaceholder.FriendsRename"),
			Text = "",
			TextColor3 = Constants.Color.WHITE,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = Theme.textSize(16),
			Font = Theme.font(Enum.Font.SourceSans),
			ZIndex = zIndex,
			[Roact.Ref] = function(p3) -- line: 102
				-- upvalues: p2 (copy), searchFieldRef (copy)
				p2.searchField = p3

				if searchFieldRef then
					searchFieldRef(p3)
				end
			end,
			[Roact.Event.Focused] = function() -- line: 111
				-- upvalues: onTextBoxFocused (copy)
				if onTextBoxFocused then
					onTextBoxFocused()
				end
			end,
			[Roact.Event.FocusLost] = function(p4) -- line: 116
				-- upvalues: onTextBoxFocusLost (copy)
				if onTextBoxFocusLost then
					onTextBoxFocusLost(p4.Text)
				end
			end
		}),
		ClearButton = Roact.createElement("ImageButton", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.new(0, 16, 0, 16),
			Image = ImagePath,
			ImageRectOffset = Frame3.offset,
			ImageRectSize = Frame3.size,
			ZIndex = zIndex,
			Visible = isTextWritten,
			[Roact.Event.Activated] = function() -- line: 132
				-- upvalues: p2 (copy)
				if p2.searchField then
					p2.searchField.Text = ""
					p2.searchField:CaptureFocus()
				end
			end
		})
	})
end
function v6.didMount(p5) -- line: 145
	local searchField = p5.searchField
	local onTextChanged = p5.props.onTextChanged

	if searchField then
		p5.textBoxChangedConnection = searchField:GetPropertyChangedSignal("Text"):Connect(function() -- line: 150
			-- upvalues: searchField (copy), p5 (copy), onTextChanged (copy)
			local searchFieldText = searchField.Text

			p5:setState({
				isTextWritten = searchFieldText:len() > 0
			})
			onTextChanged(searchFieldText)
		end)
	end
end
function v6.willUnmount(p6) -- line: 160
	if p6.textBoxChangedConnection then
		p6.textBoxChangedConnection:Disconnect()
	end
end

return v6
