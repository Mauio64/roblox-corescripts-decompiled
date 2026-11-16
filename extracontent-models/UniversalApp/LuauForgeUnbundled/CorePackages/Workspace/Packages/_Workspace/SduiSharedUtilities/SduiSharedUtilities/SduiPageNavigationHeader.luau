local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Foundation")
local useTokens = Foundation.Hooks.useTokens
local iconButton = Foundation.IconButton
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/BuilderIcons")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")
local getDisplayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Display").GetDisplayStore
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppHeaderBar")

local navButtonType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes").NavButtonType

local useScrollAwayHeaderPosition = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/useScrollAwayHeaderPosition")

local function calculateSize(p2)
	local displayStore = getDisplayStore(p2)
	local guiInset = displayStore.getGuiInset(p2)
	return UDim2.new(1, 0, 0, displayStore.getTopBarHeight(p2) - guiInset.top or 0)
end

local function SduiPageNavigationHeader(props)
	local closeCallback = props.closeCallback

	local v5 = useTokens()
	local v6 = usePreferredInput() == Responsive.Input.Directional
	local v7 = SignalsReact.useSignalBinding(calculateSize)

	local v8 = React.useMemo(function()
		if
			v6
			or not closeCallback
			or props.navButtonType ~= navButtonType.back and props.navButtonType ~= navButtonType.close
		then
			return nil
		end

		return function()
			local createElement = React.createElement
			local v10 = {
				Size = UDim2.new(0, v5.Size.Size_1400, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}

			local v11 = {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, -v5.Size.Size_250)
				}),
				IconButton = 0
			}

			local createElement2 = React.createElement
			local v13 = {
				SelectionOrder = 10,
				onActivated = closeCallback,
				isCircular = true,
				size = Foundation.Enums.InputSize.Large,
				icon = 0
			}

			local v15 = if props.navButtonType == navButtonType.close then BuilderIcons.Icon.X else BuilderIcons.Icon.ChevronLargeLeft
			v13.icon = { name = v15, variant = Foundation.Enums.IconVariant.Regular }
			v11.IconButton = createElement2(iconButton, v13)
			return createElement("Frame", v10, v11)
		end
	end, { v6, props.navButtonType, closeCallback })

	local v9 = {
		AppHeaderBarLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		AppHeaderBar = React.createElement(module6.AppHeaderBar, {
			renderNavigation = v8,
			title = props.title,
			renderUtilities = props.renderUtilities,
			automaticHeight = true,
			paddingLeft = UDim.new(0, 0),
			paddingRight = UDim.new(0, 0),
			isTitleCentered = props.navButtonType ~= navButtonType.back,
			shouldRenderTitle = true,
			onMedia = false
		})
	}

	local v11 = { enabled = props.scrollAwayHeader, scrollAwayHeight = 0 }

	local v12 = if props.scrollAwayHeader then v7:getValue().Y.Offset else nil
	v11.scrollAwayHeight = v12
	local v13 = useScrollAwayHeaderPosition(v11)

	local createElement = React.createElement
	local contentTagsByTag = {
		[React.Tag] = props.contentTag,
		Size = v7,
		LayoutOrder = props.layoutOrder or -1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v15 = if v8 then Enum.AutomaticSize.Y else nil
	contentTagsByTag.AutomaticSize = v15
	contentTagsByTag.ZIndex = 2
	contentTagsByTag.ClipsDescendants = false

	local createElement2 = React.createElement
	local v18 = {
		BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
		Size = v7,
		Position = v13,
		BorderSizePixel = 0,
		AutomaticSize = 0
	}

	local v19 = if v8 then Enum.AutomaticSize.Y else nil
	v18.AutomaticSize = v19
	return createElement("Frame", contentTagsByTag, {
		Content = createElement2("Frame", v18, v9)
	})
end

return React.memo(SduiPageNavigationHeader)
