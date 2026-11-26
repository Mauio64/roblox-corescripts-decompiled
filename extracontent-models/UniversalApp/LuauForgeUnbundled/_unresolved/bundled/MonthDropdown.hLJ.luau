local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local menuDirection = UIBlox.App.Menu.MenuDirection
local contextualMenu = UIBlox.App.Menu.ContextualMenu
local authStatefulRoundCornerBorder = require("@game/CorePackages/Workspace/Packages/AuthCommon").Components.AuthStatefulRoundCornerBorder

local function MonthDropdown(props)
	local v5 = useStyle()

	local v6 = useLocalization({
		January = "CommonUI.Controls.Label.January",
		February = "CommonUI.Controls.Label.February",
		March = "CommonUI.Controls.Label.March",
		April = "CommonUI.Controls.Label.April",
		May = "CommonUI.Controls.Label.May",
		June = "CommonUI.Controls.Label.June",
		July = "CommonUI.Controls.Label.July",
		August = "CommonUI.Controls.Label.August",
		September = "CommonUI.Controls.Label.September",
		October = "CommonUI.Controls.Label.October",
		November = "CommonUI.Controls.Label.November",
		December = "CommonUI.Controls.Label.December",
		Month = "Authentication.SignUp.Label.Month"
	})

	local v7 = {
		{ text = v6.January, key = 1 },
		{ text = v6.February, key = 2 },
		{ text = v6.March, key = 3 },
		{ text = v6.April, key = 4 },
		{ text = v6.May, key = 5 },
		{ text = v6.June, key = 6 },
		{ text = v6.July, key = 7 },
		{ text = v6.August, key = 8 },
		{ text = v6.September, key = 9 },
		{ text = v6.October, key = 10 },
		{ text = v6.November, key = 11 },
		{ text = v6.December, key = 12 }
	}

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(false)

	local function toggleDropdown()
		setState2(not state2)
	end

	local function monthSelectionElement(p2, p3)
		local function onMonthSelected()
			setState(p3)
			props.onMonthSelected(p3)
			setState2(false)
		end
		return {
			text = p2,
			onActivated = onMonthSelected,
			selected = state == p3
		}
	end

	local function dropdownMenuList()
		local createElement = React.createElement
		local v9 = {
			Size = UDim2.new(1.25, 0, 0, 0),
			AnchorPoint = 0,
			Position = 0,
			AutomaticSize = 0,
			BackgroundTransparency = 1,
			ZIndex = 2
		}
		local v10 = if props.shouldExpandRight then Vector2.new(0, 0) else Vector2.new(1, 0)
		v9.AnchorPoint = v10
		local v11 = if props.shouldExpandRight then UDim2.new(0, 0, 0, 0) else UDim2.new(1, 0, 0, 0)
		v9.Position = v11
		v9.AutomaticSize = Enum.AutomaticSize.Y
		return createElement("Frame", v9, {
			MonthMenu = React.createElement(contextualMenu, {
				buttonProps = Dash.map(v7, function(p2)
					local text = p2.text
					local key = p2.key

					local function onMonthSelected()
						setState(key)
						props.onMonthSelected(key)
						setState2(false)
					end
					return {
						text = text,
						onActivated = onMonthSelected,
						selected = state == key
					}
				end),
				open = state2,
				menuDirection = menuDirection.Down,
				screenSize = props.screenSize,
				openPositionY = UDim.new(0, -1 * props.textInputHeight),
				contextMenuWidthOverride = UDim.new(1, 0),
				onDismiss = toggleDropdown
			})
		})
	end

	local createElement = React.createElement
	local v9 = {
		Size = props.size,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = 2
	}

	local createElement2 = React.createElement
	local v12 = {
		layoutOrder = 1,
		size = UDim2.new(1, 0, 0, props.textInputHeight),
		borderState = authStatefulRoundCornerBorder.BorderState.Default
	}

	local createElement3 = React.createElement
	local toggleDropdownsByActivated = {
		Size = UDim2.new(1, 0, 1, 0),
		Image = "LuaApp/buttons/buttonFill",
		BackgroundColor3 = v5.Theme.BackgroundUIContrast.Color,
		BackgroundTransparency = v5.Theme.BackgroundUIContrast.Transparency,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9),
		[React.Event.Activated] = toggleDropdown
	}
	local children = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 12) }),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		}),
		TextLabel = 0,
		ImageLabel = 0
	}

	local createElement4 = React.createElement
	local v16 = {
		Size = UDim2.new(1, -16, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundTransparency = 1,
		Text = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0
	}

	local v17 = if state > 0 then v7[state].text else v6.Month
	v16.Text = v17
	v16.FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font)
	v16.TextSize = v5.Font.BaseSize * v5.Font.Body.RelativeSize
	local v18 = if state then v5.Theme.TextDefault.Color else v5.Theme.UIDefault.Color
	v16.TextColor3 = v18
	v16.TextTransparency = v5.Theme.TextDefault.Transparency
	children.TextLabel = createElement4("TextLabel", v16)

	children.ImageLabel = React.createElement(imageSetLabel, {
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(1, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Image = state2 and images["truncate_arrows/actions_truncationCollapse"] or images["truncate_arrows/actions_truncationExpand"],
		ImageColor3 = v5.Theme.UIDefault.Color,
		ImageTransparency = v5.Theme.UIDefault.Transparency
	})
	return createElement("Frame", v9, {
		Button = createElement2(authStatefulRoundCornerBorder, v12, {
			Base = createElement3(imageSetButton, toggleDropdownsByActivated, children)
		}),
		DropdownMenu = state2 and dropdownMenuList()
	})
end

return MonthDropdown
