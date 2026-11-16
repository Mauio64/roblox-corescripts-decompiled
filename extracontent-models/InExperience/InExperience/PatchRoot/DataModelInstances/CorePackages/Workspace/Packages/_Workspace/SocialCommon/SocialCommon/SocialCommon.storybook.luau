local SocialCommon = script:FindFirstAncestor("SocialCommon")
local parent = SocialCommon.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)
local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local UnitTestHelpers = require(parent.Dev.UnitTestHelpers)
local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)

local FoundationProvider = Foundation.FoundationProvider
local LocalizationProvider = Localization.LocalizationProvider
local LocalizationRoactContext = Localization.LocalizationRoactContext
local createStyleProvider = UnitTestHelpers.createStyleProvider
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale

local store = Rodux.Store.new(function(p)
	return p
end, { ScreenSize = Vector2.new(390, 844) }, { Rodux.thunkMiddleware })

local function withTolerantLocalization(p) -- 1 equivalent call inferred from this helper
	return function(p2)
		local v = React.useContext(LocalizationRoactContext)

		local localization = React.useMemo(function()
			return (setmetatable({
				Format = function(self, p3, p4)
					local success, result = pcall(function()
						return v:Format(p3, p4)
					end)

					if success then
						return result
					end

					return `«{p3}»`
				end
			}, { __index = v }))
		end, { v })

		return React.createElement(LocalizationProvider, { localization = localization }, {
			Story = React.createElement(p, p2)
		})
	end
end

return {
	name = "SocialCommon",
	storyRoots = { SocialCommon },
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		local v = withTolerantLocalization(p) -- inferred equivalent call
		return function(p2)
			return React.createElement(FoundationProvider, {
				device = "Phone",
				colorMode = p2 and p2.theme == "Light" and "Light" or "Dark"
			}, {
				Store = React.createElement(RoactRodux.StoreProvider, { store = store }, {
					Style = createStyleProvider({ Localization = mockLocale(v, p2) })
				})
			})
		end
	end
}
