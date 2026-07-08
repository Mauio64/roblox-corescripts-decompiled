local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SocialLibraries = require(AppChat.SocialLibraries)
local Roact = require(AppChatParent.Roact)
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local UIBlox = require(AppChatParent.UIBlox)
local Foundation = require(AppChatParent.Foundation)
local Text = require(AppChatParent.AppCommonLib).Text
local memoize = require(AppChatParent.AppCommonLib).memoize
local TextButton = UIBlox.App.Button.TextButton
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local CallbackInputBox = SocialLibraries.Components.CallbackInputBox
local v23 = Images["icons/common/search"]
local v24 = Images["icons/actions/edit/clear_small"]
local t1 = {
	Image = Images["squircles/fill"],
	SliceCenter = Rect.new(8, 8, 9, 9)
}
local v26 = Roact.PureComponent:extend("SearchTopBar")

v26.defaultProps = {
	cancelText = "CancelPlaceholder",
	searchPlaceholderText = "PlaceholderText",
	initialInputText = nil,
	filterBoxPaddingTop = 6,
	filterBoxPaddingBottom = 6,
	filterBoxPaddingLeft = 0,
	filterBoxPaddingRight = 0,
	captureFocusOnMount = false,
	cancelCallback = nil,
	shouldShowCancel = true,
	textChangedCallback = nil,
	LayoutOrder = 1,
	containerRef = nil,
	inputBoxRef = nil,
	focusNavigationEventHandlerRef = nil,
	resetOnMount = function() -- line: 54
	end,
	onSelectCallback = function() -- line: 59
	end
}

function v26.init(p1) -- line: 66
	-- upvalues: Roact (copy), memoize (copy), Text (copy)
	p1.focusNavigationService = p1.props.focusNavigationService
	p1.inputBoxRef = p1.props.inputBoxRef or Roact.createRef()
	p1.containerRef = p1.props.containerRef or Roact.createRef()
	p1.props.onSelectCallback()

	function p1.focusInputBox() -- line: 72
		-- upvalues: p1 (copy)
		if p1.inputBoxRef and p1.inputBoxRef.current then
			p1.inputBoxRef.current:CaptureFocus()
		end
	end

	p1.getTextWidth = memoize(function(p2, p3, p4) -- line: 78
		-- upvalues: Text (copy)
		return Text.GetTextWidth(p2, p3, p4)
	end)
end
function v26.didMount(p5) -- line: 83
	if p5.props.captureFocusOnMount and (p5.containerRef.current and p5.focusNavigationService and p5.focusNavigationService.focusedGuiObject:getValue() ~= nil) then
		p5.focusNavigationService:focusGuiObject(p5.containerRef.current)
	end

	if p5.inputBoxRef.current then
		p5.inputBoxRef.current.Selectable = false
	end

	p5.props.resetOnMount()
end
function v26.willUnmount(p6) -- line: 98
	if p6.focusNavigationService then
		p6.focusNavigationService:teardown()
	end
