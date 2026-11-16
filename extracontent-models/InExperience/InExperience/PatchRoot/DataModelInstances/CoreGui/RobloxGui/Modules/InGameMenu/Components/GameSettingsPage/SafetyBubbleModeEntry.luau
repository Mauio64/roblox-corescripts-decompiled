local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings

local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = require(CorePackages.Packages.Roact)
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local parent = script.Parent.Parent.Parent
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local propertyChangedSignal = gameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode")
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)

local InputLabel = require(script.Parent.InputLabel)
local RadioButtonList = UIBlox.App.InputButton.RadioButtonList
local withLocalization = require(parent.Localization.withLocalization)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local FFlagFixSafetyBubbleWidth = require(parent.Flags.FFlagFixSafetyBubbleWidth)
local fFlagFixSafetyBubbleWidth = FFlagFixSafetyBubbleWidth()

local v = {
	Title = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle",
	Description = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription",
	["Enum.VRSafetyBubbleMode.NoOne"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeNoOne",
	["Enum.VRSafetyBubbleMode.OnlyFriends"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeOnlyFriends",
	["Enum.VRSafetyBubbleMode.Anyone"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeAnyone"
}

local enumItems = Enum.VRSafetyBubbleMode:GetEnumItems()
local function getSafetyBubbleModeIndex(vrSafetyBubbleMode) -- 2 equivalent calls inferred from this helper
	return LuauPolyfill.Array.indexOf(enumItems, vrSafetyBubbleMode)
end

local function setSafetyBubbleModeByIndex(p) -- 1 equivalent call inferred from this helper
	local enumItem = enumItems[p]
	gameSettings.VRSafetyBubbleMode = enumItem
	SendAnalytics(Constants.AnalyticsSettingsChangeName, Constants.AnalyticsSettingsSafetyBubbleModeChangeName, {
		mode = tostring(enumItem)
	})
end

local extended = Roact.PureComponent:extend("SafetyBubbleModeEntry")
extended.validateProps = t.strictInterface({ LayoutOrder = t.optional(t.integer) })

function extended.init(object)
	object:setState({
		selectedMode = getSafetyBubbleModeIndex(gameSettings.VRSafetyBubbleMode) -- inferred equivalent call
	})
end

function extended.render(object)
	return withLocalization(v)(function(p)
		local createFragment = Roact.createFragment
		local v2 = {
			VRSafetyBubbleModeListener = Roact.createElement(ExternalEventConnection, {
				event = propertyChangedSignal,
				callback = function()
					object:setState({
						selectedMode = getSafetyBubbleModeIndex(gameSettings.VRSafetyBubbleMode) -- inferred equivalent call
					})
				end
			}),
			SafetyBubbleModeEntrySelector = 0
		}

		local createElement = Roact.createElement
		local v3 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = object.props.LayoutOrder,
			ZIndex = 2
		}

		local v4 = {
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
				localizationKey = v.Title,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				LayoutOrder = 1
			}),
			InputDescription = Roact.createElement(ThemedTextLabel, {
				themeKey = "TextDefault",
				fontKey = "CaptionHeader",
				Text = p.Description,
				Size = UDim2.new(0.9, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextWrapped = true,
				LayoutOrder = 2,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			RadioList = 0
		}

		local createElement2 = Roact.createElement
		local v5 = {
			layoutOrder = 3,
			radioButtons = LuauPolyfill.Array.map(enumItems, function(p2, _)
				return { label = p[tostring(p2)] }
			end),
			onActivated = function(p2)
				setSafetyBubbleModeByIndex(p2) -- inferred equivalent call
			end,
			currentValue = object.state.selectedMode,
			automaticSize = true,
			padding = UDim.new(0, 20),
			elementSize = 0
		}
		local elementSize

		if fFlagFixSafetyBubbleWidth then
			elementSize = UDim2.new(1, 0, 0, 20)
		else
			elementSize = UDim2.new(0, 0, 0, 20)
		end

		v5.elementSize = elementSize
		v4.RadioList = createElement2(RadioButtonList, v5)
		v2.SafetyBubbleModeEntrySelector = createElement("Frame", v3, v4)
		return createFragment(v2)
	end)
end

return extended
