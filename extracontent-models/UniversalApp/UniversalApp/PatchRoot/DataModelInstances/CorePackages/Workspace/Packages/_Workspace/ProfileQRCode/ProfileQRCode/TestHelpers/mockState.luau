local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local Constants = require(ProfileQRCode.Common.Constants)
local Dash = require(ProfileQRCodeParent.Dash)
local DefaultTestUserId = require(script.Parent.DefaultTestUserId)
local FirstFriendRequesterUserId = require(script.Parent.FirstFriendRequesterUserId)
local SecondFriendRequesterUserId = require(script.Parent.SecondFriendRequesterUserId)

return function(p1) -- line: 9
	-- upvalues: Dash (copy), Constants (copy), DefaultTestUserId (copy), FirstFriendRequesterUserId (copy), SecondFriendRequesterUserId (copy)
	return Dash.join({
		LocalUserId = "123",
		ScreenSize = Vector2.new(1000, 500),
		[Constants.RODUX_KEY] = {
			Users = {
				byUserId = {
					[DefaultTestUserId] = {
						displayName = "bigMalc",
						username = "malcolmtucker"
					},
					[FirstFriendRequesterUserId] = {
						displayName = "Apollo",
						username = "captapollo"
					},
					[SecondFriendRequesterUserId] = {
						displayName = "Starbuck",
						username = "ltstarbuck"
					}
				}
			},
			NetworkStatus = {},
			ShareUrl = {
				shortUrl = "www.bbc.co.uk",
				linkId = "123456"
			}
		}
	}, p1)
end
