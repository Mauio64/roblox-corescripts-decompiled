local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local withStyle = UIBlox.Style.withStyle
local withLocalization = dependencies.withLocalization
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local Images = UIBlox.App.ImageSet.Images
local mapStateToProps = require(FriendsLanding.Components.FriendsLandingContainer.mapStateToProps)
local RoactRodux = dependencies.RoactRodux
local compose = dependencies.SocialLibraries.RoduxTools.compose
local FriendsNetworking = dependencies.FriendsNetworking
local EnumScreens = require(FriendsLanding.EnumScreens)
local memoize = dependencies.memoize
local Otter = dependencies.Otter
local v18 = Roact.PureComponent:extend("FriendsLandingContextualMenu")
local t1 = {
	motorCallback = Otter.instant,
	open = {
		targetValue = 1
	},
	close = {
		targetValue = 0
	}
}

function v18.init(p1) -- line: 35
	-- upvalues: memoize (copy), EnumScreens (copy), Images (copy)
	function p1.onClose() -- line: 36
		-- upvalues: p1 (copy)
		if p1.props.navigation then
			p1.props.navigation.goBack()
		end
	end

	p1.onUnfriend = memoize(function(p2, p3) -- line: 42
		-- upvalues: p1 (copy), EnumScreens (copy)
		p1.props.navigation.navigate(EnumScreens.GenericToast, {
			toastProps = {
				toastContent = {
					toastTitle = p2,
					iconImage = p3
				}
			}
		})
	end)
	p1.onActivated = memoize(function(p4, p5) -- line: 53
		-- upvalues: p1 (copy), Images (copy)
		return function() -- line: 54
			-- upvalues: p1 (copy), p4 (copy), Images (copy), p5 (copy)
			local userId = p1.props.navigation.state.params.userId

			if userId ~= nil then
				p1.props.unfriendTargetUserId({
					targetUserId = userId,
					currentUserId = p1.props.localUserId
				}):andThen(function() -- line: 59
					-- upvalues: p1 (copy), p4 (copy), Images (copy)
					p1.onUnfriend(p4, Images["icons/actions/friends/friendRemove"])
				end):catch(function() -- line: 62
					-- upvalues: p1 (copy), p5 (copy)
					p1.onUnfriend(p5)
				end)
			end

			p1.onClose()
		end
	end)
end
function v18.render(p6) -- line: 71
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), ContextualMenu (copy), Images (copy), MenuDirection (copy), t1 (copy)
	return withStyle(function(_) -- line: 72
		-- upvalues: withLocalization (copy), Roact (copy), ContextualMenu (copy), Images (copy), p6 (copy), MenuDirection (copy), t1 (copy)
		return withLocalization({
			unfriend = "Feature.Friends.Action.Unfriend",
			error = "Feature.Toast.NetworkingError.SomethingIsWrong",
			success = "Feature.Friends.Action.FriendRemoved"
		})(function(p8) -- line: 77
			-- upvalues: Roact (copy), ContextualMenu (copy), Images (copy), p6 (copy), MenuDirection (copy), t1 (copy)
			local unfriend = p8.unfriend
			local success = p8.success
			local error = p8.error

			return Roact.createElement(ContextualMenu, {
				open = true,
				closeBackgroundVisible = false,
				buttonProps = {{
					icon = Images["icons/actions/friends/friendRemove"],
					text = unfriend,
					onActivated = p6.onActivated(success, error)
				}},
				menuDirection = MenuDirection.Up,
				openPositionY = UDim.new(1, -24),
				screenSize = p6.props.screenSize,
				onDismiss = p6.onClose,
				motorOverrideOptions = t1
			})
		end)
	end)
end

return compose(RoactRodux.connect(mapStateToProps, function(p9) -- line: 103
	-- upvalues: FriendsNetworking (copy)
	return {
		unfriendTargetUserId = function(p10) -- line: 105
			-- upvalues: p9 (copy), FriendsNetworking (copy)
			return p9(FriendsNetworking.UnfriendTargetUserId.API(p10))
		end
	}
end), FriendsLandingContext.connect(function(p11, _) -- line: 110
	return {
		screenSize = p11.screenSize
	}
end))(v18)
