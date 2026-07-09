local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Dash = require(CorePackages.Packages.Dash)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local TitleDropDown = require(Modules.AvatarExperience.Common.Components.TitleDropDown)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local v13 = t.strictInterface({
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

local function makeTopBarTitleDropDown(s1: string, p1: ((...any) -> ...any)?) -- line: 41
	-- upvalues: ArgCheck (copy), v13 (copy), withLocalization (copy), Roact (copy), TitleDropDown (copy), AvatarScreen (copy), RoactRodux (copy), NavigateWithLock (copy), RoactNavigation (copy)
	local function TopBarTitleDropDown(p2) -- line: 42
		-- upvalues: ArgCheck (copy), v13 (copy), withLocalization (copy), s1 (copy), Roact (copy), TitleDropDown (copy), AvatarScreen (copy), p1 (copy)
		ArgCheck.assert(v13(p2))

		return withLocalization({
			title = s1
		})(function(p3) -- line: 47
			-- upvalues: Roact (copy), TitleDropDown (copy), p2 (copy), AvatarScreen (copy), p1 (copy)
			return Roact.createElement(TitleDropDown, {
				Text = p3.title or "",
				onActivated = function() -- line: 50
					-- upvalues: p2 (copy), AvatarScreen (copy), p1 (copy)
					p2.navigateWithLock(function() -- line: 51
						-- upvalues: p2 (copy), AvatarScreen (copy), p1 (copy)
						p2.navigation.navigate(AvatarScreen.AXTransitionContextualMenu, {
							onOverlayClosed = p1
						})
					end)
				end,
				[Roact.Ref] = p2.buttonRef
			})
		end)
	end

	local v18 = RoactRodux.connect(nil, function(p4) -- line: 63
		-- upvalues: NavigateWithLock (copy)
		return {
			navigateWithLock = function(p5) -- line: 65
				-- upvalues: p4 (copy), NavigateWithLock (copy)
				p4(NavigateWithLock(p5))
			end
		}
	end)(TopBarTitleDropDown)

	return (RoactNavigation.withNavigation(v18))
end

return makeTopBarTitleDropDown
