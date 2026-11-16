local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withStyle = uiBlox.Style.withStyle
local withLocalization = dependencies.withLocalization
local contextualMenu = uiBlox.App.Menu.ContextualMenu
local menuDirection = uiBlox.App.Menu.MenuDirection
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local images = uiBlox.App.ImageSet.Images
local mapStateToProps = require(FriendsLanding.Components.FriendsLandingContainer.mapStateToProps)
local roactRodux = dependencies.RoactRodux
local compose = dependencies.SocialLibraries.RoduxTools.compose
local friendsNetworking = dependencies.FriendsNetworking
local EnumScreens = require(FriendsLanding.EnumScreens)
local memoize = dependencies.memoize
local otter = dependencies.Otter

local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateFriendshipStatusesRemainingActions = SharedFlags.FFlagMigrateFriendshipStatusesRemainingActions
local DataHydration = require(parent.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()

local extended = roact.PureComponent:extend("FriendsLandingContextualMenu")

local motorOverrideOptions = {
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

	self.onUnfriend = memoize(function(toastTitle, iconImage)
		self.props.navigation.navigate(EnumScreens.GenericToast, {
			toastProps = {
				toastContent = { toastTitle = toastTitle, iconImage = iconImage }
			}
		})
	end)

	self.onActivated = memoize(function(p, p2)
		return function()
			local userId = self.props.navigation.state.params.userId

			if userId ~= nil then
				local v2

				if FFlagMigrateFriendshipStatusesRemainingActions then
					v2 = v.Unfriend(userId)
				else
					v2 = self.props.unfriendTargetUserId({
						targetUserId = userId,
						currentUserId = self.props.localUserId
					})
				end

				v2:andThen(function()
					self.onUnfriend(p, images["icons/actions/friends/friendRemove"])
				end):catch(function()
					self.onUnfriend(p2)
				end)
			end

			self.onClose()
		end
	end)
end

function extended.render(data)
	return withStyle(function(_)
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
				motorOverrideOptions = motorOverrideOptions
			})
		end)
	end)
end

return compose(roactRodux.connect(mapStateToProps, function(callback)
	return {
		unfriendTargetUserId = function(p)
			return callback(friendsNetworking.UnfriendTargetUserId.API(p))
		end
	}
end), FriendsLandingContext.connect(function(p, _)
	return { screenSize = p.screenSize }
end))(extended)
