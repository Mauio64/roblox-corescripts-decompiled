local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = require(CorePackages.Packages.Roact)
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local ParentParent = script.Parent.Parent.Parent
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local PropertyChangedSignal = GameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode")
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local InputLabel = require(script.Parent.InputLabel)
local RadioButtonList = UIBlox.App.InputButton.RadioButtonList
local withLocalization = require(ParentParent.Localization.withLocalization)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local v17 = require(ParentParent.Flags.FFlagFixSafetyBubbleWidth)()
local t1 = {
	Title = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle",
	Description = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription",
	["Enum.VRSafetyBubbleMode.NoOne"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeNoOne",
	["Enum.VRSafetyBubbleMode.OnlyFriends"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeOnlyFriends",
	["Enum.VRSafetyBubbleMode.Anyone"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeAnyone"
}
local EnumItems = Enum.VRSafetyBubbleMode:GetEnumItems()

local function getSafetyBubbleModeIndex(p1) -- line: 36
	-- upvalues: LuauPolyfill (copy), EnumItems (copy)
	return LuauPolyfill.Array.indexOf(EnumItems, p1)
end
local function setSafetyBubbleModeByIndex(p2) -- line: 40
	-- upvalues: EnumItems (copy), GameSettings (copy), SendAnalytics (copy), Constants (copy)
	local v25 = EnumItems[p2]

	GameSettings.VRSafetyBubbleMode = v25
	SendAnalytics(Constants.AnalyticsSettingsChangeName, Constants.AnalyticsSettingsSafetyBubbleModeChangeName, {
		mode = tostring(v25)
	})
end

local v22 = Roact.PureComponent:extend("SafetyBubbleModeEntry")

v22.validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.integer)
})

function v22.init(p3) -- line: 53
	-- upvalues: GameSettings (copy), LuauPolyfill (copy), EnumItems (copy)
	local t2 = {}
	local VRSafetyBubbleMode = GameSettings.VRSafetyBubbleMode

	t2.selectedMode = LuauPolyfill.Array.indexOf(EnumItems, VRSafetyBubbleMode)
	p3:setState(t2)
end
function v22.render(p4) -- line: 59
	-- upvalues: withLocalization (copy), t1 (copy), Roact (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy), GameSettings (copy), LuauPolyfill (copy), EnumItems (copy), InputLabel (copy), ThemedTextLabel (copy), RadioButtonList (copy), SendAnalytics (copy), Constants (copy), v17 (copy)
	return withLocalization(t1)(function(p5) -- line: 60
		-- upvalues: Roact (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy), p4 (copy), GameSettings (copy), LuauPolyfill (copy), EnumItems (copy), InputLabel (copy), t1 (copy), ThemedTextLabel (copy), RadioButtonList (copy), SendAnalytics (copy), Constants (copy), v17 (copy)
		return Roact.createFragment({
			VRSafetyBubbleModeListener = Roact.createElement(ExternalEventConnection, {
				event = PropertyChangedSignal,
				callback = function() -- line: 64
					-- upvalues: p4 (copy), GameSettings (copy), LuauPolyfill (copy), EnumItems (copy)
					local v31 = p4
					local t3 = {}
					local VRSafetyBubbleMode = GameSettings.VRSafetyBubbleMode

					t3.selectedMode = LuauPolyfill.Array.indexOf(EnumItems, VRSafetyBubbleMode)
					v31:setState(t3)
				end
			}),
			SafetyBubbleModeEntrySelector = Roact.createElement("Frame", {
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
				InputLabel = Roact.createElement(InputLabel, {
					LayoutOrder = 1,
					localizationKey = t1.Title,
					Size = UDim2.new(1, 0, 0, 0),
					Position = UDim2.new(0, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0)
				}),
				InputDescription = Roact.createElement(ThemedTextLabel, {
					themeKey = "TextDefault",
					fontKey = "CaptionHeader",
					TextWrapped = true,
					LayoutOrder = 2,
					Text = p5.Description,
					Size = UDim2.new(0.9, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				RadioList = Roact.createElement(RadioButtonList, {
					layoutOrder = 3,
					automaticSize = true,
					radioButtons = LuauPolyfill.Array.map(EnumItems, function(p6, _) -- line: 108
						-- upvalues: p5 (copy)
						return {
							label = p5[tostring(p6)]
						}
					end),
					onActivated = function(p8) -- line: 113
						-- upvalues: EnumItems (copy), GameSettings (copy), SendAnalytics (copy), Constants (copy)
						local v37 = EnumItems[p8]

						GameSettings.VRSafetyBubbleMode = v37
						SendAnalytics(Constants.AnalyticsSettingsChangeName, Constants.AnalyticsSettingsSafetyBubbleModeChangeName, {
							mode = tostring(v37)
						})
					end,
					currentValue = p4.state.selectedMode,
					padding = UDim.new(0, 20),
					elementSize = if not v17 then UDim2.new(0, 0, 0, 20) else UDim2.new(1, 0, 0, 20)
				})
			})
		})
	end)
end

return v22
