local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local RoactRodux = InGameMenuDependencies.RoactRodux
local Cryo = InGameMenuDependencies.Cryo
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local Promise = require(ParentParent.Utility.Promise)
local withLocalization = require(ParentParent.Localization.withLocalization)
local Page = require(ParentParent.Components.Page)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local PageNavigationWatcher = require(ParentParent.Components.PageNavigationWatcher)
local FocusHandler = require(ParentParent.Components.Connection.FocusHandler)
local RootedConnection = require(ParentParent.Components.Connection.RootedConnection)
local InviteFriendsList = require(script.InviteFriendsList)
local AddFriendsNow = require(script.AddFriendsNow)
local LoadingFriendsError = require(script.LoadingFriendsError)
local GetFFlagIGMGamepadSelectionHistory = require(ParentParent.Flags.GetFFlagIGMGamepadSelectionHistory)
local v22 = Roact.PureComponent:extend("InviteFriendsPage")

v22.validateProps = t.strictInterface({
	pageTitle = t.string,
	canCaptureFocus = t.optional(t.boolean),
	PlayersService = t.union(t.Instance, t.table),
	menuPage = GetFFlagIGMGamepadSelectionHistory() and t.string or nil
})
v22.defaultProps = {
	PlayersService = Players
}

function v22.init(p1) -- line: 43
	-- upvalues: Roact (copy)
	p1.backButtonRef = Roact.createRef()
	p1.searchBoxRef = Roact.createRef()
	p1.state = {
		loadingFriends = true,
		loadingFriendsError = false,
		friends = {}
	}
end
function v22.renderLoadingPage(_) -- line: 54
	-- upvalues: withLocalization (copy), Roact (copy), ThemedTextLabel (copy)
	return withLocalization({
		loading = "CoreScripts.InGameMenu.InviteFriends.Loading"
	})(function(p3) -- line: 57
		-- upvalues: Roact (copy), ThemedTextLabel (copy)
		return Roact.createElement(ThemedTextLabel, {
			fontKey = "Header1",
			themeKey = "TextEmphasis",
			Size = UDim2.new(1, 0, 1, 0),
			Text = p3.loading
		})
	end)
end
function v22.renderError(p4) -- line: 68
	-- upvalues: Roact (copy), LoadingFriendsError (copy)
	return Roact.createElement(LoadingFriendsError, {
		onRetry = function() -- line: 70
			-- upvalues: p4 (copy)
			p4:setState({
				loadingFriends = true,
				loadingFriendsError = false
			})
			p4:loadFriends()
		end,
		canCaptureFocus = p4.props.canCaptureFocus
	})
end
function v22.renderNoFriends(p5) -- line: 81
	-- upvalues: Roact (copy), AddFriendsNow (copy)
	return Roact.createElement(AddFriendsNow, {
		canCaptureFocus = p5.props.canCaptureFocus
	})
end

local function sortFriends(p6, p7) -- line: 87
	if p6.IsOnline == p7.IsOnline then
		return p6.Username:lower() < p7.Username:lower()
	end

	return p6.IsOnline and not p7.IsOnline
end

function v22.renderFriends(p8) -- line: 95
	-- upvalues: Roact (copy), InviteFriendsList (copy)
	return Roact.createElement(InviteFriendsList, {
		friends = p8.state.friends,
		canCaptureFocus = p8.props.canCaptureFocus,
		searchBoxRef = p8.searchBoxRef
	})
