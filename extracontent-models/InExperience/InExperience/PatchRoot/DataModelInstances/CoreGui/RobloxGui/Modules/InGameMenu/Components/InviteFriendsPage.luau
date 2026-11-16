local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local RoactRodux = InGameMenuDependencies.RoactRodux
local Cryo = InGameMenuDependencies.Cryo

local parent = script.Parent.Parent

local Constants = require(parent.Resources.Constants)
local Promise = require(parent.Utility.Promise)
local withLocalization = require(parent.Localization.withLocalization)

local Page = require(parent.Components.Page)
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local PageNavigationWatcher = require(parent.Components.PageNavigationWatcher)
local FocusHandler = require(parent.Components.Connection.FocusHandler)
local RootedConnection = require(parent.Components.Connection.RootedConnection)

local InviteFriendsList = require(script.InviteFriendsList)
local AddFriendsNow = require(script.AddFriendsNow)
local LoadingFriendsError = require(script.LoadingFriendsError)

local GetFFlagIGMGamepadSelectionHistory = require(parent.Flags.GetFFlagIGMGamepadSelectionHistory)

local extended = Roact.PureComponent:extend("InviteFriendsPage")

extended.validateProps = t.strictInterface({
	pageTitle = t.string,
	canCaptureFocus = t.optional(t.boolean),
	PlayersService = t.union(t.Instance, t.table),
	menuPage = GetFFlagIGMGamepadSelectionHistory() and t.string or nil
})

extended.defaultProps = { PlayersService = Players }

function extended:init()
	self.backButtonRef = Roact.createRef()
	self.searchBoxRef = Roact.createRef()

	self.state = { loadingFriends = true, loadingFriendsError = false, friends = {} }
end

function extended:renderLoadingPage()
	return withLocalization({ loading = "CoreScripts.InGameMenu.InviteFriends.Loading" })(function(p)
		return Roact.createElement(ThemedTextLabel, {
			Size = UDim2.new(1, 0, 1, 0),
			Text = p.loading,
			fontKey = "Header1",
			themeKey = "TextEmphasis"
		})
	end)
end

function extended:renderError()
	return Roact.createElement(LoadingFriendsError, {
		onRetry = function()
			self:setState({ loadingFriends = true, loadingFriendsError = false })

			self:loadFriends()
		end,
		canCaptureFocus = self.props.canCaptureFocus
	})
end

function extended:renderNoFriends()
	return Roact.createElement(AddFriendsNow, { canCaptureFocus = self.props.canCaptureFocus })
end

local function sortFriends(p, p2)
	if p.IsOnline == p2.IsOnline then
		return p.Username:lower() < p2.Username:lower()
	end

	return p.IsOnline and not p2.IsOnline
end

function extended:renderFriends()
	return Roact.createElement(InviteFriendsList, {
		friends = self.state.friends,
		canCaptureFocus = self.props.canCaptureFocus,
		searchBoxRef = self.searchBoxRef
	})
end

function extended:render()
	local state = self.state
	local v = {
		Watcher = Roact.createElement(PageNavigationWatcher, {
			desiredPage = "InviteFriends",
			onNavigateTo = function()
				self:loadFriends()
			end
		})
	}

	if state.loadingFriends then
		v.Loading = self:renderLoadingPage()
	elseif state.loadingFriendsError then
		v.ErrorLoading = self:renderError()
	elseif #state.friends == 0 then
		v.NoFriends = self:renderNoFriends()
	else
		v.FriendsList = self:renderFriends()
	end

	return Roact.createElement(RootedConnection, {
		render = function(p)
			return Roact.createElement(FocusHandler, {
				shouldForgetPreviousSelection = GetFFlagIGMGamepadSelectionHistory() and self.props.menuPage ~= "InviteFriends" and true or nil,
				isFocused = self.props.canCaptureFocus and state.loadingFriends and p,
				didFocus = function()
					GuiService.SelectedCoreObject = self.backButtonRef:getValue()
				end
			}, {
				Page = Roact.createElement(
					Page,
					{
						pageTitle = self.props.pageTitle,
						buttonRef = self.backButtonRef,
						NextSelectionDown = self.searchBoxRef
					},
					v
				)
			})
		end
	})
end

function extended:didMount()
	self.mounted = true
	self:loadFriends()
end

function extended:loadFriends()
	Promise.new(function(callback, callback2)
		coroutine.wrap(function()
			local localPlayer = self.props.PlayersService.LocalPlayer
			local success, result = pcall(function()
				return self.props.PlayersService:GetFriendsAsync(localPlayer.UserId)
			end)

			if not success then
				callback2("Error loading friends")
				return
			end

			local v = {}

			while true do
				for _, v2 in ipairs(result:GetCurrentPage()) do
					v[#v + 1] = {
						IsOnline = v2.IsOnline,
						Id = v2.Id,
						Username = v2.Username,
						DisplayName = v2.DisplayName,
						itemRef = nil
					}
				end

				if result.IsFinished then
					callback((Cryo.List.sort(v, sortFriends)))
					break
				end

				if not pcall(function()
					result:AdvanceToNextPageAsync()
				end) then
					callback2("Error loading friends")
					break
				end
			end
		end)()
	end):andThen(function(friends)
		if self.mounted then
			self:setState({ loadingFriends = false, friends = friends })
		end
	end):catch(function()
		if self.mounted then
			self:setState({ loadingFriends = false, loadingFriendsError = true })
		end
	end)
end

function extended:willUnmount()
	self.mounted = false
end

return RoactRodux.connect(function(data, _)
	local canCaptureFocus

	if data.menuPage == "InviteFriends" then
		canCaptureFocus = data.isMenuOpen

		if canCaptureFocus then
			if data.displayOptions.inputType == Constants.InputType.Gamepad then
				canCaptureFocus = not data.respawn.dialogOpen and data.currentZone == 1
			else
				canCaptureFocus = false
			end
		end
	else
		canCaptureFocus = false
	end

	return {
		canCaptureFocus = canCaptureFocus,
		menuPage = GetFFlagIGMGamepadSelectionHistory() and data.menuPage or nil
	}
end)(extended)
