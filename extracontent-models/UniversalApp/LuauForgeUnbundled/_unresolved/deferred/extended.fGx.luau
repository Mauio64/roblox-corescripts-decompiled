local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local t = require(CorePackages.Packages.t)

local extended = Roact.PureComponent:extend("DeviceSettingsPageSetting")
local module = require("@luauforge/deferred/fGy")

local fFlagMacMenuBarContentUpdates = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagMacMenuBarContentUpdates()
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

extended.defaultProps = { topToBottom = false }

local strictInterface = t.strictInterface
local v5 = {
	topToBottom = t.optional(t.boolean),
	style = t.table,
	layoutOrder = t.number,
	header = t.string,
	description = 0,
	Control = 0,
	zIndex = 0
}
local v6 = if fFlagMacMenuBarContentUpdates then t.optional(t.string) else t.string
v5.description = v6
v5.Control = t.table
v5.zIndex = t.optional(t.number)
extended.validateProps = strictInterface(v5)

local function WithHooksComponent(props)
	local style = props.style

	local baseSize = style.Font.BaseSize
	local v7 = baseSize * style.Font.Header2.RelativeSize
	local v8 = baseSize * style.Font.CaptionBody.RelativeSize

	local v9 = useDesignTokens()

	local createElement = Roact.createElement
	local v11 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = props.zIndex
	}

	local v12 = if props.topToBottom then Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}) else nil

	local createElement2 = Roact.createElement
	local v15 = if fFlagMacMenuBarContentUpdates and props.description == nil then UDim2.fromScale(1, 1) else UDim2.fromScale(1, 0)

	local v16 = if fFlagMacMenuBarContentUpdates and props.description == nil then Enum.AutomaticSize.None else Enum.AutomaticSize.Y

	local v17 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, not module and 6 or v9.Size.Size_100)
		}),
		SettingHeaderText = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, v7),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = props.header,
			FontFace = normalizeFontFace(v9.Typography.TitleLarge.Font),
			TextSize = v7,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextColor3 = style.Theme.TextDefault.Color,
			TextTransparency = style.Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1
		}),
		SettingDescriptionText = 0
	}
	local v18

	if not (fFlagMacMenuBarContentUpdates and props.description == nil) then
		local createElement3 = Roact.createElement
		local v21 = if props.topToBottom then UDim2.new(1, 0, 0, 0) else UDim2.fromScale(0.65, 0)
		v18 = createElement3("TextLabel", {
			Size = v21,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = props.description,
			FontFace = normalizeFontFace(v9.Typography.BodySmall.Font),
			TextSize = v8,
			TextColor3 = style.Theme.TextMuted.Color,
			TextTransparency = style.Theme.TextMuted.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			LayoutOrder = 2
		})
	end

	v17.SettingDescriptionText = v18
	local children = {
		Layout = v12,
		SettingInfoFrame = createElement2("Frame", {
			Size = v15,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AutomaticSize = v16,
			LayoutOrder = 1
		}, v17),
		SettingControlFrame = 0
	}

	local createElement3 = Roact.createElement
	local v20 = {
		Size = UDim2.fromScale(1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2
	}

	local createElement4 = Roact.createElement
	local v24 = if props.topToBottom then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Right
	local v21 = {
		Layout = createElement4("UIListLayout", {
			HorizontalAlignment = v24,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = 0,
		Control = 0
	}

	local v25 = if props.topToBottom then Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, not module and 10 or v9.Size.Size_300),
		PaddingBottom = UDim.new(0, not module and 10 or v9.Size.Size_100)
	}) else nil
	v21.UIPadding = v25

	v21.Control = props.Control
	children.SettingControlFrame = createElement3("Frame", v20, v21)
	return createElement("Frame", v11, children)
end

function extended.render(p2)
	return Roact.createElement(WithHooksComponent, p2.props)
end

return extended