end
function v22.render(p9) -- line: 103
	-- upvalues: Roact (copy), PageNavigationWatcher (copy), RootedConnection (copy), FocusHandler (copy), GetFFlagIGMGamepadSelectionHistory (copy), GuiService (copy), Page (copy)
	local state = p9.state
	local t1 = {
		Watcher = Roact.createElement(PageNavigationWatcher, {
			desiredPage = "InviteFriends",
			onNavigateTo = function() -- line: 108
				-- upvalues: p9 (copy)
				p9:loadFriends()
			end
		})
	}

	if state.loadingFriends then
		t1.Loading = p9:renderLoadingPage()
	elseif state.loadingFriendsError then
		t1.ErrorLoading = p9:renderError()
	elseif #state.friends == 0 then
		t1.NoFriends = p9:renderNoFriends()
	else
		t1.FriendsList = p9:renderFriends()
	end

	return Roact.createElement(RootedConnection, {
		render = function(p10) -- line: 125
			-- upvalues: Roact (copy), FocusHandler (copy), GetFFlagIGMGamepadSelectionHistory (copy), p9 (copy), state (copy), GuiService (copy), Page (copy), t1 (copy)
			return Roact.createElement(FocusHandler, {
				shouldForgetPreviousSelection = GetFFlagIGMGamepadSelectionHistory() and p9.props.menuPage ~= "InviteFriends" or nil,
				isFocused = p9.props.canCaptureFocus and (state.loadingFriends and p10),
				didFocus = function() -- line: 132
					-- upvalues: GuiService (copy), p9 (copy)
					GuiService.SelectedCoreObject = p9.backButtonRef:getValue()
				end
			}, {
				Page = Roact.createElement(Page, {
					pageTitle = p9.props.pageTitle,
					buttonRef = p9.backButtonRef,
					NextSelectionDown = p9.searchBoxRef
				}, t1)
			})
		end
	})
end
function v22.didMount(p11) -- line: 146
	p11.mounted = true
	p11:loadFriends()
end
function v22.loadFriends(p12) -- line: 151
	-- upvalues: Promise (copy), Cryo (copy), sortFriends (copy)
	Promise.new(function(resolve, reject) -- line: 152
		-- upvalues: p12 (copy), Cryo (copy), sortFriends (copy)
		coroutine.wrap(function() -- line: 153
			-- upvalues: p12 (copy), reject (copy), Cryo (copy), sortFriends (copy), resolve (copy)
			local LocalPlayer = p12.props.PlayersService.LocalPlayer
			local ok, result = pcall(function() -- line: 155
				-- upvalues: p12 (copy), LocalPlayer (copy)
				return p12.props.PlayersService:GetFriendsAsync(LocalPlayer.UserId)
			end)

			if not ok then
				reject("Error loading friends")

				return
			end

			local t2 = {}

			repeat
				for _, v in ipairs(result:GetCurrentPage()) do
					t2[#t2 + 1] = {
						itemRef = nil,
						IsOnline = v.IsOnline,
						Id = v.Id,
						Username = v.Username,
						DisplayName = v.DisplayName
					}
				end

				if result.IsFinished then
					local v50 = Cryo.List.sort(t2, sortFriends)

					resolve(v50)

					return
				end
			until not pcall(function() -- line: 178
				-- upvalues: result (copy)
				result:AdvanceToNextPageAsync()
			end)

			reject("Error loading friends")
		end)()
	end):andThen(function(p13) -- line: 194
		-- upvalues: p12 (copy)
		if p12.mounted then
			p12:setState({
				loadingFriends = false,
				friends = p13
			})
		end
	end):catch(function() -- line: 202
		-- upvalues: p12 (copy)
		if p12.mounted then
			p12:setState({
				loadingFriends = false,
				loadingFriendsError = true
			})
		end
	end)
end
function v22.willUnmount(p14) -- line: 212
	p14.mounted = false
end

return RoactRodux.connect(function(p15, _) -- line: 216
	-- upvalues: Constants (copy), GetFFlagIGMGamepadSelectionHistory (copy)
	return {
		canCaptureFocus = p15.menuPage == "InviteFriends" and (p15.isMenuOpen and (p15.displayOptions.inputType == Constants.InputType.Gamepad and (not p15.respawn.dialogOpen and p15.currentZone == 1))),
		menuPage = GetFFlagIGMGamepadSelectionHistory() and p15.menuPage or nil
	}
end)(v22)
