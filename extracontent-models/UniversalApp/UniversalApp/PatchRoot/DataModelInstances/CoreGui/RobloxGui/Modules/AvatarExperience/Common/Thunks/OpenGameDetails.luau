local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local SetGameDetailsPeekViewState = require(Modules.LuaApp.Actions.Games.SetGameDetailsPeekViewState)
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local UseGameDetailsPeekView = require(Modules.LuaApp.Flags.UseGameDetailsPeekView)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local SetItemDetailsExpanded = require(Modules.AvatarExperience.Common.Actions.SetItemDetailsExpanded)

local function openBriefGameDetailsPeekView(p1, p2, p3) -- line: 17
	-- upvalues: SetGameDetailsPeekViewState (copy), PeekViewState (copy), SetItemDetailsExpanded (copy), NavigationUtils (copy)
	p1:dispatch(SetGameDetailsPeekViewState(PeekViewState.Closed))
	p1:dispatch(SetItemDetailsExpanded(true))
	NavigationUtils.closeFiltersAndItemDetails(p2)
	NavigationUtils.closeAllDialogs(p2)
	p2.navigate(p3.name, p3)
end

return function(p4, p5, t1: {[any]: any}?) -- line: 27
	-- upvalues: AppPage (copy), FormFactor (copy), UseGameDetailsPeekView (copy), PeekViewState (copy), OpenGameDetails (copy), openBriefGameDetailsPeekView (copy)
	return function(p6) -- line: 28
		-- upvalues: AppPage (copy), p4 (copy), t1 (copy), FormFactor (copy), UseGameDetailsPeekView (copy), PeekViewState (copy), OpenGameDetails (copy), openBriefGameDetailsPeekView (copy), p5 (copy)
		local t2 = {
			name = AppPage.GameDetail,
			detail = tostring(p4),
			extraProps = t1
		}
		local v20 = p6:getState()
		local FormFactor2 = v20.FormFactor
		local viewState = v20.GameDetailsPeekView.viewState

		if FormFactor2 == FormFactor.COMPACT and UseGameDetailsPeekView() then
			if viewState == PeekViewState.Full or viewState == PeekViewState.Extended or t1 and t1.mountAsFullView then
				p6:dispatch(OpenGameDetails(p4, t1))

				return
			end

			openBriefGameDetailsPeekView(p6, p5, t2)

			return
		end

		p6:dispatch(OpenGameDetails(p4, t1))
	end
end
