local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local BaseMenu = UIBlox.App.Menu.BaseMenu
local v11 = Images["icons/actions/truncationExpand_small"]
local v12 = ArgCheck.wrap(t.strictInterface({
	buttonSize = t.UDim2,
	dropdownList = t.table,
	selectedIndex = t.number,
	onSelection = t.callback,
	layoutOrder = t.number
}))

local function DropdownMenu(t1: {[any]: any}) -- line: 45
	-- upvalues: v12 (copy), useStyle (copy), React (copy), Roact (copy), ImageSetLabel (copy), v11 (copy), BaseMenu (copy)
	assert(v12(t1))

	local v15 = useStyle()
	local CaptionHeader = v15.Font.CaptionHeader
	local v17 = CaptionHeader.RelativeSize * v15.Font.BaseSize
	local v18 = if not v15.UIBloxThemeEnabled then Color3.fromRGB(79, 84, 95) else v15.color("ControlInputBackground")
	local v19, v20 = React.useState(false)
	local v21, v22 = React.useState({})
	local v23 = React.useCallback(function() -- line: 58
		-- upvalues: v20 (copy), v19 (copy)
		v20(not v19)
	end)

	React.useEffect(function() -- line: 62
		-- upvalues: t1 (copy), CaptionHeader (copy), v20 (copy), v22 (copy)
		local t2 = {}

		for k, v in pairs(t1.dropdownList) do
			t2[k] = {
				leftPaddingOffset = -12,
				selectedIconPaddingRight = 12,
				text = v,
				fontStyle = {
					Font = CaptionHeader.Font,
					RelativeSize = CaptionHeader.RelativeSize
				},
				onActivated = function() -- line: 71
					-- upvalues: t1 (copy), k (copy), v20 (copy)
					t1.onSelection(k)
					v20(false)
				end,
				selected = k == t1.selectedIndex
			}
		end

		v22(t2)
	end, {
		t1.dropdownList,
		t1.selectedIndex
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 3,
		Size = t1.buttonSize,
		LayoutOrder = t1.layoutOrder
	}, {
		SpawnButton = Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Text = t1.dropdownList[t1.selectedIndex],
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = v17,
			Font = CaptionHeader.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = v18,
			BackgroundTransparency = 0,
			LayoutOrder = t1.layoutOrder,
			[Roact.Event.Activated] = v23
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 4)
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 12)
			}),
			UIStroke = Roact.createElement("UIStroke", {
				Thickness = 1,
				Transparency = 0.8,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.new(1, 1, 1)
			}),
			Arrow = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = v11,
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(1, -28, 0.5, -8)
			})
		}),
		Dropdown = v19 and Roact.createElement(BaseMenu, {
			layoutOrder = 2,
			elementHeight = 40,
			showDropShadow = true,
			buttonProps = v21,
			position = UDim2.new(0, 0, 1, 6),
			background = {
				Color = v18
			}
		})
	})
end

return DropdownMenu
