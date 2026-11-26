local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Text
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").memoize

local textButton = UIBlox.App.Button.TextButton
local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.Constant.IconSize
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local focusNavigationService = ReactFocusNavigation.FocusNavigationService
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local coreGui = ReactFocusNavigation.EngineInterface.CoreGui

local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local callbackInputBox = SocialLibraries.Components.CallbackInputBox

local iconscommonsearch = images["icons/common/search"]
local iconsactionseditclear_small = images["icons/actions/edit/clear_small"]

local v5 = { Image = images["squircles/fill"], SliceCenter = Rect.new(8, 8, 9, 9) }

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

	self.getTextWidth = memoize(function(p2, p3, p4)
		return text.GetTextWidth(p2, p3, p4)
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
function extended.willUnmount(p2)
	if p2.focusNavigationService then
		p2.focusNavigationService:teardown()
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
		local v6 = props.Font.BaseSize * header2.RelativeSize
		local textWidth = data.getTextWidth(cancelText, header2.Font, v6)

		local left = Enum.HorizontalAlignment.Left

		local udim = UDim.new(0, 4)

		local udim2 = UDim2.new(1, 0, 1, 0)

		if data.props.shouldShowCancel then
			udim2 = UDim2.new(1, -textWidth - 12, 1, 0)
		end

		local body = props.Font.Body
		local v7 = props.Font.BaseSize * body.RelativeSize

		local createElement = Roact.createElement
		local focusNavigationEventHandlerRefsByRef = {
			BackgroundTransparency = props.Tokens.Color.None.Transparency,
			BackgroundColor3 = props.Theme.BackgroundDefault.Color,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = data.props.LayoutOrder,
			[Roact.Ref] = data.props.focusNavigationEventHandlerRef
		}
		local v9 = {
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

		local v10 = if data.props.shouldShowCancel then Roact.createElement(textButton, {
			text = cancelText,
			layoutOrder = 2,
			onActivated = data.props.cancelCallback
		}) else nil
		v9.cancel = v10

		v9.filterBoxContainer = withSelectionCursorProvider(function(callback)
			return Roact.createElement(Foundation.View, {
				Size = udim2,
				LayoutOrder = 1,
				selection = {
					Selectable = true,
					SelectionImageObject = callback(cursorKind.RoundedRect)
				},
				onActivated = data.focusInputBox,
				ref = data.containerRef
			}, {
				filterBoxBackground = Roact.createElement(imageSetLabel, {
					Size = UDim2.fromScale(1, 1),
					Image = v5.Image,
					ImageColor3 = props.Theme.UIDefault.Color,
					ImageTransparency = props.Theme.UIDefault.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = v5.SliceCenter,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Selectable = false
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
					filterBoxIcon = Roact.createElement(imageSetLabel, {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, iconSize.Small, 0, iconSize.Small),
						Image = iconscommonsearch,
						ImageColor3 = props.Theme.IconEmphasis.Color,
						ImageTransparency = props.Theme.IconEmphasis.Transparency,
						LayoutOrder = 1
					}),
					filterBoxContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -(iconSize.Small + 4), 1, 0),
						LayoutOrder = 2
					}, {
						filterBox = Roact.createElement(callbackInputBox, {
							initialInputText = data.props.initialInputText,
							inputTextColor3 = props.Theme.TextEmphasis.Color,
							inputTextFont = props.Tokens.Typography.BodyLarge.Font,
							inputTextSize = v7,
							inputTextTransparency = props.Theme.TextEmphasis.Transparency,
							inputTextXAlignment = Enum.TextXAlignment.Left,
							placeholderText = data.props.searchPlaceholderText,
							placeholderTextColor3 = props.Theme.TextDefault.Color,
							placeholderTextTransparency = props.Theme.TextDefault.Transparency,
							captureFocusOnMount = data.props.captureFocusOnMount,
							clearIcon = iconsactionseditclear_small,
							clearIconColor3 = props.Theme.IconEmphasis.Color,
							clearIconTransparency = props.Theme.IconEmphasis.Transparency,
							clearButtonSize = iconSize.Small,
							clearButtonDisabled = false,
							textChangedCallback = fn,
							onSelectCallback = data.props.onSelectCallback,
							inputBoxRef = data.inputBoxRef,
							clearButtonSelectionImageObject = callback(cursorKind.RoundedRect)
						})
					})
				})
			})
		end)
		return createElement("Frame", focusNavigationEventHandlerRefsByRef, v9)
	end)
end

function LUAUFORGE_MODULE_GLOBALS_hvu_FocusableSearchTopBar(p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v6 = focusNavigationService.new(coreGui)
	local cancelCallback = p2.cancelCallback

	local v7 = ReactFocusNavigation.useEventHandler(focusNavigationEventNameEnum.NavigateBack, function(object)
		if
			object.eventData
			and v6.focusedGuiObject:getValue() == ref.current
			and object.eventData.KeyCode ~= Enum.KeyCode.None
		then
			object:cancel()

			if cancelCallback then
				cancelCallback()
			end
		end
	end, "Bubble", nil)

	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(
			{
				inputBoxRef = ref2,
				containerRef = ref,
				focusNavigationEventHandlerRef = v7,
				focusNavigationService = v6
			},
			p2
		)
	)
end

return LUAUFORGE_MODULE_GLOBALS_hvu_FocusableSearchTopBar
