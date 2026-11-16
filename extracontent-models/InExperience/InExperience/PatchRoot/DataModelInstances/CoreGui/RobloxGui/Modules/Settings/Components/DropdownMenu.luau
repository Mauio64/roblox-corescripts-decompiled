local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local BaseMenu = UIBlox.App.Menu.BaseMenu

local iconsactionstruncationExpand_small = Images["icons/actions/truncationExpand_small"]

local wrapped = ArgCheck.wrap(t.strictInterface({
	buttonSize = t.UDim2,
	dropdownList = t.table,
	selectedIndex = t.number,
	onSelection = t.callback,
	layoutOrder = t.number
}))

local function DropdownMenu(props)
	assert(wrapped(props))

	local v = useStyle()
	local captionHeader = v.Font.CaptionHeader
	local textSize = captionHeader.RelativeSize * v.Font.BaseSize
	local v2

	if v.UIBloxThemeEnabled then
		v2 = v.color("ControlInputBackground")
	else
		v2 = Color3.fromRGB(79, 84, 95)
	end

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState({})

	local v3 = React.useCallback(function()
		setState(not state)
	end)

	React.useEffect(function()
		local v4 = {}

		for k, dropdown in pairs(props.dropdownList) do
			v4[k] = {
				text = dropdown,
				fontStyle = { Font = captionHeader.Font, RelativeSize = captionHeader.RelativeSize },
				onActivated = function()
					props.onSelection(k)
					setState(false)
				end,
				leftPaddingOffset = -12,
				selected = k == props.selectedIndex,
				selectedIconPaddingRight = 12
			}
		end

		setState2(v4)
	end, { props.dropdownList, props.selectedIndex })

	local createElement = Roact.createElement
	local v4 = {
		Size = props.buttonSize,
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 3
	}

	local createElement2 = Roact.createElement
	local v5 = {}
	v5.Size = UDim2.new(1, 0, 1, 0)
	v5.Text = props.dropdownList[props.selectedIndex]
	v5.TextColor3 = Color3.new(1, 1, 1)
	v5.TextSize = textSize
	local font

	if not FoundationFontFaceMigration then
		font = captionHeader.Font
	end

	v5.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.CaptionLarge.Font)
	end

	v5.FontFace = fontFace

	v5.TextXAlignment = Enum.TextXAlignment.Left
	v5.BackgroundColor3 = v2
	v5.BackgroundTransparency = 0
	v5.LayoutOrder = props.layoutOrder
	v5[Roact.Event.Activated] = v3
	return createElement("Frame", v4, {
		SpawnButton = createElement2("TextButton", v5, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
			UIPadding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, 12) }),
			UIStroke = Roact.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.new(1, 1, 1),
				Thickness = 1,
				Transparency = 0.8
			}),
			Arrow = Roact.createElement(ImageSetLabel, {
				Image = iconsactionstruncationExpand_small,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(1, -28, 0.5, -8)
			})
		}),
		Dropdown = state and Roact.createElement(BaseMenu, {
			buttonProps = state2,
			position = UDim2.new(0, 0, 1, 6),
			layoutOrder = 2,
			elementHeight = 40,
			background = { Color = v2 },
			showDropShadow = true
		})
	})
end

return DropdownMenu
