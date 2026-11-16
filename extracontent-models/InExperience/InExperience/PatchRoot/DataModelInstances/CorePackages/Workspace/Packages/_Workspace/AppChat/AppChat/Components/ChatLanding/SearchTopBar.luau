local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialLibraries = require(AppChat.SocialLibraries)

local Roact = require(parent.Roact)
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local AppCommonLib2 = require(parent.AppCommonLib)
local memoize = AppCommonLib2.memoize

local TextButton = UIBlox.App.Button.TextButton
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui

local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind

local CallbackInputBox = SocialLibraries.Components.CallbackInputBox

local iconscommonsearch = Images["icons/common/search"]
local iconsactionseditclear_small = Images["icons/actions/edit/clear_small"]

local v = { Image = Images["squircles/fill"], SliceCenter = Rect.new(8, 8, 9, 9) }

local extended = Roact.PureComponent:extend("SearchTopBar")
extended.defaultProps = {
	cancelText = "CancelPlaceholder",
	searchPlaceholderText = "PlaceholderText",
	initialInputText = nil,
	filterBoxPaddingTop = 6,
	filterBoxPaddingBottom = 6,
	filterBoxPaddingLeft = 0,
	filterBoxPaddingRight = 0,
	captureFocusOnMount = false,
	resetOnMount = function() end,
	cancelCallback = nil,
	shouldShowCancel = true,
	textChangedCallback = nil,
	LayoutOrder = 1,
	onSelectCallback = function() end,
	containerRef = nil,
	inputBoxRef = nil,
	focusNavigationEventHandlerRef = nil
}

function extended:init()
	self.focusNavigationService = self.props.focusNavigationService
	self.inputBoxRef = self.props.inputBoxRef or Roact.createRef()
	self.containerRef = self.props.containerRef or Roact.createRef()
	self.props.onSelectCallback()

	function self.focusInputBox()
		if self.inputBoxRef and self.inputBoxRef.current then
			self.inputBoxRef.current:CaptureFocus()
		end
	end

	self.getTextWidth = memoize(function(p, p2, p3)
		return Text.GetTextWidth(p, p2, p3)
	end)
end

function extended.didMount(data)
	if
		data.props.captureFocusOnMount
		and data.containerRef.current
		and data.focusNavigationService
		and data.focusNavigationService.focusedGuiObject:getValue() ~= nil
	then
		data.focusNavigationService:focusGuiObject(data.containerRef.current)
	end

	if data.inputBoxRef.current then
		data.inputBoxRef.current.Selectable = false
	end

	data.props.resetOnMount()
end
function extended.willUnmount(p)
	if p.focusNavigationService then
		p.focusNavigationService:teardown()
	end
end

