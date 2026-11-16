local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconButton = Foundation.IconButton
local BuilderIcons = require(parent.BuilderIcons)
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local SignalsReact = require(parent.SignalsReact)
local Display = require(parent.Display)
local GetDisplayStore = Display.GetDisplayStore
local AppHeaderBar = require(parent.AppHeaderBar)

local SduiIntegrationTypes = require(SduiSharedUtilities.SduiIntegrationTypes)
local NavButtonType = SduiIntegrationTypes.NavButtonType

local useScrollAwayHeaderPosition = require(SduiSharedUtilities.useScrollAwayHeaderPosition)

local function calculateSize(p)
	local displayStore = GetDisplayStore(p)
	local guiInset = displayStore.getGuiInset(p)
	return UDim2.new(1, 0, 0, displayStore.getTopBarHeight(p) - guiInset.top or 0)
end

local function SduiPageNavigationHeader(props)
	local closeCallback = props.closeCallback

	local v = useTokens()
	local v2 = usePreferredInput() == Responsive.Input.Directional
	local size = SignalsReact.useSignalBinding(calculateSize)

	local renderNavigation = React.useMemo(function()
		if
			v2
			or not closeCallback
			or props.navButtonType ~= NavButtonType.back and props.navButtonType ~= NavButtonType.close
		then
			return nil
		end

		return function()
			local createElement = React.createElement
			local v3 = {
				Size = UDim2.new(0, v.Size.Size_1400, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}

			local v4 = {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, -v.Size.Size_250)
				}),
				IconButton = 0
			}

			local createElement2 = React.createElement
			local v5 = {
				SelectionOrder = 10,
				onActivated = closeCallback,
				isCircular = true,
				size = Foundation.Enums.InputSize.Large,
				icon = 0
			}
			local name

			if props.navButtonType == NavButtonType.close then
				name = BuilderIcons.Icon.X
			else
				name = BuilderIcons.Icon.ChevronLargeLeft
			end

			v5.icon = { name = name, variant = Foundation.Enums.IconVariant.Regular }
			v4.IconButton = createElement2(IconButton, v5)
			return createElement("Frame", v3, v4)
		end
	end, { v2, props.navButtonType, closeCallback })

	local v3 = {
		AppHeaderBarLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		AppHeaderBar = React.createElement(AppHeaderBar.AppHeaderBar, {
			renderNavigation = renderNavigation,
			title = props.title,
			renderUtilities = props.renderUtilities,
			automaticHeight = true,
			paddingLeft = UDim.new(0, 0),
			paddingRight = UDim.new(0, 0),
			isTitleCentered = props.navButtonType ~= NavButtonType.back,
			shouldRenderTitle = true,
			onMedia = false
		})
	}

	local v4 = { enabled = props.scrollAwayHeader, scrollAwayHeight = 0 }
	local scrollAwayHeight

	if props.scrollAwayHeader then
		scrollAwayHeight = size:getValue().Y.Offset
	end

	v4.scrollAwayHeight = scrollAwayHeight
	local position = useScrollAwayHeaderPosition(v4)

	local createElement = React.createElement
	local contentTagsByTag = {
		[React.Tag] = props.contentTag,
		Size = size,
		LayoutOrder = props.layoutOrder or -1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local automaticSize

	if renderNavigation then
		automaticSize = Enum.AutomaticSize.Y
	end

	contentTagsByTag.AutomaticSize = automaticSize
	contentTagsByTag.ZIndex = 2
	contentTagsByTag.ClipsDescendants = false

	local createElement2 = React.createElement
	local v5 = {
		BackgroundColor3 = v.Color.Surface.Surface_0.Color3,
		Size = size,
		Position = position,
		BorderSizePixel = 0,
		AutomaticSize = 0
	}
	local automaticSize2

	if renderNavigation then
		automaticSize2 = Enum.AutomaticSize.Y
	end

	v5.AutomaticSize = automaticSize2
	return createElement("Frame", contentTagsByTag, {
		Content = createElement2("Frame", v5, v3)
	})
end

return React.memo(SduiPageNavigationHeader)