end
function v26.render(p7) -- line: 104
	-- upvalues: UIBlox (copy), Roact (copy), TextButton (copy), withSelectionCursorProvider (copy), Foundation (copy), CursorKind (copy), ImageSetLabel (copy), t1 (copy), IconSize (copy), v23 (copy), CallbackInputBox (copy), v24 (copy)
	local function v31(p8) -- line: 105
		-- upvalues: p7 (copy)
		if (not p8 or not (#p8 > 0)) and (p7.focusNavigationService and p7.inputBoxRef.current) then
			if p7.focusNavigationService.focusedGuiObject:getValue() ~= nil then
				p7.focusNavigationService:focusGuiObject(p7.containerRef.current)
				p7.focusInputBox()
			else
				p7.focusNavigationService:focusGuiObject(p7.inputBoxRef.current)
			end
		end

		if p7.props.textChangedCallback then
			p7.props.textChangedCallback(p8)
		end
	end

	return UIBlox.Style.withStyle(function(p9) -- line: 122
		-- upvalues: p7 (copy), Roact (copy), TextButton (copy), withSelectionCursorProvider (copy), Foundation (copy), CursorKind (copy), ImageSetLabel (copy), t1 (copy), IconSize (copy), v23 (copy), CallbackInputBox (copy), v24 (copy), v31 (copy)
		local cancelText = p7.props.cancelText
		local Header2 = p9.Font.Header2
		local v45 = p9.Font.BaseSize * Header2.RelativeSize
		local v46 = p7.getTextWidth(cancelText, Header2.Font, v45)
		local Left = Enum.HorizontalAlignment.Left
		local uDim = UDim.new(0, 4)
		local uDim2 = UDim2.new(1, 0, 1, 0)

		if p7.props.shouldShowCancel then
			uDim2 = UDim2.new(1, -v46 - 12, 1, 0)
		end

		local Body = p9.Font.Body
		local v51 = p9.Font.BaseSize * Body.RelativeSize

		return Roact.createElement("Frame", {
			BackgroundTransparency = p9.Tokens.Color.None.Transparency,
			BackgroundColor3 = p9.Theme.BackgroundDefault.Color,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = p7.props.LayoutOrder,
			[Roact.Ref] = p7.props.focusNavigationEventHandlerRef
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = uDim
			}),
			padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, p7.props.filterBoxPaddingTop),
				PaddingBottom = UDim.new(0, p7.props.filterBoxPaddingBottom),
				PaddingLeft = UDim.new(0, p7.props.filterBoxPaddingLeft),
				PaddingRight = UDim.new(0, p7.props.filterBoxPaddingRight)
			}),
			cancel = if not p7.props.shouldShowCancel then nil else Roact.createElement(TextButton, {
				layoutOrder = 2,
				text = cancelText,
				onActivated = p7.props.cancelCallback
			}),
			filterBoxContainer = withSelectionCursorProvider(function(p10) -- line: 174
				-- upvalues: Roact (copy), Foundation (copy), uDim2 (ref), CursorKind (copy), p7 (copy), ImageSetLabel (copy), t1 (copy), p9 (copy), IconSize (copy), v23 (copy), CallbackInputBox (copy), Body (copy), v51 (copy), v24 (copy), v31 (copy)
				return Roact.createElement(Foundation.View, {
					LayoutOrder = 1,
					Size = uDim2,
					selection = {
						Selectable = true,
						SelectionImageObject = p10(CursorKind.RoundedRect)
					},
					onActivated = p7.focusInputBox,
					ref = p7.containerRef
				}, {
					filterBoxBackground = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Selectable = false,
						Size = UDim2.fromScale(1, 1),
						Image = t1.Image,
						ImageColor3 = p9.Theme.UIDefault.Color,
						ImageTransparency = p9.Theme.UIDefault.Transparency,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = t1.SliceCenter
					}, {
						layout = Roact.createElement("UIListLayout", {
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 4)
						}),
						padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 12),
							PaddingRight = UDim.new(0, 12)
						}),
						filterBoxIcon = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
							Image = v23,
							ImageColor3 = p9.Theme.IconEmphasis.Color,
							ImageTransparency = p9.Theme.IconEmphasis.Transparency
						}),
						filterBoxContainer = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Size = UDim2.new(1, -(IconSize.Small + 4), 1, 0)
						}, {
							filterBox = Roact.createElement(CallbackInputBox, {
								clearButtonDisabled = false,
								initialInputText = p7.props.initialInputText,
								inputTextColor3 = p9.Theme.TextEmphasis.Color,
								inputTextFont = Body.Font,
								inputTextSize = v51,
								inputTextTransparency = p9.Theme.TextEmphasis.Transparency,
								inputTextXAlignment = Enum.TextXAlignment.Left,
								placeholderText = p7.props.searchPlaceholderText,
								placeholderTextColor3 = p9.Theme.TextDefault.Color,
								placeholderTextTransparency = p9.Theme.TextDefault.Transparency,
								captureFocusOnMount = p7.props.captureFocusOnMount,
								clearIcon = v24,
								clearIconColor3 = p9.Theme.IconEmphasis.Color,
								clearIconTransparency = p9.Theme.IconEmphasis.Transparency,
								clearButtonSize = IconSize.Small,
								textChangedCallback = v31,
								onSelectCallback = p7.props.onSelectCallback,
								inputBoxRef = p7.inputBoxRef,
								clearButtonSelectionImageObject = p10(CursorKind.RoundedRect)
							})
						})
					})
				})
			end)
		})
	end)
end
function FocusableSearchTopBar(p11) -- line: 260
	-- upvalues: React (copy), FocusNavigationService (copy), CoreGui (copy), ReactFocusNavigation (copy), FocusNavigationEventNameEnum (copy), Roact (copy), v26 (copy), Cryo (copy)
	local v33 = React.useRef(nil)
	local v34 = React.useRef(nil)
	local v35 = FocusNavigationService.new(CoreGui)
	local cancelCallback = p11.cancelCallback
	local v37 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, function(p12) -- line: 268
		-- upvalues: v35 (copy), v33 (copy), cancelCallback (copy)
		if p12.eventData and (v35.focusedGuiObject:getValue() == v33.current and p12.eventData.KeyCode ~= Enum.KeyCode.Unknown) then
			p12:cancel()

			if cancelCallback then
				cancelCallback()
			end
		end
	end, "Bubble", nil)

	return Roact.createElement(v26, Cryo.Dictionary.join({
		inputBoxRef = v34,
		containerRef = v33,
		focusNavigationEventHandlerRef = v37,
		focusNavigationService = v35
	}, p11))
end

return FocusableSearchTopBar
