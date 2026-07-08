local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local ContactList = CoreGui:WaitForChild("RobloxGui").Modules.ContactList
local dependencies = require(ContactList.dependencies)
local UIBlox = dependencies.UIBlox
local Colors = UIBlox.App.Style.Colors
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = dependencies.Hooks.useLocalization
local t1 = {
	searchBarHeight = 36,
	searchText = ""
}

return function(p1) -- line: 35
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), useLocalization (copy), Colors (copy), ImageSetLabel (copy), Images (copy)
	local v15 = Cryo.Dictionary.join(t1, p1)
	local v16 = useStyle()
	local Font = v16.Font
	local Theme = v16.Theme
	local v19, v20 = React.useState(false)
	local v21 = React.useCallback(function(p2, p3) -- line: 43
		-- upvalues: v15 (copy)
		if p3 == "Text" then
			v15.onSearchChanged(p2.Text)
		end
	end, { v15.onSearchChanged })
	local searchFriendsLabel = useLocalization({
		searchFriendsLabel = "Feature.Call.Prompt.SearchFriends"
	}).searchFriendsLabel

	return React.createElement("Frame", {
		Size = UDim2.new(1, -48, 0, v15.searchBarHeight),
		BackgroundColor3 = Theme.UIMuted.Color,
		BackgroundTransparency = Theme.UIMuted.Transparency,
		LayoutOrder = v15.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 4)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		}),
		UIStroke = React.createElement("UIStroke", {
			Thickness = 1,
			Color = Colors.Pumice
		}),
		SearchImage = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Image = Images["icons/common/search_small"],
			ImageColor3 = if not v19 then Color3.fromHex("#696A6B") else Colors.White,
			Size = UDim2.fromOffset(16, 16)
		}),
		TextBox = React.createElement("TextBox", {
			Size = UDim2.new(1, -20, 1, 0),
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			Font = Font.Body.Font,
			LayoutOrder = 2,
			PlaceholderColor3 = Color3.fromHex("#696A6B"),
			PlaceholderText = searchFriendsLabel,
			Text = v15.searchText,
			TextColor3 = Colors.White,
			TextSize = Font.BaseSize * Font.Body.RelativeSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			[React.Event.Changed] = v21,
			[React.Event.Focused] = function() -- line: 98
				-- upvalues: v20 (copy), v15 (copy)
				v20(true)
				v15.onFocused()
			end,
			[React.Event.FocusLost] = function() -- line: 102
				-- upvalues: v20 (copy)
				v20(false)
			end
		})
	})
end
