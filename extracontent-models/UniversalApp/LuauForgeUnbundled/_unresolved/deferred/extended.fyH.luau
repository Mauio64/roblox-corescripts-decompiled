local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local t = require(CorePackages.Packages.t)

local extended = Roact.PureComponent:extend("DeviceSettingsPageSetting")
local module = require("@luauforge/deferred/fyI")

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

	local font = style.Font.Header2.Font
	local font2 = style.Font.CaptionBody.Font
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
		SettingHeaderText = 0,
		SettingDescriptionText = 0
	}

	local createElement3 = Roact.createElement
	local v19 = {
		Size = UDim2.new(1, 0, 0, v7),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = props.header,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextWrapped = true,
		AutomaticSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextXAlignment = 0,
		LayoutOrder = 1
	}

	if foundationFontFaceMigration then
		font = nil
	end

	v19.Font = font

	local v20 = if foundationFontFaceMigration then normalizeFontFace(v9.Typography.TitleLarge.Font) else nil
	v19.FontFace = v20

	v19.TextSize = v7

	v19.AutomaticSize = Enum.AutomaticSize.Y
	v19.TextColor3 = style.Theme.TextDefault.Color
	v19.TextTransparency = style.Theme.TextDefault.Transparency
	v19.TextXAlignment = Enum.TextXAlignment.Left
	v17.SettingHeaderText = createElement3("TextLabel", v19)
	local v21

	if not (fFlagMacMenuBarContentUpdates and props.description == nil) then
		local createElement4 = Roact.createElement
		local v24 = if props.topToBottom then UDim2.new(1, 0, 0, 0) else UDim2.fromScale(0.65, 0)
		local v23 = {
			Size = v24,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = props.description,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			AutomaticSize = 0,
			TextWrapped = true,
			LayoutOrder = 2
		}

		if foundationFontFaceMigration then
			font2 = nil
		end

		v23.Font = font2

		local v25 = if foundationFontFaceMigration then normalizeFontFace(v9.Typography.BodySmall.Font) else nil
		v23.FontFace = v25

		v23.TextSize = v8
		v23.TextColor3 = style.Theme.TextMuted.Color
		v23.TextTransparency = style.Theme.TextMuted.Transparency
		v23.TextXAlignment = Enum.TextXAlignment.Left
		v23.AutomaticSize = Enum.AutomaticSize.Y
		v21 = createElement4("TextLabel", v23)
	end

	v17.SettingDescriptionText = v21
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

	local createElement4 = Roact.createElement
	local v23 = {
		Size = UDim2.fromScale(1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2
	}

	local createElement5 = Roact.createElement
	local v27 = if props.topToBottom then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Right
	local v24 = {
		Layout = createElement5("UIListLayout", {
			HorizontalAlignment = v27,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = 0,
		Control = 0
	}

	local v28 = if props.topToBottom then Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, not module and 10 or v9.Size.Size_300),
		PaddingBottom = UDim.new(0, not module and 10 or v9.Size.Size_100)
	}) else nil
	v24.UIPadding = v28

	v24.Control = props.Control
	children.SettingControlFrame = createElement4("Frame", v23, v24)
	return createElement("Frame", v11, children)
end

function extended.render(p2)
	return Roact.createElement(WithHooksComponent, p2.props)
end

return extended
