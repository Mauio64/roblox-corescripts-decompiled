local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

require("@luauforge/bundled/fzM")

local module = require("@luauforge/deferred/fzG")
local module2 = require("@luauforge/bundled/fzH")

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local iconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText
local useTokens = Foundation.Hooks.useTokens

local udim = UDim.new(0.2237, 0)

local function AppIconCard(props)
	local v5 = useTokens()
	local option = props.option
	local v6 = option.isLocked and 0.5 or 0

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["row align-y-center fill auto-y gap-medium padding-medium stroke-standard radius-medium"] = true,
			["stroke-system-contrast"] = option.isSelected,
			["stroke-emphasis"] = not option.isSelected
		},
		backgroundStyle = props.background,
		onActivated = function()
			props.onSelect(option.key)
		end,
		testId = `AppIconSelector--option-{option.key}`
	}

	local createElement2 = React.createElement
	local v10 = {
		LayoutOrder = 1,
		tag = "size-1400-1400",
		backgroundStyle = { Color3 = option.previewColor, Transparency = v6 },
		testId = `AppIconSelector--icon-{option.key}`
	}
	local v11 = {
		Corner = React.createElement("UICorner", { CornerRadius = udim }),
		Image = 0
	}

	local v12 = if option.image then React.createElement(image, {
		Image = option.image,
		tag = "size-full",
		imageStyle = { Transparency = v6 },
		testId = `AppIconSelector--icon-image-{option.key}`
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = udim })
	}) else nil
	v11.Image = v12
	local children = {
		Icon = createElement2(view, v10, v11),
		Label = React.createElement(text, {
			LayoutOrder = 2,
			Text = option.label,
			tag = "fill auto-y text-title-small text-wrap text-align-x-left",
			textStyle = { Color3 = v5.Color.Content.Emphasis.Color3, Transparency = v6 },
			testId = `AppIconSelector--label-{option.key}`
		}),
		PlusIcon = 0
	}

	local v13 = if option.showPlusIcon then React.createElement(text, {
		LayoutOrder = 3,
		Text = getIconRichText(iconName.RobloxPlus),
		RichText = true,
		tag = "auto-xy content-muted",
		testId = `AppIconSelector--plus-icon-{option.key}`
	}) else nil
	children.PlusIcon = v13
	return createElement(view, v8, children)
end

local function AppIconSelectorView(props)
	local v5 = useTokens()

	local v6 = { Color3 = v5.Color.Surface.Surface_0.Color3, Transparency = 0 }

	local v7 = module
		and React.useContext(module2) ~= nil
		and {
			Color3 = v5.Color.Shift.Shift_200.Color3,
			Transparency = v5.Color.Shift.Shift_200.Transparency
		}
		or v6

	local v8 = math.max(1, props.columns)
	local count = 0
	local children = {}

	for i = 1, #props.options, v8 do
		count += 1
		local v9 = {}

		for j = 1, v8 do
			local option = props.options[i + j - 1]
			local formatted = `Column-{j}`
			local v10 = if option then React.createElement(AppIconCard, {
				option = option,
				background = v7,
				LayoutOrder = j,
				onSelect = props.onSelect
			}) else React.createElement(view, { LayoutOrder = j, tag = "fill auto-y" })
			v9[formatted] = v10
		end

		children[`Row-{count}`] = React.createElement(
			view,
			{
				LayoutOrder = count,
				tag = "row gap-medium size-full-0 auto-y",
				testId = `AppIconSelector--row-{count}`
			},
			v9
		)
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "col gap-medium size-full-0 auto-y",
			testId = "AppIconSelector"
		},
		children
	)
end

return AppIconSelectorView
