local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local Foundation = require(CorePackages.Packages.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local ParentParent = script.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local v17 = Roact.PureComponent:extend("SearchBar")

v17.validateProps = t.interface({
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
v17.defaultProps = {
	autoCaptureFocus = false,
	visible = true,
	size = UDim2.fromScale(1, 1)
}

function v17.init(p1) -- line: 52
	-- upvalues: Roact (copy)
	p1.textboxRef = Roact.createRef()

	function p1.onAbsoluteSizeChanged(p2) -- line: 55
		-- upvalues: p1 (copy)
		local v27 = false

		if p1.width ~= p2.AbsoluteSize.X then
			p1.width = p2.AbsoluteSize.X
			v27 = true
		end

		if p1.height ~= p2.AbsoluteSize.Y then
			p1.height = p2.AbsoluteSize.Y
			v27 = true
		end

		if v27 then
			p1:setState({
				width = p1.width - 2,
				height = p1.height - 2
			})
		end
	end
	function p1.searchTextChanged(p3) -- line: 76
		-- upvalues: p1 (copy)
		if p1.props.onTextChanged then
			p1.props.onTextChanged(p3.Text)
		end
	end
	function p1.searchBoxFocused(_) -- line: 82
		-- upvalues: p1 (copy)
		if p1.props.onFocused then
			p1.props.onFocused()
		end
	end
	function p1.searchCancel() -- line: 88
		-- upvalues: p1 (copy)
		if p1.props.onCancelled then
			p1.props.onCancelled()
		end
	end
	function p1.onFocusLost() -- line: 94
		-- upvalues: p1 (copy)
		if p1.props.onFocusLost then
			p1.props.onFocusLost()
		end
	end
	function p1.onTextboxTouchTap() -- line: 100
		-- upvalues: p1 (copy)
		if p1.props.onTextboxTouchTap then
			p1.props.onTextboxTouchTap()
		end
	end
end
function v17.willUpdate(p5, p6) -- line: 107
	if p5.props.autoCaptureFocus and (p5.props.visible == false and p6.visible) then
		p5:focus()
	end
end
function v17.didMount(p7) -- line: 113
	if p7.props.autoCaptureFocus and p7.props.visible then
		p7:focus()
	end
end
function v17.focus(p8) -- line: 119
	if p8.textboxRef then
		p8.textboxRef.current:CaptureFocus()
	end
end
function v17.render(p9) -- line: 125
	-- upvalues: withFoundationOrUIBloxStyle (copy), withLocalization (copy), Roact (copy), UserInputService (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Icon (copy), IconSize (copy), ImageSetLabel (copy), Images (copy)
	return withFoundationOrUIBloxStyle(function(p10) -- line: 126
		return {
			Theme = {
				TextEmphasis = {
					Color = p10.Color.Content.Emphasis.Color3,
					Transparency = p10.Color.Content.Emphasis.Transparency
				},
				TextDefault = {
					Color = p10.Color.Content.Default.Color3,
					Transparency = p10.Color.Content.Default.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Body = {
					Font = p10.Typography.BodyLarge.Font,
					RelativeSize = p10.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(p11) -- line: 137
		-- upvalues: withLocalization (copy), p9 (copy), Roact (copy), UserInputService (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Icon (copy), IconSize (copy), ImageSetLabel (copy), Images (copy)
		return withLocalization({
			search = "CoreScripts.InGameMenu.InviteFriends.Search",
			cancel = "CoreScripts.InGameMenu.Cancel"
		})(function(p12) -- line: 141
			-- upvalues: p11 (copy), p9 (copy), Roact (copy), UserInputService (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Icon (copy), IconSize (copy), ImageSetLabel (copy), Images (copy)
			local Body = p11.Font.Body
			local v34 = p11.Font.BaseSize * Body.RelativeSize
			local Body2 = p11.Font.Body
			local v36 = p11.Font.BaseSize * Body2.RelativeSize
			local t1 = {
				BackgroundTransparency = 1,
				GroupTransparency = 0.5,
				Size = p9.props.size,
				ZIndex = p9.props.zIndex,
				Visible = p9.props.visible,
				[Roact.Ref] = p9.props.forwardRef or Roact.createRef()
			}
			local v38 = if UserInputService:GetPlatform() ~= Enum.Platform.Android then Enum.TextInputType.NoSuggestions else Enum.TextInputType.PasswordShown

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
						SearchImage = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Image = Images["icons/common/search_small"],
							Size = UDim2.fromOffset(18, 18)
						}) else Roact.createElement(Icon, {
							name = "icons/common/search_small",
							LayoutOrder = 1,
							size = IconSize.Medium
						}),
						SearchInput = Roact.createElement("TextBox", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -28, 0, 20),
							Font = Body2.Font,
							Text = p9.props.text or "",
							TextInputType = v38,
							TextSize = v36,
							TextColor3 = p11.Theme.TextEmphasis.Color,
							TextXAlignment = Enum.TextXAlignment.Left,
							PlaceholderText = p12.search,
							PlaceholderColor3 = p11.Theme.TextDefault.Color,
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
					TextSize = v34,
					Text = p12.cancel,
					TextColor3 = p11.Theme.TextEmphasis.Color,
					[Roact.Event.Activated] = p9.searchCancel
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p13, p14) -- line: 259
	-- upvalues: Roact (copy), v17 (copy), Cryo (copy)
	return Roact.createElement(v17, Cryo.Dictionary.join(p13, {
		forwardRef = p14
	}))
end)