function extended.render(data)
	local function fn(list)
		if not (list and #list > 0) and data.focusNavigationService and data.inputBoxRef.current then
			if data.focusNavigationService.focusedGuiObject:getValue() == nil then
				data.focusNavigationService:focusGuiObject(data.inputBoxRef.current)
			else
				data.focusNavigationService:focusGuiObject(data.containerRef.current)
				data.focusInputBox()
			end
		end

		if data.props.textChangedCallback then
			data.props.textChangedCallback(list)
		end
	end

	return UIBlox.Style.withStyle(function(props)
		local cancelText = data.props.cancelText

		local header2 = props.Font.Header2
		local v2 = props.Font.BaseSize * header2.RelativeSize
		local textWidth = data.getTextWidth(cancelText, header2.Font, v2)

		local left = Enum.HorizontalAlignment.Left

		local udim = UDim.new(0, 4)

		local udim2 = UDim2.new(1, 0, 1, 0)

		if data.props.shouldShowCancel then
			udim2 = UDim2.new(1, -textWidth - 12, 1, 0)
		end

		local body = props.Font.Body
		local inputTextSize = props.Font.BaseSize * body.RelativeSize

		local createElement = Roact.createElement
		local focusNavigationEventHandlerRefsByRef = {
			BackgroundTransparency = props.Tokens.Color.None.Transparency,
			BackgroundColor3 = props.Theme.BackgroundDefault.Color,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = data.props.LayoutOrder,
			[Roact.Ref] = data.props.focusNavigationEventHandlerRef
		}
		local v3 = {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = udim
			}),
			padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, data.props.filterBoxPaddingTop),
				PaddingBottom = UDim.new(0, data.props.filterBoxPaddingBottom),
				PaddingLeft = UDim.new(0, data.props.filterBoxPaddingLeft),
				PaddingRight = UDim.new(0, data.props.filterBoxPaddingRight)
			}),
			cancel = 0,
			filterBoxContainer = 0
		}
		local cancel

		if data.props.shouldShowCancel then
			cancel = Roact.createElement(TextButton, {
				text = cancelText,
				layoutOrder = 2,
				onActivated = data.props.cancelCallback
			})
		end

		v3.cancel = cancel

		v3.filterBoxContainer = withSelectionCursorProvider(function(callback)
			local createElement2 = Roact.createElement
			local view = Foundation.View
			local v4 = {
				Size = udim2,
				LayoutOrder = 1,
				selection = {
					Selectable = true,
					SelectionImageObject = callback(CursorKind.RoundedRect)
				},
				onActivated = data.focusInputBox,
				ref = data.containerRef
			}

			local createElement3 = Roact.createElement
			local v5 = {
				Size = UDim2.fromScale(1, 1),
				Image = v.Image,
				ImageColor3 = props.Theme.UIDefault.Color,
				ImageTransparency = props.Theme.UIDefault.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = v.SliceCenter,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Selectable = false
			}

			local v6 = {
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
					Size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
					Image = iconscommonsearch,
					ImageColor3 = props.Theme.IconEmphasis.Color,
					ImageTransparency = props.Theme.IconEmphasis.Transparency,
					LayoutOrder = 1
				}),
				filterBoxContainer = 0
			}

			local createElement4 = Roact.createElement
			local v7 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -(IconSize.Small + 4), 1, 0),
				LayoutOrder = 2
			}

			local createElement5 = Roact.createElement
			local v8 = {
				initialInputText = data.props.initialInputText,
				inputTextColor3 = props.Theme.TextEmphasis.Color,
				inputTextFont = 0,
				inputTextSize = 0,
				inputTextTransparency = 0,
				inputTextXAlignment = 0,
				placeholderText = 0,
				placeholderTextColor3 = 0,
				placeholderTextTransparency = 0,
				captureFocusOnMount = 0,
				clearIcon = 0,
				clearIconColor3 = 0,
				clearIconTransparency = 0,
				clearButtonSize = 0,
				clearButtonDisabled = false,
				textChangedCallback = 0,
				onSelectCallback = 0,
				inputBoxRef = 0,
				clearButtonSelectionImageObject = 0
			}
			local inputTextFont

			if FoundationFontFaceMigration then
				inputTextFont = props.Tokens.Typography.BodyLarge.Font
			else
				inputTextFont = body.Font
			end

			v8.inputTextFont = inputTextFont

			v8.inputTextSize = inputTextSize
			v8.inputTextTransparency = props.Theme.TextEmphasis.Transparency
			v8.inputTextXAlignment = Enum.TextXAlignment.Left

			v8.placeholderText = data.props.searchPlaceholderText
			v8.placeholderTextColor3 = props.Theme.TextDefault.Color
			v8.placeholderTextTransparency = props.Theme.TextDefault.Transparency

			v8.captureFocusOnMount = data.props.captureFocusOnMount

			v8.clearIcon = iconsactionseditclear_small
			v8.clearIconColor3 = props.Theme.IconEmphasis.Color
			v8.clearIconTransparency = props.Theme.IconEmphasis.Transparency
			v8.clearButtonSize = IconSize.Small

			v8.textChangedCallback = fn
			v8.onSelectCallback = data.props.onSelectCallback

			v8.inputBoxRef = data.inputBoxRef
			v8.clearButtonSelectionImageObject = callback(CursorKind.RoundedRect)
			v6.filterBoxContainer = createElement4("Frame", v7, {
				filterBox = createElement5(CallbackInputBox, v8)
			})
			return createElement2(view, v4, {
				filterBoxBackground = createElement3(ImageSetLabel, v5, v6)
			})
		end)
		return createElement("Frame", focusNavigationEventHandlerRefsByRef, v3)
	end)
end

function FocusableSearchTopBar(p)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local focusNavigationService = FocusNavigationService.new(CoreGui)
	local cancelCallback = p.cancelCallback

	local focusNavigationEventHandlerRef = ReactFocusNavigation.useEventHandler(
		FocusNavigationEventNameEnum.NavigateBack,
		function(object)
			if
				object.eventData
				and focusNavigationService.focusedGuiObject:getValue() == ref.current
				and object.eventData.KeyCode ~= Enum.KeyCode.None
			then
				object:cancel()

				if cancelCallback then
					cancelCallback()
				end
			end
		end,
		"Bubble",
		nil
	)

	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(
			{
				inputBoxRef = ref2,
				containerRef = ref,
				focusNavigationEventHandlerRef = focusNavigationEventHandlerRef,
				focusNavigationService = focusNavigationService
			},
			p
		)
	)
end

return FocusableSearchTopBar
