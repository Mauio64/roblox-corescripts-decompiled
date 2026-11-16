local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView

local favoritesSavedView = require("@luauforge/deferred/gVu").Components.FavoritesSavedView

local module = require("@luauforge/bundled/fuD")
local module2 = require("@luauforge/deferred/ggG")

local module3 = require("@luauforge/deferred/gml")
local module4 = require("@luauforge/deferred/gmi")
local module5 = require("@luauforge/deferred/gpj")

local module6 = require("@luauforge/deferred/gfe")
local module7 = require("@luauforge/deferred/goQ")
local module8 = require("@luauforge/deferred/gVz")

local function FavoritesSavedScreen(p2)
	local ref = React.useRef(nil)

	local v5 = module3()

	local v6, v7 = module5()
	local v8 = v6 == fullView.SceneFullView
	local v9 = v6 == fullView.UIFullView

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local v10 = React.useContext(module2)
	local v11 = RoactGamepad.useRefCache()
	local v12 = module4({ overlayClosedCallback = v5 }, v10[avatarScreen.FavoritesSaved])

	local v13 = React.useCallback(function()
		v7((module.getNewFullViewEnum(v6)))
	end, { v6, v7 })

	return React.createElement(Foundation.View, {
		tag = "size-full gui-object-defaults",
		ref = v12
	}, {
		NavigationEventsLogger = React.createElement(module6, {
			pageName = avatarScreen.FavoritesSaved
		}),
		AvatarExperienceView = React.createElement(module7, {
			allowAdaptiveScrolling = true,
			bottomBarEnabled = false,
			changeViewFunction = v13,
			isSceneFullView = v8,
			isUIFullView = v9,
			topBar = React.createElement(module8, { topBarRef = ref2 }),
			refinementButtonsRef = ref4,
			quickButtonsRef = ref5,
			ref = ref3,
			multiTryOnBottomBarRef = ref,
			itemDetailsPeekViewRefs = v11
		}, {
			FavoritesSavedView = React.createElement(favoritesSavedView)
		})
	})
end

return require("@luauforge/deferred/gmV")(FavoritesSavedScreen)
