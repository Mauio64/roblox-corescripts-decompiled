local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = require(CorePackages.Packages.Roact)
local t = InGameMenuDependencies.t
local SegmentedControl = InGameMenuDependencies.UIBlox.App.Control.SegmentedControl
local ParentParent = script.Parent.Parent.Parent
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local PropertyChangedSignal = GameSettings:GetPropertyChangedSignal("VRComfortSetting")
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local withLocalization = require(ParentParent.Localization.withLocalization)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local t1 = {
	Description = "CoreScripts.InGameMenu.GameSettings.ComfortSettingsDescription",
	["Enum.VRComfortSetting.Comfort"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingComfort",
	["Enum.VRComfortSetting.Normal"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingNormal",
	["Enum.VRComfortSetting.Expert"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingExpert",
	["Enum.VRComfortSetting.Custom"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingCustom"
}
local EnumItems = Enum.VRComfortSetting:GetEnumItems()

local function getComfortSettingIndex(p1) -- line: 40
	-- upvalues: LuauPolyfill (copy), EnumItems (copy)
	return LuauPolyfill.Array.indexOf(EnumItems, p1)
end
local function setComfortSettingByIndex(p2) -- line: 44
	-- upvalues: EnumItems (copy), GameSettings (copy), SendAnalytics (copy), Constants (copy)
	local v22 = EnumItems[p2]

	GameSettings.VRComfortSetting = v22
	SendAnalytics(Constants.AnalyticsSettingsChangeName, Constants.AnalyticsSettingsVRComfortSettingChangeName, {
		mode = tostring(v22)
	})
end

local v19 = Roact.PureComponent:extend("ComfortSettingsEntry")

v19.validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.integer)
})

function v19.init(p3) -- line: 57
	-- upvalues: GameSettings (copy), LuauPolyfill (copy), EnumItems (copy)
	local t2 = {}
	local VRComfortSetting = GameSettings.VRComfortSetting

	t2.selectedMode = LuauPolyfill.Array.indexOf(EnumItems, VRComfortSetting)
	p3:setState(t2)
end
function v19.render(p4) -- line: 63
	-- upvalues: withLocalization (copy), t1 (copy), Roact (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy), GameSettings (copy), LuauPolyfill (copy), EnumItems (copy), ThemedTextLabel (copy), SegmentedControl (copy), SendAnalytics (copy), Constants (copy)
	return withLocalization(t1)(function(p5) -- line: 64
		-- upvalues: Roact (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy), p4 (copy), GameSettings (copy), LuauPolyfill (copy), EnumItems (copy), ThemedTextLabel (copy), SegmentedControl (copy), SendAnalytics (copy), Constants (copy)
		return Roact.createFragment({
			VRComfortSettingListener = Roact.createElement(ExternalEventConnection, {
				event = PropertyChangedSignal,
				callback = function() -- line: 68
					-- upvalues: p4 (copy), GameSettings (copy), LuauPolyfill (copy), EnumItems (copy)
					local v28 = p4
					local t3 = {}
					local VRComfortSetting = GameSettings.VRComfortSetting

					t3.selectedMode = LuauPolyfill.Array.indexOf(EnumItems, VRComfortSetting)
					v28:setState(t3)
				end
			}),
			ComfortSettingEntrySelector = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = p4.props.LayoutOrder
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 15),
					PaddingTop = UDim.new(0, 15)
				}),
				ListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 20)
				}),
				InputDescription = Roact.createElement(ThemedTextLabel, {
					themeKey = "TextDefault",
					fontKey = "CaptionHeader",
					TextWrapped = true,
					LayoutOrder = 1,
					Text = p5.Description,
					Size = UDim2.new(0.9, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Frame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					SegmentedControl = Roact.createElement(SegmentedControl, {
						width = UDim.new(1, 0),
						selectedTabIndex = p4.state.selectedMode,
						onTabActivated = function(p6) -- line: 113
							-- upvalues: EnumItems (copy), GameSettings (copy), SendAnalytics (copy), Constants (copy)
							local v32 = EnumItems[p6]

							GameSettings.VRComfortSetting = v32
							SendAnalytics(Constants.AnalyticsSettingsChangeName, Constants.AnalyticsSettingsVRComfortSettingChangeName, {
								mode = tostring(v32)
							})
						end,
						tabs = LuauPolyfill.Array.map(EnumItems, function(p7, _) -- line: 116
							-- upvalues: p5 (copy)
							return {
								tabName = p5[tostring(p7)]
							}
						end)
					})
				})
			})
		})
	end)
end

return v19
