local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withStyle = uiBlox.Style.withStyle
local withLocalization = dependencies.withLocalization
local contextualMenu = uiBlox.App.Menu.ContextualMenu
local menuDirection = uiBlox.App.Menu.MenuDirection
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")
local images = uiBlox.App.ImageSet.Images
local mapStateToProps = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingContainer/mapStateToProps")
local roactRodux = dependencies.RoactRodux
local compose = dependencies.SocialLibraries.RoduxTools.compose
local friendsNetworking = dependencies.FriendsNetworking
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/EnumScreens")
local memoize = dependencies.memoize
local otter = dependencies.Otter

local fFlagMigrateFriendshipStatusesRemainingActions = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagMigrateFriendshipStatusesRemainingActions
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/DataHydration").Friends.FriendsStore.get()

local extended = roact.PureComponent:extend("FriendsLandingContextualMenu")

local v6 = {
	motorCallback = otter.instant,
	open = { targetValue = 1 },
	close = { targetValue = 0 }
}

function extended:init()
	function self.onClose()
		if self.props.navigation then
			self.props.navigation.goBack()
		end
	end

	self.onUnfriend = memoize(function(p2, p3)
		self.props.navigation.navigate(EnumScreens.GenericToast, {
			toastProps = {
				toastContent = { toastTitle = p2, iconImage = p3 }
			}
		})
	end)

	self.onActivated = memoize(function(p2, p3)
		return function()
			local userId = self.props.navigation.state.params.userId

			if userId ~= nil then
				local v7

				if fFlagMigrateFriendshipStatusesRemainingActions then
					v7 = v5.Unfriend(userId)
				else
					v7 = self.props.unfriendTargetUserId({
						targetUserId = userId,
						currentUserId = self.props.localUserId
					})
				end

				v7:andThen(function()
					self.onUnfriend(p2, images["icons/actions/friends/friendRemove"])
				end):catch(function()
					self.onUnfriend(p3)
				end)
			end

			self.onClose()
		end
	end)
end

function extended.render(data)
	return withStyle(function(p2)
		return withLocalization({
			unfriend = "Feature.Friends.Action.Unfriend",
			error = "Feature.Toast.NetworkingError.SomethingIsWrong",
			success = "Feature.Friends.Action.FriendRemoved"
		})(function(props)
			local unfriend = props.unfriend
			local success = props.success
			local err = props.error

			return roact.createElement(contextualMenu, {
				buttonProps = {
					{
						icon = images["icons/actions/friends/friendRemove"],
						text = unfriend,
						onActivated = data.onActivated(success, err)
					}
				},
				open = true,
				menuDirection = menuDirection.Up,
				openPositionY = UDim.new(1, -24),
				screenSize = data.props.screenSize,
				onDismiss = data.onClose,
				closeBackgroundVisible = false,
				motorOverrideOptions = v6
			})
		end)
	end)
end

return compose(roactRodux.connect(mapStateToProps, function(callback)
	return {
		unfriendTargetUserId = function(p2)
			return callback(friendsNetworking.UnfriendTargetUserId.API(p2))
		end
	}
end), FriendsLandingContext.connect(function(p2, p3)
	return { screenSize = p2.screenSize }
end))(extended)
