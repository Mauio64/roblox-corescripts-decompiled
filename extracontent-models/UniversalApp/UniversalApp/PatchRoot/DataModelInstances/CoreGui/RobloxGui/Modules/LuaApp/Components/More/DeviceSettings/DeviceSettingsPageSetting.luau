local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local v5 = Roact.PureComponent:extend("DeviceSettingsPageSetting")
local FFlagEnableDevicePreferenceLayoutUpdate = require(Modules.LuaApp.Flags.FFlagEnableDevicePreferenceLayoutUpdate)
local v7 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagMacMenuBarContentUpdates()
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens

v5.defaultProps = {
	topToBottom = false
}
v5.validateProps = t.strictInterface({
	topToBottom = t.optional(t.boolean),
	style = t.table,
	layoutOrder = t.number,
	header = t.string,
	description = if not v7 then t.string else t.optional(t.string),
	Control = t.table,
	zIndex = t.optional(t.number)
})

local function WithHooksComponent(p1) -- line: 34
	-- upvalues: useDesignTokens (copy), Roact (copy), v7 (copy), FFlagEnableDevicePreferenceLayoutUpdate (copy)
	local style = p1.style
	local BaseSize = style.Font.BaseSize
	local v13 = BaseSize * style.Font.Header2.RelativeSize
	local v14 = BaseSize * style.Font.CaptionBody.RelativeSize
	local Header2Font = style.Font.Header2.Font
	local CaptionBodyFont = style.Font.CaptionBody.Font
	local v17 = useDesignTokens()

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = p1.layoutOrder,
		ZIndex = p1.zIndex
	}, {
		Layout = if not p1.topToBottom then nil else Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SettingInfoFrame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = if not v7 or p1.description ~= nil then UDim2.fromScale(1, 0) else UDim2.fromScale(1, 1),
			AutomaticSize = if not v7 or p1.description ~= nil then Enum.AutomaticSize.Y else Enum.AutomaticSize.None
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, not FFlagEnableDevicePreferenceLayoutUpdate and 6 or v17.Size.Size_100)
			}),
			SettingHeaderText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextWrapped = true,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, v13),
				Text = p1.header,
				Font = Header2Font,
				TextSize = v13,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextColor3 = style.Theme.TextDefault.Color,
				TextTransparency = style.Theme.TextDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			SettingDescriptionText = if not not v7 and p1.description == nil then nil else Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextWrapped = true,
				LayoutOrder = 2,
				Size = if not p1.topToBottom then UDim2.fromScale(0.65, 0) else UDim2.new(1, 0, 0, 0),
				Text = p1.description,
				Font = CaptionBodyFont,
				TextSize = v14,
				TextColor3 = style.Theme.TextMuted.Color,
				TextTransparency = style.Theme.TextMuted.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y
			})
		}),
		SettingControlFrame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = if not p1.topToBottom then Enum.HorizontalAlignment.Right else Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			UIPadding = if not p1.topToBottom then nil else Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, not FFlagEnableDevicePreferenceLayoutUpdate and 10 or v17.Size.Size_300),
				PaddingBottom = UDim.new(0, not FFlagEnableDevicePreferenceLayoutUpdate and 10 or v17.Size.Size_100)
			}),
			Control = p1.Control
		})
	})
end

function v5.render(p2) -- line: 141
	-- upvalues: Roact (copy), WithHooksComponent (copy)
	return Roact.createElement(WithHooksComponent, p2.props)
end

return v5
