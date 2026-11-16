local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings

local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = require(CorePackages.Packages.Roact)
local t = InGameMenuDependencies.t
local SegmentedControl = InGameMenuDependencies.UIBlox.App.Control.SegmentedControl

local parent = script.Parent.Parent.Parent
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local propertyChangedSignal = gameSettings:GetPropertyChangedSignal("VRComfortSetting")
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)

local withLocalization = require(parent.Localization.withLocalization)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local v = {
	Description = "CoreScripts.InGameMenu.GameSettings.ComfortSettingsDescription",
	["Enum.VRComfortSetting.Comfort"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingComfort",
	["Enum.VRComfortSetting.Normal"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingNormal",
	["Enum.VRComfortSetting.Expert"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingExpert",
	["Enum.VRComfortSetting.Custom"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingCustom"
}

local enumItems = Enum.VRComfortSetting:GetEnumItems()
local function getComfortSettingIndex(vrComfortSetting) -- 2 equivalent calls inferred from this helper
	return LuauPolyfill.Array.indexOf(enumItems, vrComfortSetting)
end

local function setComfortSettingByIndex(p) -- 1 equivalent call inferred from this helper
	local enumItem = enumItems[p]
	gameSettings.VRComfortSetting = enumItem
	SendAnalytics(Constants.AnalyticsSettingsChangeName, Constants.AnalyticsSettingsVRComfortSettingChangeName, {
		mode = tostring(enumItem)
	})
end

local extended = Roact.PureComponent:extend("ComfortSettingsEntry")
extended.validateProps = t.strictInterface({ LayoutOrder = t.optional(t.integer) })

function extended.init(object)
	object:setState({
		selectedMode = getComfortSettingIndex(gameSettings.VRComfortSetting) -- inferred equivalent call
	})
end

function extended.render(object)
	return withLocalization(v)(function(p)
		return Roact.createFragment({
			VRComfortSettingListener = Roact.createElement(ExternalEventConnection, {
				event = propertyChangedSignal,
				callback = function()
					object:setState({
						selectedMode = getComfortSettingIndex(gameSettings.VRComfortSetting) -- inferred equivalent call
					})
				end
			}),
			ComfortSettingEntrySelector = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = object.props.LayoutOrder,
				ZIndex = 2
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
					Text = p.Description,
					Size = UDim2.new(0.9, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					LayoutOrder = 1,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Frame = Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 2
					},
					{
						SegmentedControl = Roact.createElement(SegmentedControl, {
							width = UDim.new(1, 0),
							selectedTabIndex = object.state.selectedMode,
							onTabActivated = function(p2)
								setComfortSettingByIndex(p2) -- inferred equivalent call
							end,
							tabs = LuauPolyfill.Array.map(enumItems, function(p2, _)
								return { tabName = p[tostring(p2)] }
							end)
						})
					}
				)
			})
		})
	end)
end

return extended
