local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local rendering = settings().Rendering

local propertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("SavedQualityLevel")

local parent = script.Parent.Parent.Parent

local ToggleEntry = require(script.Parent.ToggleEntry)
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)
local SliderEntry = require(script.Parent.SliderEntry)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local v = #Enum.SavedQualitySetting:GetEnumItems() - 1

local function mapInteger(savedQualityLevel, p, p2, min, max) -- 1 equivalent call inferred from this helper
	return (math.clamp(math.floor(min + (savedQualityLevel - p) * (max - min) / (p2 - p)), min, max))
end

local extended = Roact.PureComponent:extend("GraphicsQualityEntry")
extended.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean)
})

function extended:init()
	local automatic = UserGameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic
	self:setState({
		quality = automatic and 5 or UserGameSettings.SavedQualityLevel.Value,
		automatic = automatic
	})

	function self.onQualityChanged()
		local savedQualityLevel = UserGameSettings.SavedQualityLevel
		local quality

		if savedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
			quality = savedQualityLevel.Value or nil
		end

		self:setState({
			quality = quality,
			automatic = savedQualityLevel == Enum.SavedQualitySetting.Automatic
		})
	end

	if automatic then
		self:setAutomaticQualityLevel()
	else
		self:setManualQualityLevel(self.state.quality)
	end
end

function extended:setAutomaticQualityLevel()
	UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
	rendering.QualityLevel = 0
end

function extended:setManualQualityLevel(savedQualityLevel): nil
	local qualityLevel = mapInteger(savedQualityLevel, 1, v, 1, rendering:GetMaxQualityLevel() - 1) -- inferred equivalent call

	UserGameSettings.SavedQualityLevel = savedQualityLevel
	rendering.QualityLevel = qualityLevel
	return nil
end

function extended:render()
	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 156),
			LayoutOrder = self.props.LayoutOrder
		},
		{
			Layout = Roact.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
			AutoToggle = Roact.createElement(ToggleEntry, {
				LayoutOrder = 1,
				labelKey = "CoreScripts.InGameMenu.GameSettings.AutoGraphicsQuality",
				checked = self.state.automatic,
				onToggled = function()
					if self.state.automatic then
						self:setManualQualityLevel(self.state.quality)
					else
						self:setAutomaticQualityLevel()
					end

					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end
			}),
			Slider = Roact.createElement(SliderEntry, {
				LayoutOrder = 2,
				labelKey = "CoreScripts.InGameMenu.GameSettings.ManualGraphicsQuality",
				min = 1,
				max = 10,
				stepInterval = 1,
				value = self.state.quality,
				disabled = self.state.automatic,
				valueChanged = function(p)
					self:setManualQualityLevel(p)
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end,
				canCaptureFocus = self.props.canCaptureFocus,
				isMenuOpen = self.props.isMenuOpen
			}),
			QualityListener = Roact.createElement(ExternalEventConnection, {
				event = propertyChangedSignal,
				callback = self.onQualityChanged
			})
		}
	)
end

return extended
