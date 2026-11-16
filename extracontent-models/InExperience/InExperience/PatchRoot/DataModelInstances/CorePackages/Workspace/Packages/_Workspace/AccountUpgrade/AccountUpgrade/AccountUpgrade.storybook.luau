local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Http = require(parent.Dev.Http)
local UnitTestHelpers = require(parent.Dev.UnitTestHelpers)
local mockHttpResponse = UnitTestHelpers.mockHttpResponse
local Promise = require(parent.Promise)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AuthTestHelpers = require(parent.Dev.AuthTestHelpers)
local mockServices = AuthTestHelpers.TestHelpers.mockServices

local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device

local StatusCodes = Http.StatusCodes

local function validationEndpoint(p: string)
	return Promise.resolve(mockHttpResponse.new(p, { code = 0 }, 0, StatusCodes.OK))
end

local v = {
	Default = { themeName = "Dark", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" }
}

local v2 = { Default = ColorMode.Dark, Dark = ColorMode.Dark, Light = ColorMode.Light }

local v3 = {
	Default = "Desktop",
	Desktop = "Desktop",
	Phone = "Phone",
	Tablet = "Tablet",
	Console = "Console"
}

return {
	name = "AccountUpgrade",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local v4 = props and v[props.theme] or v.Default
			local deviceType = props and v3[props.platform] or "Desktop"
			local colorMode = props and v2[props.theme] or v2.Default

			return mockServices({
				FoundationProvider = React.createElement(FoundationProvider, {
					colorMode = colorMode,
					device = props and Device[props.platform] or Device.Desktop,
					overlayGui = props and props.focus
				}, { Story = React.createElement(p, props) })
			}, {
				includeStoreProvider = true,
				appStyle = {
					themeName = v4.themeName,
					fontName = v4.fontName,
					deviceType = deviceType
				},
				extraServices = { [RoactNetworking] = validationEndpoint }
			})
		end
	end,
	storyRoots = { AccountUpgrade }
}
