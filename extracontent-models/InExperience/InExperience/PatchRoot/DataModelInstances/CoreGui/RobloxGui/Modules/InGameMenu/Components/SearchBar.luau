local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images

local Foundation = require(CorePackages.Packages.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local parent = script.Parent.Parent
local withLocalization = require(parent.Localization.withLocalization)

local extended = Roact.PureComponent:extend("SearchBar")

extended.validateProps = t.interface({
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

extended.defaultProps = { size = UDim2.fromScale(1, 1), autoCaptureFocus = false, visible = true }

function extended:init()
	self.textboxRef = Roact.createRef()

	function self.onAbsoluteSizeChanged(p)
		local flag

		if self.width == p.AbsoluteSize.X then
			flag = false
		else
			self.width = p.AbsoluteSize.X
			flag = true
		end

		if self.height ~= p.AbsoluteSize.Y then
			self.height = p.AbsoluteSize.Y
			flag = true
		end

		if flag then
			self:setState({
				width = self.width - 2,
				height = self.height - 2
			})
		end
	end

	function self.searchTextChanged(p)
		if self.props.onTextChanged then
			self.props.onTextChanged(p.Text)
		end
	end

	function self.searchBoxFocused(_)
		if self.props.onFocused then
			self.props.onFocused()
		end
	end

	function self.searchCancel()
		if self.props.onCancelled then
			self.props.onCancelled()
		end
	end

	function self.onFocusLost()
		if self.props.onFocusLost then
			self.props.onFocusLost()
		end
	end

	function self.onTextboxTouchTap()
		if self.props.onTextboxTouchTap then
			self.props.onTextboxTouchTap()
		end
	end
end

function extended:willUpdate(p)
	if self.props.autoCaptureFocus and self.props.visible == false and p.visible then
		self:focus()
	end
end

function extended:didMount()
	if self.props.autoCaptureFocus and self.props.visible then
		self:focus()
	end
end

function extended:focus()
	if self.textboxRef then
		self.textboxRef.current:CaptureFocus()
	end
end

function extended.render(data)
	return withFoundationOrUIBloxStyle(function(p)
		local tokens

		if FoundationFontFaceMigration then
			tokens = p
		end

		return {
			Tokens = tokens,
			Theme = {
				TextEmphasis = {
					Color = p.Color.Content.Emphasis.Color3,
					Transparency = p.Color.Content.Emphasis.Transparency
				},
				TextDefault = {
					Color = p.Color.Content.Default.Color3,
					Transparency = p.Color.Content.Default.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Body = {
					Font = p.Typography.BodyLarge.Font,
					RelativeSize = p.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(data2)
		return withLocalization({
			search = "CoreScripts.InGameMenu.InviteFriends.Search",
			cancel = "CoreScripts.InGameMenu.Cancel"
		})(function(p)
			local body = data2.Font.Body
			local textSize = data2.Font.BaseSize * body.RelativeSize
			local body2 = data2.Font.Body
			local textSize2 = data2.Font.BaseSize * body2.RelativeSize

			local forwardRefsByRef = {
				BackgroundTransparency = 1,
				GroupTransparency = 0.5,
				Size = data.props.size,
				ZIndex = data.props.zIndex,
				Visible = data.props.visible,
				[Roact.Ref] = data.props.forwardRef or Roact.createRef()
			}
			local textInputType

			if UserInputService:GetPlatform() == Enum.Platform.Android then
				textInputType = Enum.TextInputType.PasswordShown
			else
				textInputType = Enum.TextInputType.NoSuggestions
			end

			local createElement = Roact.createElement
			local children = {
				SearchPanelLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 9)
				}),
				SearchBorder = 0,
				CancelButton = 0
			}

			local createElement2 = Roact.createElement
			local onAbsoluteSizeChangedsByAbsoluteSize = {
				Size = UDim2.new(1, -66, 0, 38),
				BackgroundColor3 = Color3.new(136, 136, 136),
				BackgroundTransparency = 0.8,
				[Roact.Change.AbsoluteSize] = data.onAbsoluteSizeChanged
			}
			local v = {
				BorderRadius = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
				SearchContainer = 0
			}

			local createElement3 = Roact.createElement
			local v2 = {
				BackgroundTransparency = 0,
				Size = UDim2.fromOffset(data.state.width, data.state.height),
				BackgroundColor3 = Color3.new(0, 0, 0),
				Position = UDim2.fromOffset(1, 1)
			}
			local v3 = {
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
				BorderRadius = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
				SearchImage = 0,
				SearchInput = 0
			}
			local searchImage

			if FFlagCoreUiMigrateUIBloxToFoundation then
				searchImage = Roact.createElement(Icon, {
					name = "icons/common/search_small",
					size = IconSize.Medium,
					LayoutOrder = 1
				})
			else
				searchImage = Roact.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Image = Images["icons/common/search_small"],
					Size = UDim2.fromOffset(18, 18)
				})
			end

			v3.SearchImage = searchImage

			local createElement4 = Roact.createElement
			local v4 = {
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -28, 0, 20)
			}
			local font

			if not FoundationFontFaceMigration then
				font = body2.Font
			end

			v4.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(data2.Tokens.Typography.BodyLarge.Font)
			end

			v4.FontFace = fontFace

			v4.Text = data.props.text or ""
			v4.TextInputType = textInputType
			v4.TextSize = textSize2
			v4.TextColor3 = data2.Theme.TextEmphasis.Color
			v4.TextXAlignment = Enum.TextXAlignment.Left
			v4.PlaceholderText = p.search
			v4.PlaceholderColor3 = data2.Theme.TextDefault.Color
			v4.ClearTextOnFocus = false
			v4.ClipsDescendants = true
			v4[Roact.Change.Text] = data.searchTextChanged
			v4[Roact.Event.Focused] = data.searchBoxFocused
			v4[Roact.Event.FocusLost] = data.onFocusLost
			v4[Roact.Ref] = data.textboxRef
			v4[Roact.Event.TouchTap] = data.onTextboxTouchTap
			v3.SearchInput = createElement4("TextBox", v4)
			v.SearchContainer = createElement3("Frame", v2, v3)
			children.SearchBorder = createElement2("Frame", onAbsoluteSizeChangedsByAbsoluteSize, v)

			local createElement5 = Roact.createElement
			local searchCancelsByActivated = {
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				["LayoutOrder"] = nil,
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(57, 20)
			}
			local font2

			if not FoundationFontFaceMigration then
				font2 = body.Font
			end

			searchCancelsByActivated.Font = font2
			local fontFace2

			if FoundationFontFaceMigration then
				fontFace2 = normalizeFontFace(data2.Tokens.Typography.BodyLarge.Font)
			end

			searchCancelsByActivated.FontFace = fontFace2

			searchCancelsByActivated.TextSize = textSize
			searchCancelsByActivated.Text = p.cancel
			searchCancelsByActivated.TextColor3 = data2.Theme.TextEmphasis.Color
			searchCancelsByActivated[Roact.Event.Activated] = data.searchCancel
			children.CancelButton = createElement5("TextButton", searchCancelsByActivated)
			return createElement("CanvasGroup", forwardRefsByRef, children)
		end)
	end)
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
