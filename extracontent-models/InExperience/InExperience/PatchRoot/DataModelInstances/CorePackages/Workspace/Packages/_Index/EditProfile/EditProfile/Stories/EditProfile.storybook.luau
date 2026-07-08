local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local ReactRoblox = require(EditProfileParent.Dev.ReactRoblox)
local RoactRodux = require(EditProfileParent.RoactRodux)
local Rodux = require(EditProfileParent.Rodux)
local UIBlox = require(EditProfileParent.UIBlox)
local Cryo = require(EditProfileParent.Cryo)
local Style = require(EditProfileParent.Style)
local ApolloClient = require(EditProfileParent.ApolloClient)
local Foundation = require(EditProfileParent.Foundation)
local mockLocale = require(EditProfileParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local RobloxAppUIBloxConfig = require(EditProfileParent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local FoundationProvider = Foundation.FoundationProvider
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local DesignTokenProvider = require(EditProfileParent.Style).DesignTokenProvider
local mockApolloClient = require(EditProfileParent.GraphQLServer).ApolloClientTestUtils.mockApolloClient
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local UniversalAppPolicy = require(EditProfileParent.UniversalAppPolicy)
local t1 = {
	language = "en-us"
}
local t2 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}
local t3 = {
	Console = Device.Console,
	Desktop = Device.Desktop
}

local function v24(p1) -- line: 40
	-- upvalues: Rodux (copy), Cryo (copy)
	return Rodux.Store.new(function() -- line: 41
		-- upvalues: Cryo (copy), p1 (copy)
		return Cryo.Dictionary.join(p1, {
			ScreenSize = Vector2.new(600, 600),
			TopBar = {
				topBarHeight = 0
			},
			GlobalGuiInset = {
				left = 0,
				top = 0,
				right = 0,
				bottom = 0
			}
		})
	end, {}, { Rodux.thunkMiddleware })
end

return {
	name = "EditProfile",
	storyRoot = EditProfile,
	roact = React,
	reactRoblox = ReactRoblox,
	roactRodux = RoactRodux,
	mapDefinition = function(p2) -- line: 63
		-- upvalues: Cryo (copy), t1 (copy)
		local v27 = Cryo.Dictionary.join(t1, p2.controls or {})

		return Cryo.Dictionary.join(p2, {
			controls = v27
		})
	end,
	mapStory = function(p3) -- line: 67
		-- upvalues: t2 (copy), React (copy), StyleProviderWithDefaultTheme (copy), RoactRodux (copy), v24 (copy), UniversalAppPolicy (copy), ApolloClient (copy), mockApolloClient (copy), FoundationProvider (copy), t3 (copy), DesignTokenProvider (copy), mockLocale (copy)
		return function(p4) -- line: 68
			-- upvalues: t2 (copy), React (copy), StyleProviderWithDefaultTheme (copy), RoactRodux (copy), v24 (copy), UniversalAppPolicy (copy), ApolloClient (copy), mockApolloClient (copy), FoundationProvider (copy), t3 (copy), DesignTokenProvider (copy), mockLocale (copy), p3 (copy)
			local v30 = t2[p4.theme]
			local v31 = p4.definition.state or {}

			return React.createElement(StyleProviderWithDefaultTheme, {
				withDarkTheme = true,
				withUiModeSupport = false
			}, {
				storeProvider = React.createElement(RoactRodux.StoreProvider, {
					store = v24(v31)
				}, {
					policyProvider = React.createElement(UniversalAppPolicy.RoactAppPolicy.Provider, {
						policy = { UniversalAppPolicy.AppFeaturePolicies }
					}, {
						apolloClient = React.createElement(ApolloClient.ApolloProvider, {
							client = mockApolloClient({})
						}, {
							foundationProvider = React.createElement(FoundationProvider, {
								theme = v30,
								device = t3[p4.platform],
								preferences = p4.settings
							}, {
								designTokenProvider = React.createElement(DesignTokenProvider, {
									tokenMappers = {}
								}, {
									Child = mockLocale(p3, p4)
								})
							})
						})
					})
				})
			})
		end
	end
}
