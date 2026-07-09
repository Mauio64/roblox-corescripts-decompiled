local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local v16 = Images["icons/navigation/pushRight_small"] or "LuaApp/icons/GameDetails/navigation/pushRight_small"
local vector2 = Vector2.new(14, 14)
local v18 = Images["icons/actions/info_small"] or "LuaApp/icons/GameDetails/actions/info_small"
local vector2_2 = Vector2.new(18, 18)

local function v20(p1) -- line: 35
	return p1.ScreenSize
end

return (React.forwardRef(function(t1: {[any]: any}, p2) -- line: 55
	-- upvalues: useNavigation (copy), useSelector (copy), v20 (copy), useStyle (copy), useSelectionCursor (copy), CursorKind (copy), useLocalization (copy), vector2 (copy), Focusable (copy), React (copy), AvatarScreen (copy), ImageSetLabel (copy), vector2_2 (copy), v18 (copy), VerifiedBadges (copy), v16 (copy)
	local t1LayoutOrder = t1.LayoutOrder
	local infoName = t1.infoName
	local infoNameDetails = t1.infoNameDetails
	local infoData = t1.infoData
	local onActivate = t1.onActivate
	local hasVerifiedBadge = t1.hasVerifiedBadge
	local v30 = useNavigation()
	local v31 = useSelector(v20)
	local v32 = useStyle()
	local Theme = v32.Theme
	local Font = v32.Font
	local v35 = useSelectionCursor(CursorKind.RoundedRect)
	local v36 = useLocalization({
		name = infoName
	})
	local TextEmphasisColor = Theme.TextEmphasis.Color
	local v38 = Font.BaseSize * Font.Body.RelativeSize
	local v39 = -11 - vector2.X
	local v40 = p2 ~= nil
	local v41 = not v40 and "ImageButton" or Focusable.ImageButton
	local v42 = React.useCallback(function() -- line: 82
		-- upvalues: v30 (copy), AvatarScreen (copy), v31 (copy), infoNameDetails (copy)
		v30.navigate(AvatarScreen.ItemInfoRowPrompt, {
			confirmButtonText = "CommonUI.Controls.Action.OK",
			screenSize = v31,
			message = infoNameDetails
		})
	end, {
		v30,
		v31,
		infoNameDetails
	})
	local v43 = if not infoNameDetails then nil else v42

	local function renderLabelWithInfoIcon() -- line: 91
		-- upvalues: React (copy), v43 (copy), onActivate (copy), Font (copy), v36 (copy), Theme (copy), v38 (copy), infoNameDetails (copy), ImageSetLabel (copy), vector2_2 (copy), v18 (copy), TextEmphasisColor (copy)
		return React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, 0, 1, 0),
			[React.Event.Activated] = if not v43 then onActivate else v43
		}, {
			HorizontalLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			InfoNameTextLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Font = Font.Body.Font,
				AutomaticSize = Enum.AutomaticSize.X,
				Text = v36.name,
				TextColor3 = Theme.TextDefault.Color,
				TextSize = v38,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			}),
			InfoIcon = infoNameDetails and React.createElement(ImageSetLabel, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(vector2_2.X, vector2_2.Y),
				Image = v18,
				ImageColor3 = TextEmphasisColor
			})
		})
	end

	return React.createElement(v41, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1LayoutOrder,
		Size = UDim2.new(1, 0, 0, not t1.hideDivider and 53 or 52),
		[React.Event.Activated] = onActivate,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		NextSelectionLeft = t1.NextSelectionLeft,
		NextSelectionRight = t1.NextSelectionRight,
		ref = p2,
		SelectionImageObject = v40 and v35 or nil
	}, {
		Container = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, not t1.hideDivider and -1 or 0)
		}, {
			InfoNameTextLabelContainer = renderLabelWithInfoIcon(),
			InfoDataWithEmoji = hasVerifiedBadge and React.createElement(VerifiedBadges.EmojiWrapper, {
				emoji = VerifiedBadges.emoji.verified,
				font = if not onActivate then Font.Body.Font else Font.Header2.Font,
				anchorPoint = Vector2.new(1, 0),
				position = UDim2.new(1, not onActivate and 0 or v39, 0, 0),
				size = UDim2.new(0.5, 0, 1, 0),
				automaticSize = Enum.AutomaticSize.None,
				horizontalAlignment = Enum.HorizontalAlignment.Right,
				verticalAlignment = Enum.VerticalAlignment.Center
			}, {
				InfoDataTextLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Font = onActivate and Font.Header2.Font or Font.Body.Font,
					Size = UDim2.new(0, 0, 1, 0),
					Text = v36.data or infoData,
					TextColor3 = if not onActivate then Theme.TextDefault.Color else Theme.TextEmphasis.Color,
					TextSize = v38,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextScaled = t1.TextScaled,
					AutomaticSize = Enum.AutomaticSize.X,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			InfoDataTextLabel = not hasVerifiedBadge and React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, not onActivate and 0 or v39, 0, 0),
				Font = if not onActivate then Font.Body.Font else Font.Header2.Font,
				Size = UDim2.new(0.5, 0, 1, 0),
				Text = v36.data or infoData,
				TextColor3 = if not onActivate then Theme.TextDefault.Color else Theme.TextEmphasis.Color,
				TextSize = v38,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextScaled = t1.TextScaled,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Center
			}, {
				TextSizeConstraint = t1.TextScaled and React.createElement("UITextSizeConstraint", {
					MaxTextSize = v38
				})
			}),
			LinkIcon = onActivate and React.createElement(ImageSetLabel, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(vector2.X, vector2.Y),
				Image = v16,
				ImageColor3 = TextEmphasisColor
			})
		}),
		Divider = not t1.hideDivider and React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1)
		})
	})
end))
