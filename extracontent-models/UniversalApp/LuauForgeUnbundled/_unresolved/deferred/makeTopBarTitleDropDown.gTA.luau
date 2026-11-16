local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dwM")
local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module2 = require("@luauforge/deferred/gTB")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local strictInterface = t.strictInterface({
	formFactor = t.string,
	isCompactView = t.boolean,
	isSearching = t.boolean,
	setVisible = Dash.isCallable,
	cancelSearch = Dash.isCallable,
	activateSearch = Dash.isCallable,
	buttonRef = t.optional(t.table),
	navigateWithLock = t.callback,
	navigation = t.table
})

local function makeTopBarTitleDropDown(p2, onOverlayClosed)
	local function TopBarTitleDropDown(data)
		module.assert(strictInterface(data))

		return withLocalization({ title = p2 })(function(p3)
			return Roact.createElement(module2, {
				Text = p3.title or "",
				onActivated = function()
					local function fn()
						data.navigation.navigate(avatarScreen.AXTransitionContextualMenu, {
							onOverlayClosed = onOverlayClosed
						})
					end
					data.navigateWithLock(fn)
				end,
				[Roact.Ref] = data.buttonRef
			})
		end)
	end

	local v5 = RoactRodux.connect(nil, function(callback)
		return {
			navigateWithLock = function(p3)
				callback(navigateWithLock(p3))
			end
		}
	end)(TopBarTitleDropDown)

	return (RoactNavigation.withNavigation(v5))
end

return makeTopBarTitleDropDown
