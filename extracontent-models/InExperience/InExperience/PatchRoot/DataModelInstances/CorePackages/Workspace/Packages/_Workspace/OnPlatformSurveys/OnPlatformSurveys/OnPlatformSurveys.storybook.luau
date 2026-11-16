local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)

local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device

local MockProviders = require(OnPlatformSurveys.MockProviders)

local v = { Dark = ColorMode.Dark, Light = ColorMode.Light }

local function union(props, props2) -- 1 equivalent call inferred from this helper
	local clone = table.clone(props)

	if props2 then
		for k, item in props2 do
			clone[k] = item
		end
	end

	return clone
end

return {
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local clone = union(props, props.definition and props.definition.props or {}) -- inferred equivalent call
			return React.createElement(MockProviders, {}, {
				FoundationProvider = React.createElement(FoundationProvider, {
					colorMode = v[props.theme] or ColorMode.Dark,
					device = Device[props.platform] or Device.Phone,
					preferences = props.settings,
					overlayGui = props.focus
				}, { story = React.createElement(p, clone) })
			})
		end
	end,
	storyRoots = { OnPlatformSurveys }
}
