local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local MenuDirection = UIBlox.App.Menu.MenuDirection
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local AuthStatefulRoundCornerBorder = require(CorePackages.Workspace.Packages.AuthCommon).Components.AuthStatefulRoundCornerBorder

local function MonthDropdown(t1: {[any]: any}) -- line: 33
	-- upvalues: useStyle (copy), useLocalization (copy), React (copy), ContextualMenu (copy), Dash (copy), MenuDirection (copy), AuthStatefulRoundCornerBorder (copy), ImageSetButton (copy), ImageSetLabel (copy), Images (copy)
	local v15 = useStyle()
	local v16 = useLocalization({
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
	local t2 = {
		{
			key = 1,
			text = v16.January
		},
		{
			key = 2,
			text = v16.February
		},
		{
			key = 3,
			text = v16.March
		},
		{
			key = 4,
			text = v16.April
		},
		{
			key = 5,
			text = v16.May
		},
		{
			key = 6,
			text = v16.June
		},
		{
			key = 7,
			text = v16.July
		},
		{
			key = 8,
			text = v16.August
		},
		{
			key = 9,
			text = v16.September
		},
		{
			key = 10,
			text = v16.October
		},
		{
			key = 11,
			text = v16.November
		},
		{
			key = 12,
			text = v16.December
		}
	}
	local v18, v19 = React.useState(0)
	local v20, v21 = React.useState(false)

	local function toggleDropdown() -- line: 70
		-- upvalues: v21 (copy), v20 (copy)
		v21(not v20)
	end
	local function monthSelectionElement(s1: string, n1: number) -- line: 74
		-- upvalues: v19 (copy), t1 (copy), v21 (copy), v18 (copy)
		local function onMonthSelected() -- line: 75
			-- upvalues: v19 (copy), n1 (copy), t1 (copy), v21 (copy)
			v19(n1)
			t1.onMonthSelected(n1)
			v21(false)
		end

		return {
			text = s1,
			onActivated = onMonthSelected,
			selected = n1 == v18
		}
	end
	local function dropdownMenuList() -- line: 88
		-- upvalues: React (copy), t1 (copy), ContextualMenu (copy), Dash (copy), t2 (copy), v19 (copy), v21 (copy), v18 (copy), v20 (copy), MenuDirection (copy), toggleDropdown (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.new(1.25, 0, 0, 0),
			AnchorPoint = if not t1.shouldExpandRight then Vector2.new(1, 0) else Vector2.new(0, 0),
			Position = if not t1.shouldExpandRight then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			MonthMenu = React.createElement(ContextualMenu, {
				buttonProps = Dash.map(t2, function(p1) -- line: 98
					-- upvalues: v19 (copy), t1 (copy), v21 (copy), v18 (copy)
					local text = p1.text
					local key = p1.key

					local function onMonthSelected() -- line: 75
						-- upvalues: v19 (copy), key (copy), t1 (copy), v21 (copy)
						v19(key)
						t1.onMonthSelected(key)
						v21(false)
					end

					return {
						text = text,
						onActivated = onMonthSelected,
						selected = key == v18
					}
				end),
				open = v20,
				menuDirection = MenuDirection.Down,
				screenSize = t1.screenSize,
				openPositionY = UDim.new(0, t1.textInputHeight * -1),
				contextMenuWidthOverride = UDim.new(1, 0),
				onDismiss = toggleDropdown
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = t1.size,
		LayoutOrder = t1.layoutOrder
	}, {
		Button = React.createElement(AuthStatefulRoundCornerBorder, {
			layoutOrder = 1,
			size = UDim2.new(1, 0, 0, t1.textInputHeight),
			borderState = AuthStatefulRoundCornerBorder.BorderState.Default
		}, {
			Base = React.createElement(ImageSetButton, {
				Size = UDim2.new(1, 0, 1, 0),
				Image = "LuaApp/buttons/buttonFill",
				BackgroundColor3 = v15.Theme.BackgroundUIContrast.Color,
				BackgroundTransparency = v15.Theme.BackgroundUIContrast.Transparency,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				[React.Event.Activated] = toggleDropdown
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 12)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 0),
					PaddingBottom = UDim.new(0, 0),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				TextLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -16, 1, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Text = if not (v18 > 0) then v16.Month else t2[v18].text,
					Font = v15.Font.Body.Font,
					TextSize = v15.Font.BaseSize * v15.Font.Body.RelativeSize,
					TextColor3 = if not v18 then v15.Theme.UIDefault.Color else v15.Theme.TextDefault.Color,
					TextTransparency = v15.Theme.TextDefault.Transparency
				}),
				ImageLabel = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(1, 0, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Image = v20 and Images["truncate_arrows/actions_truncationCollapse"] or Images["truncate_arrows/actions_truncationExpand"],
					ImageColor3 = v15.Theme.UIDefault.Color,
					ImageTransparency = v15.Theme.UIDefault.Transparency
				})
			})
		}),
		DropdownMenu = v20 and dropdownMenuList()
	})
end

return MonthDropdown
