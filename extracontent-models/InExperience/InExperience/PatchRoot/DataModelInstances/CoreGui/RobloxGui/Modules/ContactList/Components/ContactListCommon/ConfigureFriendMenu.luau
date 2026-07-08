local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local BaseMenu = UIBlox.App.Menu.BaseMenu
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local ContactList = CoreGui:WaitForChild("RobloxGui").Modules.ContactList
local dependencies = require(ContactList.dependencies)
local useSelector = dependencies.Hooks.useSelector
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local FriendAction = require(ContactList.Enums.FriendAction)
local useLocalization = dependencies.Hooks.useLocalization

local function ConfigureFriendMenu(p1) -- line: 22
	-- upvalues: useAnalytics (copy), useStyle (copy), useSelector (copy), useLocalization (copy), Roact (copy), BaseMenu (copy), Images (copy), EventNamesEnum (copy), FriendAction (copy)
	local v17 = useAnalytics()
	local Theme = useStyle().Theme
	local v19 = useSelector(function(p2) -- line: 27
		if p2.PlayerMenu.friend then
			return p2.PlayerMenu.friend.combinedName
		end

		return ""
	end)
	local v20 = useSelector(function(p3) -- line: 35
		if p3.PlayerMenu.friend then
			return p3.PlayerMenu.friend.userId
		end

		return nil
	end)
	local v21 = useLocalization({
		blockLabel = {
			"Feature.Call.Label.Block",
			combinedName = v19
		},
		unfriendLabel = {
			"Feature.Call.Label.Unfriend",
			combinedName = v19
		}
	})

	return Roact.createElement(BaseMenu, {
		buttonProps = {
			{
				icon = Images["icons/actions/block"],
				text = v21.blockLabel,
				onActivated = function() -- line: 59
					-- upvalues: v17 (copy), EventNamesEnum (copy), v20 (copy), p1 (copy), FriendAction (copy)
					v17.fireEvent(EventNamesEnum.PhoneBookPlayerMenuBlockClicked, {
						eventTimestampMs = os.time() * 1000,
						friendUserId = v20
					})
					p1.initiateConfirmation(FriendAction.Block)
				end
			},
			{
				icon = Images["icons/actions/friends/friendRemove"],
				text = v21.unfriendLabel,
				onActivated = function() -- line: 70
					-- upvalues: v17 (copy), EventNamesEnum (copy), v20 (copy), p1 (copy), FriendAction (copy)
					v17.fireEvent(EventNamesEnum.PhoneBookPlayerMenuUnfriendClicked, {
						eventTimestampMs = os.time() * 1000,
						friendUserId = v20
					})
					p1.initiateConfirmation(FriendAction.Unfriend)
				end
			}
		},
		background = Theme.BackgroundUIDefault,
		width = UDim.new(0, 352),
		position = UDim2.new(0.5, 0, 0.5, 0),
		anchorPoint = Vector2.new(0.5, 0.5)
	})
end

return ConfigureFriendMenu
