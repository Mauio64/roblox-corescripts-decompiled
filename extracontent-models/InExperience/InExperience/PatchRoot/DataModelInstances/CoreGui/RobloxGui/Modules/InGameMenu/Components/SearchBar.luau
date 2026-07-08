local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local withStyle = UIBlox.Core.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local ParentParent = script.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local v13 = Roact.PureComponent:extend("SearchBar")

v13.validateProps = t.interface({
	size = t.UDim2,
	text = t.optional(t.string),
	onTextChanged = t.optional(t.callback),
	onFocused = t.optional(t.callback),
	onCancelled = t.optional(t.callback),
	onFocusLost = t.optional(t.callback),
	autoCaptureFocus = t.optional(t.boolean),
	zIndex = t.optional(t.number),
	visible = t.optional(t.boolean)
})
v13.defaultProps = {
	autoCaptureFocus = false,
	visible = true,
	size = UDim2.fromScale(1, 1)
}

function v13.init(p1) -- line: 46
	-- upvalues: Roact (copy)
	p1.textboxRef = Roact.createRef()

	function p1.onAbsoluteSizeChanged(p2) -- line: 49
		-- upvalues: p1 (copy)
		local v23 = false

		if p1.width ~= p2.AbsoluteSize.X then
			p1.width = p2.AbsoluteSize.X
			v23 = true
		end

		if p1.height ~= p2.AbsoluteSize.Y then
			p1.height = p2.AbsoluteSize.Y
			v23 = true
		end

		if v23 then
			p1:setState({
				width = p1.width - 2,
				height = p1.height - 2
			})
		end
	end
	function p1.searchTextChanged(p3) -- line: 70
		-- upvalues: p1 (copy)
		if p1.props.onTextChanged then
			p1.props.onTextChanged(p3.Text)
		end
	end
	function p1.searchBoxFocused(_) -- line: 76
		-- upvalues: p1 (copy)
		if p1.props.onFocused then
			p1.props.onFocused()
		end
	end
	function p1.searchCancel() -- line: 82
		-- upvalues: p1 (copy)
		if p1.props.onCancelled then
			p1.props.onCancelled()
		end
	end
	function p1.onFocusLost() -- line: 88
		-- upvalues: p1 (copy)
		if p1.props.onFocusLost then
			p1.props.onFocusLost()
		end
	end
	function p1.onTextboxTouchTap() -- line: 94
		-- upvalues: p1 (copy)
		if p1.props.onTextboxTouchTap then
			p1.props.onTextboxTouchTap()
		end
	end
end
function v13.willUpdate(p5, p6) -- line: 101
	if p5.props.autoCaptureFocus and (p5.props.visible == false and p6.visible) then
		p5:focus()
	end
end
function v13.didMount(p7) -- line: 107
	if p7.props.autoCaptureFocus and p7.props.visible then
		p7:focus()
	end
end
function v13.focus(p8) -- line: 113
	if p8.textboxRef then
		p8.textboxRef.current:CaptureFocus()
	end
end
function v13.render(p9) -- line: 119
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), UserInputService (copy), ImageSetLabel (copy), Images (copy)
	return withStyle(function(p10) -- line: 120
		-- upvalues: withLocalization (copy), p9 (copy), Roact (copy), UserInputService (copy), ImageSetLabel (copy), Images (copy)
		return withLocalization({
			search = "CoreScripts.InGameMenu.InviteFriends.Search",
			cancel = "CoreScripts.InGameMenu.Cancel"
		})(function(p11) -- line: 124
			-- upvalues: p10 (copy), p9 (copy), Roact (copy), UserInputService (copy), ImageSetLabel (copy), Images (copy)
			local Body = p10.Font.Body
			local v29 = p10.Font.BaseSize * Body.RelativeSize
			local Body2 = p10.Font.Body
			local v31 = p10.Font.BaseSize * Body2.RelativeSize
			local t1 = {
				BackgroundTransparency = 1,
				GroupTransparency = 0.5,
				Size = p9.props.size,
				ZIndex = p9.props.zIndex,
				Visible = p9.props.visible,
				[Roact.Ref] = p9.props.forwardRef or Roact.createRef()
			}
			local v33 = if UserInputService:GetPlatform() ~= Enum.Platform.Android then Enum.TextInputType.NoSuggestions else Enum.TextInputType.PasswordShown

			return Roact.createElement("CanvasGroup", t1, {
				SearchPanelLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 9)
				}),
				SearchBorder = Roact.createElement("Frame", {
					Size = UDim2.new(1, -66, 0, 38),
					BackgroundColor3 = Color3.new(136, 136, 136),
					BackgroundTransparency = 0.8,
					[Roact.Change.AbsoluteSize] = p9.onAbsoluteSizeChanged
				}, {
					BorderRadius = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 4)
					}),
					SearchContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 0,
						Size = UDim2.fromOffset(p9.state.width, p9.state.height),
						BackgroundColor3 = Color3.new(0, 0, 0),
						Position = UDim2.fromOffset(1, 1)
					}, {
						SearchContainerLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 10)
						}),
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 12),
							PaddingRight = UDim.new(0, 12)
						}),
						BorderRadius = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 4)
						}),
						SearchImage = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Image = Images["icons/common/search_small"],
							Size = UDim2.fromOffset(18, 18)
						}),
						SearchInput = Roact.createElement("TextBox", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -28, 0, 20),
							Font = Body2.Font,
							Text = p9.props.text or "",
							TextInputType = v33,
							TextSize = v31,
							TextColor3 = p10.Theme.TextEmphasis.Color,
							TextXAlignment = Enum.TextXAlignment.Left,
							PlaceholderText = p11.search,
							PlaceholderColor3 = p10.Theme.TextDefault.Color,
							ClearTextOnFocus = false,
							ClipsDescendants = true,
							[Roact.Change.Text] = p9.searchTextChanged,
							[Roact.Event.Focused] = p9.searchBoxFocused,
							[Roact.Event.FocusLost] = p9.onFocusLost,
							[Roact.Ref] = p9.textboxRef,
							[Roact.Event.TouchTap] = p9.onTextboxTouchTap
						})
					})
				}),
				CancelButton = Roact.createElement("TextButton", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(57, 20),
					Font = Body.Font,
					TextSize = v29,
					Text = p11.cancel,
					TextColor3 = p10.Theme.TextEmphasis.Color,
					[Roact.Event.Activated] = p9.searchCancel
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p12, p13) -- line: 236
	-- upvalues: Roact (copy), v13 (copy), Cryo (copy)
	return Roact.createElement(v13, Cryo.Dictionary.join(p12, {
		forwardRef = p13
	}))
end)
