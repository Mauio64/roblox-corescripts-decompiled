local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Rendering = settings().Rendering
local PropertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("SavedQualityLevel")
local ParentParent = script.Parent.Parent.Parent
local ToggleEntry = require(script.Parent.ToggleEntry)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local SliderEntry = require(script.Parent.SliderEntry)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local v14 = #Enum.SavedQualitySetting:GetEnumItems() - 1

local function mapInteger(p1, p2, p3, p4, p5) -- line: 30
	return (math.clamp(math.floor(p4 + (p1 - p2) * (p5 - p4) / (p3 - p2)), p4, p5))
end

local v16 = Roact.PureComponent:extend("GraphicsQualityEntry")

v16.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean)
})

function v16.init(p6) -- line: 41
	-- upvalues: UserGameSettings (copy)
	local v23 = UserGameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic

	p6:setState({
		quality = if not v23 then UserGameSettings.SavedQualityLevel.Value else 5,
		automatic = v23
	})

	function p6.onQualityChanged() -- line: 48
		-- upvalues: UserGameSettings (copy), p6 (copy)
		local SavedQualityLevel = UserGameSettings.SavedQualityLevel
		local v32 = SavedQualityLevel == Enum.SavedQualitySetting.Automatic

		p6:setState({
			quality = not v32 and SavedQualityLevel.Value or nil,
			automatic = SavedQualityLevel == Enum.SavedQualitySetting.Automatic
		})
	end

	if v23 then
		p6:setAutomaticQualityLevel()

		return
	end

	p6:setManualQualityLevel(p6.state.quality)
end
function v16.setAutomaticQualityLevel(_) -- line: 65
	-- upvalues: UserGameSettings (copy), Rendering (copy)
	UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
	Rendering.QualityLevel = 0
end
function v16.setManualQualityLevel(_, p9) -- line: 70
	-- upvalues: v14 (copy), Rendering (copy), UserGameSettings (copy)
	local v27 = v14
	local v28 = Rendering:GetMaxQualityLevel() - 1
	local v29 = math.clamp(math.floor(1 + (p9 - 1) * (v28 - 1) / (v27 - 1)), 1, v28)

	UserGameSettings.SavedQualityLevel = p9
	Rendering.QualityLevel = v29

	return nil
end
function v16.render(p10) -- line: 85
	-- upvalues: Roact (copy), ToggleEntry (copy), SendAnalytics (copy), Constants (copy), SliderEntry (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 156),
		LayoutOrder = p10.props.LayoutOrder
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		AutoToggle = Roact.createElement(ToggleEntry, {
			LayoutOrder = 1,
			labelKey = "CoreScripts.InGameMenu.GameSettings.AutoGraphicsQuality",
			checked = p10.state.automatic,
			onToggled = function() -- line: 98
				-- upvalues: p10 (copy), SendAnalytics (copy), Constants (copy)
				if p10.state.automatic then
					p10:setManualQualityLevel(p10.state.quality)
				else
					p10:setAutomaticQualityLevel()
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
			value = p10.state.quality,
			disabled = p10.state.automatic,
			valueChanged = function(p11) -- line: 115
				-- upvalues: p10 (copy), SendAnalytics (copy), Constants (copy)
				p10:setManualQualityLevel(p11)
				SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
			end,
			canCaptureFocus = p10.props.canCaptureFocus,
			isMenuOpen = p10.props.isMenuOpen
		}),
		QualityListener = Roact.createElement(ExternalEventConnection, {
			event = PropertyChangedSignal,
			callback = p10.onQualityChanged
		})
	})
end

return v16
