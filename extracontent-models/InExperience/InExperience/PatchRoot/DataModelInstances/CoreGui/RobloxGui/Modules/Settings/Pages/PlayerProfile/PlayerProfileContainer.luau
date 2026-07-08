local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local View = require(CorePackages.Packages.Foundation).View
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).AppFeaturePolicies
local ChatPolicies = require(CorePackages.Workspace.Packages.SocialPolicies).ChatPolicies
local AvatarPolicies = require(CorePackages.Workspace.Packages.AvatarPolicies).AvatarPolicies
local SharePolicies = require(CorePackages.Workspace.Packages.SocialPolicies).SharePolicies
local ShareTargetGamePolicies = require(CorePackages.Workspace.Packages.SocialPolicies).ShareTargetGamePolicies
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local installReducer = require(CorePackages.Workspace.Packages.ProfilePlatform.installReducer)
local Constants = require(CorePackages.Workspace.Packages.ProfilePlatform.Constants)
local ProfileTypes = Enums.ProfileTypes
local ProfileWrapperContext = require(CorePackages.Workspace.Packages.ProfilePlatform.ProfileWrapperContext)
local PlayerProfile = require(script.Parent.PlayerProfile)

local function createStore(p1) -- line: 29
	-- upvalues: Rodux (copy), Constants (copy), installReducer (copy)
	local v23 = Rodux.combineReducers({
		[Constants.RODUX_KEY] = installReducer()
	})

	return Rodux.Store.new(v23, p1 or {}, { Rodux.thunkMiddleware })
end
local function PlayerProfileContainer(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), ChatPolicies (copy), AvatarPolicies (copy), SharePolicies (copy), ShareTargetGamePolicies (copy), ProfileWrapperContext (copy), ProfileTypes (copy), Enums (copy), CoreScriptsRootProvider (copy), RoactRodux (copy), createStore (copy), Responsive (copy), View (copy), PlayerProfile (copy)
	local v25 = React.useRef(nil)

	return React.createElement(RoactAppPolicy.Provider, {
		policy = {
			AppFeaturePolicies,
			ChatPolicies,
			AvatarPolicies,
			SharePolicies,
			ShareTargetGamePolicies
		}
	}, {
		ProfileWrapperProvider = React.createElement(ProfileWrapperContext.Provider, {
			value = {
				profileId = tostring(t1.userId),
				profileType = ProfileTypes.User,
				sourceInfo = {
					contextualInfoType = "",
					source = Enums.Sources.InExperienceProfile
				},
				navigateTo = {
					qRCodePage = function() -- line: 63
					end,
					previousView = function(_: boolean) -- line: 64
					end,
					itemDetails = function(_) -- line: 65
					end,
					itemOrBundleDetails = function(_, _) -- line: 66
					end,
					catalogSearch = function(_) -- line: 67
					end,
					tryOnItem = function(_: string, _: string, _: string?, _: string?) -- line: 68
					end,
					inspectAvatar = t1.inspectAvatar,
					editUsername = function() -- line: 76
					end,
					openLeaveRobloxAlertUIBlox = function(_: ((...any) -> ...any)) -- line: 77
					end,
					closeLeaveRobloxAlert = function() -- line: 78
					end
				},
				externalAnalytics = {
					catalogAnalytics = {}
				}
			}
		}, {
			CoreScriptsRootProvider = React.createElement(CoreScriptsRootProvider, {}, {
				RoduxStore = React.createElement(RoactRodux.StoreProvider, {
					store = createStore()
				}, {
					ResponsiveProvider = React.createElement(Responsive.ContainerRef.Provider, {
						value = v25
					}, {
						PlayerProfileContainer = React.createElement(View, {
							tag = "size-full",
							ref = v25
						}, {
							PlayerProfile = React.createElement(PlayerProfile, {
								userId = t1.userId,
								closePage = t1.closePage
							})
						})
					})
				})
			})
		})
	})
end

return PlayerProfileContainer
