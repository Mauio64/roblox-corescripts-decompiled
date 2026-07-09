local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Focusable = RoactGamepad.Focusable
local t = require(CorePackages.Packages.t)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local withStyle = UIBlox.Style.withStyle
local Constants = require(Modules.AvatarExperience.Common.Constants)
local v13 = Roact.PureComponent:extend("CategorySubButton")
local NavCornerSize = Constants.NavCornerSize
local NavButtonBorderSize = Constants.NavButtonBorderSize

v13.validateProps = t.strictInterface({
	title = t.string,
	width = t.number,
	layoutOrder = t.number,
	index = t.number,
	onSubButtonSelected = t.callback,
	parentButtonSelected = t.boolean,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	isClippedWhenParentUnselected = t.optional(t.boolean),
	buttonRef = t.table,
	selectedSubButtonIndex = t.optional(t.number)
})

function v13.renderWithProviders(p1, p2, p3) -- line: 49
	-- upvalues: Roact (copy), NavCornerSize (copy), NavButtonBorderSize (copy), Focusable (copy), CursorKind (copy)
	local v19 = if not p1.props.parentButtonSelected or not p1.props.selectedSubButtonIndex then p1.props.index == 1 else p1.props.selectedSubButtonIndex == p1.props.index
	local Theme = p2.Theme
	local v21 = p1.props.parentButtonSelected and Theme.TextEmphasis.Transparency or Theme.TextMuted.Transparency
	local p2Font = p2.Font
	local Header2Font = p2Font.Header2.Font
	local v24 = p2Font.BaseSize * p2Font.Header2.RelativeSize
	local v25 = p1.props.parentButtonSelected and Theme.TextEmphasis.Color or Theme.TextMuted.Color
	local t1 = {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, NavCornerSize)
		}),
		InnerButton = Roact.createElement("TextLabel", {
			BackgroundTransparency = 0,
			Size = UDim2.new(1, -NavButtonBorderSize * 2, 1, -NavButtonBorderSize * 2),
			Position = UDim2.fromOffset(NavButtonBorderSize, NavButtonBorderSize),
			Text = p1.props.title,
			BackgroundColor3 = if not v19 then Theme.BackgroundUIDefault.Color else v25,
			TextSize = v24,
			TextColor3 = if not v19 then v25 else Theme.BackgroundUIDefault.Color,
			TextTransparency = v21,
			Font = Header2Font
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, NavCornerSize - NavButtonBorderSize)
			})
		})
	}

	if p1.props.isClippedWhenParentUnselected and not p1.props.parentButtonSelected then
		return Roact.createElement("TextButton", {
			Size = UDim2.new(0, p1.props.width, 1, -4),
			LayoutOrder = p1.props.layoutOrder,
			[Roact.Event.Activated] = function() -- line: 91
				-- upvalues: p1 (copy)
				p1.props.onSubButtonSelected(p1.props.index)
			end,
			BorderSizePixel = 0,
			BackgroundColor3 = v25,
			Text = "",
			[Roact.Ref] = p1.props.buttonRef
		}, t1)
	end

	return Roact.createElement(Focusable.TextButton, {
		Size = UDim2.new(0, p1.props.width, 1, -4),
		LayoutOrder = p1.props.layoutOrder,
		[Roact.Event.Activated] = function() -- line: 103
			-- upvalues: p1 (copy)
			p1.props.onSubButtonSelected(p1.props.index)
		end,
		BorderSizePixel = 0,
		BackgroundColor3 = v25,
		Text = "",
		SelectionImageObject = p3(CursorKind.NavHighlight),
		NextSelectionRight = p1.props.NextSelectionRight,
		NextSelectionLeft = p1.props.NextSelectionLeft,
		[Roact.Ref] = p1.props.buttonRef
	}, t1)
end
function v13.render(p4) -- line: 117
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p5) -- line: 118
		-- upvalues: withSelectionCursorProvider (copy), p4 (copy)
		return withSelectionCursorProvider(function(p6) -- line: 119
			-- upvalues: p4 (copy), p5 (copy)
			return p4:renderWithProviders(p5, p6)
		end)
	end)
end

return (RoactRodux.connect(function(p7, _) -- line: 125
	return {
		selectedSubButtonIndex = p7.AvatarExperience.AvatarEditor.Categories.subButton
	}
end)(v13))
